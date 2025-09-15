import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/connection.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/handle.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/connection_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/utility/random_id_generator.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

/// Provider for the stateless ConnectionService.
final connectionServiceProvider = Provider<ConnectionService>((ref) {
  return ConnectionService();
});

typedef ConnectionValidator = bool Function(
  FlowNode sourceNode,
  NodeHandle sourceHandle,
  FlowNode targetNode,
  NodeHandle targetHandle,
);

/// Callback type for edge creation customization.
///
/// This factory allows for complete customization of the `FlowEdge` created
/// when a connection is successfully made.
typedef EdgeFactory = FlowEdge Function({
  required String id,
  required String sourceNodeId,
  required String sourceHandleId,
  required String targetNodeId,
  required String targetHandleId,
});

/// A small helper class to store the result of a handle search.
class ClosestHandleResult {
  final String nodeId;
  final NodeHandle handle;
  final double distance;

  ClosestHandleResult({
    required this.nodeId,
    required this.handle,
    required this.distance,
  });
}

/// A stateless service for handling all logic related to creating and managing connections.
///
/// This service operates on a `FlowCanvasState` object and returns a new, updated
/// state, ensuring immutability.
class ConnectionService {
  /// Starts a new connection process from a specific node handle.
  FlowCanvasState startConnection(
    FlowCanvasState state, {
    required String fromNodeId,
    required String fromHandleId,
    required Offset startPosition,
  }) {
    final fromNode = state.nodes[fromNodeId];
    final fromHandle = fromNode?.handles[fromHandleId];

    if (fromNode == null || fromHandle == null) {
      debugPrint("Connection start failed: Invalid source node or handle.");
      return state;
    }

    if (fromHandle.type != HandleType.source &&
        fromHandle.type != HandleType.both) {
      debugPrint("Connection start failed: Handle type cannot be a source.");
      return state;
    }

    return state.copyWith(
      connection: FlowConnection(
        id: 'pending_${generateUniqueId()}',
        type: 'pending',
        startPoint: startPosition,
        endPoint: startPosition,
        fromNodeId: fromNodeId,
        fromHandleId: fromHandleId,
      ),
      dragMode: DragMode.connection,
    );
  }

  /// Updates the active connection as the user's cursor moves.
  FlowCanvasState updateConnection(
    FlowCanvasState state,
    Offset cursorPosition, {
    double snapRadius = 20.0,
    ConnectionValidator? validator,
  }) {
    if (state.connection == null) return state;

    String? targetNodeId;
    String? targetHandleId;
    bool isValid = false;

    final closestHandle = _findClosestHandle(
      state,
      cursorPosition,
      snapRadius: snapRadius,
      validator: validator,
    );

    if (closestHandle != null) {
      targetNodeId = closestHandle.nodeId;
      targetHandleId = closestHandle.handle.id;
      isValid = true;
    }

    return state.copyWith(
      connection: state.connection!.copyWith(
        endPoint: cursorPosition,
        toNodeId: targetNodeId,
        toHandleId: targetHandleId,
      ),
      connectionState: FlowConnectionRuntimeState(isValid: isValid),
    );
  }

  /// Ends the connection process, creating an edge if valid.
  FlowCanvasState endConnection(
    FlowCanvasState state, {
    EdgeFactory? edgeFactory,
    ConnectionValidator? validator,
  }) {
    final pendingConnection = state.connection;
    if (pendingConnection == null) return state;

    final targetNodeId = pendingConnection.toNodeId;
    final targetHandleId = pendingConnection.toHandleId;

    if (state.connectionState?.isValid == true &&
        targetNodeId != null &&
        targetHandleId != null) {
      final sourceNode = state.nodes[pendingConnection.fromNodeId];
      final sourceHandle = sourceNode?.handles[pendingConnection.fromHandleId];
      final targetNode = state.nodes[targetNodeId];
      final targetHandle = targetNode?.handles[targetHandleId];

      if (sourceNode != null &&
          sourceHandle != null &&
          targetNode != null &&
          targetHandle != null &&
          _isValidConnection(
              sourceNode, sourceHandle, targetNode, targetHandle, validator)) {
        final newEdge = _createEdge(
          sourceNodeId: pendingConnection.fromNodeId!,
          sourceHandleId: pendingConnection.fromHandleId!,
          targetNodeId: targetNodeId,
          targetHandleId: targetHandleId,
          factory: edgeFactory,
        );

        final newEdges = Map<String, FlowEdge>.from(state.edges);
        newEdges[newEdge.id] = newEdge;

        return state.copyWith(
          edges: newEdges,
          connection: null,
          connectionState: null,
          dragMode: DragMode.none,
        );
      }
    }

    return cancelConnection(state);
  }

  /// Explicitly cancels the connection in progress.
  FlowCanvasState cancelConnection(FlowCanvasState state) {
    if (state.connection == null) return state;
    return state.copyWith(
      connection: null,
      connectionState: null,
      dragMode: DragMode.none,
    );
  }

  // PRIVATE HELPERS
  ClosestHandleResult? _findClosestHandle(
    FlowCanvasState state,
    Offset cursorPosition, {
    required double snapRadius,
    ConnectionValidator? validator,
  }) {
    final sourceNode = state.nodes[state.connection!.fromNodeId];
    final sourceHandle = sourceNode?.handles[state.connection!.fromHandleId];

    if (sourceNode == null || sourceHandle == null) return null;

    final nearbyHandles = _getHandlesNear(state, cursorPosition);
    ClosestHandleResult? closestHandle;
    double minDistance = double.infinity;

    for (final handleKey in nearbyHandles) {
      final keyParts = handleKey.split('/');
      final potentialTargetNodeId = keyParts[0];
      final potentialTargetHandleId = keyParts[1];

      if (potentialTargetNodeId == sourceNode.id) continue;

      final potentialTargetNode = state.nodes[potentialTargetNodeId];
      final potentialTargetHandle =
          potentialTargetNode?.handles[potentialTargetHandleId];

      if (potentialTargetNode == null || potentialTargetHandle == null) {
        continue;
      }

      final handleCenter =
          potentialTargetNode.position + potentialTargetHandle.position;
      final distance = (cursorPosition - handleCenter).distance;

      if (distance <= snapRadius && distance < minDistance) {
        if (_isValidConnection(sourceNode, sourceHandle, potentialTargetNode,
            potentialTargetHandle, validator)) {
          minDistance = distance;
          closestHandle = ClosestHandleResult(
            nodeId: potentialTargetNodeId,
            handle: potentialTargetHandle,
            distance: distance,
          );
        }
      }
    }

    return closestHandle;
  }

  bool _isValidConnection(
    FlowNode sourceNode,
    NodeHandle sourceHandle,
    FlowNode targetNode,
    NodeHandle targetHandle,
    ConnectionValidator? customValidator,
  ) {
    if (sourceNode.id == targetNode.id) return false;
    if (sourceHandle.type == HandleType.target) return false;
    if (targetHandle.type == HandleType.source) return false;
    if (!sourceHandle.isConnectable || !targetHandle.isConnectable) {
      return false;
    }
    if (customValidator != null) {
      return customValidator(
          sourceNode, sourceHandle, targetNode, targetHandle);
    }
    return true;
  }

  FlowEdge _createEdge({
    required String sourceNodeId,
    required String sourceHandleId,
    required String targetNodeId,
    required String targetHandleId,
    EdgeFactory? factory,
  }) {
    final edgeId = generateUniqueId();
    if (factory != null) {
      return factory(
        id: edgeId,
        sourceNodeId: sourceNodeId,
        sourceHandleId: sourceHandleId,
        targetNodeId: targetNodeId,
        targetHandleId: targetHandleId,
      );
    }
    return FlowEdge(
      id: edgeId,
      sourceNodeId: sourceNodeId,
      sourceHandleId: sourceHandleId,
      targetNodeId: targetNodeId,
      targetHandleId: targetHandleId,
    );
  }

  Iterable<String> _getHandlesNear(
    FlowCanvasState state,
    Offset position, {
    double gridSize = 200.0,
  }) {
    final gridX = (position.dx / gridSize).floor();
    final gridY = (position.dy / gridSize).floor();
    final nearbyHandles = <String>{};

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        final key = '${gridX + x},${gridY + y}';
        final handlesInCell = state.spatialHash[key];
        if (handlesInCell != null) {
          nearbyHandles.addAll(handlesInCell);
        }
      }
    }
    return nearbyHandles;
  }

  // PUBLIC UTILITY METHODS
  List<FlowEdge> getConnectedEdges(
      FlowCanvasState state, String nodeId, String handleId) {
    return state.edges.values
        .where((edge) =>
            (edge.sourceNodeId == nodeId && edge.sourceHandleId == handleId) ||
            (edge.targetNodeId == nodeId && edge.targetHandleId == handleId))
        .toList();
  }
}

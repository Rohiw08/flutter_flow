import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/utility/random_id_generator.dart';
import '../../domain/state/connection_state.dart';
import '../../domain/models/edge.dart';
import '../../domain/models/node.dart';
import '../../domain/models/handle.dart';
import '../../../../shared/enums.dart';

/// Provider for the stateless ConnectionService.
final connectionServiceProvider = Provider<ConnectionService>((ref) {
  return ConnectionService();
});

/// Callback type for connection validation
typedef ConnectionValidator = bool Function(
  FlowNode sourceNode,
  NodeHandle sourceHandle,
  FlowNode targetNode,
  NodeHandle targetHandle,
);

/// Callback type for edge creation customization
typedef EdgeFactory = FlowEdge Function(
  String sourceNodeId,
  String sourceHandleId,
  String targetNodeId,
  String targetHandleId,
);

/// A stateless service for handling all logic related to creating connections.
class ConnectionService {
  /// Starts a new connection from a handle
  FlowCanvasState startConnection(
    FlowCanvasState state, {
    required String fromNodeId,
    required String fromHandleId,
    required Offset startPosition,
  }) {
    final fromNode = state.internalNodes[fromNodeId];
    final fromHandle = fromNode?.handles[fromHandleId];

    if (fromNode == null || fromHandle == null) {
      return state; // Invalid starting point
    }

    // Only allow connections from source or both handles
    if (fromHandle.type != HandleType.source &&
        fromHandle.type != HandleType.both) {
      return state;
    }

    return state.copyWith(
      connection: FlowConnectionState(
        fromNodeId: fromNodeId,
        fromHandleId: fromHandleId,
        startPosition: startPosition,
        endPosition: startPosition,
      ),
      dragMode: DragMode.connection,
    );
  }

  /// Updates the position and validity of the connection in progress.
  FlowCanvasState updateConnection(
    FlowCanvasState state,
    Offset cursorPosition, {
    double snapRadius = 20.0,
    ConnectionValidator? validator,
  }) {
    if (state.connection == null) return state;

    String? hoveredKey;
    bool isValid = false;

    // Use the pre-calculated spatial hash for efficient collision detection
    final nearbyHandles =
        _getHandlesNear(state.internalSpatialHash, cursorPosition);

    for (final handleKey in nearbyHandles) {
      // Skip if it's the same handle we're connecting from
      if ('${state.connection!.fromNodeId}/${state.connection!.fromHandleId}' ==
          handleKey) {
        continue;
      }

      final keyParts = handleKey.split('/');
      final potentialTargetNodeId = keyParts[0];
      final potentialTargetHandleId = keyParts[1];

      final potentialTargetNode = state.internalNodes[potentialTargetNodeId];
      if (potentialTargetNode == null) continue;

      final potentialTargetHandle =
          potentialTargetNode.handles[potentialTargetHandleId];
      if (potentialTargetHandle == null) continue;

      // Calculate position mathematically
      final handleCenter =
          potentialTargetNode.position + potentialTargetHandle.position;
      final distance = (cursorPosition - handleCenter).distance;

      if (distance <= snapRadius) {
        // Check if this is a valid connection target
        final fromNode = state.internalNodes[state.connection!.fromNodeId];
        final fromHandle = fromNode?.handles[state.connection!.fromHandleId];

        if (fromNode != null &&
            fromHandle != null &&
            _isValidConnection(fromNode, fromHandle, potentialTargetNode,
                potentialTargetHandle, validator)) {
          isValid = true;
          hoveredKey = handleKey;
          break;
        }
      }
    }

    if (hoveredKey != null) {
      final targetIds = hoveredKey.split('/');

      return state.copyWith(
        connection: state.connection!.copyWith(
          endPosition: cursorPosition,
          targetNodeId: targetIds[0],
          targetHandleId: targetIds[1],
          isValid: isValid,
        ),
      );
    }

    return state.copyWith(
      connection: state.connection!.copyWith(
        endPosition: cursorPosition,
        isValid: isValid,
      ),
    );
  }

  /// Ends the connection process, creating an edge if the connection is valid.
  FlowCanvasState endConnection(
    FlowCanvasState state, {
    EdgeFactory? edgeFactory,
    ConnectionValidator? validator,
  }) {
    if (state.connection == null) return state;

    FlowCanvasState nextState = state;

    if (state.connection!.isValid &&
        state.connection!.targetHandleId != null &&
        state.connection!.targetNodeId != null) {
      final targetNodeId = state.connection!.targetNodeId;
      final targetHandleId = state.connection!.targetHandleId;

      final fromNode = state.internalNodes[state.connection!.fromNodeId];
      final fromHandle = fromNode?.handles[state.connection!.fromHandleId];
      final targetNode = state.internalNodes[targetNodeId];
      final targetHandle = targetNode?.handles[targetHandleId];

      // Final validation check
      if (fromNode != null &&
          fromHandle != null &&
          targetNode != null &&
          targetHandle != null &&
          _isValidConnection(
              fromNode, fromHandle, targetNode, targetHandle, validator)) {
        // Use custom edge factory or default
        final newEdge = edgeFactory != null
            ? edgeFactory(
                state.connection!.fromNodeId,
                state.connection!.fromHandleId,
                targetNodeId!,
                targetHandleId!,
              )
            : FlowEdge.withData(
                id: generateUniqueId(),
                sourceNodeId: state.connection!.fromNodeId,
                sourceHandleId: state.connection!.fromHandleId,
                targetNodeId: targetNodeId!,
                targetHandleId: targetHandleId,
                data: {},
              );

        // Use the internalEdges builder for efficiency
        final edgesBuilder = state.internalEdges.toBuilder();
        edgesBuilder[newEdge.id] = newEdge;
        nextState = state.copyWith(internalEdges: edgesBuilder.build());
      }
    }

    return nextState.copyWith(
      connection: null,
      dragMode: DragMode.none,
    );
  }

  /// Cancels the connection in progress.
  FlowCanvasState cancelConnection(FlowCanvasState state) {
    if (state.connection == null) return state;
    return state.copyWith(
      connection: null,
      dragMode: DragMode.none,
    );
  }

  /// Checks if a connection between two handles is valid
  bool _isValidConnection(
    FlowNode sourceNode,
    NodeHandle sourceHandle,
    FlowNode targetNode,
    NodeHandle targetHandle,
    ConnectionValidator? customValidator,
  ) {
    // Basic validation rules
    if (sourceNode.id == targetNode.id) {
      return false; // No self-connections
    }

    // Handle type validation
    if (sourceHandle.type != HandleType.source &&
        sourceHandle.type != HandleType.both) {
      return false; // Source handle must be able to output
    }

    if (targetHandle.type != HandleType.target &&
        targetHandle.type != HandleType.both) {
      return false; // Target handle must be able to input
    }

    if (!sourceHandle.isConnectable || !targetHandle.isConnectable) {
      return false; // Both handles must be connectable
    }

    // Allow custom validation if provided
    if (customValidator != null) {
      return customValidator(
          sourceNode, sourceHandle, targetNode, targetHandle);
    }

    return true;
  }

  /// A private utility to query the spatial hash.
  Iterable<String> _getHandlesNear(
    BuiltMap<String, BuiltSet<String>> spatialHash,
    Offset position, {
    double gridSize = 200.0,
  }) {
    final gridX = (position.dx / gridSize).floor();
    final gridY = (position.dy / gridSize).floor();
    final nearbyHandles = <String>{};

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        final key = '${gridX + x},${gridY + y}';
        final handlesInCell = spatialHash[key];
        if (handlesInCell != null) {
          nearbyHandles.addAll(handlesInCell);
        }
      }
    }
    return nearbyHandles;
  }

  /// Gets all edges connected to a specific node
  List<FlowEdge> getEdgesForNode(FlowCanvasState state, String nodeId) {
    return state.internalEdges.values
        .where((edge) =>
            edge.sourceNodeId == nodeId || edge.targetNodeId == nodeId)
        .toList();
  }

  /// Gets all edges connected to a specific handle
  List<FlowEdge> getEdgesForHandle(
      FlowCanvasState state, String nodeId, String handleId) {
    return state.internalEdges.values
        .where((edge) =>
            (edge.sourceNodeId == nodeId && edge.sourceHandleId == handleId) ||
            (edge.targetNodeId == nodeId && edge.targetHandleId == handleId))
        .toList();
  }

  /// Checks if a handle already has connections (useful for single-connection handles)
  bool isHandleConnected(
      FlowCanvasState state, String nodeId, String handleId) {
    return state.internalEdges.values.any((edge) =>
        (edge.sourceNodeId == nodeId && edge.sourceHandleId == handleId) ||
        (edge.targetNodeId == nodeId && edge.targetHandleId == handleId));
  }

  /// Disconnects all edges from a specific handle
  FlowCanvasState disconnectHandle(
      FlowCanvasState state, String nodeId, String handleId) {
    final edgesToRemove = <String>[];

    for (final entry in state.internalEdges.entries) {
      final edge = entry.value;
      if ((edge.sourceNodeId == nodeId && edge.sourceHandleId == handleId) ||
          (edge.targetNodeId == nodeId && edge.targetHandleId == handleId)) {
        edgesToRemove.add(entry.key);
      }
    }

    if (edgesToRemove.isEmpty) return state;

    final edgesBuilder = state.internalEdges.toBuilder();
    for (final edgeId in edgesToRemove) {
      edgesBuilder.remove(edgeId);
    }

    return state.copyWith(internalEdges: edgesBuilder.build());
  }
}

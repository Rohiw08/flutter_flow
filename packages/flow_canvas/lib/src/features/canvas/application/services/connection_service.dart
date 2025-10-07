import 'package:flutter/widgets.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/connection.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/handle.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/connection_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
// ADDED: Import for HandleRuntimeState
import 'package:flow_canvas/src/features/canvas/domain/state/handle_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/random_id_generator.dart';
import 'package:flow_canvas/src/shared/enums.dart';

typedef ConnectionValidator = bool Function(
  FlowNode sourceNode,
  NodeHandle sourceHandle,
  FlowNode targetNode,
  NodeHandle targetHandle,
);

typedef EdgeFactory = FlowEdge Function({
  required String id,
  required String sourceNodeId,
  required String sourceHandleId,
  required String targetNodeId,
  required String targetHandleId,
});

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

class ConnectionService {
  FlowCanvasState startConnection(
    FlowCanvasState state, {
    required String fromNodeId,
    required String fromHandleId,
    required Offset startPosition,
  }) {
    final fromNode = state.nodes[fromNodeId];
    final fromHandle = fromNode?.handles[fromHandleId];

    if (fromNode == null || fromHandle == null) return state;
    if (fromHandle.type == HandleType.target) return state;

    final handleKey = '$fromNodeId/$fromHandleId';
    final newHandleStates =
        Map<String, HandleRuntimeState>.from(state.handleStates);
    newHandleStates[handleKey] =
        (newHandleStates[handleKey] ?? const HandleRuntimeState())
            .copyWith(isActive: true);

    return state.copyWith(
      handleStates: newHandleStates,
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

  FlowCanvasState updateConnection(
    FlowCanvasState state,
    Offset cursorPosition, {
    double snapRadius = 20.0,
    ConnectionValidator? validator,
  }) {
    if (state.connection == null) return state;

    final newHandleStates =
        Map<String, HandleRuntimeState>.from(state.handleStates);
    String? currentTargetHandleKey;

    // Reset the state of the previously targeted handle
    if (state.connection?.toNodeId != null &&
        state.connection?.toHandleId != null) {
      final prevTargetKey =
          '${state.connection!.toNodeId}/${state.connection!.toHandleId}';
      newHandleStates[prevTargetKey] =
          (newHandleStates[prevTargetKey] ?? const HandleRuntimeState())
              .copyWith(isValidTarget: false);
    }

    String? targetNodeId;
    String? targetHandleId;
    bool isConnectionValid = false;

    final closestHandle = _findClosestHandle(
      state,
      cursorPosition,
      snapRadius: snapRadius,
      validator: validator,
    );

    if (closestHandle != null) {
      targetNodeId = closestHandle.nodeId;
      targetHandleId = closestHandle.handle.id;
      currentTargetHandleKey = '$targetNodeId/$targetHandleId';
      isConnectionValid = true;
      // Mark the new target handle as valid
      newHandleStates[currentTargetHandleKey] =
          (newHandleStates[currentTargetHandleKey] ??
                  const HandleRuntimeState())
              .copyWith(isValidTarget: true);
    }

    return state.copyWith(
      handleStates: newHandleStates,
      connection: state.connection!.copyWith(
        endPoint: cursorPosition,
        toNodeId: targetNodeId,
        toHandleId: targetHandleId,
      ),
      connectionState: FlowConnectionRuntimeState(isValid: isConnectionValid),
    );
  }

  FlowCanvasState endConnection(
    FlowCanvasState state, {
    EdgeFactory? edgeFactory,
    ConnectionValidator? validator,
  }) {
    final pendingConnection = state.connection;
    if (pendingConnection == null) return state;

    final newHandleStates = _clearConnectionStates(state);

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
            factory: edgeFactory);
        final newEdges = Map<String, FlowEdge>.from(state.edges)
          ..[newEdge.id] = newEdge;

        final newEdgeIndex = state.edgeIndex.addEdge(newEdge, newEdge.id);

        return state.copyWith(
          edges: newEdges,
          edgeIndex: newEdgeIndex,
          connection: null,
          connectionState: null,
          handleStates: newHandleStates,
          dragMode: DragMode.none,
        );
        // --- END SOLUTION ---
      }
    }

    return cancelConnection(state);
  }

  FlowCanvasState cancelConnection(FlowCanvasState state) {
    if (state.connection == null) return state;
    return state.copyWith(
      connection: null,
      connectionState: null,
      handleStates: _clearConnectionStates(state),
      dragMode: DragMode.none,
    );
  }

  // Resets all active/target flags on handles
  Map<String, HandleRuntimeState> _clearConnectionStates(
      FlowCanvasState state) {
    final newHandleStates =
        Map<String, HandleRuntimeState>.from(state.handleStates);

    // Reset source handle
    if (state.connection?.fromNodeId != null &&
        state.connection?.fromHandleId != null) {
      final sourceKey =
          '${state.connection!.fromNodeId}/${state.connection!.fromHandleId}';
      newHandleStates[sourceKey] =
          (newHandleStates[sourceKey] ?? const HandleRuntimeState())
              .copyWith(isActive: false);
    }

    // Reset target handle
    if (state.connection?.toNodeId != null &&
        state.connection?.toHandleId != null) {
      final targetKey =
          '${state.connection!.toNodeId}/${state.connection!.toHandleId}';
      newHandleStates[targetKey] =
          (newHandleStates[targetKey] ?? const HandleRuntimeState())
              .copyWith(isValidTarget: false);
    }

    return newHandleStates;
  }

  ClosestHandleResult? _findClosestHandle(
    FlowCanvasState state,
    Offset cursorPosition, {
    required double snapRadius,
    ConnectionValidator? validator,
    bool ignoreValidation = false, // Added flag
  }) {
    final sourceNode = state.nodes[state.connection!.fromNodeId];
    final sourceHandle = sourceNode?.handles[state.connection!.fromHandleId];

    if (sourceNode == null || sourceHandle == null) return null;

    final nearbyHandles = state.nodeIndex.queryHandlesNear(cursorPosition);
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
      if (potentialTargetHandle.type == HandleType.source) continue;

      // Convert handle's render-space offset to cartesian delta

      final handleCenter =
          potentialTargetNode.position + potentialTargetHandle.position;
      final distance = (cursorPosition - handleCenter).distance;

      if (distance <= snapRadius && distance < minDistance) {
        if (ignoreValidation ||
            _isValidConnection(sourceNode, sourceHandle, potentialTargetNode,
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
          targetHandleId: targetHandleId);
    }
    return FlowEdge(
        id: edgeId,
        sourceNodeId: sourceNodeId,
        sourceHandleId: sourceHandleId,
        targetNodeId: targetNodeId,
        targetHandleId: targetHandleId);
  }

  List<FlowEdge> getConnectedEdges(
      FlowCanvasState state, String nodeId, String handleId) {
    return state.edges.values
        .where((edge) =>
            (edge.sourceNodeId == nodeId && edge.sourceHandleId == handleId) ||
            (edge.targetNodeId == nodeId && edge.targetHandleId == handleId))
        .toList();
  }
}

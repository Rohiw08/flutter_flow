import 'package:flutter/widgets.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/connection.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/handle.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/connection_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/handle_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/random_id_generator.dart';
import 'package:flow_canvas/src/shared/enums.dart';

typedef ConnectionValidator = bool Function(
  FlowNode sourceNode,
  FlowHandle sourceHandle,
  FlowNode targetNode,
  FlowHandle targetHandle,
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
  final FlowHandle handle;
  final double distance;
  // It's often useful to also return the node itself
  final FlowNode node;

  ClosestHandleResult({
    required this.nodeId,
    required this.handle,
    required this.distance,
    required this.node,
  });
}

class ConnectionService {
  // Starts a new drag connection from a handle.
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
        Map<String, HandleRuntimeState>.from(state.handleStates)
          ..[handleKey] =
              (state.handleStates[handleKey] ?? const HandleRuntimeState())
                  .copyWith(active: true);

    return state.copyWith(
      handleStates: newHandleStates,
      activeConnection: FlowConnection(
        id: IdGenerator.generateCompactId("pending_connection"),
        type: 'pending',
        startPoint: startPosition,
        endPoint: startPosition,
        fromNodeId: fromNodeId,
        fromHandleId: fromHandleId,
      ),
      dragMode: DragMode.connection,
      connectionState: const FlowConnectionRuntimeState.idle(),
    );
  }

  // Tracks the connection drag; triggers hover status if close to valid handle.
  FlowCanvasState updateConnection(
    FlowCanvasState state,
    Offset cursorPosition, {
    double snapRadius = 20.0,
    ConnectionValidator? validator,
  }) {
    final connection = state.activeConnection;
    if (connection == null) return state;

    final sourceNode = state.nodes[connection.fromNodeId];
    final sourceHandle = sourceNode?.handles[connection.fromHandleId];

    if (sourceNode == null || sourceHandle == null) {
      return cancelConnection(state);
    }

    final newHandleStates =
        Map<String, HandleRuntimeState>.from(state.handleStates);

    // Remove previous target highlight if needed.
    if (connection.toNodeId != null && connection.toHandleId != null) {
      final prevHandleKey = '${connection.toNodeId}/${connection.toHandleId}';
      newHandleStates[prevHandleKey] =
          (newHandleStates[prevHandleKey] ?? const HandleRuntimeState())
              .copyWith(validTarget: false);
    }

    String? targetNodeId;
    String? targetHandleId;
    String? currentTargetHandleKey;
    bool isValid = false;

    final closest = _findClosestHandle(
      state,
      cursorPosition,
      snapRadius: snapRadius,
      validator: validator,
    );

    if (closest != null) {
      if (_isValidConnection(
          sourceNode, sourceHandle, closest.node, closest.handle, validator)) {
        targetNodeId = closest.nodeId;
        targetHandleId = closest.handle.id;
        currentTargetHandleKey = '$targetNodeId/$targetHandleId';
        newHandleStates[currentTargetHandleKey] =
            (newHandleStates[currentTargetHandleKey] ??
                    const HandleRuntimeState())
                .copyWith(validTarget: true);
        isValid = true;
      }
    }

    final nextConnection = connection.copyWith(
      endPoint: cursorPosition,
      toNodeId: targetNodeId,
      toHandleId: targetHandleId,
    );

    return state.copyWith(
      handleStates: newHandleStates,
      activeConnection: nextConnection,
      connectionState: FlowConnectionRuntimeState.hovering(
        targetHandleKey: currentTargetHandleKey ?? '',
        isValid: isValid,
      ),
    );
  }

  // Drops the connection; checks validity for creating edge, otherwise cancels.
  FlowCanvasState endConnection(
    FlowCanvasState state, {
    EdgeFactory? edgeFactory,
    ConnectionValidator? validator,
  }) {
    final connection = state.activeConnection;
    if (connection == null) return state;

    final isComplete = connection.isComplete;
    final validState = state.connectionState is HoveringConnectionState &&
        (state.connectionState as HoveringConnectionState).isValid;

    final newHandleStates = _clearConnectionStates(state);

    if (isComplete &&
        validState &&
        connection.fromNodeId != null &&
        connection.fromHandleId != null &&
        connection.toNodeId != null &&
        connection.toHandleId != null) {
      final sourceNode = state.nodes[connection.fromNodeId!];
      final sourceHandle = sourceNode?.handles[connection.fromHandleId!];
      final targetNode = state.nodes[connection.toNodeId!];
      final targetHandle = targetNode?.handles[connection.toHandleId!];

      if (sourceNode != null &&
          sourceHandle != null &&
          targetNode != null &&
          targetHandle != null &&
          _isValidConnection(
              sourceNode, sourceHandle, targetNode, targetHandle, validator)) {
        final newEdge = _createEdge(
          sourceNodeId: connection.fromNodeId!,
          sourceHandleId: connection.fromHandleId!,
          targetNodeId: connection.toNodeId!,
          targetHandleId: connection.toHandleId!,
          factory: edgeFactory,
        );
        final newEdges = Map<String, FlowEdge>.from(state.edges)
          ..[newEdge.id] = newEdge;
        final newEdgeIndex = state.edgeIndex.addEdge(newEdge, newEdge.id);

        return state.copyWith(
          edges: newEdges,
          edgeIndex: newEdgeIndex,
          activeConnection: null,
          connectionState: const FlowConnectionRuntimeState.idle(),
          handleStates: newHandleStates,
          dragMode: DragMode.none,
        );
      }
    }

    // Mark state as released/cancelled.
    return state.copyWith(
      activeConnection: null,
      connectionState: FlowConnectionRuntimeState.released(
        targetHandleKey: connection.hasTarget
            ? '${connection.toNodeId}/${connection.toHandleId}'
            : null,
        isValid: false,
      ),
      handleStates: newHandleStates,
      dragMode: DragMode.none,
    );
  }

  // Cancels current connection.
  FlowCanvasState cancelConnection(FlowCanvasState state) {
    if (state.activeConnection == null) return state;
    return state.copyWith(
      activeConnection: null,
      connectionState: const FlowConnectionRuntimeState.idle(),
      handleStates: _clearConnectionStates(state),
      dragMode: DragMode.none,
    );
  }

  Map<String, HandleRuntimeState> _clearConnectionStates(
      FlowCanvasState state) {
    final newHandleStates =
        Map<String, HandleRuntimeState>.from(state.handleStates);

    if (state.activeConnection?.fromNodeId != null &&
        state.activeConnection?.fromHandleId != null) {
      final srcKey =
          '${state.activeConnection!.fromNodeId}/${state.activeConnection!.fromHandleId}';
      newHandleStates[srcKey] =
          (newHandleStates[srcKey] ?? const HandleRuntimeState())
              .copyWith(active: false);
    }
    if (state.activeConnection?.toNodeId != null &&
        state.activeConnection?.toHandleId != null) {
      final tgtKey =
          '${state.activeConnection!.toNodeId}/${state.activeConnection!.toHandleId}';
      newHandleStates[tgtKey] =
          (newHandleStates[tgtKey] ?? const HandleRuntimeState())
              .copyWith(validTarget: false);
    }
    return newHandleStates;
  }

  // Finds closest target handle, if any.
  ClosestHandleResult? _findClosestHandle(
    FlowCanvasState state,
    Offset cursorPosition, {
    required double snapRadius,
    ConnectionValidator? validator,
  }) {
    final connection = state.activeConnection;
    final sourceNode = state.nodes[connection!.fromNodeId];
    final sourceHandle = sourceNode?.handles[connection.fromHandleId];

    if (sourceNode == null || sourceHandle == null) return null;

    final nearbyHandles = state.nodeIndex.queryHandlesNear(cursorPosition);
    ClosestHandleResult? closest;
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

      final handleCenter =
          potentialTargetNode.position + potentialTargetHandle.position;
      final dist = (cursorPosition - handleCenter).distance;

      if (dist <= snapRadius && dist < minDistance) {
        minDistance = dist;
        closest = ClosestHandleResult(
          nodeId: potentialTargetNodeId,
          handle: potentialTargetHandle,
          distance: dist,
          node: potentialTargetNode,
        );
      }
    }

    return closest;
  }

  bool _isValidConnection(
    FlowNode sourceNode,
    FlowHandle sourceHandle,
    FlowNode targetNode,
    FlowHandle targetHandle,
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
    final edgeId = IdGenerator.generateEdgeId();
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

  List<FlowEdge> getConnectedEdges(
      FlowCanvasState state, String nodeId, String handleId) {
    return state.edges.values
        .where((edge) =>
            (edge.sourceNodeId == nodeId && edge.sourceHandleId == handleId) ||
            (edge.targetNodeId == nodeId && edge.targetHandleId == handleId))
        .toList();
  }
}

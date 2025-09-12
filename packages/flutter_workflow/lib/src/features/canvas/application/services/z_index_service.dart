import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';

class ZIndexService {
  /// Bring a node to front in O(1) using cached maxZIndex
  FlowCanvasState bringToFront(FlowCanvasState state, String nodeId) {
    final node = state.internalNodes[nodeId];
    if (node == null) return state;

    final newZIndex = state.maxZIndex + 1;

    final nodesBuilder = state.internalNodes.toBuilder();
    nodesBuilder[nodeId] = node.copyWith(zIndex: newZIndex);

    return state.copyWith(
      internalNodes: nodesBuilder.build(),
      maxZIndex: newZIndex,
    );
  }

  /// Send a node to back in O(1) using cached minZIndex
  FlowCanvasState sendToBack(FlowCanvasState state, String nodeId) {
    final node = state.internalNodes[nodeId];
    if (node == null) return state;

    final newZIndex = state.minZIndex - 1;

    final nodesBuilder = state.internalNodes.toBuilder();
    nodesBuilder[nodeId] = node.copyWith(zIndex: newZIndex);

    return state.copyWith(
      internalNodes: nodesBuilder.build(),
      minZIndex: newZIndex,
    );
  }

  /// Bring selected nodes to front in O(S) (S = # of selected nodes)
  FlowCanvasState bringSelectedToFront(FlowCanvasState state) {
    if (state.internalSelectedNodes.isEmpty) return state;

    final nodesBuilder = state.internalNodes.toBuilder();
    int zIndex = state.maxZIndex + 1;

    for (final nodeId in state.internalSelectedNodes) {
      final node = nodesBuilder[nodeId];
      if (node != null) {
        nodesBuilder[nodeId] = node.copyWith(zIndex: zIndex++);
      }
    }

    return state.copyWith(
      internalNodes: nodesBuilder.build(),
      maxZIndex: zIndex - 1,
    );
  }

  /// Send selected nodes to back in O(S)
  FlowCanvasState sendSelectedToBack(FlowCanvasState state) {
    if (state.internalSelectedNodes.isEmpty) return state;

    final nodesBuilder = state.internalNodes.toBuilder();
    int zIndex = state.minZIndex - state.internalSelectedNodes.length;

    for (final nodeId in state.internalSelectedNodes) {
      final node = nodesBuilder[nodeId];
      if (node != null) {
        nodesBuilder[nodeId] = node.copyWith(zIndex: zIndex++);
      }
    }

    return state.copyWith(
      internalNodes: nodesBuilder.build(),
      minZIndex: zIndex - state.internalSelectedNodes.length,
    );
  }
}

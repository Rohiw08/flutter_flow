import 'dart:math' as math;
import 'dart:ui';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/node_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';

class NodeService {
  FlowNode? getNode(FlowCanvasState state, String nodeId) {
    if (!state.nodes.containsKey(nodeId)) return null;
    return state.nodes[nodeId]!;
  }

  NodeRuntimeState? getNodeRuntimeState(FlowCanvasState state, String nodeId) {
    if (!state.nodeStates.containsKey(nodeId)) return null;
    return state.nodeStates[nodeId]!;
  }

  FlowCanvasState addNode(FlowCanvasState state, FlowNode node) {
    return addNodes(state, [node]);
  }

  FlowCanvasState addNodes(FlowCanvasState state, Iterable<FlowNode> nodes) {
    if (nodes.isEmpty) return state;

    final newNodes = Map<String, FlowNode>.from(state.nodes);
    var newNodeIndex = state.nodeIndex;
    var nextZ = state.maxZIndex;

    for (final node in nodes) {
      if (newNodes.containsKey(node.id)) continue;
      nextZ = math.max(nextZ + 1, node.zIndex);
      final newNode = node.copyWith(zIndex: nextZ);
      newNodes[newNode.id] = newNode;
      newNodeIndex = newNodeIndex.addNode(newNode);
    }

    return state.copyWith(
      nodes: newNodes,
      nodeIndex: newNodeIndex,
      maxZIndex: nextZ,
    );
  }

  FlowCanvasState removeNode(FlowCanvasState state, String nodeId) {
    return removeNodes(state, [nodeId]);
  }

  FlowCanvasState removeNodes(
    FlowCanvasState state,
    Iterable<String> nodeIds,
  ) {
    if (nodeIds.isEmpty) return state;

    final newNodes = Map<String, FlowNode>.from(state.nodes);
    final newSelectedNodes = Set<String>.from(state.selectedNodes);
    var newNodeIndex = state.nodeIndex;

    final nodeIdSet = nodeIds.toSet();
    for (final nodeId in nodeIdSet) {
      if (!newNodes.containsKey(nodeId)) continue;
      final removedNode = newNodes.remove(nodeId)!;
      newNodeIndex = newNodeIndex.removeNode(removedNode);
      newSelectedNodes.remove(nodeId);
    }

    return state.copyWith(
      nodes: newNodes,
      selectedNodes: newSelectedNodes,
      nodeIndex: newNodeIndex,
    );
  }

  FlowCanvasState moveSelectedNodes(FlowCanvasState state, Offset delta) {
    return moveNodes(state, state.selectedNodes, delta);
  }

  FlowCanvasState moveNodes(
      FlowCanvasState state, Iterable<String> nodeIds, Offset delta) {
    if (delta == Offset.zero || nodeIds.isEmpty) return state;

    final newNodes = Map<String, FlowNode>.from(state.nodes);
    var newNodeIndex = state.nodeIndex;

    final nodeIdSet = nodeIds.toSet();
    for (final id in nodeIdSet) {
      final node = newNodes[id];
      if (node == null) continue;
      final draggable = node.draggable ?? true;
      if (draggable) {
        final newPosition = node.position + delta;
        final newNode = node.copyWith(position: newPosition);
        newNodes[id] = newNode;
        newNodeIndex = newNodeIndex.updateNode(node, newNode);
      }
    }

    return state.copyWith(
      nodes: newNodes,
      nodeIndex: newNodeIndex,
    );
  }

  FlowCanvasState updateNode(FlowCanvasState state, FlowNode node) {
    if (!state.nodes.containsKey(node.id)) return state;

    final oldNode = state.nodes[node.id]!;
    final newNodes = Map<String, FlowNode>.from(state.nodes);
    newNodes[node.id] = node;

    final newNodeIndex = state.nodeIndex.updateNode(oldNode, node);

    return state.copyWith(
      nodes: newNodes,
      nodeIndex: newNodeIndex,
    );
  }

  FlowCanvasState updateNodeRuntimeState(
      FlowCanvasState state, String nodeId, NodeRuntimeState runtime) {
    if (nodeId.isEmpty) return state;

    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    newNodeStates[nodeId] = runtime;
    return state.copyWith(
      nodeStates: newNodeStates,
    );
  }

  // TODO: test if this function works?
  /// Resizes a single node directionally based on the gesture delta.
  ///
  /// - [direction]: Specifies the resize handle/direction (e.g., bottomRight fixes top-left).
  /// - [delta]: The gesture delta (e.g., from onPanUpdate). Positive dx/dy expands in that direction.
  /// - [minSize]: Optional minimum size to clamp to (defaults to Size(50, 50)).
  ///
  /// Returns a new state with the updated node and index. Assumes directional resizing
  /// (fixed opposite point) for intuitive UX—e.g., dragging bottom-right expands
  /// width/height while keeping top-left anchored.
  FlowCanvasState resizeNode(
    FlowCanvasState state,
    String nodeId,
    ResizeDirection direction,
    Offset delta, {
    Size minSize = const Size(50, 50),
  }) {
    final node = state.nodes[nodeId];
    if (node == null || delta == Offset.zero) return state;

    final rect = node.rect;
    double newLeft = rect.left;
    double newTop = rect.top;
    double newRight = rect.right;
    double newBottom = rect.bottom;

    switch (direction) {
      case ResizeDirection.topLeft:
        newLeft += delta.dx;
        newTop += delta.dy;
        break;
      case ResizeDirection.topRight:
        newTop += delta.dy;
        newRight += delta.dx;
        break;
      case ResizeDirection.bottomLeft:
        newLeft += delta.dx;
        newBottom += delta.dy;
        break;
      case ResizeDirection.bottomRight:
        newRight += delta.dx;
        newBottom += delta.dy;
        break;
      case ResizeDirection.top:
        newTop += delta.dy;
        break;
      case ResizeDirection.bottom:
        newBottom += delta.dy;
        break;
      case ResizeDirection.left:
        newLeft += delta.dx;
        break;
      case ResizeDirection.right:
        newRight += delta.dx;
        break;
    }

    switch (direction) {
      case ResizeDirection.topLeft:
        newLeft = math.min(newLeft, rect.right - minSize.width);
        newTop = math.min(newTop, rect.bottom - minSize.height);
        break;
      case ResizeDirection.topRight:
        newTop = math.min(newTop, rect.bottom - minSize.height);
        newRight = math.max(newRight, rect.left + minSize.width);
        break;
      case ResizeDirection.bottomLeft:
        newLeft = math.min(newLeft, rect.right - minSize.width);
        newBottom = math.max(newBottom, rect.top + minSize.height);
        break;
      case ResizeDirection.bottomRight:
        newRight = math.max(newRight, rect.left + minSize.width);
        newBottom = math.max(newBottom, rect.top + minSize.height);
        break;
      case ResizeDirection.top:
        newTop = math.min(newTop, rect.bottom - minSize.height);
        break;
      case ResizeDirection.bottom:
        newBottom = math.max(newBottom, rect.top + minSize.height);
        break;
      case ResizeDirection.left:
        newLeft = math.min(newLeft, rect.right - minSize.width);
        break;
      case ResizeDirection.right:
        newRight = math.max(newRight, rect.left + minSize.width);
        break;
    }

    final newRect = Rect.fromLTRB(newLeft, newTop, newRight, newBottom);
    final newNode = node.copyWith(
      position: newRect.center,
      size: newRect.size,
    );

    return updateNode(state, newNode);
  }
}

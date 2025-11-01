import 'dart:ui';
import 'package:flow_canvas/flow_canvas.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/node_state.dart';

typedef NodeDataUpdater = Map<String, dynamic> Function(
    Map<String, dynamic> currentData);

class NodeService {
  FlowCanvasState addNode(FlowCanvasState state, FlowNode node) {
    return addNodes(state, [node]);
  }

  FlowCanvasState addNodes(FlowCanvasState state, Iterable<FlowNode> nodes) {
    if (nodes.isEmpty) return state;

    final newNodes = Map<String, FlowNode>.from(state.nodes);
    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    var newNodeIndex = state.nodeIndex;
    var nextZ = state.maxZIndex;

    for (final node in nodes) {
      if (newNodes.containsKey(node.id)) continue;
      nextZ += 1;
      final newNode = node.copyWith(zIndex: nextZ);
      newNodes[newNode.id] = newNode;
      newNodeStates[newNode.id] = NodeRuntimeState.idle;
      newNodeIndex = newNodeIndex.addNode(newNode);
    }

    return state.copyWith(
      nodes: newNodes,
      nodeStates: newNodeStates,
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
    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    final newSelectedNodes = Set<String>.from(state.selectedNodes);
    var newNodeIndex = state.nodeIndex;

    final nodeIdSet = nodeIds.toSet();
    for (final nodeId in nodeIdSet) {
      final removedNode = newNodes.remove(nodeId);
      if (removedNode != null) {
        newNodeIndex = newNodeIndex.removeNode(removedNode);
        newNodeStates.remove(nodeId);
        newSelectedNodes.remove(nodeId);
      }
    }

    return state.copyWith(
      nodes: newNodes,
      nodeStates: newNodeStates,
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
      if (node != null && (node.draggable ?? true)) {
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
    final newNodes = Map<String, FlowNode>.from(state.nodes);
    newNodes[node.id] = node;
    return state.copyWith(
      nodes: newNodes,
    );
  }
}

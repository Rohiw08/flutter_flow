import 'dart:ui';

import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';

import '../../domain/indexes/edge_index.dart';
import '../../domain/indexes/node_index.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_query_service.dart';

typedef NodeDataUpdater = Map<String, dynamic> Function(
    Map<String, dynamic> currentData);

/// A stateless service for handling business logic related to nodes.
///
/// All methods are pure functions that take the current state and return a new,
/// updated state, preserving immutability.
class NodeService {
  /// Adds a single node to the canvas state.
  FlowCanvasState addNode(FlowCanvasState state, FlowNode node) {
    if (state.nodes.containsKey(node.id)) {
      return state; // Node with this ID already exists.
    }

    // Assign a z-index that's one higher than the current max
    final newNode = node.copyWith(zIndex: state.maxZIndex + 1);
    final newNodes = Map<String, FlowNode>.from(state.nodes);
    newNodes[newNode.id] = newNode;

    // Update the node index
    final newNodeIndex = state.nodeIndex.addNode(newNode);

    return state.copyWith(
      nodes: newNodes,
      maxZIndex: state.maxZIndex + 1,
      nodeIndex: newNodeIndex,
    );
  }

  /// Adds multiple nodes to the canvas state in a single, efficient operation.
  FlowCanvasState addNodes(
      FlowCanvasState state, Iterable<FlowNode> nodesToAdd) {
    if (nodesToAdd.isEmpty) {
      return state;
    }

    final newNodes = Map<String, FlowNode>.from(state.nodes);
    NodeIndex newNodeIndex = state.nodeIndex;
    int currentMaxZ = state.maxZIndex;

    for (final node in nodesToAdd) {
      // Skip nodes with conflicting IDs
      if (newNodes.containsKey(node.id)) {
        continue;
      }

      currentMaxZ++;
      final newNode = node.copyWith(zIndex: currentMaxZ);
      newNodes[newNode.id] = newNode;
      newNodeIndex = newNodeIndex.addNode(newNode);
    }

    return state.copyWith(
      nodes: newNodes,
      maxZIndex: currentMaxZ,
      nodeIndex: newNodeIndex,
    );
  }

  FlowCanvasState removeNodesAndConnections(
      FlowCanvasState state, List<String> nodeIds) {
    if (nodeIds.isEmpty) return state;

    final nodeIdSet = nodeIds.toSet();

    final edgeQuery = EdgeQueryService();
    final Set<String> edgeIdsToRemove = {};
    for (final nodeId in nodeIdSet) {
      edgeIdsToRemove.addAll(edgeQuery.getEdgesForNode(state, nodeId));
    }

    final newNodes = Map<String, FlowNode>.from(state.nodes);
    final newEdges = Map<String, FlowEdge>.from(state.edges);
    final newSelectedNodes = Set<String>.from(state.selectedNodes);
    final newSelectedEdges = Set<String>.from(state.selectedEdges);

    NodeIndex newNodeIndex = state.nodeIndex;
    EdgeIndex newEdgeIndex = state.edgeIndex;

    for (final edgeId in edgeIdsToRemove) {
      final removedEdge = newEdges.remove(edgeId);
      if (removedEdge != null) {
        newEdgeIndex = newEdgeIndex.removeEdge(edgeId, removedEdge);
        newSelectedEdges.remove(edgeId);
      }
    }

    List<FlowNode> removedNodes = [];
    for (final nodeId in nodeIdSet) {
      final removedNode = newNodes.remove(nodeId);
      if (removedNode != null) {
        removedNodes.add(removedNode);
        newNodeIndex = newNodeIndex.removeNode(removedNode);
        newSelectedNodes.remove(nodeId);
      }
    }

    int newMinZ = state.minZIndex;
    int newMaxZ = state.maxZIndex;
    if (removedNodes.any(
        (n) => n.zIndex == state.minZIndex || n.zIndex == state.maxZIndex)) {
      if (newNodes.isNotEmpty) {
        final zIndexes = newNodes.values.map((n) => n.zIndex);
        newMinZ = zIndexes.reduce((min, z) => z < min ? z : min);
        newMaxZ = zIndexes.reduce((max, z) => z > max ? z : max);
      } else {
        newMinZ = 0;
        newMaxZ = 0;
      }
    }

    return state.copyWith(
      nodes: newNodes,
      edges: newEdges,
      selectedNodes: newSelectedNodes,
      selectedEdges: newSelectedEdges,
      nodeIndex: newNodeIndex,
      edgeIndex: newEdgeIndex,
      minZIndex: newMinZ,
      maxZIndex: newMaxZ,
    );
  }

  /// Drags all selected nodes by a given delta.
  FlowCanvasState dragSelectedNodes(FlowCanvasState state, Offset delta) {
    if (delta == Offset.zero || state.selectedNodes.isEmpty) {
      return state;
    }

    final newNodes = Map<String, FlowNode>.from(state.nodes);
    NodeIndex newNodeIndex = state.nodeIndex;

    for (final id in state.selectedNodes) {
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

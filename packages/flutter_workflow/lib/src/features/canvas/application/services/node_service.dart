import 'dart:ui';

import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_indexing_service.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';

import 'node_indexing_service.dart';

/// Provider for the stateless NodeService.
final nodeServiceProvider = Provider<NodeService>((ref) => NodeService());

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

  /// Removes a node and all of its connected edges.
  FlowCanvasState removeNodeAndConnections(
      FlowCanvasState state, String nodeId) {
    if (!state.nodes.containsKey(nodeId)) return state;

    // 1. Get all edges connected to this node using the index for efficiency
    final edgeIdsToRemove = state.edgeIndex.getEdgesForNode(nodeId);

    // 2. Create a new state with the edges removed
    final newEdges = Map<String, FlowEdge>.from(state.edges);
    EdgeIndex newEdgeIndex = state.edgeIndex;
    for (final edgeId in edgeIdsToRemove) {
      final edge = newEdges.remove(edgeId);
      if (edge != null) {
        newEdgeIndex = newEdgeIndex.removeEdge(edgeId, edge);
      }
    }

    // 3. Create a new state with the node removed
    final newNodes = Map<String, FlowNode>.from(state.nodes);
    final removedNode = newNodes.remove(nodeId);
    final newNodeIndex = state.nodeIndex.removeNode(nodeId);

    // 4. Remove from selection
    final newSelectedNodes = Set<String>.from(state.selectedNodes);
    newSelectedNodes.remove(nodeId);

    // 5. Recalculate z-index if necessary
    int newMinZ = state.minZIndex;
    int newMaxZ = state.maxZIndex;
    if (removedNode != null &&
        (removedNode.zIndex == state.minZIndex ||
            removedNode.zIndex == state.maxZIndex)) {
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
      // Use the provided boolean properties directly, with a fallback to true
      if (node != null && (node.draggable ?? true)) {
        final newPosition = node.position + delta;
        newNodes[id] = node.copyWith(position: newPosition);
        newNodeIndex = newNodeIndex.updateNodePosition(id, newPosition);
      }
    }

    return state.copyWith(
      nodes: newNodes,
      nodeIndex: newNodeIndex,
    );
  }

  // --- SELECTION METHODS ---

  /// Replaces the current selection with a single node.
  FlowCanvasState selectNode(FlowCanvasState state, String nodeId) {
    if (!state.nodes.containsKey(nodeId)) return state;
    return state.copyWith(selectedNodes: {nodeId});
  }

  /// Adds a node to the current selection.
  FlowCanvasState addNodeToSelection(FlowCanvasState state, String nodeId) {
    if (!state.nodes.containsKey(nodeId)) return state;
    final newSelection = Set<String>.from(state.selectedNodes);
    newSelection.add(nodeId);
    return state.copyWith(selectedNodes: newSelection);
  }

  /// Removes a node from the current selection.
  FlowCanvasState removeNodeFromSelection(
      FlowCanvasState state, String nodeId) {
    if (!state.selectedNodes.contains(nodeId)) return state;
    final newSelection = Set<String>.from(state.selectedNodes);
    newSelection.remove(nodeId);
    return state.copyWith(selectedNodes: newSelection);
  }

  /// Toggles a node's selection state.
  FlowCanvasState toggleNodeSelection(FlowCanvasState state, String nodeId) {
    if (state.selectedNodes.contains(nodeId)) {
      return removeNodeFromSelection(state, nodeId);
    } else {
      return addNodeToSelection(state, nodeId);
    }
  }

  /// Selects all nodes on the canvas.
  FlowCanvasState selectAllNodes(FlowCanvasState state) {
    return state.copyWith(selectedNodes: state.nodes.keys.toSet());
  }

  /// Clears the entire node selection.
  FlowCanvasState clearNodeSelection(FlowCanvasState state) {
    if (state.selectedNodes.isEmpty) return state;
    return state.copyWith(selectedNodes: {});
  }
}

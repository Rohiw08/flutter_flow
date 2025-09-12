import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/node_indexing_service.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';

/// Provider for the stateless NodeService.
final nodeServiceProvider = Provider<NodeService>((ref) => NodeService());

/// A stateless service for handling business logic related to nodes.
///
/// All methods in this class are PURE FUNCTIONS. They take the current state
/// as an argument and return a new state, without causing any side effects.
class NodeService {
  /// Adds a single node to the canvas state.
  FlowCanvasState addNode(FlowCanvasState currentState, FlowNode node) {
    if (currentState.internalNodes.containsKey(node.id)) {
      return currentState;
    }

    // Assign a z-index that's one higher than the current max
    final newNode = node.copyWith(zIndex: currentState.maxZIndex + 1);

    final nodesBuilder = currentState.internalNodes.toBuilder();
    nodesBuilder[newNode.id] = newNode;

    // Update the node index
    final newNodeIndex = currentState.nodeIndex.addNode(newNode);

    return currentState.copyWith(
      internalNodes: nodesBuilder.build(),
      maxZIndex: currentState.maxZIndex + 1,
      nodeIndex: newNodeIndex,
    );
  }

  /// Adds multiple nodes to the canvas state with proper z-index handling.
  FlowCanvasState addNodes(
      FlowCanvasState currentState, List<FlowNode> nodesToAdd) {
    if (nodesToAdd.isEmpty) return currentState;

    final nodesBuilder = currentState.internalNodes.toBuilder();
    int newMaxZIndex = currentState.maxZIndex;
    NodeIndex newIndex = currentState.nodeIndex;

    for (final node in nodesToAdd) {
      if (nodesBuilder[node.id] == null) {
        final newNode = node.copyWith(zIndex: newMaxZIndex + 1);
        nodesBuilder[newNode.id] = newNode;
        newMaxZIndex++;

        // Update the node index
        newIndex = newIndex.addNode(newNode);
      }
    }

    return currentState.copyWith(
      internalNodes: nodesBuilder.build(),
      maxZIndex: newMaxZIndex,
      nodeIndex: newIndex,
    );
  }

  /// Drags all selected nodes by a given delta.
  FlowCanvasState dragSelectedNodes(
      FlowCanvasState currentState, Offset delta) {
    if (delta == Offset.zero || currentState.internalSelectedNodes.isEmpty) {
      return currentState;
    }

    final nodesBuilder = currentState.internalNodes.toBuilder();
    NodeIndex newIndex = currentState.nodeIndex;

    for (final id in currentState.internalSelectedNodes) {
      final node = nodesBuilder[id];
      if (node != null &&
          node.isDraggable != null &&
          node.isDraggable == true) {
        final newPosition = node.position + delta;
        nodesBuilder[id] = node.copyWith(position: newPosition);

        // Update the node index with new position
        newIndex = newIndex.updateNodePosition(id, newPosition);
      }
    }

    return currentState.copyWith(
      internalNodes: nodesBuilder.build(),
      nodeIndex: newIndex,
    );
  }

  /// Drags a single node by a given delta, typically for unselected nodes.
  FlowCanvasState dragNode(
      FlowCanvasState currentState, String nodeId, Offset delta) {
    if (delta == Offset.zero) {
      return currentState;
    }

    final node = currentState.internalNodes[nodeId];
    if (node == null || node.isDraggable == null || node.isDraggable == false) {
      return currentState;
    }

    final nodesBuilder = currentState.internalNodes.toBuilder();
    final newPosition = node.position + delta;
    nodesBuilder[nodeId] = node.copyWith(position: newPosition);

    // Update the node index with new position
    final newIndex =
        currentState.nodeIndex.updateNodePosition(nodeId, newPosition);

    return currentState.copyWith(
      internalNodes: nodesBuilder.build(),
      nodeIndex: newIndex,
    );
  }

  /// Removes a single node and any connected edges from the state.
  FlowCanvasState removeNode(FlowCanvasState currentState, String nodeId) {
    final node = currentState.internalNodes[nodeId];
    if (node == null) {
      return currentState;
    }

    final nodesBuilder = currentState.internalNodes.toBuilder();
    final edgesBuilder = currentState.internalEdges.toBuilder();
    final selectedNodesBuilder = currentState.internalSelectedNodes.toBuilder();

    // Remove node
    nodesBuilder.remove(nodeId);

    // Remove edges connected to that node
    edgesBuilder.removeWhere((_, edge) =>
        edge.sourceNodeId == nodeId || edge.targetNodeId == nodeId);

    // Remove node from selection
    selectedNodesBuilder.remove(nodeId);

    // Update the node index
    final newIndex = currentState.nodeIndex.removeNode(nodeId);

    // Check if we need to update min/max z-index
    int newMinZIndex = currentState.minZIndex;
    int newMaxZIndex = currentState.maxZIndex;

    if (node.zIndex == currentState.minZIndex ||
        node.zIndex == currentState.maxZIndex) {
      // Recalculate min/max if the removed node had an extreme z-index
      final builtNodes = nodesBuilder.build();
      if (builtNodes.isEmpty) {
        newMinZIndex = 0;
        newMaxZIndex = 0;
      } else {
        // Convert to list to get values
        final nodeList = builtNodes.values.toList();
        newMinZIndex =
            nodeList.map((n) => n.zIndex).reduce((a, b) => a < b ? a : b);
        newMaxZIndex =
            nodeList.map((n) => n.zIndex).reduce((a, b) => a > b ? a : b);
      }
    }

    return currentState.copyWith(
      internalNodes: nodesBuilder.build(),
      internalEdges: edgesBuilder.build(),
      internalSelectedNodes: selectedNodesBuilder.build(),
      minZIndex: newMinZIndex,
      maxZIndex: newMaxZIndex,
      nodeIndex: newIndex,
    );
  }

  /// Removes multiple nodes and their connected edges.
  FlowCanvasState removeNodes(
      FlowCanvasState currentState, List<String> nodeIds) {
    if (nodeIds.isEmpty) {
      return currentState;
    }

    // Create builders once for all operations
    final nodesBuilder = currentState.internalNodes.toBuilder();
    final edgesBuilder = currentState.internalEdges.toBuilder();
    final selectedNodesBuilder = currentState.internalSelectedNodes.toBuilder();
    NodeIndex newIndex = currentState.nodeIndex;

    // Track if we need to recalc min/max z-index
    bool needsRecalc = false;

    for (final nodeId in nodeIds) {
      final node = nodesBuilder[nodeId];
      if (node == null) continue;

      if (node.zIndex == currentState.minZIndex ||
          node.zIndex == currentState.maxZIndex) {
        needsRecalc = true;
      }

      // Remove node
      nodesBuilder.remove(nodeId);

      // Remove edges connected to this node
      edgesBuilder.removeWhere((_, edge) =>
          edge.sourceNodeId == nodeId || edge.targetNodeId == nodeId);

      // Remove node from selection
      selectedNodesBuilder.remove(nodeId);

      // Update the node index
      newIndex = newIndex.removeNode(nodeId);
    }

    // Recalculate min/max z-index if needed
    int newMinZIndex = currentState.minZIndex;
    int newMaxZIndex = currentState.maxZIndex;

    if (needsRecalc) {
      final builtNodes = nodesBuilder.build();
      if (builtNodes.isEmpty) {
        newMinZIndex = 0;
        newMaxZIndex = 0;
      } else {
        // Convert to list to get values
        final nodeList = builtNodes.values.toList();
        newMinZIndex =
            nodeList.map((n) => n.zIndex).reduce((a, b) => a < b ? a : b);
        newMaxZIndex =
            nodeList.map((n) => n.zIndex).reduce((a, b) => a > b ? a : b);
      }
    }

    return currentState.copyWith(
      internalNodes: nodesBuilder.build(),
      internalEdges: edgesBuilder.build(),
      internalSelectedNodes: selectedNodesBuilder.build(),
      minZIndex: newMinZIndex,
      maxZIndex: newMaxZIndex,
      nodeIndex: newIndex,
    );
  }

  FlowCanvasState selectNode(FlowCanvasState currentState, String nodeId) {
    if (!currentState.internalNodes.containsKey(nodeId)) {
      return currentState;
    }

    final selectedNodesBuilder = currentState.internalSelectedNodes.toBuilder();
    selectedNodesBuilder
      ..clear()
      ..add(nodeId);

    return currentState.copyWith(
        internalSelectedNodes: selectedNodesBuilder.build());
  }

  /// Adds a node to the current selection
  FlowCanvasState addToSelection(FlowCanvasState currentState, String nodeId) {
    if (!currentState.internalNodes.containsKey(nodeId) ||
        currentState.internalSelectedNodes.contains(nodeId)) {
      return currentState;
    }

    final selectedNodesBuilder = currentState.internalSelectedNodes.toBuilder();
    selectedNodesBuilder.add(nodeId);

    return currentState.copyWith(
        internalSelectedNodes: selectedNodesBuilder.build());
  }

  /// Removes a node from the current selection
  FlowCanvasState removeFromSelection(
      FlowCanvasState currentState, String nodeId) {
    if (!currentState.internalSelectedNodes.contains(nodeId)) {
      return currentState;
    }

    final selectedNodesBuilder = currentState.internalSelectedNodes.toBuilder();
    selectedNodesBuilder.remove(nodeId);

    return currentState.copyWith(
        internalSelectedNodes: selectedNodesBuilder.build());
  }

  /// Clears the current selection
  FlowCanvasState clearSelection(FlowCanvasState currentState) {
    if (currentState.internalSelectedNodes.isEmpty) {
      return currentState;
    }

    final selectedNodesBuilder = currentState.internalSelectedNodes.toBuilder();
    selectedNodesBuilder.clear();

    return currentState.copyWith(
        internalSelectedNodes: selectedNodesBuilder.build());
  }

  /// Toggles a node's selection state
  FlowCanvasState toggleNodeSelection(
      FlowCanvasState currentState, String nodeId) {
    if (!currentState.internalNodes.containsKey(nodeId)) {
      return currentState;
    }

    if (currentState.internalSelectedNodes.contains(nodeId)) {
      return removeFromSelection(currentState, nodeId);
    } else {
      return addToSelection(currentState, nodeId);
    }
  }

  /// Selects all nodes in the canvas
  FlowCanvasState selectAllNodes(FlowCanvasState currentState) {
    if (currentState.internalNodes.isEmpty) {
      return currentState;
    }

    final selectedNodesBuilder = currentState.internalSelectedNodes.toBuilder();
    selectedNodesBuilder
      ..clear()
      ..addAll(currentState.internalNodes.keys);

    return currentState.copyWith(
        internalSelectedNodes: selectedNodesBuilder.build());
  }
}

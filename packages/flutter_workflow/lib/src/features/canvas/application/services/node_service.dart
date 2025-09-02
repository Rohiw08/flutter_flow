import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';
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
    if (currentState.nodes.any((n) => n.id == node.id)) {
      return currentState;
    }
    final newNodes = [...currentState.nodes, node];
    return currentState.copyWith(nodes: newNodes);
  }

  /// Adds multiple nodes to the canvas state.
  FlowCanvasState addNodes(
      FlowCanvasState currentState, List<FlowNode> nodesToAdd) {
    final existingIds = currentState.nodes.map((n) => n.id).toSet();
    final uniqueNewNodes = nodesToAdd.where((n) => !existingIds.contains(n.id));

    if (uniqueNewNodes.isEmpty) {
      return currentState;
    }

    final newNodes = [...currentState.nodes, ...uniqueNewNodes];
    return currentState.copyWith(nodes: newNodes);
  }

  /// Drags all selected nodes by a given delta.
  FlowCanvasState dragSelectedNodes(
      FlowCanvasState currentState, Offset delta) {
    if (delta == Offset.zero || currentState.selectedNodes.isEmpty) {
      return currentState;
    }

    final updatedNodes = currentState.nodes.map((node) {
      if (currentState.selectedNodes.contains(node.id)) {
        return node.copyWith(position: node.position + delta);
      }
      return node;
    }).toList();

    return currentState.copyWith(nodes: updatedNodes);
  }

  /// Drags a single node by a given delta, typically for unselected nodes.
  FlowCanvasState dragNode(
      FlowCanvasState currentState, String nodeId, Offset delta) {
    if (delta == Offset.zero) {
      return currentState;
    }

    final updatedNodes = currentState.nodes.map((node) {
      if (node.id == nodeId) {
        return node.copyWith(position: node.position + delta);
      }
      return node;
    }).toList();

    return currentState.copyWith(nodes: updatedNodes);
  }

  /// Removes a single node and any connected edges from the state.
  FlowCanvasState removeNode(FlowCanvasState currentState, String nodeId) {
    final newNodes =
        currentState.nodes.where((node) => node.id != nodeId).toList();
    final newEdges = currentState.edges
        .where((edge) =>
            edge.sourceNodeId != nodeId && edge.targetNodeId != nodeId)
        .toList();
    final newSelectedNodes = Set<String>.from(currentState.selectedNodes)
      ..remove(nodeId);

    return currentState.copyWith(
      nodes: newNodes,
      edges: newEdges,
      selectedNodes: newSelectedNodes,
    );
  }

  /// Removes multiple nodes and their connected edges.
  FlowCanvasState removeNodes(
      FlowCanvasState currentState, List<String> nodeIds) {
    if (nodeIds.isEmpty) {
      return currentState;
    }
    final idsToRemove = nodeIds.toSet();
    final newNodes = currentState.nodes
        .where((node) => !idsToRemove.contains(node.id))
        .toList();
    final newEdges = currentState.edges
        .where((edge) =>
            !idsToRemove.contains(edge.sourceNodeId) &&
            !idsToRemove.contains(edge.targetNodeId))
        .toList();
    final newSelectedNodes = Set<String>.from(currentState.selectedNodes)
      ..removeAll(idsToRemove);

    return currentState.copyWith(
      nodes: newNodes,
      edges: newEdges,
      selectedNodes: newSelectedNodes,
    );
  }

  /// Removes all currently selected nodes.
  FlowCanvasState removeSelectedNodes(FlowCanvasState currentState) {
    return removeNodes(currentState, currentState.selectedNodes.toList());
  }

  /// Updates a single node with new properties.
  FlowCanvasState updateNode(
    FlowCanvasState currentState,
    String nodeId, {
    Offset? position,
    Size? size,
    Map<String, dynamic>? data,
  }) {
    final newNodes = currentState.nodes.map((node) {
      if (node.id == nodeId) {
        return node.copyWith(
          position: position ?? node.position,
          size: size ?? node.size,
          data: data != null ? {...node.data, ...data} : node.data,
        );
      }
      return node;
    }).toList();
    return currentState.copyWith(nodes: newNodes);
  }
}

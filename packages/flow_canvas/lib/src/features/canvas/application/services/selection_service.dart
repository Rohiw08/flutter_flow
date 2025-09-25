import 'package:flutter/painting.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_query_service.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';

import '../../domain/state/edge_state.dart';
import '../../domain/state/node_state.dart';

/// A stateless service for handling business logic related to selection.
class SelectionService {
  // --- NODE SELECTION ---

  /// Replaces the current selection with a single node.
  FlowCanvasState selectNode(FlowCanvasState state, String nodeId) {
    if (!state.nodes.containsKey(nodeId)) return state;

    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    // Deselect previously selected nodes
    for (final id in state.selectedNodes) {
      if (id != nodeId) {
        newNodeStates[id] = (newNodeStates[id] ?? const NodeRuntimeState())
            .copyWith(selected: false);
      }
    }
    // Select the new node
    newNodeStates[nodeId] = (newNodeStates[nodeId] ?? const NodeRuntimeState())
        .copyWith(selected: true);

    return state.copyWith(
      selectedNodes: {nodeId},
      nodeStates: newNodeStates,
    );
  }

  /// Adds a node to the current selection.
  FlowCanvasState addNodeToSelection(FlowCanvasState state, String nodeId) {
    if (!state.nodes.containsKey(nodeId) ||
        state.selectedNodes.contains(nodeId)) {
      return state;
    }
    final newSelection = Set<String>.from(state.selectedNodes)..add(nodeId);

    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    newNodeStates[nodeId] = (newNodeStates[nodeId] ?? const NodeRuntimeState())
        .copyWith(selected: true);

    return state.copyWith(
      selectedNodes: newSelection,
      nodeStates: newNodeStates,
    );
  }

  /// Removes a node from the current selection.
  FlowCanvasState removeNodeFromSelection(
      FlowCanvasState state, String nodeId) {
    if (!state.selectedNodes.contains(nodeId)) return state;
    final newSelection = Set<String>.from(state.selectedNodes)..remove(nodeId);

    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    newNodeStates[nodeId] = (newNodeStates[nodeId] ?? const NodeRuntimeState())
        .copyWith(selected: false);

    return state.copyWith(
      selectedNodes: newSelection,
      nodeStates: newNodeStates,
    );
  }

  /// Toggles a node's selection state, optionally adding to the existing selection.
  FlowCanvasState toggleNodeSelection(
    FlowCanvasState state,
    String nodeId, {
    bool addToSelection = false,
  }) {
    final isSelected = state.selectedNodes.contains(nodeId);
    Set<String> newSelectedNodes;

    if (addToSelection) {
      newSelectedNodes = Set<String>.from(state.selectedNodes);
      if (isSelected) {
        newSelectedNodes.remove(nodeId);
      } else {
        newSelectedNodes.add(nodeId);
      }
    } else {
      newSelectedNodes = isSelected ? {} : {nodeId};
    }

    // Update runtime states
    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);

    // If not adding to selection, first deselect all others
    if (!addToSelection && !isSelected) {
      for (final id in state.selectedNodes) {
        newNodeStates[id] = (newNodeStates[id] ?? const NodeRuntimeState())
            .copyWith(selected: false);
      }
    }

    // Toggle the target node's state
    newNodeStates[nodeId] = (newNodeStates[nodeId] ?? const NodeRuntimeState())
        .copyWith(selected: newSelectedNodes.contains(nodeId));

    return state.copyWith(
      selectedNodes: newSelectedNodes,
      nodeStates: newNodeStates,
    );
  }

  // --- EDGE SELECTION ---

  /// Toggles the selection state of a single edge.
  FlowCanvasState toggleEdgeSelection(
    FlowCanvasState state,
    String edgeId, {
    bool addToSelection = false,
  }) {
    final newSelectedEdges =
        addToSelection ? Set<String>.from(state.selectedEdges) : <String>{};

    if (newSelectedEdges.contains(edgeId)) {
      newSelectedEdges.remove(edgeId);
    } else {
      newSelectedEdges.add(edgeId);
    }

    final newEdgeStates = Map<String, EdgeRuntimeState>.from(state.edgeStates);
    newEdgeStates[edgeId] = (newEdgeStates[edgeId] ?? const EdgeRuntimeState())
        .copyWith(selected: newSelectedEdges.contains(edgeId));

    return state.copyWith(
        selectedEdges: newSelectedEdges, edgeStates: newEdgeStates);
  }

  // --- GLOBAL SELECTION ---

  /// Selects all items on the canvas, with options to specify what to select.
  FlowCanvasState selectAll(
    FlowCanvasState state, {
    bool nodes = true,
    bool edges = true,
  }) {
    final newSelectedNodes =
        nodes ? state.nodes.keys.toSet() : state.selectedNodes;
    final newSelectedEdges =
        edges ? state.edges.keys.toSet() : state.selectedEdges;

    // Update all runtime states
    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    for (final nodeId in state.nodes.keys) {
      newNodeStates[nodeId] =
          (newNodeStates[nodeId] ?? const NodeRuntimeState())
              .copyWith(selected: newSelectedNodes.contains(nodeId));
    }
    final newEdgeStates = Map<String, EdgeRuntimeState>.from(state.edgeStates);
    for (final edgeId in state.edges.keys) {
      newEdgeStates[edgeId] =
          (newEdgeStates[edgeId] ?? const EdgeRuntimeState())
              .copyWith(selected: newSelectedEdges.contains(edgeId));
    }

    return state.copyWith(
      selectedNodes: newSelectedNodes,
      selectedEdges: newSelectedEdges,
      nodeStates: newNodeStates,
      edgeStates: newEdgeStates,
    );
  }

  /// Deselects all nodes and edges.
  FlowCanvasState deselectAll(FlowCanvasState state) {
    if (state.selectedNodes.isEmpty && state.selectedEdges.isEmpty) {
      return state;
    }

    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    for (final nodeId in state.selectedNodes) {
      newNodeStates[nodeId] =
          (newNodeStates[nodeId] ?? const NodeRuntimeState())
              .copyWith(selected: false);
    }
    final newEdgeStates = Map<String, EdgeRuntimeState>.from(state.edgeStates);
    for (final edgeId in state.selectedEdges) {
      newEdgeStates[edgeId] =
          (newEdgeStates[edgeId] ?? const EdgeRuntimeState())
              .copyWith(selected: false);
    }

    return state.copyWith(
      selectedNodes: {},
      selectedEdges: {},
      nodeStates: newNodeStates,
      edgeStates: newEdgeStates,
    );
  }

  // --- BOX SELECTION ---

  /// Starts a box selection gesture.
  FlowCanvasState startBoxSelection(FlowCanvasState state, Offset position) {
    return state.copyWith(
      selectionRect: Rect.fromPoints(position, position),
    );
  }

  /// Updates the box selection area and calculates the selected elements within it.
  FlowCanvasState updateBoxSelection(
    FlowCanvasState state,
    Offset position, {
    SelectionMode selectionMode = SelectionMode.partial,
    required NodeQueryService nodeQueryService,
  }) {
    if (state.selectionRect == null) return state;

    final newSelectionRect =
        Rect.fromPoints(state.selectionRect!.topLeft, position);

    // Use spatial indexing for efficient node querying
    final nodesInRect = nodeQueryService.queryInRect(state, newSelectionRect);

    final nodesInArea = <String>{};
    for (final node in nodesInRect) {
      final overlaps = selectionMode == SelectionMode.partial
          ? newSelectionRect.overlaps(node.rect)
          : newSelectionRect.contains(node.rect.topLeft) &&
              newSelectionRect.contains(node.rect.bottomRight);

      if (overlaps) {
        nodesInArea.add(node.id);
      }
    }

    // Use spatial indexing for efficient edge querying
    final edgesInArea = <String>{};
    for (final nodeId in nodesInArea) {
      final connectedEdges = state.edgeIndex.getEdgesForNode(nodeId);
      for (final edgeId in connectedEdges) {
        final edge = state.edges[edgeId];
        if (edge != null &&
            nodesInArea.contains(edge.sourceNodeId) &&
            nodesInArea.contains(edge.targetNodeId)) {
          edgesInArea.add(edgeId);
        }
      }
    }

    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    for (final nodeId in state.nodes.keys) {
      newNodeStates[nodeId] =
          (newNodeStates[nodeId] ?? const NodeRuntimeState())
              .copyWith(selected: nodesInArea.contains(nodeId));
    }
    final newEdgeStates = Map<String, EdgeRuntimeState>.from(state.edgeStates);
    for (final edgeId in state.edges.keys) {
      newEdgeStates[edgeId] =
          (newEdgeStates[edgeId] ?? const EdgeRuntimeState())
              .copyWith(selected: edgesInArea.contains(edgeId));
    }

    return state.copyWith(
      selectionRect: newSelectionRect,
      selectedNodes: nodesInArea,
      selectedEdges: edgesInArea,
      nodeStates: newNodeStates,
      edgeStates: newEdgeStates,
    );
  }

  /// Ends the box selection process.
  FlowCanvasState endBoxSelection(FlowCanvasState state) {
    return state.copyWith(
      selectionRect: null,
    );
  }
}

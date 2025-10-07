import 'package:flutter/painting.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_query_service.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_query_service.dart';

import '../../domain/state/edge_state.dart';
import '../../domain/state/node_state.dart';

/// A stateless service for handling business logic related to selection.
class SelectionService {
  /// Toggles a node's selection state.
  /// Enforces exclusive selection: selecting a node deselects all other nodes and all edges.
  FlowCanvasState toggleNodeSelection(
    FlowCanvasState state,
    String nodeId, {
    bool addToSelection =
        false, // Note: addToSelection is now effectively ignored for exclusive selection
  }) {
    final isAlreadySelected = state.selectedNodes.contains(nodeId);

    // If this node is the only thing selected, and we're clicking it again, deselect it.
    if (isAlreadySelected &&
        state.selectedNodes.length == 1 &&
        state.selectedEdges.isEmpty) {
      return deselectAll(state);
    }

    // Otherwise, we are selecting this node exclusively.
    // First, get a clean state with nothing selected.
    final deselectedState = deselectAll(state);

    // Now, select only the target node.
    final newSelectedNodes = {nodeId};
    final newNodeStates =
        Map<String, NodeRuntimeState>.from(deselectedState.nodeStates);
    newNodeStates[nodeId] = (newNodeStates[nodeId] ?? const NodeRuntimeState())
        .copyWith(selected: true);

    return deselectedState.copyWith(
      selectedNodes: newSelectedNodes,
      nodeStates: newNodeStates,
    );
  }

  /// Toggles an edge's selection state.
  /// Enforces exclusive selection: selecting an edge deselects all other edges and all nodes.
  FlowCanvasState toggleEdgeSelection(
    FlowCanvasState state,
    String edgeId, {
    bool addToSelection =
        false, // Note: addToSelection is now effectively ignored
  }) {
    final isAlreadySelected = state.selectedEdges.contains(edgeId);

    // If this edge is the only thing selected, and we're clicking it again, deselect it.
    if (isAlreadySelected &&
        state.selectedEdges.length == 1 &&
        state.selectedNodes.isEmpty) {
      return deselectAll(state);
    }

    // Otherwise, select this edge exclusively.
    final deselectedState = deselectAll(state);

    final newSelectedEdges = {edgeId};
    final newEdgeStates =
        Map<String, EdgeRuntimeState>.from(deselectedState.edgeStates);
    newEdgeStates[edgeId] = (newEdgeStates[edgeId] ?? const EdgeRuntimeState())
        .copyWith(selected: true);

    return deselectedState.copyWith(
      selectedEdges: newSelectedEdges,
      edgeStates: newEdgeStates,
    );
  }

  /// Deselects all nodes and edges. This is now the primary helper for ensuring a clean slate.
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

  // The methods below are for multi-selection, which you may want to disable or keep.
  // For now, they remain but the primary toggle methods enforce single selection.

  FlowCanvasState selectAll(FlowCanvasState state) {
    final newSelectedNodes = state.nodes.keys.toSet();
    final newSelectedEdges = state.edges.keys.toSet();

    final newNodeStates = {
      for (var id in newSelectedNodes)
        id: const NodeRuntimeState(selected: true)
    };
    final newEdgeStates = {
      for (var id in newSelectedEdges)
        id: const EdgeRuntimeState(selected: true)
    };

    return state.copyWith(
      selectedNodes: newSelectedNodes,
      selectedEdges: newSelectedEdges,
      nodeStates: newNodeStates,
      edgeStates: newEdgeStates,
    );
  }

  FlowCanvasState startBoxSelection(FlowCanvasState state, Offset position) {
    return deselectAll(state).copyWith(
      selectionRect: Rect.fromPoints(position, position),
    );
  }

  FlowCanvasState updateBoxSelection(
    FlowCanvasState state,
    Offset origin,
    Offset position, {
    SelectionMode selectionMode = SelectionMode.partial,
    required NodeQueryService nodeQueryService,
  }) {
    if (state.selectionRect == null) return state;

    final newSelectionRect = Rect.fromPoints(origin, position);
    final nodesInRect = nodeQueryService.queryInRect(state, newSelectionRect);
    final nodesInArea = nodesInRect.map((n) => n.id).toSet();

    final edgeQuery = EdgeQueryService();
    final edgesInArea = <String>{};
    for (final nodeId in nodesInArea) {
      final connectedEdges = edgeQuery.getEdgesForNode(state, nodeId);
      for (final edgeId in connectedEdges) {
        final edge = state.edges[edgeId];
        if (edge != null &&
            nodesInArea.contains(edge.sourceNodeId) &&
            nodesInArea.contains(edge.targetNodeId)) {
          edgesInArea.add(edgeId);
        }
      }
    }

    final newNodeStates = {
      for (var id in state.nodes.keys)
        id: NodeRuntimeState(selected: nodesInArea.contains(id))
    };
    final newEdgeStates = {
      for (var id in state.edges.keys)
        id: EdgeRuntimeState(selected: edgesInArea.contains(id))
    };

    return state.copyWith(
      selectionRect: newSelectionRect,
      selectedNodes: nodesInArea,
      selectedEdges: edgesInArea,
      nodeStates: newNodeStates,
      edgeStates: newEdgeStates,
    );
  }

  FlowCanvasState endBoxSelection(FlowCanvasState state) {
    return state.copyWith(
      selectionRect: null,
    );
  }
}

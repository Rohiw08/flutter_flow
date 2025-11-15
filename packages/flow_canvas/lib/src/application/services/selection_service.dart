import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/node_state.dart';
import 'package:flutter/painting.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import '../../domain/state/edge_state.dart';

/// A stateless service for handling business logic related to selection.
class SelectionService {
  /// Returns list of selected nodes (full models).
  List<FlowNode> getSelectedNodes(FlowCanvasState state) =>
      state.selectedNodes.map((id) => state.nodes[id]!).toList();

  /// Returns list of selected Edges (full models).
  List<FlowEdge> getSelectedEdges(FlowCanvasState state) =>
      state.selectedEdges.map((id) => state.edges[id]!).toList();

  /// Adds a node to the selection without deselecting others.
  /// If already selected, does nothing.
  FlowCanvasState addNodeToSelection(FlowCanvasState state, String nodeId) {
    if (state.selectedNodes.contains(nodeId)) return state;
    final newSelectedNodes = {...state.selectedNodes, nodeId};
    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    newNodeStates[nodeId] = (newNodeStates[nodeId] ?? const NodeRuntimeState())
        .copyWith(selected: true);
    return state.copyWith(
      selectedNodes: newSelectedNodes,
      nodeStates: newNodeStates,
    );
  }

  /// Similar for edges.
  FlowCanvasState addEdgeToSelection(FlowCanvasState state, String edgeId) {
    if (state.selectedEdges.contains(edgeId)) return state;
    final newSelectedEdges = {...state.selectedEdges, edgeId};
    final newEdgeStates = Map<String, EdgeRuntimeState>.from(state.edgeStates);
    newEdgeStates[edgeId] = (newEdgeStates[edgeId] ?? const EdgeRuntimeState())
        .copyWith(selected: true);
    return state.copyWith(
      selectedEdges: newSelectedEdges,
      edgeStates: newEdgeStates,
    );
  }

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

  // The methods below are for multi-selection, which you may want to disable or keep.
  // For now, they remain but the primary toggle methods enforce single selection.
  FlowCanvasState selectAll(FlowCanvasState state) {
    final newSelectedNodes = state.nodes.keys.toSet();
    final newSelectedEdges = state.edges.keys.toSet();

    final newNodeStates = <String, NodeRuntimeState>{};
    for (final id in newSelectedNodes) {
      final existing = state.nodeStates[id];
      newNodeStates[id] = existing?.copyWith(selected: true) ??
          const NodeRuntimeState(selected: true);
    }

    final newEdgeStates = <String, EdgeRuntimeState>{};
    for (final id in newSelectedEdges) {
      final existing = state.edgeStates[id];
      newEdgeStates[id] = existing?.copyWith(selected: true) ??
          const EdgeRuntimeState(selected: true);
    }

    return state.copyWith(
      selectedNodes: newSelectedNodes,
      selectedEdges: newSelectedEdges,
      nodeStates: newNodeStates,
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
  }) {
    if (state.selectionRect == Rect.zero) return state;
    final newSelectionRect = Rect.fromPoints(origin, position);
    final newSelectedNodes = state.nodeIndex.queryNodesInRect(newSelectionRect);

    final edgesInArea = <String>{};
    for (final nodeId in newSelectedNodes) {
      final connectedEdges = state.edgeIndex.getEdgesForNode(nodeId);
      for (final edgeId in connectedEdges) {
        final edge = state.edges[edgeId];
        if (edge != null &&
            newSelectedNodes.contains(edge.sourceNodeId) &&
            newSelectedNodes.contains(edge.targetNodeId)) {
          edgesInArea.add(edgeId);
        }
      }
    }
    final newSelectedEdges = edgesInArea;

    final newNodeStates = Map<String, NodeRuntimeState>.from(state.nodeStates);
    final newEdgeStates = Map<String, EdgeRuntimeState>.from(state.edgeStates);

    for (final oldSelectedId in state.selectedNodes) {
      if (!newSelectedNodes.contains(oldSelectedId)) {
        newNodeStates[oldSelectedId] =
            (newNodeStates[oldSelectedId] ?? const NodeRuntimeState())
                .copyWith(selected: false);
      }
    }

    for (final newSelectedId in newSelectedNodes) {
      newNodeStates[newSelectedId] =
          (newNodeStates[newSelectedId] ?? const NodeRuntimeState())
              .copyWith(selected: true);
    }

    for (final oldSelectedId in state.selectedEdges) {
      if (!newSelectedEdges.contains(oldSelectedId)) {
        newEdgeStates[oldSelectedId] =
            (newEdgeStates[oldSelectedId] ?? const EdgeRuntimeState())
                .copyWith(selected: false);
      }
    }
    for (final newSelectedId in newSelectedEdges) {
      newEdgeStates[newSelectedId] =
          (newEdgeStates[newSelectedId] ?? const EdgeRuntimeState())
              .copyWith(selected: true);
    }

    return state.copyWith(
      selectionRect: newSelectionRect,
      selectedNodes: newSelectedNodes.toSet(),
      selectedEdges: newSelectedEdges,
      nodeStates: newNodeStates,
      edgeStates: newEdgeStates,
    );
  }

  FlowCanvasState endBoxSelection(FlowCanvasState state) {
    return state.copyWith(
      selectionRect: Rect.zero,
    );
  }
}

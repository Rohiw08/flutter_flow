import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

/// Provider for the stateless SelectionService.
final selectionServiceProvider =
    Provider<SelectionService>((ref) => SelectionService());

/// A stateless service for handling business logic related to selection.
///
/// All methods are pure functions that operate on the `FlowCanvasState`
/// and return a new, updated state.
class SelectionService {
  // --- NODE SELECTION ---

  /// Toggles the selection state of a single node.
  FlowCanvasState toggleNodeSelection(
    FlowCanvasState state,
    String nodeId, {
    bool addToSelection = false,
  }) {
    final newSelectedNodes =
        addToSelection ? Set<String>.from(state.selectedNodes) : <String>{};

    if (newSelectedNodes.contains(nodeId)) {
      newSelectedNodes.remove(nodeId);
    } else {
      newSelectedNodes.add(nodeId);
    }

    return state.copyWith(selectedNodes: newSelectedNodes);
  }

  /// Selects all nodes on the canvas.
  FlowCanvasState selectAllNodes(FlowCanvasState state) {
    return state.copyWith(selectedNodes: state.nodes.keys.toSet());
  }

  /// Clears the selection for all nodes.
  FlowCanvasState clearNodeSelection(FlowCanvasState state) {
    if (state.selectedNodes.isEmpty) return state;
    return state.copyWith(selectedNodes: {});
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

    return state.copyWith(selectedEdges: newSelectedEdges);
  }

  /// Clears the selection for all edges.
  FlowCanvasState clearEdgeSelection(FlowCanvasState state) {
    if (state.selectedEdges.isEmpty) return state;
    return state.copyWith(selectedEdges: {});
  }

  // --- BOX SELECTION ---

  /// Starts a box selection gesture.
  FlowCanvasState startBoxSelection(FlowCanvasState state, Offset position) {
    return state.copyWith(
      selectionRect: Rect.fromPoints(position, position),
    );
  }

  /// Updates the box selection area and calculates the selected nodes within it.
  FlowCanvasState updateBoxSelection(
    FlowCanvasState state,
    Offset position, {
    SelectionMode selectionMode = SelectionMode.partial,
  }) {
    if (state.selectionRect == null) return state;

    final newSelectionRect =
        Rect.fromPoints(state.selectionRect!.topLeft, position);

    // Find nodes within the selection area
    final nodesInArea = <String>{};
    for (final node in state.nodes.values) {
      final overlaps = selectionMode == SelectionMode.partial
          ? newSelectionRect.overlaps(node.rect)
          : newSelectionRect.contains(node.rect.topLeft) &&
              newSelectionRect.contains(node.rect.bottomRight);

      if (overlaps) {
        nodesInArea.add(node.id);
      }
    }

    // Select edges where both endpoints are selected
    final edgesInArea = <String>{};
    for (final entry in state.edges.entries) {
      final e = entry.value;
      if (nodesInArea.contains(e.sourceNodeId) &&
          nodesInArea.contains(e.targetNodeId)) {
        edgesInArea.add(entry.key);
      }
    }

    return state.copyWith(
      selectionRect: newSelectionRect,
      selectedNodes: nodesInArea,
      selectedEdges: edgesInArea,
    );
  }

  /// Ends the box selection process.
  FlowCanvasState endBoxSelection(FlowCanvasState state) {
    return state.copyWith(
      selectionRect: null,
    );
  }
}

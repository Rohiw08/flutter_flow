import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

/// Provider for the stateless SelectionService.
final selectionServiceProvider =
    Provider<SelectionService>((ref) => SelectionService());

/// A stateless service for handling business logic related to selection.
class SelectionService {
  /// Selects a single node.
  FlowCanvasState selectNode(
    FlowCanvasState currentState,
    String nodeId, {
    bool multiSelect = false,
  }) {
    Set<String> newSelectedNodes;
    if (multiSelect && currentState.enableMultiSelection) {
      newSelectedNodes = {...currentState.selectedNodes, nodeId};
    } else {
      newSelectedNodes = {nodeId};
    }

    // If the selection hasn't changed, do nothing.
    if (newSelectedNodes.length == currentState.selectedNodes.length &&
        newSelectedNodes.difference(currentState.selectedNodes).isEmpty) {
      return currentState;
    }

    return _updateSelection(currentState, newSelectedNodes);
  }

  /// Deselects a single node.
  FlowCanvasState deselectNode(FlowCanvasState currentState, String nodeId) {
    if (!currentState.selectedNodes.contains(nodeId)) {
      return currentState; // Nothing to change
    }
    final newSelectedNodes = Set<String>.from(currentState.selectedNodes)
      ..remove(nodeId);
    return _updateSelection(currentState, newSelectedNodes);
  }

  /// Deselects all nodes.
  FlowCanvasState deselectAll(FlowCanvasState currentState) {
    if (currentState.selectedNodes.isEmpty) {
      return currentState;
    }
    return _updateSelection(currentState, {});
  }

  /// Selects all nodes.
  FlowCanvasState selectAll(FlowCanvasState currentState) {
    if (!currentState.enableMultiSelection) {
      return currentState;
    }
    final allNodeIds = currentState.nodes.map((n) => n.id).toSet();
    return _updateSelection(currentState, allNodeIds);
  }

  /// Starts a box selection.
  FlowCanvasState startSelection(
      FlowCanvasState currentState, Offset position) {
    return currentState.copyWith(
      dragMode: DragMode.selection,
      selectionRect: Rect.fromPoints(position, position),
    );
  }

  /// Updates the box selection area and selects nodes within it.
  FlowCanvasState updateSelection(
      FlowCanvasState currentState, Offset position) {
    if (currentState.selectionRect == null) return currentState;

    final newSelectionRect =
        Rect.fromPoints(currentState.selectionRect!.topLeft, position);

    // This logic is from the old `selectNodesInArea`
    final nodesInArea = currentState.nodes
        .where((node) => newSelectionRect.overlaps(node.rect))
        .map((node) => node.id)
        .toSet();

    // Box selection does not support multi-select (addToSelection), it always replaces.
    final newState = _updateSelection(currentState, nodesInArea);
    return newState.copyWith(selectionRect: newSelectionRect);
  }

  /// Ends the box selection process.
  FlowCanvasState endSelection(FlowCanvasState currentState) {
    return currentState.copyWith(
      dragMode: DragMode.none,
      selectionRect: null,
    );
  }

  /// A private utility to compute the new state based on a new set of selected node IDs.
  /// This is the replacement for the old `_updateNodeSelectionStatus` method.
  FlowCanvasState _updateSelection(
    FlowCanvasState currentState,
    Set<String> newSelectedNodes,
  ) {
    final newNodes = currentState.nodes.map((node) {
      final isSelected = newSelectedNodes.contains(node.id);
      // Only create a new node object if its selection status has changed.
      if (node.isSelected != isSelected) {
        return node.copyWith(isSelected: isSelected);
      }
      return node;
    }).toList();

    return currentState.copyWith(
      nodes: newNodes,
      selectedNodes: newSelectedNodes,
    );
  }
}

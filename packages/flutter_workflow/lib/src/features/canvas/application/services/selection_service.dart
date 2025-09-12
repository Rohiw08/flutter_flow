import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_workflow/src/features/canvas/domain/options/flow_options.dart';
import 'package:flutter_workflow/src/features/canvas/domain/options/viewport_options.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
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
    required FlowOptions flowOptions,
  }) {
    final node = currentState.internalNodes[nodeId];
    if (node == null ||
        !(node.isSelectable ?? flowOptions.elementsSelectable)) {
      return currentState;
    }

    BuiltSet<String> newSelectedNodes;
    if (multiSelect && flowOptions.enableMultiSelection) {
      newSelectedNodes =
          currentState.internalSelectedNodes.rebuild((b) => b.add(nodeId));
    } else {
      newSelectedNodes = BuiltSet<String>([nodeId]);
    }

    // If the selection hasn't changed, do nothing.
    if (newSelectedNodes == currentState.internalSelectedNodes) {
      return currentState;
    }

    return _updateSelection(currentState, newSelectedNodes);
  }

  /// Deselects a single node.
  FlowCanvasState deselectNode(FlowCanvasState currentState, String nodeId) {
    if (!currentState.internalSelectedNodes.contains(nodeId)) {
      return currentState; // Nothing to change
    }

    final newSelectedNodes =
        currentState.internalSelectedNodes.rebuild((b) => b.remove(nodeId));
    return _updateSelection(currentState, newSelectedNodes);
  }

  /// Deselects all nodes.
  FlowCanvasState deselectAll(FlowCanvasState currentState) {
    if (currentState.internalSelectedNodes.isEmpty) {
      return currentState;
    }

    return _updateSelection(currentState, BuiltSet<String>());
  }

  /// Selects all nodes.
  FlowCanvasState selectAll(
      FlowCanvasState currentState, FlowOptions flowOptions) {
    if (!flowOptions.enableMultiSelection ||
        currentState.internalNodes.isEmpty) {
      return currentState;
    }

    final allNodeIds = BuiltSet<String>(currentState.internalNodes.keys);
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
    FlowCanvasState currentState,
    Offset position, {
    required ViewportOptions viewportOptions,
  }) {
    if (currentState.selectionRect == null) return currentState;

    final newSelectionRect =
        Rect.fromPoints(currentState.selectionRect!.topLeft, position);

    // Find nodes in the selection area
    final nodesInArea = <String>{};
    for (final node in currentState.internalNodes.values) {
      final overlaps = viewportOptions.selectionMode == SelectionMode.partial
          ? newSelectionRect.overlaps(node.rect)
          : newSelectionRect.contains(node.rect.topLeft) &&
              newSelectionRect.contains(node.rect.bottomRight);
      if (overlaps) {
        nodesInArea.add(node.id);
      }
    }

    final newSelectedNodes = BuiltSet<String>(nodesInArea);
    final newState = _updateSelection(currentState, newSelectedNodes);

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
  FlowCanvasState _updateSelection(
    FlowCanvasState currentState,
    BuiltSet<String> newSelectedNodes,
  ) {
    // Update node selection status
    final nodesBuilder = currentState.internalNodes.toBuilder();

    // First, deselect all previously selected nodes that are no longer selected
    for (final id in currentState.internalSelectedNodes) {
      if (!newSelectedNodes.contains(id)) {
        final node = nodesBuilder[id];
        if (node != null) {
          nodesBuilder[id] = node.copyWith(isSelected: false);
        }
      }
    }

    // Then, select all newly selected nodes
    for (final id in newSelectedNodes) {
      final node = nodesBuilder[id];
      if (node != null && !(node.isSelected)) {
        nodesBuilder[id] = node.copyWith(isSelected: true);
      }
    }

    return currentState.copyWith(
      internalNodes: nodesBuilder.build(),
      internalSelectedNodes: newSelectedNodes,
    );
  }

  /// Toggles a node's selection state
  FlowCanvasState toggleNodeSelection(
      FlowCanvasState currentState, String nodeId,
      {required FlowOptions flowOptions}) {
    if (currentState.internalSelectedNodes.contains(nodeId)) {
      return deselectNode(currentState, nodeId);
    } else {
      return selectNode(currentState, nodeId,
          multiSelect: true, flowOptions: flowOptions);
    }
  }

  /// Selects nodes in a specific area (useful for programmatic selection)
  FlowCanvasState selectNodesInArea(
    FlowCanvasState currentState,
    Rect area, {
    required ViewportOptions viewportOptions,
  }) {
    final nodesInArea = <String>{};

    for (final node in currentState.internalNodes.values) {
      final overlaps = viewportOptions.selectionMode == SelectionMode.partial
          ? area.overlaps(node.rect)
          : area.contains(node.rect.topLeft) &&
              area.contains(node.rect.bottomRight);
      if (overlaps) {
        nodesInArea.add(node.id);
      }
    }

    return _updateSelection(currentState, BuiltSet<String>(nodesInArea));
  }
}

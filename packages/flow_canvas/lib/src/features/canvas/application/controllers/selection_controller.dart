import 'package:flow_canvas/src/features/canvas/application/events/selection_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_query_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/selection_service.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/selection_change_stream.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/material.dart';

class SelectionController {
  final FlowCanvasController _controller;
  final SelectionService _selectionService;
  final SelectionStreams _selectionStreams;
  final NodeQueryService _nodeQueryService;

  // Assumes a SelectionController will be created and passed in

  SelectionController({
    required FlowCanvasController controller,
    required SelectionService selectionService,
    required SelectionStreams selectionStreams,
    required NodeQueryService nodeQueryService,
  })  : _controller = controller,
        _selectionService = selectionService,
        _selectionStreams = selectionStreams,
        _nodeQueryService = nodeQueryService;

  Set<String> _getNodesInSelectionRect() {
    final rect = _controller.currentState.selectionRect;
    if (rect == null) return {};
    final cartesianRect =
        _controller.coordinateConverter.renderRectToCartesianRect(rect);
    final foundNodes =
        _nodeQueryService.queryInRect(_controller.currentState, cartesianRect);
    return foundNodes;
  }

  void selectNode(String nodeId, {bool addToSelection = false}) {
    final wasSelected = _controller.currentState.selectedNodes.contains(nodeId);
    _controller.updateStateOnly(
      _selectionService.toggleNodeSelection(_controller.currentState, nodeId,
          addToSelection: addToSelection),
    );
    final isSelected = _controller.currentState.selectedNodes.contains(nodeId);
    if (wasSelected != isSelected) {
      _selectionStreams.emitEvent(SelectionChangeEvent(
        selectedNodeIds: _controller.currentState.selectedNodes,
        selectedEdgeIds: _controller.currentState.selectedEdges,
        state: _controller.currentState,
      ));
    }
  }

  void selectEdge(String edgeId, {bool addToSelection = false}) {
    final oldState = _controller.currentState;
    _controller.updateStateOnly(_selectionService.toggleEdgeSelection(
        _controller.currentState, edgeId,
        addToSelection: addToSelection));

    if (oldState.selectedNodes != _controller.currentState.selectedNodes ||
        oldState.selectedEdges != _controller.currentState.selectedEdges) {
      _selectionStreams.emitEvent(SelectionChangeEvent(
        selectedNodeIds: _controller.currentState.selectedNodes,
        selectedEdgeIds: _controller.currentState.selectedEdges,
        state: _controller.currentState,
      ));
    }
  }

  void deselectAll() {
    _controller.updateStateOnly(
        _selectionService.deselectAll(_controller.currentState));
    _selectionStreams.emitEvent(SelectionChangeEvent(
      selectedNodeIds: _controller.currentState.selectedNodes,
      selectedEdgeIds: _controller.currentState.selectedEdges,
      state: _controller.currentState,
    ));
  }

  void selectAll() {
    _controller
        .updateStateOnly(_selectionService.selectAll(_controller.currentState));
    _selectionStreams.emitEvent(SelectionChangeEvent(
      selectedNodeIds: _controller.currentState.selectedNodes,
      selectedEdgeIds: _controller.currentState.selectedEdges,
      state: _controller.currentState,
    ));
  }

  Offset? _selectionDragOrigin;

  void startSelection(Offset position) {
    _selectionDragOrigin = position;
    final stateAfterStart =
        _selectionService.startBoxSelection(_controller.currentState, position);
    // Set the drag mode to notify other parts of the UI that a selection is in progress.
    // This is a transient state change, so we don't record it to history.
    _controller.updateStateOnly(
        stateAfterStart.copyWith(dragMode: DragMode.selection));
  }

  void updateSelection(Offset position, {SelectionMode? selectionMode}) {
    if (_controller.currentState.dragMode != DragMode.selection) return;

    // First, update the visual selection rectangle.
    final stateWithNewRect = _selectionService.updateBoxSelection(
      _controller.currentState,
      _selectionDragOrigin!,
      position,
      selectionMode: selectionMode ?? SelectionMode.partial,
      nodeQueryService: _nodeQueryService,
    );

    // Now, find which nodes are inside this new rectangle.
    final selectedNodes = _getNodesInSelectionRect();

    // Update the state without saving to history, as this is an intermediate drag state.
    _controller.updateStateOnly(
      stateWithNewRect.copyWith(selectedNodes: selectedNodes),
    );
  }

  void endSelection() {
    _selectionDragOrigin = null;

    // Get the final set of selected nodes from the last known selection rectangle.
    final finalSelectedNodes = _getNodesInSelectionRect();

    // When selection ends, commit the final selected nodes to history.
    // This mutation also removes the selection rectangle and resets the drag mode.
    _controller.mutate((s) => s.copyWith(
          selectedNodes: finalSelectedNodes,
          selectionRect: null,
        ));

    _selectionStreams.emitEvent(SelectionChangeEvent(
      selectedNodeIds: _controller.currentState.selectedNodes,
      selectedEdgeIds: _controller.currentState.selectedEdges,
      state: _controller.currentState,
    ));
  }
}

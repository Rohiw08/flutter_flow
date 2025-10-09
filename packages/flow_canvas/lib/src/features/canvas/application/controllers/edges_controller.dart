import 'package:flow_canvas/src/features/canvas/application/callbacks/edge_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/pane_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/selection_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/events/edge_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/edges_flow_state_chnage_event.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_geometry_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_service.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/edge_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/edges_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flutter/gestures.dart';

// Assumes a SelectionController will be created and passed in.
// import 'selection_controller.dart';

class EdgesController {
  final FlowCanvasController _controller;
  final EdgeService _edgeService;
  final EdgeGeometryService _edgeGeometryService;
  final EdgeInteractionCallbacks _edgeInteractionCallbacks;
  final EdgeStateCallbacks _edgeStateCallbacks;
  final EdgeInteractionStreams _edgeStreams;
  final EdgesStateStreams _edgesStateStreams;
  final PaneCallbacks _paneCallbacks;
  final SelectionController _selectionController;

  // This will be needed for deselectAll and selectEdge
  // final SelectionController _selectionController;

  EdgesController({
    required FlowCanvasController controller,
    required EdgeService edgeService,
    required EdgeGeometryService edgeGeometryService,
    required EdgeInteractionCallbacks edgeInteractionCallbacks,
    required EdgeStateCallbacks edgeStateCallbacks,
    required EdgeInteractionStreams edgeStreams,
    required EdgesStateStreams edgesStateStreams,
    required PaneCallbacks paneCallbacks,
    required SelectionController selectionController,
  })  : _controller = controller,
        _edgeService = edgeService,
        _edgeGeometryService = edgeGeometryService,
        _edgeInteractionCallbacks = edgeInteractionCallbacks,
        _edgeStateCallbacks = edgeStateCallbacks,
        _edgeStreams = edgeStreams,
        _edgesStateStreams = edgesStateStreams,
        _paneCallbacks = paneCallbacks,
        _selectionController = selectionController;

  void addEdge(FlowEdge edge) {
    _controller.mutate((s) => _edgeService.addEdge(s, edge));
    _edgeGeometryService.updateEdge(_controller.currentState, edge.id);

    final event = EdgeLifecycleEvent(
      type: EdgeLifecycleType.add,
      state: _controller.currentState,
      edgeId: edge.id,
      data: edge,
    );
    _edgesStateStreams.emitEvent(event);
    _edgeStateCallbacks.onEdgeAdd(event);
  }

  void addEdges(List<FlowEdge> edges) {
    _controller.mutate((s) => _edgeService.addEdges(s, edges));
    for (final edge in edges) {
      _edgeGeometryService.updateEdge(_controller.currentState, edge.id);
    }

    final events = edges
        .map((e) => EdgeLifecycleEvent(
              type: EdgeLifecycleType.add,
              state: _controller.currentState,
              edgeId: e.id,
              data: e,
            ))
        .toList();
    _edgesStateStreams.emitBulk(events);
    for (final event in events) {
      _edgeStateCallbacks.onEdgeAdd(event);
    }
  }

  void removeSelectedEdges() {
    final edgesToRemove =
        Set<String>.from(_controller.currentState.selectedEdges);
    if (edgesToRemove.isEmpty) return;

    _controller
        .mutate((s) => _edgeService.removeEdges(s, edgesToRemove.toList()));
    _edgeGeometryService.removeEdges(edgesToRemove);

    final events = edgesToRemove
        .map((id) => EdgeLifecycleEvent(
              type: EdgeLifecycleType.remove,
              state: _controller.currentState,
              edgeId: id,
            ))
        .toList();
    _edgesStateStreams.emitBulk(events);
    for (final event in events) {
      _edgeStateCallbacks.onEdgeRemove(event);
    }
  }

  void updateEdge(String edgeId, EdgeDataUpdater updater) {
    final oldEdge = _controller.currentState.edges[edgeId];
    if (oldEdge == null) return;

    _controller.mutate((s) => _edgeService.updateEdgeData(s, edgeId, updater));
    _edgeGeometryService.updateEdge(_controller.currentState, edgeId);

    final newEdge = _controller.currentState.edges[edgeId];
    final event = EdgeLifecycleEvent(
      type: EdgeLifecycleType.update,
      state: _controller.currentState,
      edgeId: edgeId,
      data: {'old': oldEdge.data, 'new': newEdge?.data},
    );
    _edgesStateStreams.emitEvent(event);
    _edgeStateCallbacks.onEdgeUpdate(event);
  }

  void reconnectEdge({
    required String edgeId,
    String? newSourceNodeId,
    String? newSourceHandleId,
    String? newTargetNodeId,
    String? newTargetHandleId,
  }) {
    _controller.mutate((s) => _edgeService.reconnectEdge(s, edgeId,
        newSourceNodeId: newSourceNodeId,
        newSourceHandleId: newSourceHandleId,
        newTargetNodeId: newTargetNodeId,
        newTargetHandleId: newTargetHandleId));

    final event = EdgeLifecycleEvent(
      type: EdgeLifecycleType.reconnect,
      state: _controller.currentState,
      edgeId: edgeId,
    );
    _edgesStateStreams.emitEvent(event);
    _edgeStateCallbacks.onEdgeReconnect(event);
  }

  void onEdgePointerHover(PointerEvent event, Offset localPosition) {
    final state = _controller.currentState;
    final hit = _edgeGeometryService.hitTestEdgeAt(
        localPosition, state, state.viewport.zoom);

    final currentHoveredId = state.hoveredEdgeId;
    if (hit != currentHoveredId) {
      _controller.updateStateOnly(state.copyWith(hoveredEdgeId: hit));

      if (currentHoveredId != null) {
        _edgeInteractionCallbacks.onMouseLeave(currentHoveredId, event);
        _edgeStreams.emitEvent(
            EdgeMouseLeaveEvent(edgeId: currentHoveredId, details: event));
      }
      if (hit != null) {
        _edgeInteractionCallbacks.onMouseEnter(hit, event);
        _edgeStreams
            .emitEvent(EdgeMouseEnterEvent(edgeId: hit, details: event));
      }
    }

    if (hit != null) {
      _edgeInteractionCallbacks.onMouseMove(hit, event);
      _edgeStreams.emitEvent(EdgeMouseMoveEvent(edgeId: hit, details: event));
    }
  }

  void onEdgeTapDown(TapDownDetails details, Offset localPosition) {
    final state = _controller.currentState;
    final hit = _edgeGeometryService.hitTestEdgeAt(
        localPosition, state, state.viewport.zoom);

    _controller.updateStateOnly(state.copyWith(lastClickedEdgeId: hit));

    if (hit != null) {
      if (state.edges[hit]?.selectable ?? true) {
        // Delegate to SelectionController
        _selectionController.selectEdge(hit, addToSelection: false);
      }
      _edgeInteractionCallbacks.onClick(hit, details);
      _edgeStreams.emitEvent(EdgeClickEvent(edgeId: hit, details: details));
    } else {
      // If no edge was hit, treat it as a pane tap
      _selectionController.deselectAll();
      _paneCallbacks.onTap(details);
    }
  }

  void onEdgeDoubleTap() {
    final lastDownEdgeId = _controller.currentState.lastClickedEdgeId;
    if (lastDownEdgeId != null) {
      _edgeInteractionCallbacks.onDoubleClick(lastDownEdgeId);
      _edgeStreams.emitEvent(EdgeDoubleClickEvent(edgeId: lastDownEdgeId));
    }
  }

  void onEdgeLongPressStart(
      LongPressStartDetails details, Offset localPosition) {
    final state = _controller.currentState;
    final hit = _edgeGeometryService.hitTestEdgeAt(
        localPosition, state, state.viewport.zoom);
    if (hit != null) {
      _edgeInteractionCallbacks.onContextMenu(hit, details);
      _edgeStreams
          .emitEvent(EdgeContextMenuEvent(edgeId: hit, details: details));
    }
  }
}

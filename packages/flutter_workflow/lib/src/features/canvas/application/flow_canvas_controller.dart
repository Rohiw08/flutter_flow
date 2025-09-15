import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/clipboard_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/connection_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/history_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/node_query_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_query_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/node_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/selection_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/viewport_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/z_index_service.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flutter_workflow/src/options/components/fitview_options.dart';

class FlowCanvasController extends StateNotifier<FlowCanvasState> {
  final Ref ref;
  final NodeRegistry nodeRegistry;
  final EdgeRegistry edgeRegistry;

  // UI controller for InteractiveViewer
  final TransformationController transformationController =
      TransformationController();

  // Public stream of state for the presentation layer
  final StreamController<FlowCanvasState> _stateStreamController =
      StreamController<FlowCanvasState>.broadcast();
  @override
  Stream<FlowCanvasState> get stream => _stateStreamController.stream;

  // Services
  final NodeService _nodeService;
  final EdgeService _edgeService;
  final SelectionService _selectionService;
  final ViewportService _viewportService;
  final ConnectionService _connectionService;
  final ZIndexService _zIndexService;
  final NodeQueryService _nodeQueryService;
  final EdgeQueryService _edgeQueryService;
  final ClipboardService _clipboardService;
  final HistoryService _history;

  FlowCanvasController(
    this.ref, {
    required this.nodeRegistry,
    required this.edgeRegistry,
  })  : _nodeService = NodeService(),
        _edgeService = EdgeService(),
        _selectionService = SelectionService(),
        _viewportService = ViewportService(),
        _connectionService = ConnectionService(),
        _zIndexService = ZIndexService(),
        _nodeQueryService = NodeQueryService(),
        _edgeQueryService = EdgeQueryService(),
        _clipboardService = ClipboardService(),
        _history = HistoryService(),
        super(FlowCanvasState.initial()) {
    _history.init(state);
    _emit();
  }

  // --- Emit helper ---
  void _emit() {
    if (!_stateStreamController.isClosed) {
      _stateStreamController.add(state);
    }
  }

  // --- Viewport & Transform ---
  void setViewportSize(Size size) {
    state = state.copyWith(viewportSize: size);
    _emit();
  }

  void pan(Offset delta) {
    state = _history.apply(state, (s) => _viewportService.pan(s, delta));
    _emit();
  }

  void zoom(double delta,
      {Offset focalPoint = Offset.zero,
      double minZoom = 0.5,
      double maxZoom = 2.0}) {
    final zoomFactor = 1 + delta;
    state = _history.apply(
        state,
        (s) => _viewportService.zoom(
              s,
              zoomFactor: zoomFactor,
              focalPoint: focalPoint,
              minZoom: minZoom,
              maxZoom: maxZoom,
            ));
    _emit();
  }

  void fitView({FitViewOptions options = const FitViewOptions()}) {
    state = _history.apply(
        state, (s) => _viewportService.fitView(s, options: options));
    _emit();
  }

  void centerView() {
    if (state.viewportSize == null) return;
    // Center the viewport on the canvas origin (0,0)
    centerOnPosition(Offset.zero);
  }

  void resetView() {
    state = state.copyWith(
        viewport: const FlowViewport(offset: Offset.zero, zoom: 1.0));
    _emit();
  }

  void centerOnPosition(Offset canvasPosition) {
    if (state.viewportSize == null) return;
    final newOffset = (canvasPosition * state.viewport.zoom * -1) +
        Offset(state.viewportSize!.width / 2, state.viewportSize!.height / 2);
    state =
        state.copyWith(viewport: state.viewport.copyWith(offset: newOffset));
    _emit();
  }

  // --- Nodes ---
  void addNode(FlowNode node) {
    state = _history.apply(state, (s) => _nodeService.addNode(s, node));
    _emit();
  }

  // Node selection helpers
  void selectNode(String nodeId) {
    state = _nodeService.selectNode(state, nodeId);
    _emit();
  }

  void addNodeToSelection(String nodeId) {
    state = _nodeService.addNodeToSelection(state, nodeId);
    _emit();
  }

  void removeNodeFromSelection(String nodeId) {
    state = _nodeService.removeNodeFromSelection(state, nodeId);
    _emit();
  }

  void toggleNodeSelection(String nodeId) {
    state = _nodeService.toggleNodeSelection(state, nodeId);
    _emit();
  }

  void dragSelectedBy(Offset delta, {bool snapToGrid = false, SnapGrid? grid}) {
    state =
        _history.apply(state, (s) => _nodeService.dragSelectedNodes(s, delta));
    if (snapToGrid && grid != null) {
      final newNodes = Map<String, FlowNode>.from(state.nodes);
      NodeIndex newIndex = state.nodeIndex;
      for (final id in state.selectedNodes) {
        final n = newNodes[id];
        if (n == null) continue;
        final snapped = Offset(
          (n.position.dx / grid.width).round() * grid.width,
          (n.position.dy / grid.height).round() * grid.height,
        );
        if (snapped != n.position) {
          newNodes[id] = n.copyWith(position: snapped);
          newIndex = newIndex.updateNodePosition(id, snapped);
        }
      }
      state = state.copyWith(nodes: newNodes, nodeIndex: newIndex);
    }
    _emit();
  }

  void removeSelectedNodes() {
    state = _history.apply(state, (s) {
      FlowCanvasState cur = s;
      for (final nodeId in s.selectedNodes) {
        cur = _nodeService.removeNodeAndConnections(cur, nodeId);
      }
      return cur.copyWith(selectedNodes: {}, selectedEdges: {});
    });
    _emit();
  }

  void deselectAll() {
    state = state.copyWith(selectedNodes: {}, selectedEdges: {});
    _emit();
  }

  // --- Selection ---
  void startSelection(Offset position) {
    state = _selectionService.startBoxSelection(state, position);
    _emit();
  }

  void updateSelection(Offset position,
      {SelectionMode selectionMode = SelectionMode.partial}) {
    state = _selectionService.updateBoxSelection(state, position,
        selectionMode: selectionMode);
    _emit();
  }

  void endSelection() {
    state = _selectionService.endBoxSelection(state);
    _emit();
  }

  // --- Connection ---
  void startConnection(String nodeId, String handleId, Offset startPosition) {
    state = _connectionService.startConnection(state,
        fromNodeId: nodeId,
        fromHandleId: handleId,
        startPosition: startPosition);
    _emit();
  }

  void updateConnection(Offset cursorPosition) {
    state = _connectionService.updateConnection(state, cursorPosition);
    _emit();
  }

  void endConnection() {
    state = _connectionService.endConnection(state);
    _emit();
  }

  void togglePanZoomLock() {
    state = state.copyWith(isPanZoomLocked: !state.isPanZoomLocked);
    _emit();
  }

  // --- Disposal ---
  @override
  void dispose() {
    _stateStreamController.close();
    transformationController.dispose();
    super.dispose();
  }
}

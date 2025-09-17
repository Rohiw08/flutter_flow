import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/clipboard_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/connection_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/history_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/keyboard_action_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/node_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/selection_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/serialization_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/viewport_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/z_index_service.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/fitview_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/keyboard_options.dart';

import '../../../shared/enums.dart';

/// The central state management hub for the Flow Canvas.
///
/// This controller coordinates all the domain services (NodeService, EdgeService, etc.)
/// to manipulate the immutable `FlowCanvasState`. It integrates a history service
/// for undo/redo capabilities and exposes a clean API for the UI layer (via FlowCanvasFacade).
class FlowCanvasController extends StateNotifier<FlowCanvasState> {
  final Ref ref;
  final NodeRegistry nodeRegistry;
  final EdgeRegistry edgeRegistry;

  // UI controller for InteractiveViewer, synced with our state's viewport.
  final TransformationController transformationController =
      TransformationController();

  // --- Domain Services ---
  final NodeService _nodeService;
  final EdgeService _edgeService;
  final SelectionService _selectionService;
  final ViewportService _viewportService;
  final ConnectionService _connectionService;
  final ZIndexService _zIndexService;
  final ClipboardService _clipboardService;
  final HistoryService _history;
  final KeyboardActionService _keyboardActionService;
  final SerializationService _serializationService;

  FlowCanvasController(
    this.ref, {
    required this.nodeRegistry,
    required this.edgeRegistry,
    FlowCanvasState? initialState,
  })  : _nodeService = NodeService(),
        _edgeService = EdgeService(),
        _selectionService = SelectionService(),
        _viewportService = ViewportService(),
        _connectionService = ConnectionService(),
        _zIndexService = ZIndexService(),
        _clipboardService = ClipboardService(),
        _history = HistoryService(),
        _keyboardActionService = KeyboardActionService(
          history: HistoryService(),
          nodeService: NodeService(),
          edgeService: EdgeService(),
          selectionService: SelectionService(),
          viewportService: ViewportService(),
          clipboardService: ClipboardService(),
        ),
        _serializationService = SerializationService(),
        super(initialState ?? FlowCanvasState.initial()) {
    // Initialize the history service with the starting state.
    _history.init(state);
    // Sync the InteractiveViewer controller with the initial viewport state.
    _updateTransformationController();

    // Listen to our own state changes to keep the TransformationController in sync.
    addListener((newState) {
      _updateTransformationController();
    });
  }

  // --- State Update Helper ---
  /// Applies a mutation and updates the state, saving the change to history.
  void _mutate(FlowCanvasState Function(FlowCanvasState) mutation) {
    state = _history.apply(state, mutation);
  }

  // --- Viewport & Transform ---
  void setViewportSize(Size size) {
    if (state.viewportSize != size) {
      _mutate((s) => s.copyWith(viewportSize: size));
    }
  }

  void pan(Offset delta) => _mutate((s) => _viewportService.pan(s, delta));

  void zoom(
    double zoomFactor, {
    required Offset focalPoint,
    required double minZoom,
    required double maxZoom,
  }) =>
      _mutate((s) => _viewportService.zoom(
            s,
            zoomFactor: 1 + zoomFactor, // service expects a factor
            focalPoint: focalPoint,
            minZoom: minZoom,
            maxZoom: maxZoom,
          ));

  void fitView({FitViewOptions options = const FitViewOptions()}) =>
      _mutate((s) => _viewportService.fitView(s, options: options));

  void centerView() {
    if (state.viewportSize == null) return;
    centerOnPosition(Offset.zero);
  }

  void resetView() =>
      _mutate((s) => s.copyWith(viewport: const FlowViewport()));

  void centerOnPosition(Offset canvasPosition) {
    if (state.viewportSize == null) return;
    final newOffset = (canvasPosition * state.viewport.zoom * -1) +
        Offset(state.viewportSize!.width / 2, state.viewportSize!.height / 2);
    _mutate(
        (s) => s.copyWith(viewport: s.viewport.copyWith(offset: newOffset)));
  }

  // --- Nodes ---
  void addNode(FlowNode node) => _mutate((s) => _nodeService.addNode(s, node));

  void removeSelectedNodes() => _mutate((s) {
        FlowCanvasState currentState = s;
        for (final nodeId in s.selectedNodes) {
          currentState =
              _nodeService.removeNodeAndConnections(currentState, nodeId);
        }
        return currentState.copyWith(selectedNodes: {}, selectedEdges: {});
      });

  void dragSelectedBy(Offset delta) =>
      _mutate((s) => _nodeService.dragSelectedNodes(s, delta));

  // --- Edges ---
  void addEdge(FlowEdge edge) => _mutate((s) => _edgeService.addEdge(s, edge));

  void removeSelectedEdges() =>
      _mutate((s) => _edgeService.removeEdges(s, s.selectedEdges.toList()));

  // --- Selection ---
  void selectNode(String nodeId, {bool addToSelection = false}) =>
      _mutate((s) => _selectionService.toggleNodeSelection(s, nodeId,
          addToSelection: addToSelection));

  void selectEdge(String edgeId, {bool addToSelection = false}) =>
      _mutate((s) => _selectionService.toggleEdgeSelection(s, edgeId,
          addToSelection: addToSelection));

  void startSelection(Offset position) =>
      _mutate((s) => _selectionService.startBoxSelection(s, position));

  void updateSelection(Offset position, {SelectionMode? selectionMode}) =>
      _mutate((s) => _selectionService.updateBoxSelection(s, position,
          selectionMode: selectionMode ?? SelectionMode.partial));

  void endSelection() => _mutate((s) => _selectionService.endBoxSelection(s));

  void deselectAll() => _mutate((s) => s.copyWith(
        selectedNodes: {},
        selectedEdges: {},
      ));

  // --- Connections ---
  void startConnection(String nodeId, String handleId, Offset startPosition) =>
      _mutate((s) => _connectionService.startConnection(s,
          fromNodeId: nodeId,
          fromHandleId: handleId,
          startPosition: startPosition));

  void updateConnection(Offset cursorPosition) {
    // This is a transient update, so we don't record it in history.
    state = _connectionService.updateConnection(state, cursorPosition);
  }

  void endConnection() => _mutate((s) => _connectionService.endConnection(s));

  // --- Z-Index ---
  void bringToFront() => _mutate((s) => _zIndexService.bringSelectedToFront(s));
  void sendToBack() => _mutate((s) => _zIndexService.sendSelectedToBack(s));

  // --- History ---
  void undo() {
    final prevState = _history.undo();
    if (prevState != null) {
      state = prevState;
    }
  }

  void redo() {
    final nextState = _history.redo();
    if (nextState != null) {
      state = nextState;
    }
  }

  // --- Clipboard ---
  void copySelection() {
    _clipboardService.copy(state);
  }

  void paste({Offset? positionOffset}) {
    _mutate((s) {
      final payload = _clipboardService.copy(s);
      return _clipboardService.paste(s, payload,
          positionOffset: positionOffset ?? const Offset(20, 20));
    });
  }

  // --- Keyboard ---
  void handleKeyboardAction(
    KeyboardAction action, {
    required KeyboardOptions options,
  }) =>
      _mutate((s) => _keyboardActionService.handleAction(s, action,
          arrowMoveDelta:
              Offset(options.arrowKeyMoveSpeed, options.arrowKeyMoveSpeed),
          zoomStep: options.zoomStep,
          minZoom: s.viewport.zoom,
          maxZoom: s.viewport.zoom));

  // --- Serialization ---
  Map<String, dynamic> toJson() => _serializationService.toJson(state);

  void fromJson(Map<String, dynamic> json) {
    _mutate((s) => _serializationService.fromJson(s, json));
    _history.clear(); // Clear history after loading a new state
    _history.init(state);
  }

  // --- Private Helpers ---
  /// Syncs the external TransformationController with the internal viewport state.
  void _updateTransformationController() {
    final viewport = state.viewport;
    final matrix = Matrix4.identity()
      ..translate(viewport.offset.dx, viewport.offset.dy)
      ..scale(viewport.zoom);
    transformationController.value = matrix;
  }

  // --- Disposal ---
  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }
}

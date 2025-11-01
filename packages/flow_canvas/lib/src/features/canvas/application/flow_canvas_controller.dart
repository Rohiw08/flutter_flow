import 'package:flow_canvas/src/features/canvas/application/controllers/canvas_queries_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/clipboard_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/connection_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/edge_geometry_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/edges_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/handles_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/history_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/keyboard_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/nodes_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/selection_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/serialization_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/viewport_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/z_index_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/clipboard_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/connection_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_geometry_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/history_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/keyboard_action_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/selection_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/serialization_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/viewport_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/z_index_service.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/connection_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/edge_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/edges_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/node_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/nodes_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/pane_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/selection_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/viewport_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The central state management hub for the Flow Canvas.
///
/// This controller acts as a facade, coordinating all the domain services and sub-controllers
/// to manipulate the immutable `FlowCanvasState`. It integrates a history service
/// for undo/redo capabilities and exposes a clean API for the UI layer.
class FlowCanvasController extends StateNotifier<FlowCanvasState> {
  final Ref ref;

  // UI controller for InteractiveViewer, synced with our state's viewport.
  final TransformationController transformationController =
      TransformationController();
  final GlobalKey canvasKey = GlobalKey();

  // --- Domain Services (read from providers) ---
  late final NodeService _nodeService;
  late final EdgeService _edgeService;
  late final SelectionService _selectionService;
  late final ViewportService _viewportService;
  late final ConnectionService _connectionService;
  late final ZIndexService _zIndexService;
  late final ClipboardService _clipboardService;
  late final HistoryService _history;
  late final SerializationService _serializationService;
  late final KeyboardActionService _keyboardActionService;
  late final CanvasCoordinateConverter coordinateConverter;
  late final EdgeGeometryService edgeGeometryService;

  // --- Sub-Controllers ---
  late final NodesController nodes;
  late final EdgesController edges;
  late final SelectionController selection;
  late final ViewportController viewport;
  late final ConnectionController connection;
  late final ClipboardController clipboard;
  late final HistoryController history;
  late final HandleController handle;
  late final EdgeGeometryController edgeGeometry;
  // late final CanvasQuerier querier;
  late final ZIndexController zIndex;
  late final SerializationController serialization;
  late final KeyboardController keyboard;

  FlowCanvasController(
    this.ref, {
    FlowCanvasState? initialState,
  }) : super(initialState ?? FlowCanvasState.initial()) {
    // Read registries and services from providers
    _nodeService = ref.read(nodeServiceProvider);
    _edgeService = ref.read(edgeServiceProvider);
    _selectionService = ref.read(selectionServiceProvider);
    _viewportService = ref.read(viewportServiceProvider);
    _connectionService = ref.read(connectionServiceProvider);
    _zIndexService = ref.read(zIndexServiceProvider);
    _clipboardService = ref.read(clipboardServiceProvider);
    _history = ref.read(historyServiceProvider);
    _serializationService = ref.read(serializationServiceProvider);
    _keyboardActionService = ref.read(keyboardActionServiceProvider);
    edgeGeometryService = ref.read(edgeGeometryServiceProvider);
    coordinateConverter = ref.read(coordinateConverterProvider);

    // Initialize all sub-controllers, injecting dependencies
    selection = SelectionController(
      controller: this,
      selectionService: _selectionService,
      selectionStreams: _selectionStreams,
    );
    nodes = NodesController(
      controller: this,
      nodeService: _nodeService,
      edgeService: _edgeService,
      nodeInteractionCallbacks: ref.read(nodeCallbacksProvider),
      nodeStateCallbacks: ref.read(nodesStateCallbacksProvider),
      nodeStreams: _nodeStreams,
      nodesStateStreams: _nodesStateStreams,
      selectionController: selection,
    );
    edges = EdgesController(
        controller: this,
        edgeService: _edgeService,
        edgeGeometryService: edgeGeometryService,
        edgeInteractionCallbacks: ref.read(edgeCallbacksProvider),
        edgeStateCallbacks: ref.read(edgesStateCallbacksProvider),
        edgeStreams: _edgeStreams,
        edgesStateStreams: _edgesStateStreams,
        paneCallbacks: ref.read(paneCallbacksProvider),
        selectionController: selection);
    viewport = ViewportController(
      controller: this,
      viewportService: _viewportService,
      coordinateConverter: coordinateConverter,
      viewportStreams: _viewportStreams,
      viewportCallbacks: ref.read(viewportCallbacksProvider),
    );
    connection = ConnectionController(
        controller: this,
        connectionService: _connectionService,
        coordinateConverter: coordinateConverter,
        connectionStreams: _connectionStreams,
        connectionCallbacks: ref.read(connectionCallbacksProvider));
    clipboard = ClipboardController(
        controller: this,
        clipboardService: _clipboardService,
        nodeService: _nodeService,
        edgeService: _edgeService,
        nodesStateStreams: _nodesStateStreams,
        edgesStateStreams: _edgesStateStreams);
    history = HistoryController(controller: this, history: _history);
    handle = HandleController(controller: this);
    edgeGeometry = EdgeGeometryController(
        controller: this, edgeGeometryService: edgeGeometryService);
    // TODO: create querier service for users
    // querier = CanvasQuerier(
    //   controller: this,
    //   nodeQueryService: _nodeQueryService,
    //   edgeQueryService: _edgeQueryService,
    //   connectionService: _connectionService,
    //   viewportService: _viewportService,
    // );
    zIndex = ZIndexController(controller: this, zIndexService: _zIndexService);
    serialization = SerializationController(
        controller: this, serializationService: _serializationService);
    keyboard = KeyboardController(
        controller: this, keyboardActionService: _keyboardActionService);

    // Initialize services that depend on the initial state.
    _history.init(state);
    _updateTransformationController();
    transformationController.addListener(_onTransformationChanged);

    // Main listener to orchestrate updates
    addListener((newState) {
      edgeGeometry.updateGeometryIfNeeded(newState);
      _updateTransformationController();
    });
  }

  // --- Streams ---
  final NodeInteractionStreams _nodeStreams = NodeInteractionStreams();
  final NodesStateStreams _nodesStateStreams = NodesStateStreams();
  final EdgeInteractionStreams _edgeStreams = EdgeInteractionStreams();
  final EdgesStateStreams _edgesStateStreams = EdgesStateStreams();
  final ConnectionStreams _connectionStreams = ConnectionStreams();
  final PaneStreams _paneStreams = PaneStreams();
  final SelectionStreams _selectionStreams = SelectionStreams();
  final ViewportStreams _viewportStreams = ViewportStreams();

  // Public stream accessors
  NodeInteractionStreams get nodeStreams => _nodeStreams;
  NodesStateStreams get nodesStateStreams => _nodesStateStreams;
  EdgeInteractionStreams get edgeStreams => _edgeStreams;
  EdgesStateStreams get edgesStateStream => _edgesStateStreams;
  ConnectionStreams get connectionStreams => _connectionStreams;
  PaneStreams get paneStreams => _paneStreams;
  SelectionStreams get selectionStreams => _selectionStreams;
  ViewportStreams get viewportStreams => _viewportStreams;

  // =================================================================================
  // --- State Update & Private Helpers ---
  // =================================================================================

  /// Applies a mutation and updates the state, saving the change to history.
  void mutate(FlowCanvasState Function(FlowCanvasState) mutation) {
    final newState = mutation(state);
    if (!identical(newState, state)) {
      _history.record(newState);
      state = newState;
    }
    print("state updated");
  }

  /// Updates state WITHOUT saving to history (for transient/intermediate states).
  void updateStateOnly(FlowCanvasState newState) {
    if (!identical(newState, state)) {
      state = newState;
    }
    print("state updated");
  }

  void _updateTransformationController() {
    final viewport = state.viewport;
    final stateMatrix = Matrix4.identity()
      ..translate(viewport.offset.dx, viewport.offset.dy)
      ..scale(viewport.zoom);

    if (transformationController.value != stateMatrix) {
      transformationController.value = stateMatrix;
    }
  }

  void _onTransformationChanged() {
    final matrix = transformationController.value;
    final newOffset =
        Offset(matrix.getTranslation().x, matrix.getTranslation().y);
    final newZoom = matrix.getMaxScaleOnAxis();

    final newViewport = FlowViewport(offset: newOffset, zoom: newZoom);

    if (state.viewport != newViewport) {
      updateStateOnly(state.copyWith(viewport: newViewport));
    }
  }

  // =================================================================================
  // --- Public Delegated API ---
  // =================================================================================

  FlowCanvasState get currentState => state;

  // --- Disposal ---
  @override
  void dispose() {
    _nodeStreams.dispose();
    _nodesStateStreams.dispose();
    _edgeStreams.dispose();
    _edgesStateStreams.dispose();
    _connectionStreams.dispose();
    _paneStreams.dispose();
    _selectionStreams.dispose();
    _viewportStreams.dispose();
    transformationController.removeListener(_onTransformationChanged);
    transformationController.dispose();
    super.dispose();
  }
}

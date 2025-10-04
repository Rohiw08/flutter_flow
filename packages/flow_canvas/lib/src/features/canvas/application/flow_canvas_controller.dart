import 'package:flow_canvas/src/features/canvas/application/callbacks/connection_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/edge_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/node_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/pane_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/viewport_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/events/connection_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/edge_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/edges_flow_state_chnage_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/node_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/nodes_flow_state_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/selection_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/services/clipboard_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/connection_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_geometry_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_query_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/history_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/keyboard_action_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_query_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/selection_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/serialization_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/viewport_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/z_index_service.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/edges_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/nodes_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/selection_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flow_canvas/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/handle_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/fitview_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/keyboard_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'events/viewport_change_event.dart';
import 'streams/connection_change_stream.dart';
import 'streams/edge_change_stream.dart';
import 'streams/node_change_stream.dart';
import 'streams/pane_change_stream.dart';
import 'streams/viewport_change_stream.dart';

/// The central state management hub for the Flow Canvas.
///
/// This controller coordinates all the domain services (NodeService, EdgeService, etc.)
/// to manipulate the immutable `FlowCanvasState`. It integrates a history service
/// for undo/redo capabilities and exposes a clean API for the UI layer (via FlowCanvasFacade).
class FlowCanvasController extends StateNotifier<FlowCanvasState> {
  final Ref ref;

  // UI controller for InteractiveViewer, synced with our state's viewport.
  final TransformationController transformationController =
      TransformationController();
  final GlobalKey canvasKey = GlobalKey();
  Map<String, dynamic>? _clipboardPayload;

  // --- Domain Services (read from providers) ---
  late final NodeRegistry nodeRegistry;
  late final EdgeRegistry edgeRegistry;
  late final NodeService _nodeService;
  late final EdgeService _edgeService;
  late final SelectionService _selectionService;
  late final ViewportService _viewportService;
  late final ConnectionService _connectionService;
  late final ZIndexService _zIndexService;
  late final ClipboardService _clipboardService;
  late final HistoryService _history;
  late final SerializationService _serializationService;
  late final EdgeQueryService _edgeQueryService;
  late final NodeQueryService _nodeQueryService;
  late final KeyboardActionService _keyboardActionService;
  late final CanvasCoordinateConverter coordinateConverter;
  late final EdgeGeometryService edgeGeometryService;

  // Callbacks provided by the user
  late final NodeInteractionCallbacks nodeInteractionCallbacks;
  late final NodeStateCallbacks nodeStateCallbacks;
  late final EdgeInteractionCallbacks edgeInteractionCallbacks;
  late final EdgeStateCallbacks edgeStateCallbacks;
  late final ConnectionCallbacks connectionCallbacks;
  late final PaneCallbacks paneCallbacks;
  late final ViewportCallbacks viewportCallbacks;

  FlowCanvasController(
    this.ref, {
    FlowCanvasState? initialState,
  }) : super(initialState ?? FlowCanvasState.initial()) {
    // Read registries and services from providers
    nodeRegistry = ref.read(nodeRegistryProvider);
    edgeRegistry = ref.read(edgeRegistryProvider);
    _nodeService = ref.read(nodeServiceProvider);
    _edgeService = ref.read(edgeServiceProvider);
    _selectionService = ref.read(selectionServiceProvider);
    _viewportService = ref.read(viewportServiceProvider);
    _connectionService = ref.read(connectionServiceProvider);
    _zIndexService = ref.read(zIndexServiceProvider);
    _clipboardService = ref.read(clipboardServiceProvider);
    _history = ref.read(historyServiceProvider);
    _serializationService = ref.read(serializationServiceProvider);
    _edgeQueryService = ref.read(edgeQueryServiceProvider);
    _nodeQueryService = ref.read(nodeQueryServiceProvider);
    _keyboardActionService = ref.read(keyboardActionServiceProvider);
    edgeGeometryService = ref.read(edgeGeometryServiceProvider);

    // --- Utility ---
    coordinateConverter = ref.read(coordinateConverterProvider);

    // --- Callbacks ---
    nodeInteractionCallbacks = ref.read(nodeCallbacksProvider);
    nodeStateCallbacks = ref.read(nodesStateCallbacksProvider);
    edgeInteractionCallbacks = ref.read(edgeCallbacksProvider);
    edgeStateCallbacks = ref.read(edgesStateCallbacksProvider);
    connectionCallbacks = ref.read(connectionCallbacksProvider);
    paneCallbacks = ref.read(paneCallbacksProvider);
    viewportCallbacks = ref.read(viewportCallbacksProvider);

    // Initialize services that depend on the initial state.
    _history.init(state);
    _updateTransformationController();
    transformationController.addListener(_onTransformationChanged);

    // Listen to our own state changes to keep the TransformationController in sync.
    addListener((newState) {
      edgeGeometryService.updateCache(newState, newState.edges.keys);
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

  // Expose the streams publicly for the developer to listen to
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
  void _mutate(FlowCanvasState Function(FlowCanvasState) mutation) {
    state = _history.apply(state, mutation);
  }

  /// Syncs the external TransformationController with the internal viewport state.
  void _updateTransformationController() {
    final viewport = state.viewport;
    final stateMatrix = Matrix4.identity()
      ..translate(viewport.offset.dx, viewport.offset.dy)
      ..scale(viewport.zoom);

    if (transformationController.value == stateMatrix) {
      return;
    }

    transformationController.value = stateMatrix;
  }

  void _onTransformationChanged() {
    final matrix = transformationController.value;
    final newOffset =
        Offset(matrix.getTranslation().x, matrix.getTranslation().y);
    final newZoom = matrix.getMaxScaleOnAxis();

    final newViewport = FlowViewport(offset: newOffset, zoom: newZoom);

    if (state.viewport != newViewport) {
      state = state.copyWith(viewport: newViewport);
    }
  }

  // =================================================================================
  // --- canvas State ---
  // =================================================================================
  FlowCanvasState get currentState => state;

  // =================================================================================
  // --- Viewport & Transform ---
  // =================================================================================

  void setViewportSize(Size size) {
    if (state.viewportSize != size) {
      _mutate((s) => s.copyWith(viewportSize: size));
      _viewportStreams.emitEvent(ViewportEvent(
        type: ViewportEventType.resize,
        viewport: state.viewport,
        viewportSize: size,
      ));
    }
  }

  /// Pans the viewport by a given screen-space delta.
  /// Use this for programmatic panning where DragUpdateDetails are not available.
  void panBy(Offset delta) {
    _mutate((s) => _viewportService.pan(s, delta));
    _viewportStreams.emitEvent(ViewportEvent(
      type: ViewportEventType.transform,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  void toggleLock() {
    _mutate((s) => s.copyWith(isPanZoomLocked: !s.isPanZoomLocked));
  }

  void zoom({
    required Offset focalPoint,
    required double minZoom,
    required double maxZoom,
    required double zoomFactor,
  }) {
    _mutate((s) => _viewportService.zoom(
          s,
          zoomFactor: 1 + zoomFactor,
          focalPoint: focalPoint,
          minZoom: minZoom,
          maxZoom: maxZoom,
        ));
    _viewportStreams.emitEvent(
      ViewportEvent(
        type: ViewportEventType.transform,
        viewport: state.viewport,
        viewportSize: state.viewportSize,
      ),
    );
  }

  void fitView({FitViewOptions options = const FitViewOptions()}) {
    _mutate((s) => _viewportService.fitView(s, options: options));
    _viewportStreams.emitEvent(ViewportEvent(
      type: ViewportEventType.transform,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  void centerOnOrigin() {
    if (state.viewportSize == null) return;
    centerOnPosition(Offset.zero);
  }

  void resetView() {
    _mutate((s) => s.copyWith(viewport: const FlowViewport()));
    _viewportStreams.emitEvent(ViewportEvent(
      type: ViewportEventType.transform,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  void centerOnPosition(Offset canvasPosition) {
    if (state.viewportSize == null) return;
    final renderPosition = coordinateConverter.toRenderPosition(canvasPosition);

    final newOffset = (renderPosition * state.viewport.zoom * -1) +
        Offset(state.viewportSize!.width / 2, state.viewportSize!.height / 2);
    _mutate(
        (s) => s.copyWith(viewport: s.viewport.copyWith(offset: newOffset)));
    _viewportStreams.emitEvent(ViewportEvent(
      type: ViewportEventType.transform,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  Offset screenToCanvas(Offset screenPosition) =>
      _viewportService.screenToCanvas(state, screenPosition);

  Offset canvasToScreen(Offset canvasPosition) =>
      _viewportService.canvasToScreen(state, canvasPosition);

  Offset screenToCanvasPosition(Offset screenPosition) {
    final renderPosition =
        _viewportService.screenToCanvas(state, screenPosition);
    return coordinateConverter.toCartesianPosition(renderPosition);
  }

  Offset canvasToScreenPosition(Offset cartesianPosition) {
    final renderPosition =
        coordinateConverter.toRenderPosition(cartesianPosition);

    return _viewportService.canvasToScreen(state, renderPosition);
  }

  // =================================================================================
  // --- Nodes ---
  // =================================================================================

  void addNode(FlowNode node) {
    if (state.nodes.containsKey(node.id)) {
      throw ArgumentError('Node with id ${node.id} already exists');
    }
    _mutate((s) => _nodeService.addNode(s, node));
    final event = NodeLifecycleEvent(
      type: NodeLifecycleType.add,
      state: state,
      nodeId: node.id,
      data: node,
    );
    _nodesStateStreams.emitEvent(event);
  }

  void addNodes(List<FlowNode> nodes) {
    for (var node in nodes) {
      if (state.nodes.containsKey(node.id)) {
        throw ArgumentError('Node with id ${node.id} already exists');
      }
    }
    _mutate((s) => _nodeService.addNodes(s, nodes));
    final events = nodes
        .map((n) => NodeLifecycleEvent(
              type: NodeLifecycleType.add,
              state: state,
              nodeId: n.id,
              data: n,
            ))
        .toList();
    _nodesStateStreams.emitBulk(events);
  }

  void removeSelectedNodes() {
    final oldState = state;
    if (oldState.selectedNodes.isEmpty) return;

    final removedNodeIds = Set<String>.from(oldState.selectedNodes);

    _mutate((s) =>
        _nodeService.removeNodesAndConnections(s, removedNodeIds.toList()));

    final nodeEvents = removedNodeIds
        .map((id) => NodeLifecycleEvent(
              type: NodeLifecycleType.remove,
              state: state,
              nodeId: id,
            ))
        .toList();
    _nodesStateStreams.emitBulk(nodeEvents);
  }

  void updateNode(FlowNode node) {
    final oldNode = state.nodes[node.id];
    if (oldNode == null) return;

    _mutate((s) => _nodeService.updateNode(s, node));

    final newNode = state.nodes[node.id]!;
    final event = NodeLifecycleEvent(
      type: NodeLifecycleType.update,
      state: state,
      nodeId: node.id,
      data: {'old': oldNode, 'new': newNode},
    );
    _nodesStateStreams.emitEvent(event);
  }

  void onNodeTap(String nodeId, TapDownDetails details, bool isSelectable,
      FocusNode focusNode, bool isFocusable) {
    if (isSelectable) {
      selectNode(nodeId, addToSelection: false);
    }
    if (isFocusable) {
      focusNode.requestFocus();
    }
    nodeInteractionCallbacks.onClick(nodeId, details);
    _nodeStreams.emitEvent(NodeClickEvent(nodeId: nodeId, details: details));
  }

  void onNodeDoubleClick(String nodeId) {
    nodeInteractionCallbacks.onDoubleClick(nodeId);
    _nodeStreams.emitEvent(NodeDoubleClickEvent(nodeId: nodeId));
  }

  void onNodeContextMenu(String nodeId, LongPressStartDetails details) {
    nodeInteractionCallbacks.onContextMenu(nodeId, details);
    _nodeStreams
        .emitEvent(NodeContextMenuEvent(nodeId: nodeId, details: details));
  }

  void onNodeDragStart(String nodeId, DragStartDetails details) {
    if (state.dragMode != DragMode.node) {
      _mutate((s) => s.copyWith(dragMode: DragMode.node));
    }
    nodeInteractionCallbacks.onDragStart(nodeId, details);
    _nodeStreams
        .emitEvent(NodeDragStartEvent(nodeId: nodeId, details: details));
  }

  void onNodeDragUpdate(
      String nodeId, DragUpdateDetails details, bool isSelectable) {
    if (isSelectable && !currentState.selectedNodes.contains(nodeId)) {
      selectNode(nodeId, addToSelection: false);
    }
    moveSelectedNodesBy(details.delta, details);
    nodeInteractionCallbacks.onDrag(nodeId, details);
  }

  void onNodeDragEnd(String nodeId, DragEndDetails details) {
    if (state.dragMode == DragMode.node) {
      _mutate((s) => s.copyWith(dragMode: DragMode.none));
    }
    nodeInteractionCallbacks.onDragStop(nodeId, details);
    _nodeStreams.emitEvent(NodeDragStopEvent(nodeId: nodeId, details: details));
  }

  void onNodeMouseEnter(String nodeId, PointerEvent details) {
    nodeInteractionCallbacks.onMouseEnter(nodeId, details);
    _nodeStreams
        .emitEvent(NodeMouseEnterEvent(nodeId: nodeId, details: details));
  }

  void onNodeMouseLeave(String nodeId, PointerEvent details) {
    nodeInteractionCallbacks.onMouseLeave(nodeId, details);
    _nodeStreams
        .emitEvent(NodeMouseLeaveEvent(nodeId: nodeId, details: details));
  }

  void onNodeMouseMove(String nodeId, PointerEvent details) {
    nodeInteractionCallbacks.onMouseMove(nodeId, details);
    _nodeStreams
        .emitEvent(NodeMouseMoveEvent(nodeId: nodeId, details: details));
  }

  /// Updates the state DIRECTLY for a smooth visual drag.
  void moveSelectedNodesBy(Offset screenDelta, DragUpdateDetails details) {
    if (state.dragMode != DragMode.node) return;
    final cartesianDelta = coordinateConverter.toCartesianDelta(screenDelta);

    // Directly mutate state for smooth UI, without using the history service.
    state = _nodeService.dragSelectedNodes(state, cartesianDelta);

    // Emit drag events for all selected nodes.
    for (final nodeId in state.selectedNodes) {
      final node = state.nodes[nodeId];
      if (node != null) {
        _nodeStreams.emitEvent(NodeDragEvent(
          nodeId: nodeId,
          position: node.position,
          delta: cartesianDelta,
          details: details,
        ));
      }
    }
  }

  // =================================================================================
  // --- Edges ---
  // =================================================================================

  void addEdge(FlowEdge edge) {
    _mutate((s) => _edgeService.addEdge(s, edge));
    final event = EdgeLifecycleEvent(
      type: EdgeLifecycleType.add,
      state: state, // Pass the correct, new state snapshot
      edgeId: edge.id,
      data: edge,
    );
    _edgesStateStreams.emitEvent(event);
  }

  void addEdges(List<FlowEdge> edges) {
    _mutate((s) => _edgeService.addEdges(s, edges));
    final events = edges
        .map((e) => EdgeLifecycleEvent(
              type: EdgeLifecycleType.add,
              state: state,
              edgeId: e.id,
              data: e,
            ))
        .toList();
    _edgesStateStreams.emitBulk(events);
  }

  void removeSelectedEdges() {
    final edgesToRemove = List<String>.from(state.selectedEdges);
    if (edgesToRemove.isEmpty) return;

    _mutate((s) => _edgeService.removeEdges(s, edgesToRemove));
    final events = edgesToRemove
        .map((id) => EdgeLifecycleEvent(
              type: EdgeLifecycleType.remove,
              state: state,
              edgeId: id,
            ))
        .toList();
    _edgesStateStreams.emitBulk(events);
  }

  void updateEdgeData(String edgeId, EdgeDataUpdater updater) {
    final oldEdge = state.edges[edgeId];
    if (oldEdge == null) return;

    _mutate((s) => _edgeService.updateEdgeData(s, edgeId, updater));

    final newEdge = state.edges[edgeId];
    final event = EdgeLifecycleEvent(
      type: EdgeLifecycleType.update,
      state: state,
      edgeId: edgeId,
      data: {'old': oldEdge.data, 'new': newEdge?.data},
    );
    _edgesStateStreams.emitEvent(event);
  }

  void reconnectEdge({
    required String edgeId,
    String? newSourceNodeId,
    String? newSourceHandleId,
    String? newTargetNodeId,
    String? newTargetHandleId,
  }) {
    _mutate((s) => _edgeService.reconnectEdge(s, edgeId,
        newSourceNodeId: newSourceNodeId,
        newSourceHandleId: newSourceHandleId,
        newTargetNodeId: newTargetNodeId,
        newTargetHandleId: newTargetHandleId));

    final event = EdgeLifecycleEvent(
      type: EdgeLifecycleType.reconnect,
      state: state,
      edgeId: edgeId,
    );
    _edgesStateStreams.emitEvent(event);
  }

  void onEdgePointerHover(PointerEvent event, Offset localPosition) {
    final hit = edgeGeometryService.hitTestEdgeAt(
        localPosition, state, state.viewport.zoom);

    final currentHoveredId = state.hoveredEdgeId;
    if (hit != currentHoveredId) {
      // Update the hovered state via mutation
      _mutate((s) => s.copyWith(hoveredEdgeId: hit));

      // Emit leave event for the old edge
      if (currentHoveredId != null) {
        edgeInteractionCallbacks.onMouseLeave(currentHoveredId, event);
        _edgeStreams.emitEvent(
            EdgeMouseLeaveEvent(edgeId: currentHoveredId, details: event));
      }
      // Emit enter event for the new edge
      if (hit != null) {
        edgeInteractionCallbacks.onMouseEnter(hit, event);
        _edgeStreams
            .emitEvent(EdgeMouseEnterEvent(edgeId: hit, details: event));
      }
    }

    // Always emit mouse move for the currently hovered edge
    if (hit != null) {
      edgeInteractionCallbacks.onMouseMove(hit, event);
      _edgeStreams.emitEvent(EdgeMouseMoveEvent(edgeId: hit, details: event));
    }
  }

  /// Handles tap down events on an edge or the pane.
  void onEdgeTapDown(TapDownDetails details, Offset localPosition) {
    final hit = edgeGeometryService.hitTestEdgeAt(
        localPosition, state, state.viewport.zoom);

    // Update the last clicked edge ID in the state
    _mutate((s) => s.copyWith(lastClickedEdgeId: hit));

    if (hit != null) {
      // Check selectable property from the edge model, not context
      if (state.edges[hit]?.selectable ?? true) {
        selectEdge(hit, addToSelection: false);
      }
      edgeInteractionCallbacks.onClick(hit, details);
      _edgeStreams.emitEvent(EdgeClickEvent(edgeId: hit, details: details));
    } else {
      // If no edge was hit, treat it as a pane tap
      deselectAll();
      paneCallbacks.onTap(details);
    }
  }

  /// Handles double tap events on an edge.
  void onEdgeDoubleTap() {
    final lastDownEdgeId = state.lastClickedEdgeId;
    if (lastDownEdgeId != null) {
      edgeInteractionCallbacks.onDoubleClick(lastDownEdgeId);
      _edgeStreams.emitEvent(EdgeDoubleClickEvent(edgeId: lastDownEdgeId));
    }
  }

  /// Handles long press events for showing a context menu on an edge.
  void onEdgeLongPressStart(
      LongPressStartDetails details, Offset localPosition) {
    final hit = edgeGeometryService.hitTestEdgeAt(
        localPosition, state, state.viewport.zoom);
    if (hit != null) {
      edgeInteractionCallbacks.onContextMenu(hit, details);
      _edgeStreams
          .emitEvent(EdgeContextMenuEvent(edgeId: hit, details: details));
    }
  }

  // =================================================================================
  // --- Selection ---
  // =================================================================================

  void selectNode(String nodeId, {bool addToSelection = false}) {
    final wasSelected = state.selectedNodes.contains(nodeId);

    _mutate((s) => _selectionService.toggleNodeSelection(s, nodeId,
        addToSelection: addToSelection));

    final isSelected = state.selectedNodes.contains(nodeId);

    // Only emit an event if the selection state actually changed.
    if (wasSelected != isSelected) {
      // Emit a single, global event describing the new selection state.
      _selectionStreams.emitEvent(SelectionChangeEvent(
        selectedNodeIds: state.selectedNodes,
        selectedEdgeIds: state.selectedEdges,
        state: state,
      ));
    }
  }

  void selectEdge(String edgeId, {bool addToSelection = false}) {
    final wasSelected = state.selectedEdges.contains(edgeId);
    // Mutate the selection state using the selection service
    _mutate((s) => _selectionService.toggleEdgeSelection(s, edgeId,
        addToSelection: addToSelection));
    final isSelected = state.selectedEdges.contains(edgeId);

    if (wasSelected != isSelected) {
      _selectionStreams.emitEvent(SelectionChangeEvent(
        selectedNodeIds: state.selectedNodes,
        selectedEdgeIds: state.selectedEdges,
        state: state,
      ));
    }
  }

  void selectAll() {
    _mutate((s) => _selectionService.selectAll(s));
    _selectionStreams.emitEvent(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

  void startSelection(Offset position) =>
      _mutate((s) => _selectionService.startBoxSelection(s, position));

  void updateSelection(Offset position, {SelectionMode? selectionMode}) =>
      _mutate((s) => _selectionService.updateBoxSelection(s, position,
          selectionMode: selectionMode ?? SelectionMode.partial,
          nodeQueryService: _nodeQueryService));

  void endSelection() {
    _mutate((s) => _selectionService.endBoxSelection(s));
    _selectionStreams.emitEvent(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

  void deselectAll() {
    _mutate((s) => _selectionService.deselectAll(s));
    _selectionStreams.emitEvent(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

  // =================================================================================
  // --- Handle State ---
  // =================================================================================

  void setHandleHover(String handleKey, bool isHovered) {
    final currentStates =
        Map<String, HandleRuntimeState>.from(state.handleStates);
    final currentState = currentStates[handleKey] ?? const HandleRuntimeState();

    if (currentState.isHovered == isHovered) return;

    currentStates[handleKey] = currentState.copyWith(isHovered: isHovered);
    state = state.copyWith(handleStates: currentStates);
  }

  // =================================================================================
  // --- Connections ---
  // =================================================================================

  void startConnection(String nodeId, String handleId) {
    final sourceNode = state.nodes[nodeId];
    final sourceHandle = sourceNode?.handles[handleId];
    if (sourceNode == null || sourceHandle == null) return;

    final handleCenterPosition = sourceNode.position + sourceHandle.position;

    state = _connectionService.startConnection(
      state.copyWith(dragMode: DragMode.connection),
      fromNodeId: nodeId,
      fromHandleId: handleId,
      startPosition: handleCenterPosition,
    );

    if (state.connection != null) {
      _connectionStreams.emitEvent(
        ConnectionEvent(
            type: ConnectionEventType.start, connection: state.connection!),
      );
    }
  }

  void updateConnection(
      Offset cursorScreenPosition, String nodeId, String handleId) {
    if (state.dragMode != DragMode.connection || state.connection == null) {
      return;
    }

    final cartesianPosition =
        coordinateConverter.toCartesianPosition(cursorScreenPosition);

    if (state.connection!.endPoint != cartesianPosition) {
      state = _connectionService.updateConnection(state, cartesianPosition);
    }
  }

  void endConnection() {
    final oldState = state;
    final pendingConnection = oldState.connection;
    if (pendingConnection == null) return;

    _mutate((s) => _connectionService.endConnection(s));

    final wasSuccessful = state.edges.length > oldState.edges.length;

    if (wasSuccessful) {
      final newEdge = state.edges.values
          .firstWhere((e) => !oldState.edges.containsKey(e.id));
      final finalConnection = pendingConnection.copyWith(
        id: newEdge.id,
        toNodeId: newEdge.targetNodeId,
        toHandleId: newEdge.targetHandleId,
      );
      _connectionStreams.emitEvent(ConnectionEvent(
          type: ConnectionEventType.connect, connection: finalConnection));
    }

    _connectionStreams.emitEvent(ConnectionEvent(
        type: ConnectionEventType.end, connection: pendingConnection));
  }

  // =================================================================================
  // --- Z-Index ---
  // =================================================================================

  void bringSelectionToFront() =>
      _mutate((s) => _zIndexService.bringSelectedToFront(s));
  void sendSelectionToBack() =>
      _mutate((s) => _zIndexService.sendSelectedToBack(s));

  void bringNodeToFront(String nodeId) =>
      _mutate((s) => _zIndexService.bringToFront(s, nodeId));

  void sendNodeToBack(String nodeId) =>
      _mutate((s) => _zIndexService.sendToBack(s, nodeId));

  // =================================================================================
  // --- History ---
  // =================================================================================

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

  // =================================================================================
  // --- Clipboard ---
  // =================================================================================

  /// Copies the currently selected nodes and edges to the internal clipboard.
  void copySelection() {
    // The copy service returns a payload that we store in the controller.
    _clipboardPayload = _clipboardService.copy(state);
  }

  /// Pastes the content from the internal clipboard onto the canvas.
  void paste({Offset? positionOffset}) {
    // Do nothing if the clipboard is empty.
    if (_clipboardPayload == null) return;

    final oldState = state;
    _mutate((s) {
      // Use the stored payload instead of re-copying.
      return _clipboardService.paste(
        s,
        _clipboardPayload!,
        positionOffset: positionOffset ?? const Offset(20, 20),
        nodeService: _nodeService,
        edgeService: _edgeService,
      );
    });

    // Find the newly added elements by comparing the state before and after.
    final newNodes =
        state.nodes.values.where((n) => !oldState.nodes.containsKey(n.id));
    final newEdges =
        state.edges.values.where((e) => !oldState.edges.containsKey(e.id));

    // Emit bulk lifecycle events for the newly pasted nodes and edges.
    if (newNodes.isNotEmpty) {
      final nodeEvents = newNodes
          .map((n) => NodeLifecycleEvent(
                type: NodeLifecycleType.add,
                state: state,
                nodeId: n.id,
                data: n,
              ))
          .toList();
      _nodesStateStreams.emitBulk(nodeEvents);
    }
    if (newEdges.isNotEmpty) {
      final edgeEvents = newEdges
          .map((e) => EdgeLifecycleEvent(
                type: EdgeLifecycleType.add,
                state: state,
                edgeId: e.id,
                data: e,
              ))
          .toList();
      _edgesStateStreams.emitBulk(edgeEvents);
    }
  }

  // =================================================================================
  // --- Keyboard ---
  // =================================================================================

  void handleKeyboardAction(
    KeyboardAction action, {
    required KeyboardOptions options,
    required double minZoom,
    required double maxZoom,
  }) {
    _mutate(
      (s) => _keyboardActionService.handleAction(
        s,
        action,
        arrowMoveDelta:
            Offset(options.arrowKeyMoveSpeed, options.arrowKeyMoveSpeed),
        zoomStep: options.zoomStep,
        minZoom: minZoom,
        maxZoom: maxZoom,
      ),
    );
  }

  // =================================================================================
  // --- Serialization ---
  // =================================================================================

  Map<String, dynamic> toJson() => _serializationService.toJson(state);

  void fromJson(Map<String, dynamic> json) {
    _mutate((s) => _serializationService.fromJson(s, json));
    _history.clear();
    _history.init(state);
  }

  // =================================================================================
  // --- QUERIES ---
  // =================================================================================

  List<FlowNode> findNodesInRect(Rect rect) =>
      _nodeQueryService.queryInRect(state, rect);
  List<FlowNode> findNodesNearPoint(Offset point, double radius) =>
      _nodeQueryService.queryNearPoint(state, point, radius);
  List<FlowNode> getIsolatedNodes() =>
      _nodeQueryService.getIsolatedNodes(state);
  Set<String> getNodesConnectedTo(String nodeId) =>
      _nodeQueryService.getConnectedNodes(state, nodeId);
  NodeBounds getNodeBounds(
          {List<String> nodeIds = const [], bool includeHidden = false}) =>
      _viewportService.getNodeBounds(state,
          nodeIds: nodeIds, includeHidden: includeHidden);

  Set<String> getEdgesForNode(String nodeId) =>
      _edgeQueryService.getEdgesForNode(state, nodeId);
  Set<String> getEdgesForHandle(String nodeId, String handleId) =>
      _edgeQueryService.getEdgesForHandle(state, nodeId, handleId);
  bool isNodeConnected(String nodeId) =>
      _edgeQueryService.isNodeConnected(state, nodeId);
  bool isHandleConnected(String nodeId, String handleId) =>
      _edgeQueryService.isHandleConnected(state, nodeId, handleId);
  List<FlowEdge> getConnectedEdges(String nodeId, String handleId) =>
      _connectionService.getConnectedEdges(state, nodeId, handleId);

  // =================================================================================
  // --- Disposal ---
  // =================================================================================

  @override
  void dispose() {
    _nodeStreams.dispose();
    _edgeStreams.dispose();
    _connectionStreams.dispose();
    _paneStreams.dispose();
    _selectionStreams.dispose();
    _viewportStreams.dispose();
    transformationController.dispose();
    transformationController.removeListener(_onTransformationChanged);
    super.dispose();
  }
}

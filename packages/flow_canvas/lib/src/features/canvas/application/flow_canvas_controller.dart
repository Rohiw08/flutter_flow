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

class _EdgeUpdateInfo {
  final bool needsUpdate;
  final bool fullUpdate;
  final Set<String> specificNodes;

  _EdgeUpdateInfo({
    required this.needsUpdate,
    this.fullUpdate = false,
    this.specificNodes = const {},
  });
}

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

  // Track initial positions for undo/redo on drag operations
  Map<String, Offset>? _dragStartPositions;
  FlowCanvasState? _previousState;

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
    // In FlowCanvasController constructor, replace the addListener with this:

    addListener((newState) {
      final updateInfo = _shouldUpdateEdgeGeometry(newState);

      if (updateInfo.needsUpdate) {
        if (updateInfo.specificNodes.isNotEmpty) {
          // Only update edges connected to changed nodes
          edgeGeometryService.updateEdgesForNodes(
              newState, updateInfo.specificNodes);
        } else if (updateInfo.fullUpdate) {
          // Full update needed (edges added/removed)
          edgeGeometryService.updateCache(newState, newState.edges.keys);
        }
      }

      _updateTransformationController();
      _previousState = newState;
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
    final newState = mutation(state);
    if (!identical(newState, state)) {
      _history.record(newState); // Use the new record method
      state = newState;
    }
  }

  /// Updates state WITHOUT saving to history (for transient/intermediate states).
  void _updateStateOnly(FlowCanvasState newState) {
    state = newState;
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

  void setDragMode(DragMode mode) {
    if (state.dragMode != mode) {
      _updateStateOnly(state.copyWith(dragMode: mode));
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
      // Don't save viewport size to history
      _updateStateOnly(state.copyWith(viewportSize: size));
      _viewportStreams.emitEvent(ViewportEvent(
        type: ViewportEventType.resize,
        viewport: state.viewport,
        viewportSize: size,
      ));
    }
  }

  void panBy(Offset delta) {
    // Don't save pan operations to history
    _updateStateOnly(_viewportService.pan(state, delta));
    _viewportStreams.emitEvent(ViewportEvent(
      type: ViewportEventType.transform,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  void toggleLock() {
    // Don't save lock state to history
    _updateStateOnly(state.copyWith(isPanZoomLocked: !state.isPanZoomLocked));
  }

  void zoom({
    required Offset focalPoint,
    required double minZoom,
    required double maxZoom,
    required double zoomFactor,
  }) {
    // Don't save zoom operations to history
    _updateStateOnly(_viewportService.zoom(
      state,
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
    _updateStateOnly(_viewportService.fitView(state, options: options));
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

    // Don't save centerOnPosition to history
    _updateStateOnly(
        state.copyWith(viewport: state.viewport.copyWith(offset: newOffset)));
    _viewportStreams.emitEvent(ViewportEvent(
      type: ViewportEventType.transform,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  void resetView() {
    _updateStateOnly(state.copyWith(viewport: const FlowViewport()));
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
    // Store initial positions of all selected nodes for undo/redo
    _dragStartPositions = {};
    for (final selectedId in state.selectedNodes) {
      final node = state.nodes[selectedId];
      if (node != null) {
        _dragStartPositions![selectedId] = node.position;
      }
    }

    if (state.dragMode != DragMode.node) {
      // Don't save dragMode to history - it's transient UI state
      _updateStateOnly(state.copyWith(dragMode: DragMode.node));
    }

    nodeInteractionCallbacks.onDragStart(nodeId, details);
    _nodeStreams
        .emitEvent(NodeDragStartEvent(nodeId: nodeId, details: details));
  }

  void onNodeDragUpdate(
      String nodeId, DragUpdateDetails details, bool isSelectable) {
    if (isSelectable && !state.selectedNodes.contains(nodeId)) {
      selectNode(nodeId, addToSelection: false);
    }
    moveSelectedNodesBy(details.delta, details);
    nodeInteractionCallbacks.onDrag(nodeId, details);
  }

  void onNodeDragEnd(String nodeId, DragEndDetails details) {
    if (_dragStartPositions != null) {
      final startPositions = _dragStartPositions!;
      bool hasChanged = false;
      for (final id in startPositions.keys) {
        if (state.nodes[id]?.position != startPositions[id]) {
          hasChanged = true;
          break;
        }
      }
      if (hasChanged) {
        _history.record(state);
      }
      _dragStartPositions = null;
    }

    _mutate((s) => state.copyWith(dragMode: DragMode.none));

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

  /// Updates the state DIRECTLY for smooth visual drag WITHOUT saving to history.
  void moveSelectedNodesBy(Offset screenDelta, DragUpdateDetails details) {
    if (state.dragMode != DragMode.node) return;
    final cartesianDelta = coordinateConverter.toCartesianDelta(screenDelta);

    _updateStateOnly(_nodeService.dragSelectedNodes(state, cartesianDelta));
    // print(
    //     "-------------------- ${state.selectedNodes} --------------------------------");
    // edgeGeometryService.updateEdge(state, "e1-2");
    edgeGeometryService.updateEdgesForNodes(state, state.selectedNodes);

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
  // --- Edges Geometry ---
  // =================================================================================

  _EdgeUpdateInfo _shouldUpdateEdgeGeometry(FlowCanvasState newState) {
    if (_previousState == null) {
      return _EdgeUpdateInfo(needsUpdate: true, fullUpdate: true);
    }

    final old = _previousState!;

    // Check if edges were added or removed
    if (newState.edges.length != old.edges.length) {
      return _EdgeUpdateInfo(needsUpdate: true, fullUpdate: true);
    }

    // Check if any edge keys changed (edges replaced)
    if (!_sameEdgeKeys(old.edges, newState.edges)) {
      return _EdgeUpdateInfo(needsUpdate: true, fullUpdate: true);
    }

    // During node drag, only update edges connected to moving nodes
    if (newState.dragMode == DragMode.node) {
      final movedNodes = _getMovedNodes(old, newState);
      if (movedNodes.isNotEmpty) {
        return _EdgeUpdateInfo(
          needsUpdate: true,
          fullUpdate: false,
          specificNodes: movedNodes,
        );
      }
    }

    // Check if any node positions changed outside of drag
    // (e.g., programmatic updates, paste operations)
    final changedNodes = _getNodesWithChangedPositions(old, newState);
    if (changedNodes.isNotEmpty) {
      return _EdgeUpdateInfo(
        needsUpdate: true,
        fullUpdate: false,
        specificNodes: changedNodes,
      );
    }

    return _EdgeUpdateInfo(needsUpdate: false);
  }

  bool _sameEdgeKeys(Map<String, FlowEdge> map1, Map<String, FlowEdge> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
    }
    return true;
  }

  Set<String> _getMovedNodes(FlowCanvasState old, FlowCanvasState current) {
    final movedNodes = <String>{};

    // Check selected nodes during drag
    for (final nodeId in current.selectedNodes) {
      final oldNode = old.nodes[nodeId];
      final newNode = current.nodes[nodeId];

      if (oldNode != null &&
          newNode != null &&
          oldNode.position != newNode.position) {
        movedNodes.add(nodeId);
      }
    }

    return movedNodes;
  }

  Set<String> _getNodesWithChangedPositions(
      FlowCanvasState old, FlowCanvasState current) {
    final changedNodes = <String>{};

    // Only check nodes that exist in both states
    for (final nodeId in current.nodes.keys) {
      final oldNode = old.nodes[nodeId];
      final newNode = current.nodes[nodeId];
      if (oldNode != null && oldNode.position != newNode!.position) {
        changedNodes.add(nodeId);
      }
    }

    return changedNodes;
  }

  // =================================================================================
  // --- Edges ---
  // =================================================================================

  void addEdge(FlowEdge edge) {
    _mutate((s) => _edgeService.addEdge(s, edge));
    edgeGeometryService.updateEdge(state, edge.id);

    final event = EdgeLifecycleEvent(
      type: EdgeLifecycleType.add,
      state: state,
      edgeId: edge.id,
      data: edge,
    );
    _edgesStateStreams.emitEvent(event);
  }

  void addEdges(List<FlowEdge> edges) {
    _mutate((s) => _edgeService.addEdges(s, edges));
    for (final edge in edges) {
      edgeGeometryService.updateEdge(state, edge.id);
    }

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
    final edgesToRemove = Set<String>.from(state.selectedEdges);
    if (edgesToRemove.isEmpty) return;

    _mutate((s) => _edgeService.removeEdges(s, edgesToRemove.toList()));
    edgeGeometryService.removeEdges(edgesToRemove);

    final events = edgesToRemove
        .map((id) => EdgeLifecycleEvent(
              type: EdgeLifecycleType.remove,
              state: state,
              edgeId: id,
            ))
        .toList();
    _edgesStateStreams.emitBulk(events);
  }

  void updateEdge(String edgeId, EdgeDataUpdater updater) {
    final oldEdge = state.edges[edgeId];
    if (oldEdge == null) return;

    _mutate((s) => _edgeService.updateEdgeData(s, edgeId, updater));
    edgeGeometryService.updateEdge(state, edgeId);

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
      // Don't save hover state to history - it's transient UI state
      _updateStateOnly(state.copyWith(hoveredEdgeId: hit));

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

    // Don't save lastClickedEdgeId to history - it's transient UI state
    _updateStateOnly(state.copyWith(lastClickedEdgeId: hit));

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
    _updateStateOnly(
      _selectionService.toggleNodeSelection(state, nodeId,
          addToSelection: addToSelection),
    );
    final isSelected = state.selectedNodes.contains(nodeId);
    if (wasSelected != isSelected) {
      _selectionStreams.emitEvent(SelectionChangeEvent(
        selectedNodeIds: state.selectedNodes,
        selectedEdgeIds: state.selectedEdges,
        state: state,
      ));
    }
  }

  void selectEdge(String edgeId, {bool addToSelection = false}) {
    final oldState = state;
    _updateStateOnly(_selectionService.toggleEdgeSelection(state, edgeId,
        addToSelection: addToSelection));

    if (oldState.selectedNodes != state.selectedNodes ||
        oldState.selectedEdges != state.selectedEdges) {
      _selectionStreams.emitEvent(SelectionChangeEvent(
        selectedNodeIds: state.selectedNodes,
        selectedEdgeIds: state.selectedEdges,
        state: state,
      ));
    }
  }

  void deselectAll() {
    _updateStateOnly(_selectionService.deselectAll(state));
    _selectionStreams.emitEvent(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

  void selectAll() {
    _updateStateOnly(_selectionService.selectAll(state));
    _selectionStreams.emitEvent(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

  Offset? _selectionDragOrigin;

  void startSelection(Offset position) {
    _selectionDragOrigin = position;
    final stateAfterStart =
        _selectionService.startBoxSelection(state, position);
    // Set the drag mode to notify other parts of the UI that a selection is in progress.
    // This is a transient state change, so we don't record it to history.
    _updateStateOnly(stateAfterStart.copyWith(dragMode: DragMode.selection));
  }

  void updateSelection(Offset position, {SelectionMode? selectionMode}) {
    if (state.dragMode != DragMode.selection) return;
    // print("${state.selectionRect}");
    _updateStateOnly(_selectionService.updateBoxSelection(
        state, _selectionDragOrigin!, position,
        selectionMode: selectionMode ?? SelectionMode.partial,
        nodeQueryService: _nodeQueryService));
  }

  void endSelection() {
    _selectionDragOrigin = null;
    // When selection ends, we commit the result to history.
    // This mutation removes the selection rectangle and resets the drag mode.
    _mutate((s) {
      final stateWithoutRect = _selectionService.endBoxSelection(s);
      return stateWithoutRect;
    });
    _selectionStreams.emitEvent(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

  // =================================================================================
  // --- Handle ---
  // =================================================================================

  void setHandleHover(String handleKey, bool isHovered) {
    final currentStates =
        Map<String, HandleRuntimeState>.from(state.handleStates);
    final currentState = currentStates[handleKey] ?? const HandleRuntimeState();
    if (currentState.isHovered == isHovered) return;
    currentStates[handleKey] = currentState.copyWith(isHovered: isHovered);
    _updateStateOnly(state.copyWith(handleStates: currentStates));
  }

  // =================================================================================
  // --- Connections ---
  // =================================================================================

  void startConnection(String nodeId, String handleId) {
    final sourceNode = state.nodes[nodeId];
    final sourceHandle = sourceNode?.handles[handleId];
    if (sourceNode == null || sourceHandle == null) return;
    final handleCenterPosition = sourceNode.position + sourceHandle.position;
    _updateStateOnly(_connectionService.startConnection(
      state.copyWith(dragMode: DragMode.connection),
      fromNodeId: nodeId,
      fromHandleId: handleId,
      startPosition: handleCenterPosition,
    ));

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
      _updateStateOnly(
          _connectionService.updateConnection(state, cartesianPosition));
    }
  }

  void endConnection() {
    final oldState = state;
    final pendingConnection = oldState.connection;
    if (pendingConnection == null) return;

    // Save final connection result to history (if an edge was created)
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
    final dragMode = state.dragMode;
    final currentViewport = state.viewport;
    final currentViewportSize = state.viewportSize;
    final prevState = _history.undo();
    if (prevState != null) {
      state = prevState.copyWith(
        dragMode: dragMode,
        viewport: currentViewport,
        viewportSize: currentViewportSize,
      );
      _updateTransformationController();
    }
  }

  void redo() {
    final dragMode = state.dragMode;
    final currentViewport = state.viewport;
    final currentViewportSize = state.viewportSize;
    final nextState = _history.redo();
    if (nextState != null) {
      state = nextState.copyWith(
        dragMode: dragMode,
        viewport: currentViewport,
        viewportSize: currentViewportSize,
      );
      _updateTransformationController();
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
    _nodesStateStreams.dispose();
    _edgeStreams.dispose();
    _edgesStateStreams.dispose();
    _connectionStreams.dispose();
    _paneStreams.dispose();
    _selectionStreams.dispose();
    _viewportStreams.dispose();
    transformationController.dispose();
    transformationController.removeListener(_onTransformationChanged);
    super.dispose();
  }
}

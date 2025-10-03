import 'package:flow_canvas/src/features/canvas/domain/state/handle_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flow_canvas/src/shared/utility/map_comparitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/application/events/connection_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/edge_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/node_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/selection_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/services/clipboard_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/connection_service.dart';
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
import 'package:flow_canvas/src/features/canvas/application/streams/selection_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flow_canvas/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/fitview_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/keyboard_options.dart';
import 'package:flow_canvas/src/shared/enums.dart';

import 'events/pane_change.dart';
import 'streams/connection_change_stream.dart';
import 'streams/edge_change_stream.dart';
import 'streams/node_change_stream.dart';
import 'streams/pane_change_stream.dart';
import 'streams/viewport_change_stream.dart';
import 'events/viewport_change_event.dart';
// import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_transform_utils.dart';

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
  Map<String, Offset> _initialDragPositions = {};

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

    // --- Utility ---
    coordinateConverter = ref.read(coordinateConverterProvider);

    // Initialize services that depend on the initial state.
    _history.init(state);
    _updateTransformationController();
    transformationController.addListener(_onTransformationChanged);

    // Listen to our own state changes to keep the TransformationController in sync.
    addListener((newState) {
      _updateTransformationController();
    });
  }

  // --- Streams ---
  final NodeStreams _nodeStreams = NodeStreams();
  final EdgeStreams _edgeStreams = EdgeStreams();
  final ConnectionStreams _connectionStreams = ConnectionStreams();
  final PaneStreams _paneStreams = PaneStreams();
  final SelectionStreams _selectionStreams = SelectionStreams();
  final ViewportStreams _viewportStreams = ViewportStreams();

  // Expose the streams publicly for the developer to listen to
  NodeStreams get nodeStreams => _nodeStreams;
  EdgeStreams get edgeStreams => _edgeStreams;
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

    // If the controller's matrix already matches our state, do nothing.
    // This is the key to breaking the feedback loop.
    if (transformationController.value == stateMatrix) {
      return;
    }

    transformationController.value = stateMatrix;
  }

  /// [NEW] Add this method to listen for changes from the InteractiveViewer.
  void _onTransformationChanged() {
    final matrix = transformationController.value;
    final newOffset =
        Offset(matrix.getTranslation().x, matrix.getTranslation().y);
    final newZoom = matrix.getMaxScaleOnAxis();

    final newViewport = FlowViewport(offset: newOffset, zoom: newZoom);

    // This is a direct state update reflecting the current view.
    // It does not go into the undo/redo history.
    if (state.viewport != newViewport) {
      state = state.copyWith(viewport: newViewport);
    }
  }

  // =================================================================================
  // --- canvas State ---
  // =================================================================================
  /// Get the current state (public accessor for the facade)
  FlowCanvasState get currentState => state;

  // =================================================================================
  // --- Viewport & Transform ---
  // =================================================================================

  void setViewportSize(Size size) {
    if (state.viewportSize != size) {
      _mutate((s) => s.copyWith(viewportSize: size));
      _viewportStreams.emit(ViewportEvent(
        type: ViewportEventType.resize,
        viewport: state.viewport,
        viewportSize: size,
      ));
    }
  }

  void pan(Offset delta) {
    _mutate((s) => _viewportService.pan(s, delta));
    final evt = PaneEvent(type: PaneEventType.move, viewport: state.viewport);
    _paneStreams.emitEvent(evt);
    _viewportStreams.emit(ViewportEvent(
      type: ViewportEventType.change,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  void toggleLock() {
    _mutate((s) => s.copyWith(isPanZoomLocked: !s.isPanZoomLocked));
    _viewportStreams.emit(ViewportEvent(
      type: ViewportEventType.change,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  void zoom(
    double zoomFactor, {
    required Offset focalPoint,
    required double minZoom,
    required double maxZoom,
  }) {
    _mutate((s) => _viewportService.zoom(
          s,
          zoomFactor: 1 + zoomFactor,
          focalPoint: focalPoint,
          minZoom: minZoom,
          maxZoom: maxZoom,
        ));
    final evt = PaneEvent(type: PaneEventType.move, viewport: state.viewport);
    _paneStreams.emitEvent(evt);
    _viewportStreams.emit(
      ViewportEvent(
        type: ViewportEventType.change,
        viewport: state.viewport,
        viewportSize: state.viewportSize,
      ),
    );
  }

  void fitView({FitViewOptions options = const FitViewOptions()}) {
    _mutate((s) => _viewportService.fitView(s, options: options));
    _viewportStreams.emit(ViewportEvent(
      type: ViewportEventType.change,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  void centerView() {
    if (state.viewportSize == null) return;
    centerOnPosition(Offset.zero);
  }

  void resetView() {
    _mutate((s) => s.copyWith(viewport: const FlowViewport()));
    _viewportStreams.emit(ViewportEvent(
      type: ViewportEventType.change,
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
    _viewportStreams.emit(ViewportEvent(
      type: ViewportEventType.change,
      viewport: state.viewport,
      viewportSize: state.viewportSize,
    ));
  }

  /// Converts a point from screen coordinates to canvas coordinates.
  Offset screenToCanvas(Offset screenPosition) =>
      _viewportService.screenToCanvas(state, screenPosition);

  /// Converts a point from canvas coordinates to screen coordinates.
  Offset canvasToScreen(Offset canvasPosition) =>
      _viewportService.canvasToScreen(state, canvasPosition);

  /// Converts a point from the screen (e.g., a mouse click) to the canvas's
  /// internal Cartesian coordinate system.
  Offset screenToCanvasPosition(Offset screenPosition) {
    final renderPosition =
        _viewportService.screenToCanvas(state, screenPosition);
    return coordinateConverter.toCartesianPosition(renderPosition);
  }

  /// Converts a point from the canvas's internal Cartesian coordinate system
  /// to a screen position.
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
    final event = NodeChangeEvent(
        nodeId: node.id, type: NodeChangeType.add, newValue: node);
    _nodeStreams.emitChanges([event]);
  }

  void addNodes(List<FlowNode> nodes) {
    for (var node in nodes) {
      if (state.nodes.containsKey(node.id)) {
        throw ArgumentError('Node with id ${node.id} already exists');
      }
    }
    _mutate((s) => _nodeService.addNodes(s, nodes));
    final events = nodes
        .map((n) => NodeChangeEvent(
            nodeId: n.id, type: NodeChangeType.add, newValue: n))
        .toList();
    _nodeStreams.emitChanges(events);
  }

  void removeSelectedNodes() {
    final oldState = state;
    if (oldState.selectedNodes.isEmpty) return;

    final removedNodeIds = Set<String>.from(oldState.selectedNodes);
    final removedEdgeIds = oldState.edges.values
        .where((edge) =>
            removedNodeIds.contains(edge.sourceNodeId) ||
            removedNodeIds.contains(edge.targetNodeId))
        .map((edge) => edge.id)
        .toSet();

    _mutate((s) =>
        _nodeService.removeNodesAndConnections(s, removedNodeIds.toList()));

    final nodeEvents = removedNodeIds
        .map((id) => NodeChangeEvent(nodeId: id, type: NodeChangeType.remove))
        .toList();
    _nodeStreams.emitChanges(nodeEvents);

    // Emit NodeEvent.delete for each removed node (interaction-level event)
    for (final id in removedNodeIds) {
      _nodeStreams.emitEvent(NodeEvent(nodeId: id, type: NodeEventType.delete));
    }

    final edgeEvents = removedEdgeIds
        .map((id) => EdgeChangeEvent(edgeId: id, type: EdgeEventType.delete))
        .toList();
    _edgeStreams.emitChanges(edgeEvents);
  }

  void updateNode(FlowNode node) {
    final oldNode = state.nodes[node.id];
    if (oldNode == null) return; // Or throw an error

    _mutate((s) => _nodeService.updateNode(s, node));

    // After mutation, the state has been updated
    final newNode = state.nodes[node.id]!;

    // Create a change event and emit it
    // You can make this more granular by comparing oldNode and newNode
    // to see exactly what changed (e.g., position, size, data).
    final event = NodeChangeEvent(
      nodeId: node.id,
      type: NodeChangeType.update, // A generic update type
      oldValue: oldNode,
      newValue: newNode,
    );
    _nodeStreams.emitChanges([event]);
  }

  /// Sets the drag mode to indicate a node is being dragged.
  void startNodeDrag() {
    if (state.dragMode != DragMode.node) {
      state = state.copyWith(dragMode: DragMode.node);

      // Store the original positions of the selected nodes.
      _initialDragPositions = {
        for (var id in state.selectedNodes)
          if (state.nodes.containsKey(id)) id: state.nodes[id]!.position,
      };
    }
  }

  /// Resets the drag mode when the node drag ends.
  void endNodeDrag() {
    if (state.dragMode == DragMode.node) {
      final oldPositions = _initialDragPositions;
      final newPositions = {
        for (var id in oldPositions.keys)
          if (state.nodes.containsKey(id)) id: state.nodes[id]!.position,
      };

      if (oldPositions.isNotEmpty &&
          newPositions.isNotEmpty &&
          !areMapsEqual(oldPositions, newPositions)) {
        _mutate((s) {
          return s;
        });
      }

      _initialDragPositions = {};
      state = state.copyWith(dragMode: DragMode.none);
    }
  }

  /// Updates the state DIRECTLY for a smooth visual drag.
  /// This method NO LONGER uses _mutate.
  void dragSelectedBy(Offset screenDelta) {
    // This check is important to avoid updating state if not dragging.
    if (state.dragMode != DragMode.node) return;
    final cartesianDelta = coordinateConverter.toCartesianDelta(screenDelta);

    // --- KEY CHANGE ---
    // Update the state directly without adding to history.
    state = _nodeService.dragSelectedNodes(state, cartesianDelta);

    // The event stream can still be emitted for real-time updates.
    final changes = state.selectedNodes
        .map((nodeId) {
          final oldPosition = _initialDragPositions[nodeId];
          final newNode = state.nodes[nodeId];
          if (oldPosition != null && newNode != null) {
            return NodeChangeEvent(
              nodeId: nodeId,
              type: NodeChangeType.position,
              oldValue: oldPosition,
              newValue: newNode.position,
            );
          }
          return null;
        })
        .whereType<NodeChangeEvent>()
        .toList();

    if (changes.isNotEmpty) {
      _nodeStreams.emitChanges(changes);
    }
  }

  // =================================================================================
  // --- Edges ---
  // =================================================================================

  void addEdge(FlowEdge edge) {
    _mutate((s) => _edgeService.addEdge(s, edge));
    final event = EdgeChangeEvent(
        edgeId: edge.id, type: EdgeEventType.change, data: edge);
    _edgeStreams.emitChanges([event]);
  }

  void removeSelectedEdges() {
    final edgesToRemove = List<String>.from(state.selectedEdges);
    if (edgesToRemove.isEmpty) return;

    _mutate((s) => _edgeService.removeEdges(s, edgesToRemove));
    final events = edgesToRemove
        .map((id) => EdgeChangeEvent(edgeId: id, type: EdgeEventType.delete))
        .toList();
    _edgeStreams.emitChanges(events);
  }

  /// Updates the data payload of a specific edge.
  void updateEdgeData(String edgeId, EdgeDataUpdater updater) {
    final oldEdge = state.edges[edgeId];
    if (oldEdge == null) return;

    _mutate((s) => _edgeService.updateEdgeData(s, edgeId, updater));

    final newEdge = state.edges[edgeId];
    final event = EdgeChangeEvent(
      edgeId: edgeId,
      type: EdgeEventType.change,
      data: {'old': oldEdge.data, 'new': newEdge?.data},
    );
    _edgeStreams.emitChanges([event]);
  }

  /// Reconnects an edge to a new source or target handle.
  void reconnectEdge(
    String edgeId, {
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

    final event =
        EdgeChangeEvent(edgeId: edgeId, type: EdgeEventType.reconnect);
    _edgeStreams.emitEvent(event);
  }

  /// Imports a list of edges, skipping any that already exist or are invalid.
  void importEdges(List<FlowEdge> edges) {
    _mutate((s) => _edgeService.importEdges(s, edges));
    final events = edges
        .map((e) =>
            EdgeChangeEvent(edgeId: e.id, type: EdgeEventType.change, data: e))
        .toList();
    _edgeStreams.emitChanges(events);
  }

  // =================================================================================
  // --- Selection ---
  // =================================================================================

  void selectNode(String nodeId, {bool addToSelection = false}) {
    final wasSelected = state.selectedNodes.contains(nodeId);
    _mutate((s) => _selectionService.toggleNodeSelection(s, nodeId,
        addToSelection: addToSelection));
    final isSelected = state.selectedNodes.contains(nodeId);

    if (wasSelected != isSelected) {
      final event = NodeChangeEvent(
          nodeId: nodeId, type: NodeChangeType.selection, newValue: isSelected);
      _nodeStreams.emitChanges([event]);
    }
    _selectionStreams.emit(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

  void selectEdge(String edgeId, {bool addToSelection = false}) {
    final wasSelected = state.selectedEdges.contains(edgeId);
    _mutate((s) => _selectionService.toggleEdgeSelection(s, edgeId,
        addToSelection: addToSelection));
    final isSelected = state.selectedEdges.contains(edgeId);

    if (wasSelected != isSelected) {
      final event = EdgeChangeEvent(
          edgeId: edgeId,
          type: EdgeEventType.change,
          data: {'selected': isSelected});
      _edgeStreams.emitChanges([event]);
    }
    _selectionStreams.emit(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

  void selectAll({bool nodes = true, bool edges = true}) {
    _mutate((s) => _selectionService.selectAll(s, nodes: nodes, edges: edges));
    _selectionStreams.emit(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
    // Emitting events for a full selectAll can be noisy; consumers can use selectionStreams
  }

  void startSelection(Offset position) =>
      _mutate((s) => _selectionService.startBoxSelection(s, position));

  void updateSelection(Offset position, {SelectionMode? selectionMode}) =>
      _mutate((s) => _selectionService.updateBoxSelection(s, position,
          selectionMode: selectionMode ?? SelectionMode.partial,
          nodeQueryService: _nodeQueryService));

  void endSelection() {
    _mutate((s) => _selectionService.endBoxSelection(s));
    _selectionStreams.emit(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

  void deselectAll() {
    _mutate((s) => _selectionService.deselectAll(s));
    _selectionStreams.emit(SelectionChangeEvent(
      selectedNodeIds: state.selectedNodes,
      selectedEdgeIds: state.selectedEdges,
      state: state,
    ));
  }

// =================================================================================
  // --- Handle State ---
  // =================================================================================

  /// Updates the hover state of a specific handle.
  void setHandleHover(String handleKey, bool isHovered) {
    // This is a direct UI state update and should not create a history entry.
    // It's a transient visual state.
    final currentStates =
        Map<String, HandleRuntimeState>.from(state.handleStates);
    final currentState = currentStates[handleKey] ?? const HandleRuntimeState();

    // Avoid unnecessary state updates
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

    // BUG: cursorScreenPosition is in RENDER space (from canvas RenderBox)
    // but queryHandlesNear expects CARTESIAN space
    // Convert screen position to cartesian coordinates
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
      // Reconstruct the successful connection object for the event
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

  /// Brings a single, specific node to the front.
  void bringNodeToFront(String nodeId) =>
      _mutate((s) => _zIndexService.bringToFront(s, nodeId));

  /// Sends a single, specific node to the back.
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

  void copySelection() {
    _clipboardService.copy(state);
  }

  void paste({Offset? positionOffset}) {
    final oldState = state;
    _mutate((s) {
      final payload = _clipboardService.copy(s);
      // NOTE: This assumes your ClipboardService has been updated to accept
      // the node and edge services to properly update the indexes.
      return _clipboardService.paste(
        s,
        payload,
        positionOffset: positionOffset ?? const Offset(20, 20),
        nodeService: _nodeService,
        edgeService: _edgeService,
      );
    });

    // Diff the state to find out what was added
    final newNodes =
        state.nodes.values.where((n) => !oldState.nodes.containsKey(n.id));
    final newEdges =
        state.edges.values.where((e) => !oldState.edges.containsKey(e.id));

    if (newNodes.isNotEmpty) {
      _nodeStreams.emitChanges(newNodes
          .map((n) => NodeChangeEvent(
              nodeId: n.id, type: NodeChangeType.add, newValue: n))
          .toList());
    }
    if (newEdges.isNotEmpty) {
      _edgeStreams.emitChanges(newEdges
          .map((e) => EdgeChangeEvent(
              edgeId: e.id, type: EdgeEventType.change, data: e))
          .toList());
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
    _history.clear(); // Clear history after loading a new state
    _history.init(state);
  }

  // =================================================================================
  // --- QUERIES (Read-only operations) ---
  // =================================================================================

  // -- Node Queries --
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

  // -- Edge Queries --
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

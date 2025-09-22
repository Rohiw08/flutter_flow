import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/application/events/connection_change_event.dart';
import 'package:flutter_workflow/src/features/canvas/application/events/edge_change_event.dart';
import 'package:flutter_workflow/src/features/canvas/application/events/node_change_event.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/clipboard_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/connection_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_query_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/history_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/keyboard_action_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/node_query_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/node_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/selection_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/serialization_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/viewport_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/z_index_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/streams/selection_change_stream.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/fitview_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/keyboard_options.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

import 'events/pane_change.dart';
import 'streams/connection_change_stream.dart';
import 'streams/edge_change_stream.dart';
import 'streams/node_change_stream.dart';
import 'streams/pane_change_stream.dart';

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
  final SerializationService _serializationService;
  final EdgeQueryService _edgeQueryService;
  final NodeQueryService _nodeQueryService;
  late final KeyboardActionService _keyboardActionService;

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
        _serializationService = SerializationService(),
        _edgeQueryService = EdgeQueryService(),
        _nodeQueryService = NodeQueryService(),
        super(initialState ?? FlowCanvasState.initial()) {
    _keyboardActionService = KeyboardActionService(
      history: _history,
      nodeService: _nodeService,
      edgeService: _edgeService,
      selectionService: _selectionService,
      viewportService: _viewportService,
      clipboardService: _clipboardService,
    );

    // Initialize services that depend on the initial state.
    _history.init(state);
    _updateTransformationController();

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

  // Expose the streams publicly for the developer to listen to
  NodeStreams get nodeStreams => _nodeStreams;
  EdgeStreams get edgeStreams => _edgeStreams;
  ConnectionStreams get connectionStreams => _connectionStreams;
  PaneStreams get paneStreams => _paneStreams;
  SelectionStreams get selectionStreams => _selectionStreams;

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
    final matrix = Matrix4.identity()
      ..translate(viewport.offset.dx, viewport.offset.dy)
      ..scale(viewport.zoom);
    transformationController.value = matrix;
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
    }
  }

  void pan(Offset delta) {
    _mutate((s) => _viewportService.pan(s, delta));
    _paneStreams.emitEvent(
        PaneEvent(type: PaneEventType.move, viewport: state.viewport));
  }

  void toggleLock() {
    _mutate((s) => s.copyWith(isPanZoomLocked: !s.isPanZoomLocked));
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
    _paneStreams.emitEvent(
        PaneEvent(type: PaneEventType.move, viewport: state.viewport));
  }

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

  /// Converts a point from screen coordinates to canvas coordinates.
  Offset screenToCanvas(Offset screenPosition) =>
      _viewportService.screenToCanvas(state, screenPosition);

  /// Converts a point from canvas coordinates to screen coordinates.
  Offset canvasToScreen(Offset canvasPosition) =>
      _viewportService.canvasToScreen(state, canvasPosition);

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

    final edgeEvents = removedEdgeIds
        .map((id) => EdgeChangeEvent(edgeId: id, type: EdgeEventType.delete))
        .toList();
    _edgeStreams.emitChanges(edgeEvents);
  }

  void dragSelectedBy(Offset delta) {
    final oldState = state;
    _mutate((s) => _nodeService.dragSelectedNodes(s, delta));

    final changes = oldState.selectedNodes
        .map((nodeId) {
          final oldNode = oldState.nodes[nodeId];
          final newNode = state.nodes[nodeId];
          if (oldNode != null && newNode != null) {
            return NodeChangeEvent(
              nodeId: nodeId,
              type: NodeChangeType.position,
              oldValue: oldNode.position,
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
  }

  void selectAll({bool nodes = true, bool edges = true}) {
    _mutate((s) => _selectionService.selectAll(s, nodes: nodes, edges: edges));
    // Emitting events for a full selectAll can be noisy, but here's how you could
    // For now, developers can listen to the generic onStateChange stream
  }

  void startSelection(Offset position) =>
      _mutate((s) => _selectionService.startBoxSelection(s, position));

  void updateSelection(Offset position, {SelectionMode? selectionMode}) =>
      _mutate((s) => _selectionService.updateBoxSelection(s, position,
          selectionMode: selectionMode ?? SelectionMode.partial,
          nodeQueryService: _nodeQueryService));

  void endSelection() => _mutate((s) => _selectionService.endBoxSelection(s));

  void deselectAll() {
    _mutate((s) => _selectionService.deselectAll(s));
  }

  // =================================================================================
  // --- Connections ---
  // =================================================================================

  void startConnection(String nodeId, String handleId, Offset startPosition) {
    _mutate((s) => _connectionService.startConnection(s,
        fromNodeId: nodeId,
        fromHandleId: handleId,
        startPosition: startPosition));

    if (state.connection != null) {
      _connectionStreams.emitEvent(ConnectionEvent(
          type: ConnectionEventType.start, connection: state.connection!));
    }
  }

  void updateConnection(Offset cursorPosition) {
    // This is a transient update, so we don't record it in history.
    state = _connectionService.updateConnection(state, cursorPosition);
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
  }) {
    _mutate(
      (s) => _keyboardActionService.handleAction(
        s,
        action,
        arrowMoveDelta:
            Offset(options.arrowKeyMoveSpeed, options.arrowKeyMoveSpeed),
        zoomStep: options.zoomStep,
        minZoom: s.viewport.zoom,
        maxZoom: s.viewport.zoom,
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
    transformationController.dispose();
    super.dispose();
  }
}

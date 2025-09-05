import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/connection_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flutter_workflow/src/shared/providers.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class FlowCanvasFacade {
  final ProviderContainer _container;
  final ({NodeRegistry nodeRegistry, EdgeRegistry edgeRegistry}) _registries;

  // StreamControllers for managing combined streams
  StreamController<List<Object?>>? _nodesAndViewportController;
  StreamSubscription? _nodesSubscription;
  StreamSubscription? _viewportSubscription;

  List<FlowNode>? _lastNodes;
  Rect? _lastViewport;

  FlowCanvasFacade({
    required NodeRegistry nodeRegistry,
    required EdgeRegistry edgeRegistry,
  })  : _registries = (nodeRegistry: nodeRegistry, edgeRegistry: edgeRegistry),
        _container = ProviderContainer() {
    _initializeCombinedStreams();
  }

  // --- INTERNAL GETTERS ---
  StateNotifierProviderFamily<FlowCanvasController, FlowCanvasState,
          ({EdgeRegistry edgeRegistry, NodeRegistry nodeRegistry})>
      get _provider => flowControllerProvider;

  FlowCanvasController get _controller =>
      _container.read(_provider(_registries).notifier);

  // --- PUBLIC PROPERTIES ---
  /// The transformation controller for the InteractiveViewer.
  TransformationController get transformationController =>
      _controller.transformationController;

  /// The latest synchronous state. Use with caution, prefer streams for UI.
  FlowCanvasState get state => _container.read(_provider(_registries));

  // --- COMMANDS ---
  void addNode(FlowNode node) => _controller.addNode(node);
  void removeSelectedNodes() => _controller.removeSelectedNodes();
  void deselectAll() => _controller.deselectAll();
  void fitView(Size viewportSize) => _controller.fitView();
  void centerView() => _controller.centerView();
  void pan(Offset delta) => _controller.pan(delta);
  void zoom(double delta) => _controller.zoom(delta);
  void centerOnPosition(Offset canvasPosition) =>
      _controller.centerOnPosition(canvasPosition);
  void startConnection(String nodeId, String handleId, Offset globalPosition) =>
      _controller.startConnection(nodeId, handleId, globalPosition);
  void updateConnection(Offset globalPosition) =>
      _controller.updateConnection(globalPosition);
  void endConnection() => _controller.endConnection();
  void togglePanZoomLock() => _controller.togglePanZoomLock();
  void startSelection(Offset position) => _controller.startSelection(position);
  void updateSelection(Offset position) =>
      _controller.updateSelection(position);
  void endSelection() => _controller.endSelection();

  // --- QUERIES (STREAMS) ---
  Stream<List<FlowNode>> get nodesStream => _controller.stream
      .map((state) => state.nodes)
      .distinct((p, n) => const ListEquality().equals(p, n));

  Stream<List<FlowEdge>> get edgesStream => _controller.stream
      .map((state) => state.edges)
      .distinct((p, n) => const ListEquality().equals(p, n));

  Stream<FlowConnectionState?> get connectionStream =>
      _controller.stream.map((state) => state.connection).distinct();

  Stream<Rect?> get selectionRectStream =>
      _controller.stream.map((state) => state.selectionRect).distinct();

  Stream<double> get zoomStream =>
      _controller.stream.map((state) => state.zoom).distinct();

  Stream<bool> get isPanZoomLockedStream =>
      _controller.stream.map((state) => state.isPanZoomLocked).distinct();

  Stream<Rect?> get viewportStream {
    return _controller.stream.map((state) => state.viewport).distinct();
  }

  Stream<List<Object?>> get nodesAndViewportStream {
    return _nodesAndViewportController!.stream;
  }

  Stream<FlowCanvasState> get fullCanvasStream => _controller.stream.distinct();

  // --- PRIVATE METHODS ---
  void _initializeCombinedStreams() {
    _nodesAndViewportController = StreamController<List<Object?>>.broadcast();

    _nodesSubscription = nodesStream.listen((nodes) {
      _lastNodes = nodes;
      _emitCombinedUpdate();
    });

    _viewportSubscription = viewportStream.listen((viewport) {
      _lastViewport = viewport;
      _emitCombinedUpdate();
    });
  }

  void _emitCombinedUpdate() {
    if (_lastNodes != null &&
        _nodesAndViewportController != null &&
        !_nodesAndViewportController!.isClosed) {
      _nodesAndViewportController!.add([_lastNodes!, _lastViewport]);
    }
  }

  /// Disposes the internal ProviderContainer to prevent memory leaks.
  void dispose() {
    _nodesSubscription?.cancel();
    _viewportSubscription?.cancel();
    _nodesAndViewportController?.close();
    _container.dispose();
  }
}

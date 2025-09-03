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
import 'package:rxdart/rxdart.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

/// The public-facing API for interacting with a FlowCanvas.
///
/// This class provides a clean, un-opinionated API that hides the internal
/// state management implementation (Riverpod).
class FlowCanvasFacade {
  final ProviderContainer _container;
  final ({NodeRegistry nodeRegistry, EdgeRegistry edgeRegistry}) _registries;

  FlowCanvasFacade({
    required NodeRegistry nodeRegistry,
    required EdgeRegistry edgeRegistry,
  })  : _registries = (nodeRegistry: nodeRegistry, edgeRegistry: edgeRegistry),
        _container = ProviderContainer();

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
    return Rx.combineLatest2(nodesStream, viewportStream, (a, b) => [a, b]);
  }

  /// A combined stream for efficiently rebuilding the entire canvas painter.
  Stream<FlowCanvasState> get fullCanvasStream => Rx.combineLatest6(
      nodesStream,
      edgesStream,
      connectionStream,
      selectionRectStream,
      zoomStream,
      isPanZoomLockedStream,
      (a, b, c, d, e, f) => FlowCanvasState(
          nodes: a,
          edges: b,
          connection: c,
          selectionRect: d,
          zoom: e,
          isPanZoomLocked: f));

  /// Disposes the internal ProviderContainer to prevent memory leaks.
  void dispose() {
    _container.dispose();
  }
}

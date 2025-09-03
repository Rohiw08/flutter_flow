import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/enums.dart';
import '../domain/flow_canvas_state.dart';
import '../domain/models/node.dart';
import '../domain/registries/edge_registry.dart';
import '../domain/registries/node_registry.dart';
import 'services/connection_service.dart';
import 'services/handle_service.dart';
import 'services/node_service.dart';
import 'services/selection_service.dart';

/// The single brain for the canvas.
///
/// This controller is a StateNotifier that manages the immutable FlowCanvasState.
/// It is the only class that can modify the state. It uses stateless services

/// to compute the next state in response to UI events.
class FlowCanvasController extends StateNotifier<FlowCanvasState> {
  final Ref _ref;
  final NodeRegistry nodeRegistry;
  final EdgeRegistry edgeRegistry;

  final TransformationController transformationController =
      TransformationController();

  FlowCanvasController(
    this._ref, {
    required this.nodeRegistry,
    required this.edgeRegistry,
  }) : super(FlowCanvasState.initial()) {
    transformationController.addListener(_onTransformChanged);
  }

  void _onTransformChanged() {
    // When the InteractiveViewer transform changes, update the zoom and viewport
    // in our immutable state. This allows other parts of the UI (like the minimap)
    // to react to viewport changes.
    state = state.copyWith(
      zoom: transformationController.value.getMaxScaleOnAxis(),
      viewport: state.viewportSize != null
          ? _calculateViewport(state.viewportSize!)
          : null,
    );
  }

  // --- VIEWPORT & NAVIGATION ---

  /// Called by the UI to inform the controller of its current size.
  void setViewportSize(Size size) {
    if (state.viewportSize == size) return;
    // Update the state with the new size and the resulting viewport rectangle.
    state = state.copyWith(
      viewportSize: size,
      viewport: _calculateViewport(size),
    );
  }

  Rect _calculateViewport(Size viewportSize) {
    final matrix = transformationController.value;
    try {
      final invertedMatrix = Matrix4.inverted(matrix);
      final topLeft = invertedMatrix.transform3(Vector3.zero());
      final bottomRight = invertedMatrix
          .transform3(Vector3(viewportSize.width, viewportSize.height, 0));
      return Rect.fromPoints(
        Offset(topLeft.x, topLeft.y),
        Offset(bottomRight.x, bottomRight.y),
      );
    } catch (e) {
      // Matrix might not be invertible during extreme scales
      return Rect.zero;
    }
  }

  void pan(Offset screenDelta) {
    if (state.isPanZoomLocked) return;
    transformationController.value = transformationController.value.clone()
      ..translate(screenDelta.dx, screenDelta.dy);
  }

  void fitView() {
    if (state.isPanZoomLocked ||
        state.nodes.isEmpty ||
        state.viewportSize == null) {
      return;
    }
    final bounds = state.nodes
        .map((n) => n.rect)
        .reduce((value, element) => value.expandToInclude(element));
    if (bounds.width <= 0 || bounds.height <= 0) return;

    const padding = EdgeInsetsGeometry.all(50);
    final viewportSize = state.viewportSize!;
    final scaleX = (viewportSize.width - padding.horizontal) / bounds.width;
    final scaleY = (viewportSize.height - padding.vertical) / bounds.height;
    final scale = min(scaleX, min(scaleY, 2.0));
    final scaledBoundsWidth = bounds.width * scale;
    final scaledBoundsHeight = bounds.height * scale;
    final translateX =
        (viewportSize.width - scaledBoundsWidth) / 2 - (bounds.left * scale);
    final translateY =
        (viewportSize.height - scaledBoundsHeight) / 2 - (bounds.top * scale);

    transformationController.value = Matrix4.identity()
      ..translate(translateX, translateY)
      ..scale(scale);
  }

  void zoom(double delta, [Offset? focalPoint]) {
    if (state.isPanZoomLocked) return;
    final currentScale = state.zoom;
    final newScale = (currentScale + delta).clamp(0.1, 2.0); // Use constants
    final actualFactor = newScale / currentScale;

    if (actualFactor == 1.0) return;

    final sceneFocalPoint = focalPoint != null
        ? transformationController.toScene(focalPoint)
        : transformationController.toScene(Offset(
            state.viewportSize!.width / 2, state.viewportSize!.height / 2));

    transformationController.value = transformationController.value.clone()
      ..translate(sceneFocalPoint.dx, sceneFocalPoint.dy)
      ..scale(actualFactor)
      ..translate(-sceneFocalPoint.dx, -sceneFocalPoint.dy);
  }

  void centerOnPosition(Offset canvasPosition) {
    if (state.isPanZoomLocked || state.viewportSize == null) return;
    final viewportSize = state.viewportSize!;
    final currentScale = state.zoom;
    transformationController.value = Matrix4.identity()
      ..translate(-canvasPosition.dx * currentScale + viewportSize.width / 2,
          -canvasPosition.dy * currentScale + viewportSize.height / 2)
      ..scale(currentScale);
  }

  void togglePanZoomLock() {
    state = state.copyWith(isPanZoomLocked: !state.isPanZoomLocked);
  }

  // --- NODE METHODS ---
  void addNode(FlowNode node) {
    if (!nodeRegistry.isRegistered(node.type)) {
      debugPrint('Error: Node type "${node.type}" is not registered.');
      return;
    }
    final intermediateState =
        _ref.read(nodeServiceProvider).addNode(state, node);
    final newHash = _ref
        .read(handleServiceProvider)
        .buildSpatialHash(intermediateState.nodes);
    state = intermediateState.copyWith(spatialHash: newHash);
  }

  void removeSelectedNodes() {
    final intermediateState =
        _ref.read(nodeServiceProvider).removeSelectedNodes(state);
    final newHash = _ref
        .read(handleServiceProvider)
        .buildSpatialHash(intermediateState.nodes);
    state = intermediateState.copyWith(spatialHash: newHash);
  }

  void dragSelectedNodes(Offset delta) {
    state = _ref.read(nodeServiceProvider).dragSelectedNodes(state, delta);
  }

  void endNodeDrag() {
    final newHash =
        _ref.read(handleServiceProvider).buildSpatialHash(state.nodes);
    state = state.copyWith(spatialHash: newHash);
  }

  // --- SELECTION METHODS ---
  void selectNode(String nodeId, {bool multiSelect = false}) {
    state = _ref
        .read(selectionServiceProvider)
        .selectNode(state, nodeId, multiSelect: multiSelect);
  }

  void deselectAll() {
    state = _ref.read(selectionServiceProvider).deselectAll(state);
  }

  void startSelection(Offset position) {
    state = _ref.read(selectionServiceProvider).startSelection(state, position);
  }

  void updateSelection(Offset position) {
    if (state.dragMode != DragMode.selection) return;
    state =
        _ref.read(selectionServiceProvider).updateSelection(state, position);
  }

  void endSelection() {
    if (state.dragMode != DragMode.selection) return;
    state = _ref.read(selectionServiceProvider).endSelection(state);
  }

  // --- CONNECTION METHODS ---
  void startConnection(
      String fromNodeId, String fromHandleId, Offset startPosition) {
    state = _ref.read(connectionServiceProvider).startConnection(
          state,
          fromNodeId: fromNodeId,
          fromHandleId: fromHandleId,
          startPosition: startPosition,
        );
  }

  void updateConnection(Offset endPosition) {
    if (state.connection == null) return;
    state = _ref
        .read(connectionServiceProvider)
        .updateConnection(state, endPosition);
  }

  void endConnection() {
    if (state.connection == null) return;
    state = _ref.read(connectionServiceProvider).endConnection(state);
  }

  void cancelConnection() {
    if (state.connection == null) return;
    state = _ref.read(connectionServiceProvider).cancelConnection(state);
  }

  @override
  void dispose() {
    transformationController.removeListener(_onTransformChanged);
    transformationController.dispose();
    super.dispose();
  }
}

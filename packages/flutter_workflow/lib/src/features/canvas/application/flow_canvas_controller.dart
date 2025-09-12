import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/enums.dart';
import '../domain/state/flow_canvas_state.dart';
import '../domain/models/node.dart';
import '../domain/registries/edge_registry.dart';
import '../domain/registries/node_registry.dart';
import 'services/connection_service.dart';
import 'services/handle_service.dart';
import 'services/node_service.dart';
import 'services/selection_service.dart';

class FlowCanvasController extends StateNotifier<FlowCanvasState> {
  final Ref _ref;
  final NodeRegistry nodeRegistry;
  final EdgeRegistry edgeRegistry;
  bool _hasInitialized = false; // Track initialization

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

    final isFirstTime = state.viewportSize == null;

    state = state.copyWith(
      viewportSize: size,
      viewport: _calculateViewport(size),
    );

    // Initialize view on first viewport size setting
    if (isFirstTime && !_hasInitialized) {
      _initializeView(size);
      _hasInitialized = true;
    }
  }

  /// Initialize the view with proper centering or fit view
  void _initializeView(Size viewportSize) {
    if (state.nodes.isNotEmpty) {
      // If we have nodes, fit them in view
      _fitViewInternal(viewportSize);
    } else {
      // If no nodes, center the canvas (Cartesian coordinate system)
      _centerCanvasInViewport(viewportSize);
    }
  }

  /// Centers the canvas so that (0,0) in canvas coordinates appears at viewport center
  void _centerCanvasInViewport(Size viewportSize) {
    final canvasCenter = Offset(state.canvasWidth / 2, state.canvasHeight / 2);
    const initialScale = 1.0;

    // Calculate translation to move canvas center to viewport center
    final translateX = -canvasCenter.dx * initialScale + viewportSize.width / 2;
    final translateY =
        -canvasCenter.dy * initialScale + viewportSize.height / 2;

    transformationController.value = Matrix4.identity()
      ..translate(translateX, translateY)
      ..scale(initialScale);
  }

  /// Internal fit view that takes viewport size as parameter
  void _fitViewInternal(Size viewportSize) {
    if (state.nodes.isEmpty) {
      _centerCanvasInViewport(viewportSize);
      return;
    }

    final bounds = state.nodes
        .map((n) => n.rect)
        .reduce((value, element) => value.expandToInclude(element));

    if (bounds.width <= 0 || bounds.height <= 0) {
      _centerCanvasInViewport(viewportSize);
      return;
    }

    const padding = 50.0; // Padding around nodes
    final paddedWidth = viewportSize.width - (padding * 2);
    final paddedHeight = viewportSize.height - (padding * 2);

    if (paddedWidth <= 0 || paddedHeight <= 0) {
      _centerCanvasInViewport(viewportSize);
      return;
    }

    final scaleX = paddedWidth / bounds.width;
    final scaleY = paddedHeight / bounds.height;
    final scale = min(scaleX, min(scaleY, 2.0)); // Max scale of 2.0

    // Calculate the center of the bounds
    final boundsCenter = bounds.center;

    // Calculate translation to center the bounds in the viewport
    final translateX = viewportSize.width / 2 - boundsCenter.dx * scale;
    final translateY = viewportSize.height / 2 - boundsCenter.dy * scale;

    transformationController.value = Matrix4.identity()
      ..translate(translateX, translateY)
      ..scale(scale);
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
      return Rect.zero;
    }
  }

  void pan(Offset screenDelta) {
    if (state.isPanZoomLocked) return;
    transformationController.value = transformationController.value.clone()
      ..translate(screenDelta.dx, screenDelta.dy);
  }

  /// Public fit view method (re-initializes if viewport exists)
  void fitView() {
    if (state.isPanZoomLocked || state.viewportSize == null) {
      return;
    }
    _fitViewInternal(state.viewportSize!);
  }

  void zoom(double delta, [Offset? focalPoint]) {
    if (state.isPanZoomLocked) return;
    final currentScale = state.zoom;
    final newScale = (currentScale + delta).clamp(0.1, 2.0);
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

  void centerView() {
    if (state.isPanZoomLocked || state.viewportSize == null) return;
    _centerCanvasInViewport(state.viewportSize!);
  }

  /// Reset view to initial state (center or fit depending on nodes)
  void resetView() {
    if (state.viewportSize == null) return;
    _initializeView(state.viewportSize!);
  }

  void togglePanZoomLock() {
    state = state.copyWith(isPanZoomLocked: !state.isPanZoomLocked);
  }

  // --- NODE METHODS ---
  void addNode(FlowNode node) {
    if (!nodeRegistry.isRegistered(node.type)) {
      return;
    }

    // Don't transform node position here - let it be placed where requested
    final intermediateState =
        _ref.read(nodeServiceProvider).addNode(state, node);
    final newHash = _ref
        .read(handleServiceProvider)
        .buildSpatialHash(intermediateState.nodes);

    state = intermediateState.copyWith(spatialHash: newHash);

    // If this is the first node and we have a viewport, re-initialize view
    if (state.nodes.length == 1 &&
        state.viewportSize != null &&
        _hasInitialized) {
      // Optional: Auto-fit view when first node is added
      // Uncomment the next line if you want this behavior:
      // _fitViewInternal(state.viewportSize!);
    }
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

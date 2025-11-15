import 'dart:ui';
import 'package:flow_canvas/src/features/canvas/application/events/viewport_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/viewport_service.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/viewport_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/fitview_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/viewport_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';

class ViewportController {
  final FlowCanvasInternalController _controller;
  final ViewportService _viewportService;
  final CanvasCoordinateConverter _coordinateConverter;
  final ViewportStreams _viewportStreams;

  ViewportController({
    required FlowCanvasInternalController controller,
    required ViewportService viewportService,
    required CanvasCoordinateConverter coordinateConverter,
    required ViewportStreams viewportStreams,
  })  : _controller = controller,
        _viewportService = viewportService,
        _coordinateConverter = coordinateConverter,
        _viewportStreams = viewportStreams;

  void setViewportSize(Size size) {
    final currentState = _controller.currentState;
    if (currentState.viewportSize != size) {
      _controller.updateStateOnly(currentState.copyWith(viewportSize: size));
      final event = ViewportEvent(
        type: ViewportEventType.resize,
        viewport: currentState.viewport,
        viewportSize: size,
      );
      _viewportStreams.emitEvent(event);
    }
  }

  void panBy(Offset delta) {
    final newState = _viewportService.pan(_controller.currentState, delta);
    _controller.updateStateOnly(newState);
    final event = ViewportEvent(
      type: ViewportEventType.transform,
      viewport: newState.viewport,
      viewportSize: newState.viewportSize,
    );
    _viewportStreams.emitEvent(event);
  }

  void toggleLock() {
    final currentState = _controller.currentState;
    _controller.updateStateOnly(
        currentState.copyWith(isPanZoomLocked: !currentState.isPanZoomLocked));
  }

  void zoom({
    required Offset focalPoint,
    required double minZoom,
    required double maxZoom,
    required double zoomFactor,
  }) {
    final newState = _viewportService.zoom(
      _controller.currentState,
      zoomFactor: 1 + zoomFactor,
      focalPoint: focalPoint,
      minZoom: minZoom,
      maxZoom: maxZoom,
    );
    _controller.updateStateOnly(newState);
    final event = ViewportEvent(
      type: ViewportEventType.transform,
      viewport: newState.viewport,
      viewportSize: newState.viewportSize,
    );
    _viewportStreams.emitEvent(event);
  }

  void fitView(
      {FitViewOptions fitviewOptions = const FitViewOptions(),
      ViewportOptions viewportOptions = const ViewportOptions()}) {
    final newState = _viewportService.fitView(
        state: _controller.currentState,
        viewportOptions: viewportOptions,
        fitViewOptions: fitviewOptions);
    _controller.updateStateOnly(newState);
    final event = ViewportEvent(
      type: ViewportEventType.transform,
      viewport: newState.viewport,
      viewportSize: newState.viewportSize,
    );
    _viewportStreams.emitEvent(event);
  }

  void centerOnPosition(Offset canvasPosition) {
    final newState = _viewportService.centerOnPosition(
      _controller.currentState,
      canvasPosition,
    );

    _controller.updateStateOnly(newState);
    final event = ViewportEvent(
      type: ViewportEventType.transform,
      viewport: newState.viewport,
      viewportSize: newState.viewportSize,
    );
    _viewportStreams.emitEvent(event);
  }

  void resetView() {
    final newState =
        _controller.currentState.copyWith(viewport: const FlowViewport());
    _controller.updateStateOnly(newState);
    final event = ViewportEvent(
      type: ViewportEventType.transform,
      viewport: newState.viewport,
      viewportSize: newState.viewportSize,
    );
    _viewportStreams.emitEvent(event);
  }

  Offset screenToCanvas(Offset screenPosition) =>
      _viewportService.screenToCanvas(_controller.currentState, screenPosition);

  Offset canvasToScreen(Offset canvasPosition) =>
      _viewportService.canvasToScreen(_controller.currentState, canvasPosition);

  Offset screenToCanvasPosition(Offset screenPosition) {
    final renderPosition = _viewportService.screenToCanvas(
        _controller.currentState, screenPosition);
    return _coordinateConverter.toCartesianPosition(renderPosition);
  }

  Offset canvasToScreenPosition(Offset cartesianPosition) {
    final renderPosition =
        _coordinateConverter.toRenderPosition(cartesianPosition);
    return _viewportService.canvasToScreen(
        _controller.currentState, renderPosition);
  }
}

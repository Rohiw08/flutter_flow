import 'dart:math';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/viewport_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flutter/painting.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/fitview_options.dart';

import '../../domain/models/node.dart';

typedef NodeBounds = ({Rect rect, List<FlowNode> nodes});

/// A stateless service for handling viewport transformations like panning and zooming.
class ViewportService {
  final CanvasCoordinateConverter _coordinateConverter;

  ViewportService({required CanvasCoordinateConverter coordinateConverter})
      : _coordinateConverter = coordinateConverter;

  /// Converts a point from screen coordinates to canvas coordinates.
  Offset screenToCanvas(FlowCanvasState state, Offset screenPosition) {
    return (screenPosition - state.viewport.offset) / state.viewport.zoom;
  }

  /// Converts a point from canvas coordinates to screen coordinates.
  Offset canvasToScreen(FlowCanvasState state, Offset canvasPosition) {
    return (canvasPosition * state.viewport.zoom) + state.viewport.offset;
  }

  // --- VIEWPORT MANIPULATION ---

  /// Pans the viewport by a given screen delta.
  FlowCanvasState pan(FlowCanvasState state, Offset delta) {
    return state.copyWith(
      viewport: state.viewport.copyWith(
        offset: state.viewport.offset + delta,
      ),
    );
  }

  /// Zooms the viewport by a factor, keeping a focal point stationary.
  FlowCanvasState zoom(
    FlowCanvasState state, {
    required double zoomFactor,
    required Offset focalPoint,
    required double minZoom,
    required double maxZoom,
  }) {
    final newZoom = (state.viewport.zoom * zoomFactor).clamp(minZoom, maxZoom);

    if (newZoom == state.viewport.zoom) return state;
    final canvasPoint = screenToCanvas(state, focalPoint);
    final newOffset = focalPoint - (canvasPoint * newZoom);

    return state.copyWith(
      viewport: FlowViewport(offset: newOffset, zoom: newZoom),
    );
  }

  FlowCanvasState centerOnPosition(
      FlowCanvasState state, Offset canvasPosition) {
    if (state.viewportSize == null) return state;

    final renderPosition =
        _coordinateConverter.toRenderPosition(canvasPosition);
    final newOffset = (renderPosition * state.viewport.zoom * -1) +
        Offset(state.viewportSize!.width / 2, state.viewportSize!.height / 2);

    return state.copyWith(
      viewport: state.viewport.copyWith(offset: newOffset),
    );
  }

  /// Adjusts the viewport to fit all or a subset of nodes within the screen.
  FlowCanvasState fitView({
    required FlowCanvasState state,
    required ViewportOptions viewportOptions,
    required FitViewOptions fitViewOptions,
  }) {
    final viewportSize = state.viewportSize;
    if (viewportSize == null || viewportSize.isEmpty) return state;

    final nodes = state.nodes.values.toList();
    final bounds = getNodeBounds(
        nodes: nodes, includeHidden: fitViewOptions.includeHiddenNodes);
    if (bounds.nodes.isEmpty || bounds.rect.isEmpty) return state;

    final availableWidth =
        viewportSize.width - fitViewOptions.padding.horizontal;
    final availableHeight =
        viewportSize.height - fitViewOptions.padding.vertical;

    if (availableWidth <= 0 || availableHeight <= 0) return state;

    final scaleX = availableWidth / bounds.rect.width;
    final scaleY = availableHeight / bounds.rect.height;
    final idealZoom = min(scaleX, scaleY);

    final effectiveMinZoom =
        max(viewportOptions.minZoom, fitViewOptions.minZoom);
    final effectiveMaxZoom =
        min(viewportOptions.maxZoom, fitViewOptions.maxZoom);

    final newZoom = idealZoom.clamp(effectiveMinZoom, effectiveMaxZoom);

    final scaledContentWidth = bounds.rect.width * newZoom;
    final scaledContentHeight = bounds.rect.height * newZoom;

    final newOffsetX = (viewportSize.width - scaledContentWidth) / 2 -
        (bounds.rect.left * newZoom);
    final newOffsetY = (viewportSize.height - scaledContentHeight) / 2 -
        (bounds.rect.top * newZoom);

    return state.copyWith(
      viewport:
          FlowViewport(offset: Offset(newOffsetX, newOffsetY), zoom: newZoom),
    );
  }

  // --- UTILITY METHODS ---

  /// Calculates the bounding box that encloses a given set of nodes.
  NodeBounds getNodeBounds({
    List<FlowNode> nodes = const [],
    bool includeHidden = false,
  }) {
    final nodesToConsider = nodes.where((node) {
      final isVisible = includeHidden || !(node.hidden ?? false);
      return isVisible;
    }).toList();

    if (nodesToConsider.isEmpty) {
      return (rect: Rect.zero, nodes: []);
    }

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in nodesToConsider) {
      final nodeRect =
          _coordinateConverter.cartesianRectToRenderRect(node.rect);

      minX = min(minX, nodeRect.left);
      minY = min(minY, nodeRect.top);
      maxX = max(maxX, nodeRect.right);
      maxY = max(maxY, nodeRect.bottom);
    }

    return (
      rect: Rect.fromLTRB(minX, minY, maxX, maxY),
      nodes: nodesToConsider
    );
  }
}

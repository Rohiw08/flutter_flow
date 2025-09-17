import 'dart:math';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/fitview_options.dart';

import '../../domain/models/node.dart';

/// Provider for the stateless ViewportService.
final viewportServiceProvider =
    Provider<ViewportService>((ref) => ViewportService());

typedef NodeBounds = ({Rect rect, List<FlowNode> nodes});

/// A stateless service for handling viewport transformations like panning and zooming.
class ViewportService {
  // --- COORDINATE CONVERSION ---

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

    // Calculate the point on the canvas under the focal point (e.g., cursor)
    final canvasPoint = screenToCanvas(state, focalPoint);

    // Calculate the new offset to keep the canvas point stationary under the focal point
    final newOffset = focalPoint - (canvasPoint * newZoom);

    return state.copyWith(
      viewport: FlowViewport(offset: newOffset, zoom: newZoom),
    );
  }

  /// Adjusts the viewport to fit all or a subset of nodes within the screen.
  FlowCanvasState fitView(
    FlowCanvasState state, {
    required FitViewOptions options,
  }) {
    final viewportSize = state.viewportSize;
    if (viewportSize == null || viewportSize.isEmpty) return state;

    final bounds = getNodeBounds(state,
        nodeIds: options.nodes, includeHidden: options.includeHiddenNodes);
    if (bounds.nodes.isEmpty) return state; // No nodes to fit

    final paddedRect = options.padding.inflateRect(bounds.rect);

    final newZoom = _calculateZoomToFit(paddedRect.size, viewportSize)
        .clamp(options.minZoom, options.maxZoom);

    final newOffset =
        _calculateOffsetToCenter(paddedRect, viewportSize, newZoom);

    return state.copyWith(
      viewport: FlowViewport(offset: newOffset, zoom: newZoom),
    );
  }

  // --- UTILITY METHODS ---

  /// Calculates the bounding box that encloses a given set of nodes.
  NodeBounds getNodeBounds(
    FlowCanvasState state, {
    List<String> nodeIds = const [],
    bool includeHidden = false,
  }) {
    final nodesToConsider = state.nodes.values.where((node) {
      final isIncluded = nodeIds.isEmpty || nodeIds.contains(node.id);
      final isVisible = includeHidden || !(node.hidden ?? false);
      return isIncluded && isVisible;
    }).toList();

    if (nodesToConsider.isEmpty) {
      return (rect: Rect.zero, nodes: []);
    }

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in nodesToConsider) {
      minX = min(minX, node.rect.left);
      minY = min(minY, node.rect.top);
      maxX = max(maxX, node.rect.right);
      maxY = max(maxY, node.rect.bottom);
    }

    return (
      rect: Rect.fromLTRB(minX, minY, maxX, maxY),
      nodes: nodesToConsider
    );
  }

  // PRIVATE HELPERS

  double _calculateZoomToFit(Size contentSize, Size viewportSize) {
    if (contentSize.width <= 0 || contentSize.height <= 0) return 1.0;
    final scaleX = viewportSize.width / contentSize.width;
    final scaleY = viewportSize.height / contentSize.height;
    return min(scaleX, scaleY);
  }

  Offset _calculateOffsetToCenter(
      Rect contentRect, Size viewportSize, double zoom) {
    final scaledContentWidth = contentRect.width * zoom;
    final scaledContentHeight = contentRect.height * zoom;

    final dx = (viewportSize.width - scaledContentWidth) / 2 -
        (contentRect.left * zoom);
    final dy = (viewportSize.height - scaledContentHeight) / 2 -
        (contentRect.top * zoom);

    return Offset(dx, dy);
  }
}

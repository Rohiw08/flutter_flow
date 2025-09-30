import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/minimap_theme.dart';

/// Holds the calculated transformation values for rendering the minimap.
class MiniMapTransform {
  final double scale;
  final Offset offset;
  final Rect contentBounds;

  const MiniMapTransform({
    required this.scale,
    required this.offset,
    required this.contentBounds,
  });
}

/// A highly optimized painter for the canvas minimap.
class MiniMapPainter extends CustomPainter {
  final List<FlowNode> nodes;
  final Rect viewport;
  final FlowMinimapStyle theme;

  // Pre-built Paint objects for performance.
  final Paint _backgroundPaint;
  final Paint _nodePaint;
  final Paint _viewportStrokePaint;
  final Paint _viewportFillPaint;

  MiniMapPainter({
    required this.nodes,
    required this.viewport,
    required this.theme,
  })  : _backgroundPaint = Paint()
          ..color = (theme.backgroundColor ?? Colors.grey.shade200),
        _nodePaint = Paint()..color = (theme.nodeColor ?? Colors.blue.shade600),
        _viewportStrokePaint = Paint()
          ..color = (theme.maskStrokeColor ?? Colors.red.shade600)
          ..strokeWidth = (theme.maskStrokeWidth ?? 2.0)
          ..style = PaintingStyle.stroke,
        _viewportFillPaint = Paint()
          ..color = (theme.maskStrokeColor ?? Colors.red.shade600).withAlpha(30)
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final combinedBounds = _getCombinedBounds(nodes, viewport);
    final transform = calculateTransform(combinedBounds, size, theme);

    if (transform.scale <= 0) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height), _backgroundPaint);
      return;
    }

    canvas.save();

    // Draw background
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), _backgroundPaint);

    // Draw nodes
    _drawNodes(canvas, transform);

    // Draw viewport indicator
    _drawViewport(canvas, transform);

    canvas.restore();
  }

  void _drawNodes(Canvas canvas, MiniMapTransform transform) {
    for (final node in nodes) {
      final nodeRect = fromCanvasToMiniMap(node.rect, transform);
      // Make sure nodes are visible even when very small
      const minSize = 2.0;
      final adjustedRect = Rect.fromLTWH(
        nodeRect.left,
        nodeRect.top,
        math.max(nodeRect.width, minSize),
        math.max(nodeRect.height, minSize),
      );
      canvas.drawRect(adjustedRect, _nodePaint);
    }
  }

  void _drawViewport(Canvas canvas, MiniMapTransform transform) {
    if (viewport.isEmpty) return;

    final viewportInMiniMap = fromCanvasToMiniMap(viewport, transform);

    // Draw viewport fill (semi-transparent)
    canvas.drawRect(viewportInMiniMap, _viewportFillPaint);

    // Draw viewport border
    canvas.drawRect(viewportInMiniMap, _viewportStrokePaint);
  }

  // FIXED: Calculate bounds that include both nodes AND viewport
  Rect _getCombinedBounds(List<FlowNode> nodes, Rect viewport) {
    if (nodes.isEmpty && viewport.isEmpty) return Rect.zero;

    Rect? combinedBounds;

    // Include all node bounds
    if (nodes.isNotEmpty) {
      combinedBounds =
          nodes.map((node) => node.rect).reduce((a, b) => a.expandToInclude(b));
    }

    // Include viewport bounds
    if (!viewport.isEmpty) {
      combinedBounds = combinedBounds?.expandToInclude(viewport) ?? viewport;
    }

    // Add some padding to ensure everything is visible
    if (combinedBounds != null && !combinedBounds.isEmpty) {
      final padding =
          math.max(combinedBounds.width, combinedBounds.height) * 0.1;
      combinedBounds = combinedBounds.inflate(padding);
    }

    return combinedBounds ?? Rect.zero;
  }

  // --- STATIC UTILITY METHODS ---

  static MiniMapTransform calculateTransform(
      Rect contentBounds, Size minimapSize, FlowMinimapStyle theme) {
    if (contentBounds.isEmpty || minimapSize.isEmpty) {
      return const MiniMapTransform(
          scale: 0, offset: Offset.zero, contentBounds: Rect.zero);
    }

    final padding = theme.padding ?? 10.0;
    final paddedWidth = minimapSize.width - (padding * 2);
    final paddedHeight = minimapSize.height - (padding * 2);

    if (contentBounds.width <= 0 ||
        contentBounds.height <= 0 ||
        paddedWidth <= 0 ||
        paddedHeight <= 0) {
      return MiniMapTransform(
          scale: 0, offset: Offset.zero, contentBounds: contentBounds);
    }

    final scaleX = paddedWidth / contentBounds.width;
    final scaleY = paddedHeight / contentBounds.height;
    final scale = math.min(scaleX, scaleY);

    final scaledContentWidth = contentBounds.width * scale;
    final scaledContentHeight = contentBounds.height * scale;

    final offsetX = (minimapSize.width - scaledContentWidth) / 2 -
        (contentBounds.left * scale);
    final offsetY = (minimapSize.height - scaledContentHeight) / 2 -
        (contentBounds.top * scale);

    return MiniMapTransform(
        scale: scale,
        offset: Offset(offsetX, offsetY),
        contentBounds: contentBounds);
  }

  static Offset fromMiniMapToCanvas(
      Offset miniMapPosition, MiniMapTransform transform) {
    if (transform.scale == 0) return Offset.zero;
    return Offset(
      (miniMapPosition.dx - transform.offset.dx) / transform.scale,
      (miniMapPosition.dy - transform.offset.dy) / transform.scale,
    );
  }

  static Rect fromCanvasToMiniMap(Rect canvasRect, MiniMapTransform transform) {
    return Rect.fromLTWH(
      canvasRect.left * transform.scale + transform.offset.dx,
      canvasRect.top * transform.scale + transform.offset.dy,
      canvasRect.width * transform.scale,
      canvasRect.height * transform.scale,
    );
  }

  @override
  bool shouldRepaint(covariant MiniMapPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.viewport != viewport ||
        oldDelegate.theme != theme;
  }
}

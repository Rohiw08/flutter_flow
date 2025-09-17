import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/minimap_theme.dart';

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
  final Paint _maskPaint;
  final Paint _viewportStrokePaint;

  MiniMapPainter({
    required this.nodes,
    required this.viewport,
    required this.theme,
  })  : _backgroundPaint = Paint()
          ..color = (theme.backgroundColor ?? Colors.transparent),
        _nodePaint = Paint()..color = (theme.nodeColor ?? Colors.blue),
        _maskPaint = Paint()
          ..color = (theme.maskColor ?? const Color(0x66000000)),
        _viewportStrokePaint = Paint()
          ..color = (theme.maskStrokeColor ?? Colors.white)
          ..strokeWidth = (theme.maskStrokeWidth ?? 1.0)
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final transform = calculateTransform(_getBounds(nodes), size, theme);
    if (transform.scale <= 0) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height), _backgroundPaint);
      return;
    }

    canvas.save();
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), _backgroundPaint);
    _drawNodes(canvas, transform);
    _drawViewport(canvas, size, transform);
    canvas.restore();
  }

  void _drawNodes(Canvas canvas, MiniMapTransform transform) {
    final nodesPath = Path();

    for (final node in nodes) {
      final nodeRect = fromCanvasToMiniMap(node.rect, transform);
      nodesPath.addRect(nodeRect);
    }
    canvas.drawPath(nodesPath, _nodePaint);
  }

  void _drawViewport(Canvas canvas, Size size, MiniMapTransform transform) {
    final viewportInMiniMap = fromCanvasToMiniMap(viewport, transform);
    final maskPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRect(viewportInMiniMap),
    );
    canvas.drawPath(maskPath, _maskPaint);
    canvas.drawRect(viewportInMiniMap, _viewportStrokePaint);
  }

  Rect _getBounds(List<FlowNode> nodes) {
    if (nodes.isEmpty) return Rect.zero;
    return nodes
        .map((node) => node.rect)
        .reduce((a, b) => a.expandToInclude(b));
  }

  // --- STATIC UTILITY METHODS ---

  static MiniMapTransform calculateTransform(
      Rect contentBounds, Size minimapSize, FlowMinimapStyle theme) {
    if (contentBounds.isEmpty || minimapSize.isEmpty) {
      return MiniMapTransform(
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

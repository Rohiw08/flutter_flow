import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/theme/components/minimap_theme.dart';

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
  final Map<String, FlowNode> nodes;
  final Rect viewport;
  final FlowCanvasMiniMapStyle theme;

  // Pre-built Paint objects for performance.
  final Paint _backgroundPaint;
  final Paint _nodePaint;
  final Paint _selectedNodePaint;
  final Paint _maskPaint;
  final Paint _viewportStrokePaint;

  MiniMapPainter({
    required this.nodes,
    required this.viewport,
    required this.theme,
  })  : _backgroundPaint = Paint()..color = theme.backgroundColor,
        _nodePaint = Paint()..color = theme.nodeColor,
        _selectedNodePaint = Paint()..color = theme.selectedNodeColor,
        _maskPaint = Paint()..color = theme.maskColor,
        _viewportStrokePaint = Paint()
          ..color = theme.maskStrokeColor
          ..strokeWidth = theme.maskStrokeWidth
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
    final regularNodesPath = Path();
    final selectedNodesPath = Path();

    for (MapEntry<String, FlowNode> node in nodes.entries) {
      final nodeRect = fromCanvasToMiniMap(node.value.rect, transform);
      if (node.value.isSelected) {
        selectedNodesPath.addRect(nodeRect);
      } else {
        regularNodesPath.addRect(nodeRect);
      }
    }
    canvas.drawPath(regularNodesPath, _nodePaint);
    canvas.drawPath(selectedNodesPath, _selectedNodePaint);
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

  Rect _getBounds(Map<String, FlowNode> nodes) {
    if (nodes.isEmpty) return Rect.zero;
    return nodes.values
        .map((node) => node.rect)
        .reduce((a, b) => a.expandToInclude(b));
  }

  // --- STATIC UTILITY METHODS ---

  static MiniMapTransform calculateTransform(
      Rect contentBounds, Size minimapSize, FlowCanvasMiniMapStyle theme) {
    if (contentBounds.isEmpty || minimapSize.isEmpty) {
      return const MiniMapTransform(
          scale: 0, offsetX: 0, offsetY: 0, contentBounds: Rect.zero);
    }
    final paddedWidth = minimapSize.width - (theme.padding * 2);
    final paddedHeight = minimapSize.height - (theme.padding * 2);

    if (contentBounds.width <= 0 ||
        contentBounds.height <= 0 ||
        paddedWidth <= 0 ||
        paddedHeight <= 0) {
      return MiniMapTransform(
          scale: 0, offsetX: 0, offsetY: 0, contentBounds: contentBounds);
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
        offsetX: offsetX,
        offsetY: offsetY,
        contentBounds: contentBounds);
  }

  static Offset fromMiniMapToCanvas(
      Offset miniMapPosition, MiniMapTransform transform) {
    if (transform.scale == 0) return Offset.zero;
    return Offset(
      (miniMapPosition.dx - transform.offsetX) / transform.scale,
      (miniMapPosition.dy - transform.offsetY) / transform.scale,
    );
  }

  static Rect fromCanvasToMiniMap(Rect canvasRect, MiniMapTransform transform) {
    return Rect.fromLTWH(
      canvasRect.left * transform.scale + transform.offsetX,
      canvasRect.top * transform.scale + transform.offsetY,
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

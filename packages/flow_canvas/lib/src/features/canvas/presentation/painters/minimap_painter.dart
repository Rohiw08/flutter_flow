import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/minimap_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/widgets/flow_minimap.dart';

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

class MiniMapPainter extends CustomPainter {
  final List<FlowNode> nodes;
  final Rect viewport;
  final FlowMinimapStyle theme;
  final MiniMapNodeColorFunc? nodeColor;
  final MiniMapNodeColorFunc? nodeStrokeColor;
  final MiniMapNodeProperty<double>? nodeStrokeWidth;
  final MiniMapNodeProperty<double>? nodeBorderRadius;
  final MiniMapNodeBuilder? nodeBuilder;

  final Paint _backgroundPaint;
  final Paint _nodePaint;
  final Paint _nodeStrokePaint;
  final Paint _viewportStrokePaint;
  final Paint _viewportFillPaint;

  MiniMapPainter({
    required this.nodes,
    required this.viewport,
    required this.theme,
    this.nodeColor,
    this.nodeStrokeColor,
    this.nodeStrokeWidth,
    this.nodeBorderRadius,
    this.nodeBuilder,
  })  : _backgroundPaint = Paint()..color = theme.backgroundColor,
        _nodePaint = Paint()..style = PaintingStyle.fill,
        _nodeStrokePaint = Paint()..style = PaintingStyle.stroke,
        _viewportStrokePaint = Paint()
          ..color = theme.maskStrokeColor
          ..strokeWidth = theme.maskStrokeWidth
          ..style = PaintingStyle.stroke,
        _viewportFillPaint = Paint()
          ..color = theme.maskStrokeColor.withAlpha(30)
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final combinedBounds = getCombinedBounds(nodes, viewport);
    final transform = calculateTransform(combinedBounds, size, theme);

    canvas.save();
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), _backgroundPaint);

    if (transform.scale > 0) {
      _drawNodes(canvas, transform, size);
      _drawViewport(canvas, transform, size);
    }

    canvas.restore();
  }

  void _drawNodes(Canvas canvas, MiniMapTransform transform, Size minimapSize) {
    for (final node in nodes) {
      if (nodeBuilder != null) {
        final customPath = nodeBuilder!(node);
        final matrix = Matrix4.identity()
          ..translate(
              transform.offset.dx, minimapSize.height - transform.offset.dy)
          ..scale(transform.scale, -transform.scale);
        final transformedPath = customPath.transform(matrix.storage);

        _nodePaint.color = nodeColor?.call(node) ?? theme.nodeColor;
        canvas.drawPath(transformedPath, _nodePaint);

        final strokeWidth =
            nodeStrokeWidth?.call(node) ?? theme.nodeStrokeWidth;
        if (strokeWidth > 0) {
          _nodeStrokePaint.color =
              nodeStrokeColor?.call(node) ?? theme.nodeStrokeColor;
          _nodeStrokePaint.strokeWidth = strokeWidth;
          canvas.drawPath(transformedPath, _nodeStrokePaint);
        }
      } else {
        final transformedRect =
            fromCanvasToMiniMap(node.rect, transform, minimapSize);
        const minSize = 2.0;
        final adjustedRect = Rect.fromLTWH(
          transformedRect.left,
          transformedRect.top,
          math.max(transformedRect.width, minSize),
          math.max(transformedRect.height, minSize),
        );
        _nodePaint.color = nodeColor?.call(node) ?? theme.nodeColor;
        final radius = nodeBorderRadius?.call(node) ?? theme.nodeBorderRadius;

        canvas.drawRRect(
          RRect.fromRectAndRadius(adjustedRect, Radius.circular(radius)),
          _nodePaint,
        );

        final strokeWidth =
            nodeStrokeWidth?.call(node) ?? theme.nodeStrokeWidth;
        if (strokeWidth > 0) {
          _nodeStrokePaint.color =
              nodeStrokeColor?.call(node) ?? theme.nodeStrokeColor;
          _nodeStrokePaint.strokeWidth = strokeWidth;
          canvas.drawRRect(
            RRect.fromRectAndRadius(adjustedRect, Radius.circular(radius)),
            _nodeStrokePaint,
          );
        }
      }
    }
  }

  void _drawViewport(
      Canvas canvas, MiniMapTransform transform, Size minimapSize) {
    if (viewport.isEmpty) return;
    final finalRect = fromCanvasToMiniMap(viewport, transform, minimapSize);
    canvas.drawRect(finalRect, _viewportFillPaint);
    if (_viewportStrokePaint.strokeWidth > 0) {
      canvas.drawRect(finalRect, _viewportStrokePaint);
    }
  }

  Rect getCombinedBounds(List<FlowNode> nodes, Rect viewport) {
    if (nodes.isEmpty && viewport.isEmpty) return Rect.zero;
    Rect? combinedBounds;
    if (nodes.isNotEmpty) {
      combinedBounds =
          nodes.map((node) => node.rect).reduce((a, b) => a.expandToInclude(b));
    }
    if (!viewport.isEmpty) {
      combinedBounds = combinedBounds?.expandToInclude(viewport) ?? viewport;
    }
    return combinedBounds?.inflate(
            math.max(combinedBounds.width, combinedBounds.height) * 0.1) ??
        Rect.zero;
  }

  static MiniMapTransform calculateTransform(
      Rect contentBounds, Size minimapSize, FlowMinimapStyle theme) {
    if (contentBounds.isEmpty || minimapSize.isEmpty) {
      return const MiniMapTransform(
          scale: 0, offset: Offset.zero, contentBounds: Rect.zero);
    }
    final padding = theme.padding;
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
      Offset miniMapPosition, MiniMapTransform transform, Size minimapSize) {
    if (transform.scale == 0) return Offset.zero;
    final flippedY = minimapSize.height - miniMapPosition.dy;
    return Offset(
      (miniMapPosition.dx - transform.offset.dx) / transform.scale,
      (flippedY - transform.offset.dy) / transform.scale,
    );
  }

  static Rect fromCanvasToMiniMap(
      Rect canvasRect, MiniMapTransform transform, Size minimapSize) {
    final left = canvasRect.left * transform.scale + transform.offset.dx;
    final top = canvasRect.top * transform.scale + transform.offset.dy;
    final flippedTop =
        minimapSize.height - top - (canvasRect.height * transform.scale);
    return Rect.fromLTWH(left, flippedTop, canvasRect.width * transform.scale,
        canvasRect.height * transform.scale);
  }

  @override
  bool shouldRepaint(covariant MiniMapPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.viewport != viewport ||
        oldDelegate.theme != theme ||
        oldDelegate.nodeColor != nodeColor ||
        oldDelegate.nodeStrokeColor != nodeStrokeColor ||
        oldDelegate.nodeStrokeWidth != nodeStrokeWidth ||
        oldDelegate.nodeBorderRadius != nodeBorderRadius ||
        oldDelegate.nodeBuilder != nodeBuilder;
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/widgets.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/connection.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/connection_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_export.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/edge_path_creator.dart';

/// A lightweight painter for drawing only the active connection line.
class ConnectionPainter extends CustomPainter {
  final FlowConnection? connection;
  final FlowConnectionRuntimeState? connectionState;
  final FlowConnectionStyle style;
  final double canvasHeight;
  final double canvasWidth;

  final Paint _connectionPaint;
  final Paint _markerPaint;

  ConnectionPainter({
    required this.connection,
    required this.connectionState,
    required this.style,
    required this.canvasHeight,
    required this.canvasWidth,
  })  : _connectionPaint = Paint()
          ..strokeWidth = style.activeDecoration.strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _markerPaint = Paint()
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    if (connection == null) return;

    final coordinateConverter = CanvasCoordinateConverter(
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
    );
    _drawConnection(canvas, coordinateConverter);
  }

  void _drawConnection(
      Canvas canvas, CanvasCoordinateConverter coordinateConverter) {
    final conn = connection!;

    // Determine color and stroke style based on validity
    final validity = connectionState?.validity ?? ConnectionValidity.none;
    final strokeStyle = switch (validity) {
      ConnectionValidity.valid =>
        style.validTargetDecoration ?? style.activeDecoration,
      ConnectionValidity.invalid => style.activeDecoration,
      ConnectionValidity.none => style.activeDecoration,
    };

    _connectionPaint
      ..color = strokeStyle.color
      ..strokeWidth = strokeStyle.strokeWidth;

    final renderStartPoint =
        coordinateConverter.toRenderPosition(conn.startPoint);
    final renderEndPoint = coordinateConverter.toRenderPosition(conn.endPoint);

    final path = _buildPath(renderStartPoint, renderEndPoint);

    canvas.drawPath(path, _connectionPaint);

    // Draw markers if they exist
    if (style.startMarkerStyle != null) {
      _drawMarker(canvas, path, strokeStyle.color, style.startMarkerStyle!,
          atStart: true);
    }

    if (style.endMarkerStyle != null) {
      _drawMarker(canvas, path, strokeStyle.color, style.endMarkerStyle!,
          atStart: false);
    }
  }

  Path _buildPath(Offset start, Offset end) {
    if (style.connectionBuilder != null) {
      // Call the custom builder with the correct signature
      style.connectionBuilder!(
        Canvas(PictureRecorder()),
        start,
        end,
        style.activeDecoration,
      );

      // Fallback to default path since connectionBuilder draws directly
      // rather than returning a path
      return EdgePathCreator.createPath(
        style.pathType,
        start,
        end,
      );
    }

    return EdgePathCreator.createPath(
      style.pathType,
      start,
      end,
    );
  }

  void _drawMarker(
    Canvas canvas,
    Path path,
    Color baseColor,
    FlowEdgeMarkerStyle markerStyle, {
    required bool atStart,
  }) {
    // Get path metrics
    final metricsIterator = path.computeMetrics(forceClosed: false).iterator;
    if (!metricsIterator.moveNext()) return;

    final metric = metricsIterator.current;
    final tangent = atStart
        ? metric.getTangentForOffset(0)
        : metric.getTangentForOffset(metric.length);

    if (tangent == null) return;

    // Resolve the marker style (use base decoration for connections)
    final resolvedStyle = markerStyle.decoration;

    // Configure reusable marker paint
    _markerPaint
      ..color = resolvedStyle.color
      ..strokeWidth = resolvedStyle.strokeWidth
      ..style = PaintingStyle.stroke;

    final size = resolvedStyle.size.width;

    // Handle custom builder
    if (markerStyle.builder != null) {
      _markerPaint.style = PaintingStyle.fill;
      markerStyle.builder!(canvas, tangent, resolvedStyle);
      return;
    }

    // Handle built-in marker types
    switch (markerStyle.type) {
      case EdgeMarkerType.arrow:
        _drawDefaultArrow(canvas, tangent, size, _markerPaint,
            reverse: atStart);
        break;

      case EdgeMarkerType.arrowClosed:
        _markerPaint.style = PaintingStyle.fill;
        _drawDefaultArrow(canvas, tangent, size, _markerPaint,
            close: true, reverse: atStart);
        break;

      case EdgeMarkerType.circle:
        _markerPaint.style = PaintingStyle.fill;
        canvas.drawCircle(tangent.position, size / 2, _markerPaint);
        break;

      case EdgeMarkerType.none:
        break;
    }
  }

  void _drawDefaultArrow(
    Canvas canvas,
    Tangent tangent,
    double size,
    Paint paint, {
    bool close = false,
    bool reverse = false,
  }) {
    // Get the direction angle from the tangent vector
    var angle = tangent.vector.direction;

    // Reverse the arrow direction for start markers
    if (reverse) {
      angle += pi;
    }

    final pos = tangent.position;

    // Pre-calculate angle offsets for arrow wings
    const angleOffset = pi / 6;
    final leftAngle = angle - angleOffset;
    final rightAngle = angle + angleOffset;

    // Calculate the two wing points of the arrow
    final p2 = Offset(
      pos.dx - size * cos(leftAngle),
      pos.dy - size * sin(leftAngle),
    );
    final p3 = Offset(
      pos.dx - size * cos(rightAngle),
      pos.dy - size * sin(rightAngle),
    );

    final path = Path();
    if (close) {
      path
        ..moveTo(pos.dx, pos.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..close();
    } else {
      path
        ..moveTo(p2.dx, p2.dy)
        ..lineTo(pos.dx, pos.dy)
        ..lineTo(p3.dx, p3.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) {
    return oldDelegate.connection != connection ||
        oldDelegate.connectionState != connectionState ||
        oldDelegate.style != style;
  }
}

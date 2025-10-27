import 'dart:math';
import 'package:flow_canvas/src/features/canvas/domain/models/connection.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/connection_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/connection_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/edge_path_creator.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/widgets.dart';

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
          // Default setup, will be overridden in paint
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

  void _drawConnection(Canvas canvas, CanvasCoordinateConverter converter) {
    final conn = connection!;

    // Determine validity and stroke style based on runtime state
    final (validity, _) = switch (connectionState) {
      HoveringConnectionState s => (
          s.isValid ? ConnectionValidity.valid : ConnectionValidity.invalid,
          s.targetHandleKey
        ),
      ReleasedConnectionState s => (
          s.isValid ? ConnectionValidity.valid : ConnectionValidity.invalid,
          s.targetHandleKey
        ),
      IdleConnectionState _ => (ConnectionValidity.none, null),
      null => (ConnectionValidity.none, null),
      // Added missing case for FlowConnectionRuntimeState
      FlowConnectionRuntimeState() => (ConnectionValidity.none, null),
    };

    final strokeStyle = switch (validity) {
      ConnectionValidity.valid =>
        style.validTargetDecoration ?? style.activeDecoration,
      // Use activeDecoration for both invalid and none states
      ConnectionValidity.invalid ||
      ConnectionValidity.none =>
        style.activeDecoration,
    };

    // Configure the main paint object
    _connectionPaint
      ..color = strokeStyle.color
      ..strokeWidth = strokeStyle.strokeWidth;

    // Convert connection points to render space
    final renderStart = converter.toRenderPosition(conn.startPoint);
    final renderEnd = converter.toRenderPosition(conn.endPoint);

    // If a custom builder exists, call it and return.
    // The builder is now responsible for drawing the entire connection, including markers.
    if (style.connectionBuilder != null) {
      style.connectionBuilder!(
        canvas, // Pass the actual canvas
        renderStart,
        renderEnd,
        strokeStyle, // Pass the resolved stroke style
      );
      return; // Skip default drawing if builder is used
    }

    // Build the path using EdgePathCreator
    final path = EdgePathCreator.createPath(
      style.pathType, // Use pathType from the main style
      renderStart,
      renderEnd,
    );

    // Draw the connection path
    canvas.drawPath(path, _connectionPaint);

    // Draw markers (only if no custom builder was used)
    if (style.startMarkerStyle case final FlowEdgeMarkerStyle s?) {
      _drawMarker(canvas, path, strokeStyle.color, s, atStart: true);
    }
    if (style.endMarkerStyle case final FlowEdgeMarkerStyle e?) {
      _drawMarker(canvas, path, strokeStyle.color, e, atStart: false);
    }
  }

  // _buildPath method removed as path creation is now inline or handled by builder

  void _drawMarker(
    Canvas canvas,
    Path path,
    Color
        baseColor, // No longer using strokeStyle here, marker has its own color
    FlowEdgeMarkerStyle markerStyle, {
    required bool atStart,
  }) {
    // Get path metrics (only compute if needed)
    // Use list + isEmpty check which is slightly safer than iterator
    final metrics = path.computeMetrics(forceClosed: false).toList();
    if (metrics.isEmpty) return;

    final metric = atStart ? metrics.first : metrics.last;
    final tangent = atStart
        ? metric.getTangentForOffset(0)
        : metric.getTangentForOffset(metric.length);

    if (tangent == null) return;

    // Resolve marker decoration based on its own properties (not edge state)
    // Connection painter uses the base decoration from the marker style directly.
    final resolvedMarkerDecoration = markerStyle.decoration;

    // Configure marker paint based on resolved decoration
    _markerPaint
      ..color = resolvedMarkerDecoration.color
      ..strokeWidth = resolvedMarkerDecoration.strokeWidth
      ..style = markerStyle.type == EdgeMarkerType.arrowClosed ||
              markerStyle.type == EdgeMarkerType.circle
          ? PaintingStyle.fill
          : PaintingStyle.stroke;

    final size = resolvedMarkerDecoration
        .size.width; // Assuming width/height are same for markers

    // If marker has a custom builder, use it
    if (markerStyle.builder != null) {
      // Ensure paint style is fill if builder expects it (common convention)
      // Builder might override this, but setting a default helps.
      _markerPaint.style = PaintingStyle.fill;
      markerStyle.builder!(canvas, tangent, resolvedMarkerDecoration);
      return;
    }

    // Draw built-in marker types
    // Calculate angle correctly for start/end
    var angle = tangent.vector.direction;
    if (atStart) angle += pi; // Reverse direction for start marker

    switch (markerStyle.type) {
      case EdgeMarkerType.arrow:
        _drawDefaultArrow(canvas, tangent.position, angle, size, _markerPaint,
            close: false);
        break;
      case EdgeMarkerType.arrowClosed:
        // Ensure fill style for closed arrow
        _markerPaint.style = PaintingStyle.fill;
        _drawDefaultArrow(canvas, tangent.position, angle, size, _markerPaint,
            close: true);
        break;
      case EdgeMarkerType.circle:
        // Ensure fill style for circle
        _markerPaint.style = PaintingStyle.fill;
        canvas.drawCircle(tangent.position, size / 2, _markerPaint);
        break;
      case EdgeMarkerType.none:
        break;
    }
  }

  // Renamed _drawDefaultArrow, removed tangent, added position/angle args
  // Removed 'reverse' parameter, handled by angle calculation in _drawMarker
  void _drawDefaultArrow(
    Canvas canvas,
    Offset position,
    double angle,
    double size,
    Paint paint, {
    required bool close,
  }) {
    // Arrow head angle (30 degrees)
    const angleOffset = pi / 6;
    final leftAngle = angle - angleOffset;
    final rightAngle = angle + angleOffset;

    // Calculate the points relative to the angle
    final p2 = Offset(
      position.dx - size * cos(leftAngle),
      position.dy - size * sin(leftAngle),
    );
    final p3 = Offset(
      position.dx - size * cos(rightAngle),
      position.dy - size * sin(rightAngle),
    );

    final path = Path();
    if (close) {
      path
        ..moveTo(position.dx, position.dy) // Start at the tip
        ..lineTo(p2.dx, p2.dy) // Line to left wing point
        ..lineTo(p3.dx, p3.dy) // Line to right wing point
        ..close(); // Close back to the tip
    } else {
      path
        ..moveTo(p2.dx, p2.dy) // Start at left wing point
        ..lineTo(position.dx, position.dy) // Line to the tip
        ..lineTo(p3.dx, p3.dy); // Line to the right wing point
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter old) {
    // Comparison remains the same
    return old.connection != connection ||
        old.connectionState != connectionState ||
        old.style != style ||
        old.canvasHeight != canvasHeight ||
        old.canvasWidth != canvasWidth;
  }
}

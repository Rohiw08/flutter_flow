import 'dart:math';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';
import 'package:flutter/widgets.dart';

import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/edge_state.dart';

/// A painter for drawing only the final, persistent edges on the canvas.
class EdgePainter extends CustomPainter {
  final Map<String, FlowNode> nodes;
  final Map<String, FlowEdge> edges;
  final Map<String, EdgeRuntimeState> edgeStates;
  final FlowCanvasTheme style;
  final double canvasHeight;
  final double canvasWidth;
  final Map<String, Path> precomputedPaths;

  // Reusable paint objects for performance
  final Paint _edgePaint;
  final Paint _markerPaint;

  EdgePainter({
    required this.nodes,
    required this.edges,
    required this.style,
    required this.canvasHeight,
    required this.canvasWidth,
    required this.precomputedPaths,
    this.edgeStates = const {},
  })  : _edgePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _markerPaint = Paint()..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    _drawEdges(canvas);
  }

  void _drawEdges(Canvas canvas) {
    // Loop through all the edges that need to be drawn.
    for (final entry in edges.entries) {
      final edgeId = entry.key;
      final edge = entry.value;

      // Get the pre-calculated path from the geometry service.
      // If a path doesn't exist, we can't draw the edge.
      final path = precomputedPaths[edgeId];
      if (path == null) {
        continue;
      }

      // Determine the current state (selected, hovered, etc.) for styling.
      final state = edgeStates[edgeId];
      final isSelected = state?.selected ?? false;
      final isHovered = state?.hovered ?? false;

      // Build a set of states to resolve the correct style.
      final states = <FlowEdgeState>{};
      if (isSelected) states.add(FlowEdgeState.selected);
      if (isHovered) states.add(FlowEdgeState.hovered);

      // Resolve the stroke style from the edge's properties or the canvas theme.
      final edgeStyle = edge.style ?? style.edge;
      final strokeStyle = edgeStyle.resolveDecoration(states);

      // Configure the reusable paint object for the edge's main line.
      _edgePaint
        ..color = strokeStyle.color
        ..strokeWidth = strokeStyle.strokeWidth
        ..strokeCap = strokeStyle.strokeCap
        ..strokeJoin = strokeStyle.strokeJoin;

      // Draw the edge's path.
      canvas.drawPath(path, _edgePaint);

      // Resolve and draw the start marker, if one is defined.
      final startMarkerStyle =
          edge.startMarkerStyle ?? edgeStyle.startMarkerStyle;
      if (startMarkerStyle != null) {
        _drawMarker(canvas, path, strokeStyle, startMarkerStyle, states,
            atStart: true);
      }

      // Resolve and draw the end marker, if one is defined.
      final endMarkerStyle = edge.endMarkerStyle ?? edgeStyle.endMarkerStyle;
      if (endMarkerStyle != null) {
        _drawMarker(canvas, path, strokeStyle, endMarkerStyle, states,
            atStart: false);
      }
    }
  }

  void _drawMarker(
    Canvas canvas,
    Path path,
    FlowEdgeStrokeStyle strokeStyle,
    FlowEdgeMarkerStyle markerStyle,
    Set<FlowEdgeState> states, {
    required bool atStart,
  }) {
    // Get path metrics
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final metric = atStart ? metrics.first : metrics.last;
    final tangent = atStart
        ? metric.getTangentForOffset(0)
        : metric.getTangentForOffset(metric.length);
    if (tangent == null) return;

    // Resolve the marker style based on edge state
    final resolvedMarkerStyle = markerStyle.resolve(states);

    // Configure marker paint
    _markerPaint
      ..color = resolvedMarkerStyle.color
      ..strokeWidth = resolvedMarkerStyle.strokeWidth
      ..style = PaintingStyle.stroke;

    final size = resolvedMarkerStyle.size.width;

    // Handle custom builder
    if (markerStyle.builder != null) {
      _markerPaint.style = PaintingStyle.fill;
      markerStyle.builder!(canvas, tangent, resolvedMarkerStyle);
      return;
    }

    // Calculate arrow angle
    final angle =
        atStart ? tangent.vector.direction + pi : tangent.vector.direction;

    // Draw built-in marker types
    switch (markerStyle.type) {
      case EdgeMarkerType.arrow:
        _drawDefaultArrow(canvas, tangent.position, angle, size, _markerPaint);
        break;

      case EdgeMarkerType.arrowClosed:
        _markerPaint.style = PaintingStyle.fill;
        _drawDefaultArrow(canvas, tangent.position, angle, size, _markerPaint,
            close: true);
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
    Offset pos,
    double angle,
    double size,
    Paint paint, {
    bool close = false,
  }) {
    const angleOffset = pi / 6;
    final leftAngle = angle - angleOffset;
    final rightAngle = angle + angleOffset;

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
  bool shouldRepaint(covariant EdgePainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.edges != edges ||
        oldDelegate.edgeStates != edgeStates ||
        oldDelegate.style != style ||
        oldDelegate.precomputedPaths != precomputedPaths;
  }
}

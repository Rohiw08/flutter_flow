import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/shared/enums.dart';

/// A utility class with static methods to create different types of edge paths.
///
/// Styled to match React Flow's edge aesthetics with proper bezier curves,
/// smooth steps, and clean orthogonal routing.
class EdgePathCreator {
  EdgePathCreator._();

  /// Default curvature for bezier curves (higher = more curved)
  static const double defaultCurvature = 0.5;

  /// Default border radius for smooth step corners
  static const double defaultBorderRadius = 25.0;

  /// Creates a path based on the specified [EdgePathType].
  static Path createPath(
    EdgePathType type,
    Offset start,
    Offset end, {
    double curvature = defaultCurvature,
    double borderRadius = defaultBorderRadius,
  }) {
    switch (type) {
      case EdgePathType.bezier:
        return _getBezierPath(start, end, curvature);
      case EdgePathType.step:
        return _getStepPath(start, end);
      case EdgePathType.straight:
        return _getStraightPath(start, end);
      case EdgePathType.smoothStep:
        return _getSmoothStepPath(start, end, borderRadius);
    }
  }

  static Path _getStraightPath(Offset start, Offset end) {
    return Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);
  }

  /// React Flow style bezier curve with configurable curvature
  /// Smoothly blends between horizontal and vertical control points based on angle
  static Path _getBezierPath(Offset start, Offset end, double curvature) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final absDx = dx.abs();
    final absDy = dy.abs();

    // Calculate blend factor (0 = fully horizontal, 1 = fully vertical)
    // This creates smooth transitions instead of snapping
    final totalDistance = absDx + absDy;
    final verticalWeight = totalDistance > 0 ? absDy / totalDistance : 0.5;

    // Use distance-based offset for more pronounced curves
    final distance = sqrt(dx * dx + dy * dy);
    final baseOffset = distance * curvature;

    // Calculate offsets for both directions
    final horizontalOffset = max(absDx * curvature, baseOffset * 0.5);
    final verticalOffset = max(absDy * curvature, baseOffset * 0.5);

    // Blend between horizontal and vertical control points
    final cp1x = start.dx +
        (dx > 0 ? horizontalOffset : -horizontalOffset) * (1 - verticalWeight);
    final cp1y =
        start.dy + (dy > 0 ? verticalOffset : -verticalOffset) * verticalWeight;

    final cp2x = end.dx -
        (dx > 0 ? horizontalOffset : -horizontalOffset) * (1 - verticalWeight);
    final cp2y =
        end.dy - (dy > 0 ? verticalOffset : -verticalOffset) * verticalWeight;

    path.cubicTo(
      cp1x,
      cp1y,
      cp2x,
      cp2y,
      end.dx,
      end.dy,
    );

    return path;
  }

  /// Clean orthogonal step path matching React Flow's step edge
  static Path _getStepPath(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final midX = start.dx + (end.dx - start.dx) / 2;

    // Horizontal to midpoint
    path.lineTo(midX, start.dy);
    // Vertical to target height
    path.lineTo(midX, end.dy);
    // Horizontal to target
    path.lineTo(end.dx, end.dy);

    return path;
  }

  /// React Flow style smooth step with proper rounded corners
  /// Uses quadratic bezier curves for smooth transitions at corners
  static Path _getSmoothStepPath(
      Offset start, Offset end, double borderRadius) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final midX = start.dx + (end.dx - start.dx) / 2;

    // Clamp border radius to prevent overshooting
    final dx = (end.dx - start.dx).abs();
    final dy = (end.dy - start.dy).abs();
    final maxRadius = min(dx / 4, dy / 2);
    final radius = min(borderRadius, maxRadius);

    // Determine directions
    final horizontalDir = end.dx > start.dx ? 1.0 : -1.0;
    final verticalDir = end.dy > start.dy ? 1.0 : -1.0;

    // First segment: horizontal from start toward midpoint
    final firstCornerX = midX - (horizontalDir * radius);
    path.lineTo(firstCornerX, start.dy);

    // First corner: transition from horizontal to vertical
    path.quadraticBezierTo(
      midX, start.dy, // Control point at corner
      midX, start.dy + (verticalDir * radius), // End point after curve
    );

    // Vertical segment
    final secondCornerY = end.dy - (verticalDir * radius);
    path.lineTo(midX, secondCornerY);

    // Second corner: transition from vertical to horizontal
    path.quadraticBezierTo(
      midX, end.dy, // Control point at corner
      midX + (horizontalDir * radius), end.dy, // End point after curve
    );

    // Final horizontal segment to target
    path.lineTo(end.dx, end.dy);

    return path;
  }

  /// Alternative bezier with handle positions (like React Flow's positional edges)
  /// Useful when you know the direction handles should point
  static Path getBezierPathWithPositions(
    Offset source,
    Offset target, {
    HandlePosition sourcePosition = HandlePosition.right,
    HandlePosition targetPosition = HandlePosition.left,
    double curvature = defaultCurvature,
  }) {
    final path = Path();
    path.moveTo(source.dx, source.dy);

    final controlPoint1 = _getControlPoint(source, sourcePosition, curvature);
    final controlPoint2 = _getControlPoint(target, targetPosition, curvature);

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      target.dx,
      target.dy,
    );

    return path;
  }

  /// Calculate control point offset based on handle position
  static Offset _getControlPoint(
    Offset point,
    HandlePosition position,
    double curvature,
  ) {
    // Distance for control point (similar to React Flow)
    const baseOffset = 50.0;
    final offset = baseOffset * (curvature / defaultCurvature);

    switch (position) {
      case HandlePosition.left:
        return Offset(point.dx - offset, point.dy);
      case HandlePosition.right:
        return Offset(point.dx + offset, point.dy);
      case HandlePosition.top:
        return Offset(point.dx, point.dy - offset);
      case HandlePosition.bottom:
        return Offset(point.dx, point.dy + offset);
    }
  }
}

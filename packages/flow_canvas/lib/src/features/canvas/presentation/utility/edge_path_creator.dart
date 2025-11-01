import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/shared/enums.dart';

/// A utility class with static methods to create different types of edge paths.
///
/// Implements edge path algorithms matching React Flow's aesthetics:
/// - **Bezier**: Smooth cubic curves with intelligent control point placement
/// - **Straight**: Direct line connections
/// - **Step**: Orthogonal routing with sharp corners
/// - **Smooth Step**: Orthogonal routing with rounded corners
///
/// ## Usage
///
/// ```
/// // Create a bezier curve
/// final path = EdgePathCreator.createPath(
///   EdgePathType.bezier,
///   Offset(0, 100),
///   Offset(400, 200),
/// );
///
/// // Create with custom curvature
/// final curvedPath = EdgePathCreator.createPath(
///   EdgePathType.bezier,
///   start,
///   end,
///   curvature: 0.8,
/// );
///
/// // Create with handle positions (like React Flow)
/// final positionalPath = EdgePathCreator.getBezierPathWithPositions(
///   source: Offset(0, 100),
///   target: Offset(400, 200),
///   sourcePosition: HandlePosition.right,
///   targetPosition: HandlePosition.left,
/// );
/// ```
///
/// See also:
///
///  * [EdgePathType], for available edge types
///  * [HandlePosition], for defining connection point directions
@immutable
class EdgePathCreator {
  /// Private constructor to prevent instantiation.
  const EdgePathCreator._();

  /// Default curvature factor for bezier curves.
  ///
  /// Range: 0.0 (no curve) to 1.0 (maximum curve).
  /// React Flow typically uses 0.25-0.5 for most cases.
  static const double defaultCurvature = 0.25;

  /// Default border radius for smooth step corners in logical pixels.
  ///
  /// React Flow uses values between 4-8 pixels typically.
  static const double defaultBorderRadius = 5.0;

  /// Default control point offset for positioned bezier edges.
  ///
  /// This is the minimum distance control points extend from their nodes.
  /// React Flow uses 20-50 pixels depending on the zoom level.
  static const double defaultControlOffset = 20.0;

  /// Creates a path based on the specified [EdgePathType].
  ///
  /// The [type] determines the routing algorithm:
  /// - [EdgePathType.bezier]: Smooth cubic bezier curve
  /// - [EdgePathType.straight]: Direct line
  /// - [EdgePathType.step]: Orthogonal with sharp corners
  /// - [EdgePathType.smoothStep]: Orthogonal with rounded corners
  ///
  /// Optional parameters:
  /// - [curvature]: Controls bezier curve intensity (0.0-1.0)
  /// - [borderRadius]: Controls smooth step corner radius in pixels
  ///
  /// Example:
  /// ```
  /// final path = EdgePathCreator.createPath(
  ///   EdgePathType.smoothStep,
  ///   Offset(0, 100),
  ///   Offset(400, 200),
  ///   borderRadius: 8.0,
  /// );
  /// ```
  static Path createPath(
    EdgePathType type,
    Offset start,
    Offset end, {
    double curvature = defaultCurvature,
    double borderRadius = defaultBorderRadius,
  }) {
    assert(curvature >= 0.0 && curvature <= 1.0,
        'Curvature must be between 0.0 and 1.0');
    assert(borderRadius >= 0.0, 'Border radius must be non-negative');

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

  /// Creates a straight line path.
  ///
  /// This is the simplest edge type, drawing a direct line from start to end.
  static Path _getStraightPath(Offset start, Offset end) {
    return Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);
  }

  /// Creates a bezier curve path matching React Flow's algorithm.
  ///
  /// Uses cubic bezier with control points positioned to create natural-looking
  /// curves. The algorithm:
  /// 1. Calculates distance between points
  /// 2. Places control points along the primary axis
  /// 3. Adjusts based on curvature factor
  ///
  /// This implementation matches React Flow's behavior where control points
  /// are positioned at a distance proportional to the total edge length.
  static Path _getBezierPath(Offset start, Offset end, double curvature) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    // Calculate distance for control point offset
    // React Flow uses a percentage of the total distance
    final distance = sqrt(dx * dx + dy * dy);
    final controlOffset = distance * curvature;

    // Determine primary direction (more horizontal vs more vertical)
    final absDx = dx.abs();
    final absDy = dy.abs();
    final isHorizontal = absDx > absDy;

    late final double cp1x, cp1y, cp2x, cp2y;

    if (isHorizontal) {
      // Horizontal dominant: extend control points horizontally
      final offset = max(controlOffset, absDx * 0.5 * curvature);
      cp1x = start.dx + (dx > 0 ? offset : -offset);
      cp1y = start.dy;
      cp2x = end.dx - (dx > 0 ? offset : -offset);
      cp2y = end.dy;
    } else {
      // Vertical dominant: extend control points vertically
      final offset = max(controlOffset, absDy * 0.5 * curvature);
      cp1x = start.dx;
      cp1y = start.dy + (dy > 0 ? offset : -offset);
      cp2x = end.dx;
      cp2y = end.dy - (dy > 0 ? offset : -offset);
    }

    path.cubicTo(cp1x, cp1y, cp2x, cp2y, end.dx, end.dy);
    return path;
  }

  /// Creates a step path with sharp orthogonal corners.
  ///
  /// Routes the edge with a right-angle turn at the midpoint,
  /// matching React Flow's step edge behavior:
  /// 1. Horizontal from source to midpoint
  /// 2. Vertical to target height
  /// 3. Horizontal to target
  static Path _getStepPath(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final midX = start.dx + (end.dx - start.dx) / 2;

    // Horizontal segment to midpoint
    path.lineTo(midX, start.dy);
    // Vertical segment to target height
    path.lineTo(midX, end.dy);
    // Horizontal segment to target
    path.lineTo(end.dx, end.dy);

    return path;
  }

  /// Creates a smooth step path with rounded corners.
  ///
  /// Similar to step path but uses quadratic bezier curves for smooth corners.
  /// This matches React Flow's smooth step edge with configurable border radius.
  ///
  /// The algorithm:
  /// 1. Routes orthogonally like step edges
  /// 2. Applies rounded corners using quadratic bezier curves
  /// 3. Clamps radius to prevent overshooting
  static Path _getSmoothStepPath(
      Offset start, Offset end, double borderRadius) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final midX = start.dx + (end.dx - start.dx) / 2;
    final dx = (end.dx - start.dx).abs();
    final dy = (end.dy - start.dy).abs();

    // Prevent radius from being larger than available space
    // React Flow clamps to 1/4 of horizontal distance and 1/2 of vertical
    final maxRadius = min(dx / 4, dy / 2);
    final radius = min(borderRadius, maxRadius);

    // Handle edge case where radius would be too large
    if (radius < 0.5) {
      return _getStepPath(start, end);
    }

    final horizontalDir = end.dx > start.dx ? 1.0 : -1.0;
    final verticalDir = end.dy > start.dy ? 1.0 : -1.0;

    // First horizontal segment (approaching first corner)
    final firstCornerX = midX - (horizontalDir * radius);
    path.lineTo(firstCornerX, start.dy);

    // First rounded corner (horizontal to vertical transition)
    path.quadraticBezierTo(
      midX,
      start.dy,
      midX,
      start.dy + (verticalDir * radius),
    );

    // Vertical segment
    final secondCornerY = end.dy - (verticalDir * radius);
    path.lineTo(midX, secondCornerY);

    // Second rounded corner (vertical to horizontal transition)
    path.quadraticBezierTo(
      midX,
      end.dy,
      midX + (horizontalDir * radius),
      end.dy,
    );

    // Final horizontal segment to target
    path.lineTo(end.dx, end.dy);

    return path;
  }

  /// Creates a bezier path with explicit handle positions (React Flow style).
  ///
  /// This matches React Flow's positioned edges where you specify which side
  /// of each node the connection comes from/goes to. The control points are
  /// positioned along the direction of the handle.
  ///
  /// Example:
  /// ```
  /// // Connect from right side of source to left side of target
  /// final path = EdgePathCreator.getBezierPathWithPositions(
  ///   source: Offset(0, 100),
  ///   target: Offset(400, 200),
  ///   sourcePosition: HandlePosition.right,
  ///   targetPosition: HandlePosition.left,
  ///   curvature: 0.25,
  /// );
  /// ```
  ///
  /// See also:
  ///
  ///  * React Flow's getBezierPath() function
  static Path getBezierPathWithPositions({
    required Offset source,
    required Offset target,
    HandlePosition sourcePosition = HandlePosition.right,
    HandlePosition targetPosition = HandlePosition.left,
    double curvature = defaultCurvature,
    double controlOffset = defaultControlOffset,
  }) {
    assert(curvature >= 0.0 && curvature <= 1.0,
        'Curvature must be between 0.0 and 1.0');
    assert(controlOffset >= 0.0, 'Control offset must be non-negative');

    final path = Path();
    path.moveTo(source.dx, source.dy);

    // Calculate distance-based offset
    final dx = target.dx - source.dx;
    final dy = target.dy - source.dy;
    final distance = sqrt(dx * dx + dy * dy);

    // Scale offset based on distance and curvature
    // React Flow typically uses 20-25% of the distance
    final offset = max(controlOffset, distance * curvature);

    final cp1 = _getControlPoint(source, sourcePosition, offset);
    final cp2 = _getControlPoint(target, targetPosition, offset);

    path.cubicTo(
      cp1.dx,
      cp1.dy,
      cp2.dx,
      cp2.dy,
      target.dx,
      target.dy,
    );

    return path;
  }

  /// Calculates control point position based on handle position and offset.
  ///
  /// This matches React Flow's algorithm where control points extend
  /// perpendicular to the node's edge in the direction of the handle.
  static Offset _getControlPoint(
    Offset point,
    HandlePosition position,
    double offset,
  ) {
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

  /// Calculates the center point of an edge path for label placement.
  ///
  /// Returns the approximate center of the path, useful for positioning
  /// edge labels. For bezier curves, this is an approximation.
  ///
  /// Example:
  /// ```
  /// final center = EdgePathCreator.getPathCenter(
  ///   EdgePathType.bezier,
  ///   Offset(0, 100),
  ///   Offset(400, 200),
  /// );
  /// ```
  static Offset getPathCenter(
    EdgePathType type,
    Offset start,
    Offset end,
  ) {
    switch (type) {
      case EdgePathType.straight:
        // Simple midpoint for straight edges
        return Offset(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2,
        );

      case EdgePathType.bezier:
        // For bezier, approximate center using control points
        // React Flow uses t=0.5 on the curve
        return Offset(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2,
        );

      case EdgePathType.step:
      case EdgePathType.smoothStep:
        // Center of the step is at the midpoint
        final midX = start.dx + (end.dx - start.dx) / 2;
        final midY = start.dy + (end.dy - start.dy) / 2;
        return Offset(midX, midY);
    }
  }
}

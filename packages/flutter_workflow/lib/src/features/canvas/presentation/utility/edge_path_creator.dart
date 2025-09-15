import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

/// A utility class with static methods to create different types of edge paths.
///
/// This keeps the path generation logic separate from the painter, making it
/// reusable and easier to test.
class EdgePathCreator {
  EdgePathCreator._();

  /// Creates a path based on the specified [EdgePathType].
  static Path createPath(
    EdgePathType type,
    Offset start,
    Offset end,
  ) {
    switch (type) {
      case EdgePathType.bezier:
        return _getBezierPath(start, end);
      case EdgePathType.step:
        return _getStepPath(start, end);
      case EdgePathType.straight:
        return _getStraightPath(start, end);
      case EdgePathType.smoothStep:
        return _getSmoothStepPath(start, end);
    }
  }

  static Path _getStraightPath(Offset start, Offset end) {
    return Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);
  }

  static Path _getBezierPath(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    double hx1 = start.dx + (end.dx - start.dx).abs() * 0.5;
    double hx2 = end.dx - (end.dx - start.dx).abs() * 0.5;

    path.cubicTo(hx1, start.dy, hx2, end.dy, end.dx, end.dy);
    return path;
  }

  static Path _getStepPath(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    double midX = start.dx + (end.dx - start.dx) / 2;
    path.lineTo(midX, start.dy);
    path.lineTo(midX, end.dy);
    path.lineTo(end.dx, end.dy);

    return path;
  }

  static Path _getSmoothStepPath(Offset start, Offset end) {
    // Smooth step: orthogonal routing with quadratic smoothing at corners
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final midX = start.dx + (end.dx - start.dx) / 2;

    // First corner (horizontal to midX, then vertical toward end.dy) with a curve
    final cornerRadius = 20.0;

    // Horizontal segment to slightly before the corner
    final firstCornerX = midX;
    final firstCornerY = start.dy;

    // Vertical segment will go from firstCorner to (midX, end.dy)
    final secondCornerX = midX;
    final secondCornerY = end.dy;

    // Draw horizontal with smoothing
    final hDir = firstCornerX >= start.dx ? 1.0 : -1.0;
    final vDir = secondCornerY >= firstCornerY ? 1.0 : -1.0;

    final hCutX = firstCornerX - hDir * cornerRadius;
    final vStartY = firstCornerY;

    path.lineTo(hCutX, vStartY);
    // Quadratic curve around the corner
    path.quadraticBezierTo(
      firstCornerX,
      firstCornerY,
      firstCornerX,
      firstCornerY + vDir * cornerRadius,
    );

    // Vertical segment to slightly before the second corner toward end
    final vCutY = secondCornerY - vDir * cornerRadius;
    path.lineTo(secondCornerX, vCutY);

    // Second corner smoothing into the final horizontal to end
    final finalHDir = end.dx >= secondCornerX ? 1.0 : -1.0;
    path.quadraticBezierTo(
      secondCornerX,
      secondCornerY,
      secondCornerX + finalHDir * cornerRadius,
      secondCornerY,
    );

    // Final straight to end
    path.lineTo(end.dx, end.dy);

    return path;
  }
}

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
}

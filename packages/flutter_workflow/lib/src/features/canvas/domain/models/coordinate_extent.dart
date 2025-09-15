import 'package:flutter/foundation.dart';

/// Defines a rectangular area with minimum and maximum coordinates.
/// Used to constrain panning or node dragging.
@immutable
class CoordinateExtent {
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  /// Creates a coordinate extent.
  ///
  /// Defaults represent an unconstrained area.
  const CoordinateExtent({
    this.minX = double.negativeInfinity,
    this.minY = double.negativeInfinity,
    this.maxX = double.infinity,
    this.maxY = double.infinity,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoordinateExtent &&
        other.minX == minX &&
        other.minY == minY &&
        other.maxX == maxX &&
        other.maxY == maxY;
  }

  @override
  int get hashCode => Object.hash(minX, minY, maxX, maxY);
}

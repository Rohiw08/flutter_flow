import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

class CoordinationHelper {
  /// Converts a screen position (e.g., from a mouse click) to a canvas world position.
  static Offset screenToWorld(
    Offset screenPosition,
    TransformationController transformationController,
  ) {
    return transformationController.toScene(screenPosition);
  }

  /// Converts a canvas world position to a screen position for rendering.
  static Offset worldToScreen(
    Offset worldPosition,
    TransformationController transformationController,
  ) {
    final Matrix4 matrix = transformationController.value;
    final Vector3 transformed =
        matrix.transform3(Vector3(worldPosition.dx, worldPosition.dy, 0));
    return Offset(transformed.x, transformed.y);
  }
}

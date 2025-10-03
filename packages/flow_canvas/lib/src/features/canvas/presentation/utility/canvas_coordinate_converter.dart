import "package:flutter/material.dart";

/// A service to handle transformations between the Cartesian coordinate
/// system (like React Flow: +y is up, origin at center) and Flutters render
/// coordinate system (+y is down, origin at top-left).
///
/// **Cartesian Coordinate System:**
/// - Origin (0,0) is at the center of the canvas
/// - Positive X goes right, negative X goes left
/// - Positive Y goes upward, negative Y goes downward
/// - Like traditional mathematical coordinates
class CanvasCoordinateConverter {
  final double canvasWidth;
  final double canvasHeight;

  /// The center of the canvas in Flutters coordinate system.
  late final Offset renderCenter;

  /// The origin point in Cartesian coordinates (always 0,0)
  static const Offset cartesianOrigin = Offset.zero;

  CanvasCoordinateConverter({
    required this.canvasWidth,
    required this.canvasHeight,
  }) {
    renderCenter = Offset(canvasWidth / 2, canvasHeight / 2);
  }

  /// Converts a Cartesian position to a Flutter render position.
  ///
  /// This is the bridge between the logical coordinate system used for defining layouts
  /// (where the origin `(0,0)` is at the center and the **+y axis points up**)
  /// and the absolute pixel coordinates required by Flutter's layout and painting systems
  /// (where the origin `(0,0)` is at the top-left and the **+y axis points down**).
  ///
  /// For example, on a 1000x1000 canvas, the `renderCenter` is `(500, 500)`.
  /// A `cartesianPosition` of `(100, 100)` (100px right and 100px up from the center)
  /// would be converted to a render position of `(600, 400)`.
  Offset toRenderPosition(Offset cartesianPosition) {
    final double renderX = renderCenter.dx + cartesianPosition.dx;
    final double renderY = renderCenter.dy - cartesianPosition.dy;
    return Offset(renderX, renderY);
  }

  /// Converts a Flutter render position back to Cartesian coordinates.
  ///
  /// Example: Screen tap -> Cartesian position relative to center
  Offset toCartesianPosition(Offset renderPosition) {
    final double cartesianX = renderPosition.dx - renderCenter.dx;
    final double cartesianY = -renderPosition.dy + renderCenter.dy;
    return Offset(cartesianX, cartesianY);
  }

  // Offset fromRenderCentreToCartisionPosition(Offset renderPosition) {
  //   final double cartesianX = renderCenter.dx + renderPosition.dx;
  //   final double cartesianY = renderCenter.dy - renderPosition.dy;
  //   return Offset(cartesianX, cartesianY);
  // }

  /// Converts a movement delta from Flutter space to Cartesian space.
  ///
  /// Example: Dragging right and up -> positive X and positive Y delta
  Offset toCartesianDelta(Offset renderDelta) {
    return Offset(renderDelta.dx, -renderDelta.dy);
  }

  /// Converts a Cartesian delta to Flutter render delta.
  Offset toRenderDelta(Offset cartesianDelta) {
    return Offset(cartesianDelta.dx, -cartesianDelta.dy);
  }

  // =================================================================================
  // --- UTILITY METHODS ---
  // =================================================================================

  /// Gets the canvas bounds in Cartesian coordinates.
  /// Returns a Rect where:
  /// - Left: -canvasWidth/2
  /// - Right: +canvasWidth/2
  /// - Top: +canvasHeight/2
  /// - Bottom: -canvasHeight/2
  Rect get cartesianBounds {
    final halfWidth = canvasWidth / 2;
    final halfHeight = canvasHeight / 2;
    return Rect.fromLTRB(-halfWidth, halfHeight, halfWidth, -halfHeight);
  }

  /// Gets the render bounds (Flutter coordinates).
  Rect get renderBounds {
    return Rect.fromLTWH(0, 0, canvasWidth, canvasHeight);
  }

  /// Checks if a Cartesian position is within canvas bounds.
  bool isWithinCartesianBounds(Offset cartesianPosition) {
    return cartesianBounds.contains(cartesianPosition);
  }

  /// Clamps a Cartesian position to stay within canvas bounds.
  Offset clampToCartesianBounds(Offset cartesianPosition) {
    final bounds = cartesianBounds;
    return Offset(
      cartesianPosition.dx.clamp(bounds.left, bounds.right),
      cartesianPosition.dy.clamp(bounds.bottom, bounds.top),
    );
  }

  /// Converts a Cartesian Rect to a Flutter render Rect.
  Rect cartesianRectToRenderRect(Rect cartesianRect) {
    final topLeft =
        toRenderPosition(Offset(cartesianRect.left, cartesianRect.top));
    final bottomRight =
        toRenderPosition(Offset(cartesianRect.right, cartesianRect.bottom));

    return Rect.fromPoints(
      Offset(topLeft.dx, bottomRight.dy), // Flutters top-left
      Offset(bottomRight.dx, topLeft.dy), // Flutters bottom-right
    );
  }

  /// Converts a Flutter render Rect to a Cartesian Rect.
  Rect renderRectToCartesianRect(Rect renderRect) {
    final topLeft = toCartesianPosition(renderRect.topLeft);
    final bottomRight = toCartesianPosition(renderRect.bottomRight);

    return Rect.fromPoints(
      Offset(topLeft.dx, bottomRight.dy), // Cartesian top-left
      Offset(bottomRight.dx, topLeft.dy), // Cartesian bottom-right
    );
  }
}

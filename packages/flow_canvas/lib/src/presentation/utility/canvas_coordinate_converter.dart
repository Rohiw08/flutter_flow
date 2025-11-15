import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A service to handle transformations between Cartesian coordinates
/// (mathematical coordinate system) and Flutter's render coordinates.
///
/// ## Coordinate Systems
///
/// **Cartesian Coordinates** (Logical/Mathematical):
/// - Origin (0,0) at canvas center
/// - Positive X → right, Negative X → left
/// - Positive Y → UP, Negative Y → DOWN (mathematical convention)
/// - Used for defining node positions, edge endpoints, etc.
///
/// **Flutter Render Coordinates** (Screen/Pixel):
/// - Origin (0,0) at top-left corner
/// - Positive X → right, Negative X → left
/// - Positive Y → DOWN, Negative Y → UP (screen convention)
/// - Used for actual rendering and hit testing
///
/// ## Why This Matters
///
/// Flutter's default coordinate system has Y increasing downward, which is
/// counterintuitive for graph/canvas applications. This converter allows you
/// to work with mathematical coordinates (Y up) while Flutter renders correctly.
///
/// ## Example
///
/// ```
/// final converter = CanvasCoordinateConverter(
///   canvasWidth: 1000,
///   canvasHeight: 1000,
/// );
///
/// // Place node at (100, 100) - 100px right and 100px UP from center
/// final renderPos = converter.toRenderPosition(Offset(100, 100));
/// // Result: (600, 400) in Flutter coordinates
///
/// // Convert screen tap to logical position
/// final cartesian = converter.toCartesianPosition(Offset(600, 400));
/// // Result: (100, 100) in Cartesian coordinates
/// ```
///
/// See also:
///
///  * [FlowPositioned], which uses this coordinate system
///  * [EdgePathCreator], for creating paths in this system
@immutable
class CanvasCoordinateConverter with Diagnosticable {
  /// The width of the canvas in logical pixels.
  final double canvasWidth;

  /// The height of the canvas in logical pixels.
  final double canvasHeight;

  /// The center point of the canvas in Flutter's render coordinate system.
  ///
  /// This is calculated as (canvasWidth/2, canvasHeight/2) and represents
  /// where the Cartesian origin (0,0) maps to in render space.
  late final Offset renderCenter;

  /// The Cartesian origin point (always at 0,0).
  ///
  /// This constant represents the center of the coordinate system in
  /// Cartesian space, which maps to [renderCenter] in render space.
  static const Offset cartesianOrigin = Offset.zero;

  /// Creates a coordinate converter for the given canvas dimensions.
  ///
  /// The [canvasWidth] and [canvasHeight] must be positive values.
  ///
  /// Example:
  /// ```
  /// final converter = CanvasCoordinateConverter(
  ///   canvasWidth: 1920,
  ///   canvasHeight: 1080,
  /// );
  /// ```
  CanvasCoordinateConverter({
    required this.canvasWidth,
    required this.canvasHeight,
  })  : assert(canvasWidth > 0, 'Canvas width must be positive'),
        assert(canvasHeight > 0, 'Canvas height must be positive') {
    renderCenter = Offset(canvasWidth / 2, canvasHeight / 2);
  }

  /// Converts a Cartesian position to Flutter render coordinates.
  ///
  /// Transforms from the logical coordinate system (origin at center, Y+ = up)
  /// to Flutter's screen coordinate system (origin at top-left, Y+ = down).
  ///
  /// Formula:
  /// - renderX = centerX + cartesianX
  /// - renderY = centerY - cartesianY (note the negation)
  ///
  /// Example on a 1000x1000 canvas:
  /// ```
  /// // Node at (100, 100) - 100px right and UP from center
  /// final render = converter.toRenderPosition(Offset(100, 100));
  /// // Returns: (600, 400)
  ///
  /// // Node at (-200, -150) - 200px left and DOWN from center
  /// final render2 = converter.toRenderPosition(Offset(-200, -150));
  /// // Returns: (300, 650)
  /// ```
  Offset toRenderPosition(Offset cartesianPosition) {
    return Offset(
      renderCenter.dx + cartesianPosition.dx,
      renderCenter.dy - cartesianPosition.dy, // Flip Y axis
    );
  }

  /// Converts Flutter render coordinates back to Cartesian position.
  ///
  /// Transforms from Flutter's screen coordinates to the logical coordinate
  /// system. Useful for converting user input (taps, drags) to logical positions.
  ///
  /// Formula:
  /// - cartesianX = renderX - centerX
  /// - cartesianY = centerY - renderY (note the flip)
  ///
  /// Example on a 1000x1000 canvas:
  /// ```
  /// // User taps at screen position (600, 400)
  /// final cartesian = converter.toCartesianPosition(Offset(600, 400));
  /// // Returns: (100, 100) - 100px right and UP from center
  ///
  /// // User taps at screen position (300, 650)
  /// final cartesian2 = converter.toCartesianPosition(Offset(300, 650));
  /// // Returns: (-200, -150) - 200px left and DOWN from center
  /// ```
  Offset toCartesianPosition(Offset renderPosition) {
    return Offset(
      renderPosition.dx - renderCenter.dx,
      renderCenter.dy - renderPosition.dy, // Flip Y axis
    );
  }

  /// Converts a movement delta from Flutter render space to Cartesian space.
  ///
  /// Transforms a delta/offset from screen coordinates to logical coordinates.
  /// Only the Y component needs flipping; X is the same in both systems.
  ///
  /// Example:
  /// ```
  /// // User drags right 50px and down 30px on screen
  /// final renderDelta = Offset(50, 30);
  /// final cartesianDelta = converter.toCartesianDelta(renderDelta);
  /// // Returns: (50, -30) - right 50px and DOWN 30px logically
  ///
  /// // User drags left 20px and up 40px on screen
  /// final renderDelta2 = Offset(-20, -40);
  /// final cartesianDelta2 = converter.toCartesianDelta(renderDelta2);
  /// // Returns: (-20, 40) - left 20px and UP 40px logically
  /// ```
  Offset toCartesianDelta(Offset renderDelta) {
    return Offset(
      renderDelta.dx,
      -renderDelta.dy, // Flip Y axis
    );
  }

  /// Converts a Cartesian delta to Flutter render delta.
  ///
  /// Transforms a delta/offset from logical coordinates to screen coordinates.
  /// Only the Y component needs flipping; X is the same in both systems.
  ///
  /// Example:
  /// ```
  /// // Move node right 50px and UP 30px logically
  /// final cartesianDelta = Offset(50, 30);
  /// final renderDelta = converter.toRenderDelta(cartesianDelta);
  /// // Returns: (50, -30) - right 50px and up 30px on screen
  /// ```
  Offset toRenderDelta(Offset cartesianDelta) {
    return Offset(
      cartesianDelta.dx,
      -cartesianDelta.dy, // Flip Y axis
    );
  }

  // ==========================================================================
  // Bounds and Clamping Utilities
  // ==========================================================================

  /// Gets the canvas bounds in Cartesian coordinates.
  ///
  /// Returns a [Rect] representing the visible canvas area where:
  /// - Left: -canvasWidth/2 (leftmost X)
  /// - Right: +canvasWidth/2 (rightmost X)
  /// - Top: +canvasHeight/2 (highest Y, because Y+ is up)
  /// - Bottom: -canvasHeight/2 (lowest Y)
  ///
  /// Example for 1000x1000 canvas:
  /// ```
  /// final bounds = converter.cartesianBounds;
  /// // Returns: Rect.fromLTRB(-500, 500, 500, -500)
  /// ```
  Rect get cartesianBounds {
    final halfWidth = canvasWidth / 2;
    final halfHeight = canvasHeight / 2;
    return Rect.fromLTRB(
      -halfWidth, // Left
      halfHeight, // Top (positive Y)
      halfWidth, // Right
      -halfHeight, // Bottom (negative Y)
    );
  }

  /// Gets the canvas bounds in Flutter render coordinates.
  ///
  /// Returns a standard Flutter [Rect] from (0,0) to (width, height).
  Rect get renderBounds {
    return Rect.fromLTWH(0, 0, canvasWidth, canvasHeight);
  }

  /// Checks if a Cartesian position is within canvas bounds.
  ///
  /// Returns true if the position is visible on the canvas.
  ///
  /// Example:
  /// ```
  /// final isVisible = converter.isWithinCartesianBounds(Offset(100, 100));
  /// // Returns: true if within bounds
  /// ```
  bool isWithinCartesianBounds(Offset cartesianPosition) {
    return cartesianBounds.contains(cartesianPosition);
  }

  /// Clamps a Cartesian position to stay within canvas bounds.
  ///
  /// Useful for preventing nodes from being dragged off-canvas.
  ///
  /// Example:
  /// ```
  /// // Try to place node at (1000, 1000) on 1000x1000 canvas
  /// final clamped = converter.clampToCartesianBounds(Offset(1000, 1000));
  /// // Returns: (500, 500) - clamped to max bounds
  /// ```
  Offset clampToCartesianBounds(Offset cartesianPosition) {
    final bounds = cartesianBounds;
    return Offset(
      cartesianPosition.dx.clamp(bounds.left, bounds.right),
      cartesianPosition.dy
          .clamp(bounds.bottom, bounds.top), // Note: bottom < top
    );
  }

  /// Converts a Cartesian [Rect] to Flutter render [Rect].
  ///
  /// Transforms a rectangle from logical coordinates to screen coordinates,
  /// properly handling the Y-axis flip.
  ///
  /// Example:
  /// ```
  /// // Selection box from (-100, -50) to (100, 50) in Cartesian
  /// final cartesianRect = Rect.fromLTRB(-100, 50, 100, -50);
  /// final renderRect = converter.cartesianRectToRenderRect(cartesianRect);
  /// // Returns rectangle in screen coordinates
  /// ```
  Rect cartesianRectToRenderRect(Rect cartesianRect) {
    final topLeft = toRenderPosition(
      Offset(cartesianRect.left, cartesianRect.top),
    );
    final bottomRight = toRenderPosition(
      Offset(cartesianRect.right, cartesianRect.bottom),
    );

    return Rect.fromPoints(
      Offset(topLeft.dx, bottomRight.dy), // Screen top-left
      Offset(bottomRight.dx, topLeft.dy), // Screen bottom-right
    );
  }

  /// Converts a Flutter render [Rect] to Cartesian [Rect].
  ///
  /// Transforms a rectangle from screen coordinates to logical coordinates,
  /// properly handling the Y-axis flip.
  ///
  /// Example:
  /// ```
  /// // User selection from (400, 450) to (600, 550) on screen
  /// final renderRect = Rect.fromLTRB(400, 450, 600, 550);
  /// final cartesianRect = converter.renderRectToCartesianRect(renderRect);
  /// // Returns rectangle in Cartesian coordinates
  /// ```
  Rect renderRectToCartesianRect(Rect renderRect) {
    final topLeft = toCartesianPosition(renderRect.topLeft);
    final bottomRight = toCartesianPosition(renderRect.bottomRight);

    return Rect.fromPoints(
      Offset(topLeft.dx, bottomRight.dy), // Cartesian top-left
      Offset(bottomRight.dx, topLeft.dy), // Cartesian bottom-right
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('canvasWidth', canvasWidth));
    properties.add(DoubleProperty('canvasHeight', canvasHeight));
    properties.add(DiagnosticsProperty<Offset>('renderCenter', renderCenter));
    properties
        .add(DiagnosticsProperty<Rect>('cartesianBounds', cartesianBounds));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CanvasCoordinateConverter('
        'size: ${canvasWidth}x$canvasHeight, '
        'center: $renderCenter'
        ')';
  }
}

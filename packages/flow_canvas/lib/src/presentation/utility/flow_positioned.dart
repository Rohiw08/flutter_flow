import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Positions a widget using canvas-style coordinates within an infinite canvas.
///
/// This widget provides absolute positioning with a mathematical coordinate
/// system (origin at center, positive Y upward) rather than Flutter's default
/// screen coordinate system (origin at top-left, positive Y downward).
///
/// ## Coordinate System
///
/// Unlike Flutter's standard coordinate system where (0,0) is the top-left
/// corner, [FlowPositioned] uses a canvas coordinate system:
/// - Origin (0, 0) is at the center of the parent
/// - Positive X moves right
/// - Positive Y moves UP (inverted from Flutter's default)
/// - Units are in logical pixels
///
/// ## Performance
///
/// Uses [Transform.translate] which is highly efficient and runs on the GPU
/// compositor thread, making it suitable for positioning large numbers of
/// widgets or for animations.
///
/// ## Usage
///
/// ```
/// FlowPositioned(
///   dx: 100,    // 100 pixels right of center
///   dy: 50,     // 50 pixels above center
///   child: Container(
///     width: 50,
///     height: 50,
///     color: Colors.blue,
///   ),
/// )
/// ```
///
/// ## Comparison with Alternatives
///
/// - **Positioned**: Requires Stack, uses top-left origin, positive Y down
/// - **Align**: Uses fractional positioning (-1.0 to 1.0), not absolute pixels
/// - **FlowPositioned**: Absolute pixels, center origin, positive Y up
///
/// See also:
///
///  * [Transform.translate], which performs the actual positioning
///  * [Align], which centers the coordinate system
///  * [Positioned], Flutter's standard absolute positioning widget
@immutable
class FlowPositioned extends StatelessWidget {
  /// The horizontal offset from the center in logical pixels.
  ///
  /// Positive values move the child to the right.
  /// Negative values move the child to the left.
  final double dx;

  /// The vertical offset from the center in logical pixels.
  ///
  /// Positive values move the child UP (inverted from Flutter's default).
  /// Negative values move the child DOWN.
  ///
  /// Note: This is negated internally to convert from mathematical
  /// coordinates (Y+ = up) to Flutter coordinates (Y+ = down).
  final double dy;

  /// The widget to position.
  final Widget child;

  /// Creates a widget positioned at canvas coordinates (dx, dy).
  ///
  /// The [dx] and [dy] parameters specify the offset from the center
  /// of the parent widget in logical pixels.
  ///
  /// Example:
  /// ```
  /// FlowPositioned(
  ///   dx: 0,     // Centered horizontally
  ///   dy: 100,   // 100 pixels above center
  ///   child: Text('Hello'),
  /// )
  /// ```
  const FlowPositioned({
    super.key,
    required this.dx,
    required this.dy,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Transform.translate(
        // Negate dy to convert from mathematical coordinates (Y+ = up)
        // to Flutter's screen coordinates (Y+ = down)
        offset: Offset(dx, -dy),
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('dx', dx, defaultValue: 0.0));
    properties.add(DoubleProperty('dy', dy, defaultValue: 0.0));
  }
}

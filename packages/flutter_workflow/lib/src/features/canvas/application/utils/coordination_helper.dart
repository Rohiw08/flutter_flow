import 'dart:ui' show Rect, Offset;

/// Utility class for coordinate transformations between logical and canvas coordinates
class CoordinateTransform {
  final double canvasWidth;
  final double canvasHeight;

  CoordinateTransform(this.canvasWidth, this.canvasHeight);

  /// The center point of the canvas in canvas coordinates
  Offset get canvasCenter => Offset(canvasWidth / 2, canvasHeight / 2);

  /// Convert logical coordinates (where 0,0 is center) to canvas coordinates
  Offset logicalToCanvas(Offset logicalPosition) {
    return Offset(
      canvasCenter.dx + logicalPosition.dx,
      canvasCenter.dy - logicalPosition.dy,
    );
  }

  /// Convert canvas coordinates to logical coordinates
  Offset canvasToLogical(Offset canvasPosition) {
    return Offset(
      canvasPosition.dx - canvasCenter.dx,
      canvasCenter.dy - canvasPosition.dy,
    );
  }

  /// Convert a canvas rect to logical coordinates
  Rect canvasToLogicalRect(Rect canvasRect) {
    final topLeft = canvasToLogical(canvasRect.topLeft);
    final bottomRight = canvasToLogical(canvasRect.bottomRight);
    return Rect.fromPoints(topLeft, bottomRight);
  }

  /// Convert a logical rect to canvas coordinates
  Rect logicalToCanvasRect(Rect logicalRect) {
    final topLeft = logicalToCanvas(logicalRect.topLeft);
    final bottomRight = logicalToCanvas(logicalRect.bottomRight);
    return Rect.fromPoints(topLeft, bottomRight);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

class FlowCanvasConnectionTheme {
  final Color activeColor;
  final Color validTargetColor;
  final Color invalidTargetColor;
  final double strokeWidth;
  final double endPointRadius;
  final EdgePathType pathType; // NEW: Added pathType property

  const FlowCanvasConnectionTheme({
    required this.activeColor,
    required this.validTargetColor,
    required this.invalidTargetColor,
    this.strokeWidth = 2.0,
    this.endPointRadius = 6.0,
    this.pathType = EdgePathType.bezier, // NEW: Default to bezier
  });

  factory FlowCanvasConnectionTheme.light() {
    return const FlowCanvasConnectionTheme(
      activeColor: Color(0xFF2196F3),
      validTargetColor: Color(0xFF4CAF50),
      invalidTargetColor: Color(0xFFF44336),
      strokeWidth: 2.0,
      endPointRadius: 6.0,
      pathType: EdgePathType.bezier,
    );
  }

  factory FlowCanvasConnectionTheme.dark() {
    return const FlowCanvasConnectionTheme(
      activeColor: Color(0xFF64B5F6),
      validTargetColor: Color(0xFF81C784),
      invalidTargetColor: Color(0xFFE57373),
      strokeWidth: 2.0,
      endPointRadius: 6.0,
      pathType: EdgePathType.bezier,
    );
  }

  FlowCanvasConnectionTheme copyWith({
    Color? activeColor,
    Color? validTargetColor,
    Color? invalidTargetColor,
    double? strokeWidth,
    double? endPointRadius,
    EdgePathType? pathType, // NEW: Added to copyWith
  }) {
    return FlowCanvasConnectionTheme(
      activeColor: activeColor ?? this.activeColor,
      validTargetColor: validTargetColor ?? this.validTargetColor,
      invalidTargetColor: invalidTargetColor ?? this.invalidTargetColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      endPointRadius: endPointRadius ?? this.endPointRadius,
      pathType: pathType ?? this.pathType, // NEW
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowCanvasConnectionTheme &&
        other.activeColor == activeColor &&
        other.validTargetColor == validTargetColor &&
        other.invalidTargetColor == invalidTargetColor &&
        other.strokeWidth == strokeWidth &&
        other.endPointRadius == endPointRadius &&
        other.pathType == pathType; // NEW
  }

  @override
  int get hashCode => Object.hash(
        activeColor,
        validTargetColor,
        invalidTargetColor,
        strokeWidth,
        endPointRadius,
        pathType, // NEW
      );
}

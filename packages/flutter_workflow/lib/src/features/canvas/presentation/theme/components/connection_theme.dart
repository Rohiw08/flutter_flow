import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

@immutable
class FlowConnectionStyle {
  final Color activeColor;
  final Color validTargetColor;
  final Color invalidTargetColor;
  final double strokeWidth;
  final EdgePathType pathType;

  const FlowConnectionStyle({
    required this.activeColor,
    required this.validTargetColor,
    required this.invalidTargetColor,
    this.strokeWidth = 2.0,
    this.pathType = EdgePathType.bezier, // NEW: Default to bezier
  });

  factory FlowConnectionStyle.light() {
    return const FlowConnectionStyle(
      activeColor: Color(0xFF2196F3),
      validTargetColor: Color(0xFF4CAF50),
      invalidTargetColor: Color(0xFFF44336),
      strokeWidth: 2.0,
      pathType: EdgePathType.bezier,
    );
  }

  factory FlowConnectionStyle.dark() {
    return const FlowConnectionStyle(
      activeColor: Color(0xFF64B5F6),
      validTargetColor: Color(0xFF81C784),
      invalidTargetColor: Color(0xFFE57373),
      strokeWidth: 2.0,
      pathType: EdgePathType.bezier,
    );
  }

  FlowConnectionStyle copyWith({
    Color? activeColor,
    Color? validTargetColor,
    Color? invalidTargetColor,
    double? strokeWidth,
    double? endPointRadius,
    EdgePathType? pathType, // NEW: Added to copyWith
  }) {
    return FlowConnectionStyle(
      activeColor: activeColor ?? this.activeColor,
      validTargetColor: validTargetColor ?? this.validTargetColor,
      invalidTargetColor: invalidTargetColor ?? this.invalidTargetColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      pathType: pathType ?? this.pathType, // NEW
    );
  }

  FlowConnectionStyle lerp(FlowConnectionStyle other, double t) {
    return FlowConnectionStyle(
      activeColor: Color.lerp(activeColor, other.activeColor, t) ?? activeColor,
      validTargetColor:
          Color.lerp(validTargetColor, other.validTargetColor, t) ??
              validTargetColor,
      invalidTargetColor:
          Color.lerp(invalidTargetColor, other.invalidTargetColor, t) ??
              invalidTargetColor,
      strokeWidth: strokeWidth + (other.strokeWidth - strokeWidth) * t,
      pathType: t < 0.5 ? pathType : other.pathType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowConnectionStyle &&
        other.activeColor == activeColor &&
        other.validTargetColor == validTargetColor &&
        other.invalidTargetColor == invalidTargetColor &&
        other.strokeWidth == strokeWidth &&
        other.pathType == pathType; // NEW
  }

  @override
  int get hashCode => Object.hash(
        activeColor,
        validTargetColor,
        invalidTargetColor,
        strokeWidth,
        pathType, // NEW
      );
}

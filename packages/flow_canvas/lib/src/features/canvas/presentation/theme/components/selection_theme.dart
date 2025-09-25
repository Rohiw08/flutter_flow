import 'package:flutter/material.dart';

@immutable
class FlowSelectionStyle {
  final Color? fillColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? dashLength;
  final double? gapLength;

  const FlowSelectionStyle({
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.dashLength = 5.0,
    this.gapLength = 5.0,
  });

  factory FlowSelectionStyle.light() {
    return const FlowSelectionStyle(
      fillColor: Color(0x1A2196F3),
      borderColor: Color(0xFF2196F3),
      borderWidth: 1.0,
      dashLength: 5.0,
      gapLength: 5.0,
    );
  }

  factory FlowSelectionStyle.dark() {
    return const FlowSelectionStyle(
      fillColor: Color(0x1A64B5F6),
      borderColor: Color(0xFF64B5F6),
      borderWidth: 1.0,
      dashLength: 5.0,
      gapLength: 5.0,
    );
  }

  FlowSelectionStyle copyWith({
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    double? dashLength,
    double? gapLength,
  }) {
    return FlowSelectionStyle(
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      dashLength: dashLength ?? this.dashLength,
      gapLength: gapLength ?? this.gapLength,
    );
  }

  FlowSelectionStyle lerp(FlowSelectionStyle other, double t) {
    return FlowSelectionStyle(
      fillColor: Color.lerp(fillColor, other.fillColor, t) ?? fillColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderWidth: (borderWidth == null || other.borderWidth == null)
          ? (t < 0.5 ? borderWidth : other.borderWidth)
          : borderWidth! + (other.borderWidth! - borderWidth!) * t,
      dashLength: (dashLength == null || other.dashLength == null)
          ? (t < 0.5 ? dashLength : other.dashLength)
          : dashLength! + (other.dashLength! - dashLength!) * t,
      gapLength: (gapLength == null || other.gapLength == null)
          ? (t < 0.5 ? gapLength : other.gapLength)
          : gapLength! + (other.gapLength! - gapLength!) * t,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowSelectionStyle &&
        other.fillColor == fillColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.dashLength == dashLength &&
        other.gapLength == gapLength;
  }

  @override
  int get hashCode => Object.hash(
        fillColor,
        borderColor,
        borderWidth,
        dashLength,
        gapLength,
      );
}

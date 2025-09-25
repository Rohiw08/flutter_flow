import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

@immutable
class FlowHandleStyle {
  final Color? idleColor;
  final Color? hoverColor;
  final Color? activeColor;
  final Color? validTargetColor;
  final Color? invalidTargetColor;
  final double? size;
  final double? borderWidth;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
  final bool? enableAnimations;

  const FlowHandleStyle({
    this.idleColor,
    this.hoverColor,
    this.activeColor,
    this.validTargetColor,
    this.invalidTargetColor,
    this.size = 10.0,
    this.borderWidth = 1.5,
    this.borderColor,
    this.shadows = const [],
    this.enableAnimations = true,
  });

  factory FlowHandleStyle.light() {
    return FlowHandleStyle(
      idleColor: const Color(0xFF9CA3AF),
      hoverColor: const Color(0xFF6B7280),
      activeColor: const Color(0xFF3B82F6),
      validTargetColor: const Color(0xFF10B981),
      invalidTargetColor: const Color(0xFFEF4444),
      size: 10.0,
      borderWidth: 1.5,
      borderColor: Colors.white,
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
      enableAnimations: true,
    );
  }

  factory FlowHandleStyle.dark() {
    return FlowHandleStyle(
      idleColor: const Color(0xFF6B7280),
      hoverColor: const Color(0xFF9CA3AF),
      activeColor: const Color(0xFF60A5FA),
      validTargetColor: const Color(0xFF34D399),
      invalidTargetColor: const Color(0xFFF87171),
      size: 10.0,
      borderWidth: 1.5,
      borderColor: const Color(0xFF374151),
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(77),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      enableAnimations: true,
    );
  }

  FlowHandleStyle copyWith({
    Color? idleColor,
    Color? hoverColor,
    Color? activeColor,
    Color? validTargetColor,
    Color? invalidTargetColor,
    double? size,
    double? borderWidth,
    Color? borderColor,
    List<BoxShadow>? shadows,
    bool? enableAnimations,
  }) {
    return FlowHandleStyle(
      idleColor: idleColor ?? this.idleColor,
      hoverColor: hoverColor ?? this.hoverColor,
      activeColor: activeColor ?? this.activeColor,
      validTargetColor: validTargetColor ?? this.validTargetColor,
      invalidTargetColor: invalidTargetColor ?? this.invalidTargetColor,
      size: size ?? this.size,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      shadows: shadows ?? this.shadows,
      enableAnimations: enableAnimations ?? this.enableAnimations,
    );
  }

  FlowHandleStyle lerp(FlowHandleStyle other, double t) {
    return FlowHandleStyle(
      idleColor: Color.lerp(idleColor, other.idleColor, t) ?? idleColor,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t) ?? hoverColor,
      activeColor: Color.lerp(activeColor, other.activeColor, t) ?? activeColor,
      validTargetColor:
          Color.lerp(validTargetColor, other.validTargetColor, t) ??
              validTargetColor,
      invalidTargetColor:
          Color.lerp(invalidTargetColor, other.invalidTargetColor, t) ??
              invalidTargetColor,
      size: (size == null || other.size == null)
          ? (t < 0.5 ? size : other.size)
          : size! + (other.size! - size!) * t,
      borderWidth: (borderWidth == null || other.borderWidth == null)
          ? (t < 0.5 ? borderWidth : other.borderWidth)
          : borderWidth! + (other.borderWidth! - borderWidth!) * t,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      shadows: t < 0.5 ? shadows : other.shadows,
      enableAnimations:
          (enableAnimations == null || other.enableAnimations == null)
              ? (t < 0.5 ? enableAnimations : other.enableAnimations)
              : (t < 0.5 ? enableAnimations! : other.enableAnimations!),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowHandleStyle &&
        other.idleColor == idleColor &&
        other.hoverColor == hoverColor &&
        other.activeColor == activeColor &&
        other.validTargetColor == validTargetColor &&
        other.invalidTargetColor == invalidTargetColor &&
        other.size == size &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        listEquals(other.shadows, shadows) &&
        other.enableAnimations == enableAnimations;
  }

  @override
  int get hashCode => Object.hash(
        idleColor,
        hoverColor,
        activeColor,
        validTargetColor,
        invalidTargetColor,
        size,
        borderWidth,
        borderColor,
        shadows == null ? null : Object.hashAll(shadows!),
        enableAnimations,
      );
}

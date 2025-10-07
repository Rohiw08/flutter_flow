import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

@immutable
class FlowHandleStyle {
  final Color idleColor;
  final Color hoverColor;
  final Color activeColor;
  final Color validTargetColor;
  final Size size;
  final double borderWidth;
  final Color borderColor;
  final List<BoxShadow> shadows;
  final bool enableAnimations;
  final BoxShape shape;

  const FlowHandleStyle({
    this.idleColor = const Color(0xFF9CA3AF),
    this.hoverColor = const Color(0xFF6B7280),
    this.activeColor = const Color(0xFF3B82F6),
    this.validTargetColor = const Color(0xFF10B981),
    this.size = const Size(10, 10),
    this.borderWidth = 1.5,
    this.borderColor = Colors.white,
    this.shadows = const [],
    this.enableAnimations = true,
    this.shape = BoxShape.circle,
  });

  factory FlowHandleStyle.light() {
    return FlowHandleStyle(
      idleColor: const Color(0xFF9CA3AF),
      hoverColor: const Color(0xFF6B7280),
      borderColor: Colors.white,
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
      shape: BoxShape.circle,
    );
  }

  factory FlowHandleStyle.dark() {
    return FlowHandleStyle(
      idleColor: const Color(0xFF6B7280),
      hoverColor: const Color(0xFF9CA3AF),
      activeColor: const Color(0xFF60A5FA),
      validTargetColor: const Color(0xFF34D399),
      borderColor: const Color(0xFF374151),
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(77),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      shape: BoxShape.circle,
    );
  }

  FlowHandleStyle copyWith({
    Color? idleColor,
    Color? hoverColor,
    Color? activeColor,
    Color? validTargetColor,
    Size? size,
    double? borderWidth,
    Color? borderColor,
    List<BoxShadow>? shadows,
    bool? enableAnimations,
    BoxShape? shape,
  }) {
    return FlowHandleStyle(
      idleColor: idleColor ?? this.idleColor,
      hoverColor: hoverColor ?? this.hoverColor,
      activeColor: activeColor ?? this.activeColor,
      validTargetColor: validTargetColor ?? this.validTargetColor,
      size: size ?? this.size,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      shadows: shadows ?? this.shadows,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      shape: shape ?? this.shape,
    );
  }

  FlowHandleStyle merge(FlowHandleStyle? other) {
    if (other == null) return this;
    return copyWith(
      idleColor: other.idleColor,
      hoverColor: other.hoverColor,
      activeColor: other.activeColor,
      validTargetColor: other.validTargetColor,
      size: other.size,
      borderWidth: other.borderWidth,
      borderColor: other.borderColor,
      shadows: other.shadows,
      enableAnimations: other.enableAnimations,
      shape: other.shape,
    );
  }

  FlowHandleStyle lerp(FlowHandleStyle other, double t) {
    return FlowHandleStyle(
      idleColor: Color.lerp(idleColor, other.idleColor, t)!,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t)!,
      activeColor: Color.lerp(activeColor, other.activeColor, t)!,
      validTargetColor:
          Color.lerp(validTargetColor, other.validTargetColor, t)!,
      size: Size.lerp(size, other.size, t)!,
      borderWidth: ui.lerpDouble(borderWidth, other.borderWidth, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      shadows: BoxShadow.lerpList(shadows, other.shadows, t)!,
      enableAnimations: t < 0.5 ? enableAnimations : other.enableAnimations,
      shape: t < 0.5 ? shape : other.shape,
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
        other.size == size &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        listEquals(other.shadows, shadows) &&
        other.enableAnimations == enableAnimations &&
        other.shape == shape;
  }

  @override
  int get hashCode => Object.hash(
        idleColor,
        hoverColor,
        activeColor,
        validTargetColor,
        size,
        borderWidth,
        borderColor,
        Object.hashAll(shadows),
        enableAnimations,
        shape,
      );
}

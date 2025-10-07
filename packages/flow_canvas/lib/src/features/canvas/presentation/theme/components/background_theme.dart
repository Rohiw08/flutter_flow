import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/shared/enums.dart';

@immutable
class FlowBackgroundStyle extends ThemeExtension<FlowBackgroundStyle> {
  final Color backgroundColor;
  final BackgroundVariant variant;
  final Color patternColor;
  final double gap;
  final double lineWidth;
  final double dotRadius;
  final double crossSize;
  final bool fadeOnZoom;
  final Gradient? gradient;
  final Offset patternOffset;
  final BlendMode blendMode;

  const FlowBackgroundStyle({
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.variant = BackgroundVariant.dots,
    this.patternColor = const Color.fromARGB(255, 157, 157, 157),
    this.gap = 25.0,
    this.lineWidth = 1.0,
    this.dotRadius = 0.75,
    this.crossSize = 8.0,
    this.fadeOnZoom = true,
    this.gradient,
    this.patternOffset = Offset.zero,
    this.blendMode = BlendMode.srcOver,
  });

  factory FlowBackgroundStyle.light() {
    return const FlowBackgroundStyle(); // Now uses the default constructor values
  }

  factory FlowBackgroundStyle.dark() {
    return const FlowBackgroundStyle(
      backgroundColor: Color(0xFF404040),
      patternColor: Color(0xFF1A1A1A),
    );
  }

  factory FlowBackgroundStyle.animatedGradient({
    required List<Color> colors,
    BackgroundVariant variant = BackgroundVariant.none,
    double gap = 30.0,
  }) {
    return FlowBackgroundStyle(
        backgroundColor:
            colors.isNotEmpty ? colors.first : const Color(0xFF000000),
        variant: variant,
        patternColor: colors.length > 1
            ? colors[1]
            : (colors.isNotEmpty ? colors.first : const Color(0xFFFFFFFF)),
        gap: gap,
        gradient: LinearGradient(
            colors: colors.isNotEmpty
                ? colors
                : [const Color(0xFF000000), const Color(0xFFFFFFFF)]));
  }

  /// Merges this style with an optional override style.
  FlowBackgroundStyle merge(FlowBackgroundStyle? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      variant: other.variant,
      patternColor: other.patternColor,
      gap: other.gap,
      lineWidth: other.lineWidth,
      dotRadius: other.dotRadius,
      crossSize: other.crossSize,
      fadeOnZoom: other.fadeOnZoom,
      gradient: other.gradient,
      patternOffset: other.patternOffset,
      blendMode: other.blendMode,
    );
  }

  @override
  FlowBackgroundStyle copyWith({
    Color? backgroundColor,
    BackgroundVariant? variant,
    Color? patternColor,
    double? gap,
    double? lineWidth,
    double? dotRadius,
    double? crossSize,
    bool? fadeOnZoom,
    Gradient? gradient,
    Offset? patternOffset,
    BlendMode? blendMode,
    List<Color>? alternateColors,
  }) {
    return FlowBackgroundStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      variant: variant ?? this.variant,
      patternColor: patternColor ?? this.patternColor,
      gap: gap ?? this.gap,
      lineWidth: lineWidth ?? this.lineWidth,
      dotRadius: dotRadius ?? this.dotRadius,
      crossSize: crossSize ?? this.crossSize,
      fadeOnZoom: fadeOnZoom ?? this.fadeOnZoom,
      gradient: gradient ?? this.gradient,
      patternOffset: patternOffset ?? this.patternOffset,
      blendMode: blendMode ?? this.blendMode,
    );
  }

  @override
  FlowBackgroundStyle lerp(
      ThemeExtension<FlowBackgroundStyle>? other, double t) {
    if (other is! FlowBackgroundStyle) return this;
    return FlowBackgroundStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      variant: t < 0.5 ? variant : other.variant,
      patternColor: Color.lerp(patternColor, other.patternColor, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      lineWidth: lerpDouble(lineWidth, other.lineWidth, t)!,
      dotRadius: lerpDouble(dotRadius, other.dotRadius, t)!,
      crossSize: lerpDouble(crossSize, other.crossSize, t)!,
      fadeOnZoom: t < 0.5 ? fadeOnZoom : other.fadeOnZoom,
      gradient: Gradient.lerp(gradient, other.gradient, t),
      patternOffset: Offset.lerp(patternOffset, other.patternOffset, t)!,
      blendMode: t < 0.5 ? blendMode : other.blendMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowBackgroundStyle &&
        other.backgroundColor == backgroundColor &&
        other.variant == variant &&
        other.patternColor == patternColor &&
        other.gap == gap &&
        other.lineWidth == lineWidth &&
        other.dotRadius == dotRadius &&
        other.crossSize == crossSize &&
        other.fadeOnZoom == fadeOnZoom &&
        other.gradient == gradient &&
        other.patternOffset == patternOffset &&
        other.blendMode == blendMode;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        variant,
        patternColor,
        gap,
        lineWidth,
        dotRadius,
        crossSize,
        fadeOnZoom,
        gradient,
        patternOffset,
        blendMode,
      );
}

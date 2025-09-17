import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_extensions.dart';
import 'package:flutter/foundation.dart';

@immutable
class FlowBackgroundStyle extends ThemeExtension<FlowBackgroundStyle> {
  final Color? backgroundColor;
  final BackgroundVariant? variant;
  final Color? patternColor;
  final double? gap;
  final double? lineWidth;
  final double? dotRadius;
  final double? crossSize;
  final bool? fadeOnZoom;
  final Gradient? gradient;
  final Offset? patternOffset;
  final BlendMode? blendMode;
  final List<Color>? alternateColors;

  const FlowBackgroundStyle({
    this.backgroundColor,
    this.variant,
    this.patternColor,
    this.gap,
    this.lineWidth,
    this.dotRadius,
    this.crossSize,
    this.fadeOnZoom,
    this.gradient,
    this.patternOffset,
    this.blendMode,
    this.alternateColors,
  });

  factory FlowBackgroundStyle.light() {
    return const FlowBackgroundStyle(
      backgroundColor: Color(0xFFFAFAFA),
      variant: BackgroundVariant.dots,
      patternColor: Color.fromARGB(75, 0, 0, 0),
      gap: 25.0,
      lineWidth: 1.0,
      dotRadius: 0.75,
      crossSize: 8.0,
      fadeOnZoom: true,
      gradient: null,
      patternOffset: Offset.zero,
      blendMode: BlendMode.srcOver,
      alternateColors: null,
    );
  }

  factory FlowBackgroundStyle.dark() {
    return const FlowBackgroundStyle(
      backgroundColor: Color(0xFF1A1A1A),
      variant: BackgroundVariant.dots,
      patternColor: Color(0xFF404040),
      gap: 25.0,
      lineWidth: 1.0,
      dotRadius: 0.75,
      crossSize: 8.0,
      fadeOnZoom: true,
      gradient: null,
      patternOffset: Offset.zero,
      blendMode: BlendMode.srcOver,
      alternateColors: null,
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
      lineWidth: 1.0,
      dotRadius: 0.75,
      crossSize: 8.0,
      fadeOnZoom: true,
      gradient: LinearGradient(
          colors: colors.isNotEmpty
              ? colors
              : [const Color(0xFF000000), const Color(0xFFFFFFFF)]),
      patternOffset: Offset.zero,
      blendMode: BlendMode.srcOver,
      alternateColors: colors.length > 2 ? colors.sublist(2) : null,
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
      alternateColors: alternateColors ?? this.alternateColors,
    );
  }

  @override
  FlowBackgroundStyle lerp(
      ThemeExtension<FlowBackgroundStyle>? other, double t) {
    if (other is! FlowBackgroundStyle) return this;
    return FlowBackgroundStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      variant: t < 0.5 ? variant : other.variant, // Discrete switch
      patternColor: Color.lerp(patternColor, other.patternColor, t),
      gap: lerpDouble(gap, other.gap, t),
      lineWidth: lerpDouble(lineWidth, other.lineWidth, t),
      dotRadius: lerpDouble(dotRadius, other.dotRadius, t),
      crossSize: lerpDouble(crossSize, other.crossSize, t),
      fadeOnZoom: t < 0.5 ? fadeOnZoom : other.fadeOnZoom,
      gradient: Gradient.lerp(gradient, other.gradient, t),
      patternOffset:
          Offset.lerp(patternOffset, other.patternOffset, t) ?? Offset.zero,
      blendMode: t < 0.5 ? blendMode : other.blendMode,
      alternateColors:
          t < 0.5 ? alternateColors : other.alternateColors, // Simplified
    );
  }

  FlowBackgroundStyle resolveBackgroundTheme(
    BuildContext context,
    FlowBackgroundStyle? backgroundTheme, {
    // Local property overrides
    Color? backgroundColor,
    BackgroundVariant? pattern,
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
    // Start with the theme object if provided, otherwise fall back to the context theme.
    final base = backgroundTheme ?? context.flowCanvasTheme.background;

    // Apply all local overrides on top of the base theme.
    return base.copyWith(
      backgroundColor: backgroundColor,
      variant: pattern,
      patternColor: patternColor,
      gap: gap,
      lineWidth: lineWidth,
      dotRadius: dotRadius,
      crossSize: crossSize,
      fadeOnZoom: fadeOnZoom,
      gradient: gradient,
      patternOffset: patternOffset,
      blendMode: blendMode,
      alternateColors: alternateColors,
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
        other.blendMode == blendMode &&
        listEquals(other.alternateColors, alternateColors);
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
        alternateColors == null ? null : Object.hashAll(alternateColors!),
      );
}

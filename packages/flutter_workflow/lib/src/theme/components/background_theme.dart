import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

class FlowCanvasBackgroundTheme
    extends ThemeExtension<FlowCanvasBackgroundTheme> {
  final Color backgroundColor;
  final BackgroundVariant variant;
  final Color patternColor;
  final double gap;
  final double lineWidth;
  final double? dotRadius;
  final double? crossSize;
  final bool fadeOnZoom;
  final Gradient? gradient;
  final Offset patternOffset;
  final BlendMode? blendMode;
  final List<Color>? alternateColors;

  const FlowCanvasBackgroundTheme({
    required this.backgroundColor,
    required this.variant,
    required this.patternColor,
    this.gap = 30.0,
    this.lineWidth = 1.0,
    this.dotRadius,
    this.crossSize,
    this.fadeOnZoom = true,
    this.gradient,
    this.patternOffset = Offset.zero,
    this.blendMode,
    this.alternateColors,
  });

  factory FlowCanvasBackgroundTheme.light() {
    return const FlowCanvasBackgroundTheme(
      backgroundColor: Color(0xFFFAFAFA),
      variant: BackgroundVariant.dots,
      patternColor: Color.fromARGB(75, 0, 0, 0),
      dotRadius: 0.75,
      gap: 25.0,
      fadeOnZoom: true,
    );
  }

  factory FlowCanvasBackgroundTheme.dark() {
    return const FlowCanvasBackgroundTheme(
      backgroundColor: Color(0xFF1A1A1A),
      variant: BackgroundVariant.dots,
      patternColor: Color(0xFF404040),
      dotRadius: 0.75,
      gap: 25.0,
      fadeOnZoom: true,
    );
  }

  factory FlowCanvasBackgroundTheme.animatedGradient({
    required List<Color> colors,
    BackgroundVariant variant = BackgroundVariant.none,
    double gap = 30.0,
  }) {
    return FlowCanvasBackgroundTheme(
      backgroundColor: colors.first,
      variant: variant,
      patternColor: colors.length > 1 ? colors[1] : colors.first,
      gap: gap,
      gradient: LinearGradient(colors: colors),
      alternateColors: colors.length > 2 ? colors.sublist(2) : null,
    );
  }

  @override
  FlowCanvasBackgroundTheme copyWith({
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
    return FlowCanvasBackgroundTheme(
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
  FlowCanvasBackgroundTheme lerp(
      ThemeExtension<FlowCanvasBackgroundTheme>? other, double t) {
    if (other is! FlowCanvasBackgroundTheme) return this;
    return FlowCanvasBackgroundTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      variant: t < 0.5 ? variant : other.variant, // Discrete switch
      patternColor: Color.lerp(patternColor, other.patternColor, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
      lineWidth: lerpDouble(lineWidth, other.lineWidth, t)!,
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
}

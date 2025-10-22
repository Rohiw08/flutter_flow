import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/shared/enums.dart';

/// Defines the visual styling of the flow canvas background,
/// including color, pattern type, gradients, and grid spacing.
///
/// This theme extension allows customizing the background of the
/// flow editor area while maintaining support for light, dark,
/// and dynamic system-based themes.
@immutable
class FlowBackgroundStyle extends ThemeExtension<FlowBackgroundStyle> {
  /// The base background color of the canvas.
  final Color backgroundColor;

  /// The type of pattern to render (e.g., dots, grid, crosses).
  final BackgroundVariant variant;

  /// The color of the pattern (grid lines, dots, etc.).
  final Color patternColor;

  /// The distance between pattern elements.
  final double gap;

  /// The width of lines for grid or cross variants.
  final double lineWidth;

  /// The radius of dots for the dot variant.
  final double dotRadius;

  /// The size of cross elements for the cross variant.
  final double crossSize;

  /// Whether the background pattern should fade when zooming.
  final bool fadeOnZoom;

  /// The gradient overlay applied to the background, if any.
  final Gradient? gradient;

  /// The offset to shift the pattern drawing position.
  final Offset patternOffset;

  /// The blend mode used when painting the pattern.
  final BlendMode blendMode;

  const FlowBackgroundStyle({
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.variant = BackgroundVariant.dots,
    this.patternColor = const Color(0xFF9D9D9D),
    this.gap = 25.0,
    this.lineWidth = 1.0,
    this.dotRadius = 0.75,
    this.crossSize = 8.0,
    this.fadeOnZoom = true,
    this.gradient,
    this.patternOffset = Offset.zero,
    this.blendMode = BlendMode.srcOver,
  });

  /// Creates a light mode background style.
  factory FlowBackgroundStyle.light() => const FlowBackgroundStyle();

  /// Creates a dark mode background style.
  factory FlowBackgroundStyle.dark() => const FlowBackgroundStyle(
        backgroundColor: Color(0xFF404040),
        patternColor: Color(0xFF1A1A1A),
      );

  /// Creates a background style that adapts to the system theme.
  factory FlowBackgroundStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowBackgroundStyle.dark()
        : FlowBackgroundStyle.light();
  }

  /// Creates a background style from a Flutter [ColorScheme].
  factory FlowBackgroundStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowBackgroundStyle(
      backgroundColor: colorScheme.surface,
      patternColor: colorScheme.onSurface.withAlpha(75),
    );
  }

  /// Creates a background style derived from a seed color.
  ///
  /// Uses [ColorScheme.fromSeed] to generate a harmonious color palette.
  factory FlowBackgroundStyle.fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
    BackgroundVariant variant = BackgroundVariant.dots,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return FlowBackgroundStyle.fromColorScheme(colorScheme).copyWith(
      variant: variant,
    );
  }

  /// Creates a gradient-based background style.
  factory FlowBackgroundStyle.gradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
    BackgroundVariant variant = BackgroundVariant.none,
  }) {
    return FlowBackgroundStyle(
      backgroundColor: colors.isNotEmpty ? colors.first : Colors.black,
      variant: variant,
      patternColor:
          colors.length > 1 ? colors[1] : (colors.firstOrNull ?? Colors.white),
      gradient: LinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  /// Merges this style with another [FlowBackgroundStyle].
  ///
  /// The properties from [other] take precedence when not null.
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
    return identical(this, other) ||
        (other is FlowBackgroundStyle &&
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
            other.blendMode == blendMode);
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

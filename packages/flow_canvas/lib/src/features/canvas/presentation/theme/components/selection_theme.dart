import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Defines the visual styling for selection boxes in the flow canvas.
///
/// Selection boxes are drawn when users drag to select multiple nodes.
/// This style controls the fill color, border appearance, and dash pattern.
///
/// Example usage:
/// ```dart
/// FlowSelectionStyle(
///   fillColor: Colors.blue.withOpacity(0.1),
///   borderColor: Colors.blue,
///   borderWidth: 2.0,
///   borderRadius: BorderRadius.circular(8.0),
///   dashLength: 8.0,
///   gapLength: 4.0,
/// )
/// ```
@immutable
class FlowSelectionStyle extends ThemeExtension<FlowSelectionStyle> {
  /// Fill color for the selection box interior.
  final Color? fillColor;

  /// Border color for the selection box outline.
  final Color? borderColor;

  /// Width of the selection box border.
  final double borderWidth;

  /// Border radius for rounded corners on the selection box.
  final BorderRadius borderRadius;

  /// Length of each dash in the border (if dashed).
  /// Set to 0 for a solid border.
  final double dashLength;

  /// Length of gaps between dashes in the border.
  /// Ignored if [dashLength] is 0.
  final double gapLength;

  const FlowSelectionStyle({
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = BorderRadius.zero,
    this.dashLength = 5.0,
    this.gapLength = 5.0,
  });

  /// Creates a light theme selection style.
  factory FlowSelectionStyle.light() {
    return const FlowSelectionStyle(
      fillColor: Color(0x1A2196F3),
      borderColor: Color(0xFF2196F3),
      borderWidth: 1.0,
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      dashLength: 5.0,
      gapLength: 5.0,
    );
  }

  /// Creates a dark theme selection style.
  factory FlowSelectionStyle.dark() {
    return const FlowSelectionStyle(
      fillColor: Color(0x1A64B5F6),
      borderColor: Color(0xFF64B5F6),
      borderWidth: 1.0,
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      dashLength: 5.0,
      gapLength: 5.0,
    );
  }

  /// Creates a selection style that adapts to the system brightness.
  factory FlowSelectionStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowSelectionStyle.dark()
        : FlowSelectionStyle.light();
  }

  /// Creates a selection style from a Material 3 color scheme.
  factory FlowSelectionStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowSelectionStyle(
      fillColor: colorScheme.primary.withAlpha(38),
      borderColor: colorScheme.primary,
      borderWidth: 1.0,
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      dashLength: 5.0,
      gapLength: 5.0,
    );
  }

  /// Creates a selection style from a seed color using Material 3 guidelines.
  factory FlowSelectionStyle.fromSeed(
    Color seedColor, {
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return FlowSelectionStyle.fromColorScheme(colorScheme);
  }

  /// Merges this style with another, preferring the other's non-null values.
  ///
  /// Null values in [other] will fall back to this style's values.
  FlowSelectionStyle merge(FlowSelectionStyle? other) {
    if (other == null) return this;
    return copyWith(
      fillColor: other.fillColor,
      borderColor: other.borderColor,
      borderWidth: other.borderWidth,
      borderRadius: other.borderRadius,
      dashLength: other.dashLength,
      gapLength: other.gapLength,
    );
  }

  @override
  FlowSelectionStyle copyWith({
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    double? dashLength,
    double? gapLength,
  }) {
    return FlowSelectionStyle(
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      dashLength: dashLength ?? this.dashLength,
      gapLength: gapLength ?? this.gapLength,
    );
  }

  @override
  FlowSelectionStyle lerp(
      covariant ThemeExtension<FlowSelectionStyle>? other, double t) {
    if (other is! FlowSelectionStyle) return this;
    return FlowSelectionStyle(
      fillColor: Color.lerp(fillColor, other.fillColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t) ?? borderWidth,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t) ??
          borderRadius,
      dashLength: lerpDouble(dashLength, other.dashLength, t) ?? dashLength,
      gapLength: lerpDouble(gapLength, other.gapLength, t) ?? gapLength,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowSelectionStyle &&
        other.fillColor == fillColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.dashLength == dashLength &&
        other.gapLength == gapLength;
  }

  @override
  int get hashCode => Object.hash(
        fillColor,
        borderColor,
        borderWidth,
        borderRadius,
        dashLength,
        gapLength,
      );
}

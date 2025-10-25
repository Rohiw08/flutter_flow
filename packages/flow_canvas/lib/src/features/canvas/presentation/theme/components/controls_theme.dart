import 'package:flutter/material.dart';

@immutable
class FlowControlsStyle extends ThemeExtension<FlowControlsStyle> {
  final Decoration decoration;

  const FlowControlsStyle({
    required this.decoration,
  });

  /// Creates a style from simple property values.
  factory FlowControlsStyle.colored({
    required Color color,
    Color? borderColor,
    double borderWidth = 1.0,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
    List<BoxShadow>? shadows,
  }) {
    return FlowControlsStyle(
      decoration: BoxDecoration(
        color: color,
        border: borderColor != null
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
    );
  }

  /// Creates a light theme style.
  factory FlowControlsStyle.light() {
    return FlowControlsStyle.colored(
      color: Colors.white,
      borderColor: Colors.grey.shade300,
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(12),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Creates a dark theme style.
  factory FlowControlsStyle.dark() {
    return FlowControlsStyle.colored(
      color: const Color(0xFF2D2D2D),
      borderColor: const Color(0xFF404040),
    );
  }

  /// Creates a style that adapts to the system brightness.
  factory FlowControlsStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowControlsStyle.dark()
        : FlowControlsStyle.light();
  }

  /// Creates a style from a Material 3 color scheme.
  factory FlowControlsStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowControlsStyle.colored(
      color: colorScheme.surfaceContainer,
      borderColor: colorScheme.outlineVariant,
    );
  }

  /// Creates a style from a seed color using Material 3 guidelines.
  factory FlowControlsStyle.fromSeed(
    Color seedColor, {
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return FlowControlsStyle.fromColorScheme(colorScheme);
  }

  /// Merges this style with another, preferring the other's values.
  FlowControlsStyle merge(FlowControlsStyle? other) {
    if (other == null) return this;
    return FlowControlsStyle(
      decoration: other.decoration,
    );
  }

  @override
  FlowControlsStyle copyWith({
    Decoration? decoration,
  }) {
    return FlowControlsStyle(
      decoration: decoration ?? this.decoration,
    );
  }

  @override
  FlowControlsStyle lerp(
      covariant ThemeExtension<FlowControlsStyle>? other, double t) {
    if (other is! FlowControlsStyle) return this;
    return FlowControlsStyle(
      decoration:
          Decoration.lerp(decoration, other.decoration, t) ?? decoration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowControlsStyle && other.decoration == decoration;
  }

  @override
  int get hashCode => decoration.hashCode;
}

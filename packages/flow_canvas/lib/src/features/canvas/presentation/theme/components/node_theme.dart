import 'package:flutter/material.dart';

/// Represents the possible states of a flow node.
enum FlowNodeState { normal, selected, hovered, disabled }

/// Defines the visual styling for flow canvas nodes.
///
/// This style uses [Decoration] to provide maximum flexibility while offering
/// convenient factory constructors for common cases.
///
/// Example usage:
/// ```dart
/// // Simple colored node
/// FlowNodeStyle.colored(
///   color: Colors.white,
///   borderColor: Colors.grey,
///   selectedBorderColor: Colors.blue,
/// )
///
/// // Custom gradient node
/// FlowNodeStyle(
///   decoration: BoxDecoration(
///     gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
///     borderRadius: BorderRadius.circular(12),
///   ),
/// )
/// ```
@immutable
class FlowNodeStyle extends ThemeExtension<FlowNodeStyle> {
  /// Decoration for the node in its normal state.
  final Decoration decoration;

  /// Decoration for the node when selected.
  final Decoration? selectedDecoration;

  /// Decoration for the node when hovered.
  final Decoration? hoverDecoration;

  /// Decoration for the node when disabled.
  final Decoration? disabledDecoration;

  const FlowNodeStyle({
    required this.decoration,
    this.selectedDecoration,
    this.hoverDecoration,
    this.disabledDecoration,
  });

  /// Resolves the appropriate decoration based on node state.
  ///
  /// State priority (highest to lowest):
  /// 1. Error
  /// 2. Disabled
  /// 3. Selected
  /// 4. Hovered
  /// 5. Normal
  Decoration resolveDecoration(Set<FlowNodeState> states) {
    if (states.contains(FlowNodeState.disabled)) {
      return disabledDecoration ??
          (decoration as BoxDecoration).copyWith(
              color: (decoration as BoxDecoration).color?.withAlpha(125));
    }
    if (states.contains(FlowNodeState.selected)) {
      return selectedDecoration ?? hoverDecoration ?? decoration;
    }
    if (states.contains(FlowNodeState.hovered)) {
      return hoverDecoration ?? decoration;
    }
    return decoration;
  }

  /// Creates a node style from simple property values.
  ///
  /// This is a convenience factory for the most common use case where you
  /// just want to specify colors and borders for different states.
  factory FlowNodeStyle.colored({
    required Color color,
    Color? selectedColor,
    Color? hoverColor,
    Color? disabledColor,
    Color? borderColor,
    Color? selectedBorderColor,
    Color? hoverBorderColor,
    Color? disabledBorderColor,
    double borderWidth = 1.0,
    double selectedBorderWidth = 2.0,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
    List<BoxShadow>? shadows,
  }) {
    BoxDecoration createDecoration({
      required Color bgColor,
      Color? bColor,
      double bWidth = 1.0,
    }) {
      return BoxDecoration(
        color: bgColor,
        border:
            bColor != null ? Border.all(color: bColor, width: bWidth) : null,
        borderRadius: borderRadius,
        boxShadow: shadows,
      );
    }

    return FlowNodeStyle(
      decoration: createDecoration(
        bgColor: color,
        bColor: borderColor,
        bWidth: borderWidth,
      ),
      selectedDecoration: selectedColor != null || selectedBorderColor != null
          ? createDecoration(
              bgColor: selectedColor ?? color,
              bColor: selectedBorderColor,
              bWidth: selectedBorderWidth,
            )
          : null,
      hoverDecoration: hoverColor != null || hoverBorderColor != null
          ? createDecoration(
              bgColor: hoverColor ?? color,
              bColor: hoverBorderColor,
              bWidth: borderWidth,
            )
          : null,
      disabledDecoration: disabledColor != null || disabledBorderColor != null
          ? createDecoration(
              bgColor: disabledColor ?? color,
              bColor: disabledBorderColor,
              bWidth: borderWidth,
            )
          : null,
    );
  }

  /// Creates a light theme node style.
  factory FlowNodeStyle.light() {
    return FlowNodeStyle.colored(
      color: Colors.white,
      borderColor: Colors.grey.shade300,
      selectedBorderColor: Colors.blue.shade600,
      hoverColor: Colors.grey.shade50,
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(12),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Creates a dark theme node style.
  factory FlowNodeStyle.dark() {
    return FlowNodeStyle.colored(
      color: const Color(0xFF2D2D2D),
      borderColor: const Color(0xFF404040),
      selectedBorderColor: Colors.blue.shade400,
      hoverColor: const Color(0xFF3A3A3A),
    );
  }

  /// Creates a node style that adapts to the system brightness.
  factory FlowNodeStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowNodeStyle.dark()
        : FlowNodeStyle.light();
  }

  /// Creates a node style from a Material 3 color scheme.
  factory FlowNodeStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowNodeStyle.colored(
      color: colorScheme.surfaceContainer,
      borderColor: colorScheme.outlineVariant,
      selectedBorderColor: colorScheme.primary,
      hoverColor: colorScheme.surfaceContainerHigh,
      disabledColor: colorScheme.surfaceContainerLow,
      disabledBorderColor: colorScheme.outlineVariant.withAlpha(125),
    );
  }

  /// Creates a node style from a seed color using Material 3 guidelines.
  factory FlowNodeStyle.fromSeed(
    Color seedColor, {
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return FlowNodeStyle.fromColorScheme(colorScheme);
  }

  /// Merges this style with another, preferring the other's values.
  ///
  /// Null values in [other] will fall back to this style's values.
  FlowNodeStyle merge(FlowNodeStyle? other) {
    if (other == null) return this;
    return FlowNodeStyle(
      decoration: other.decoration,
      selectedDecoration: other.selectedDecoration ?? selectedDecoration,
      hoverDecoration: other.hoverDecoration ?? hoverDecoration,
      disabledDecoration: other.disabledDecoration ?? disabledDecoration,
    );
  }

  @override
  FlowNodeStyle copyWith({
    Decoration? decoration,
    Decoration? selectedDecoration,
    Decoration? hoverDecoration,
    Decoration? disabledDecoration,
    Decoration? errorDecoration,
  }) {
    return FlowNodeStyle(
      decoration: decoration ?? this.decoration,
      selectedDecoration: selectedDecoration ?? this.selectedDecoration,
      hoverDecoration: hoverDecoration ?? this.hoverDecoration,
      disabledDecoration: disabledDecoration ?? this.disabledDecoration,
    );
  }

  @override
  FlowNodeStyle lerp(covariant ThemeExtension<FlowNodeStyle>? other, double t) {
    if (other is! FlowNodeStyle) return this;
    return FlowNodeStyle(
      decoration:
          Decoration.lerp(decoration, other.decoration, t) ?? decoration,
      selectedDecoration:
          Decoration.lerp(selectedDecoration, other.selectedDecoration, t),
      hoverDecoration:
          Decoration.lerp(hoverDecoration, other.hoverDecoration, t),
      disabledDecoration:
          Decoration.lerp(disabledDecoration, other.disabledDecoration, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowNodeStyle &&
        other.decoration == decoration &&
        other.selectedDecoration == selectedDecoration &&
        other.hoverDecoration == hoverDecoration &&
        other.disabledDecoration == disabledDecoration;
  }

  @override
  int get hashCode => Object.hash(
        decoration,
        selectedDecoration,
        hoverDecoration,
        disabledDecoration,
      );
}

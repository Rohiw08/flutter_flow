import 'package:flutter/material.dart';

/// Represents the possible states of a flow canvas button.
enum FlowControlState { normal, hovered, selected, disabled }

/// Defines the visual styling for flow canvas buttons.
///
/// This style uses [Decoration] and [IconThemeData] to provide maximum
/// flexibility while offering convenient factory constructors for common cases.
@immutable
class FlowControlsButtonStyle extends ThemeExtension<FlowControlsButtonStyle> {
  /// Decoration for a button in its normal state.
  final Decoration decoration;

  /// Decoration for a button when hovered.
  final Decoration? hoverDecoration;

  /// Decoration for a button when selected.
  final Decoration? selectedDecoration;

  /// Decoration for a button when disabled.
  final Decoration? disabledDecoration;

  /// Icon theme for the normal state.
  final IconThemeData iconTheme;

  /// Icon theme for the hovered state.
  final IconThemeData? hoverIconTheme;

  /// Icon theme for the selected state.
  final IconThemeData? selectedIconTheme;

  /// Icon theme for the disabled state.
  final IconThemeData? disabledIconTheme;

  const FlowControlsButtonStyle({
    required this.decoration,
    required this.iconTheme,
    this.hoverDecoration,
    this.selectedDecoration,
    this.disabledDecoration,
    this.hoverIconTheme,
    this.selectedIconTheme,
    this.disabledIconTheme,
  });

  /// Creates a button style from simple color values.
  factory FlowControlsButtonStyle.colored({
    Color? buttonColor,
    Color? hoverColor,
    Color? selectedColor,
    Color? disabledColor,
    Color? iconColor,
    Color? hoverIconColor,
    Color? selectedIconColor,
    Color? disabledIconColor,
    List<BoxShadow>? shadows,
    Border? border,
  }) {
    BoxDecoration? createDecoration(Color? color) {
      if (color == null && shadows == null && border == null) return null;
      return BoxDecoration(
        color: color,
        boxShadow: shadows,
        border: border,
      );
    }

    return FlowControlsButtonStyle(
      decoration: createDecoration(buttonColor)!,
      hoverDecoration: createDecoration(hoverColor),
      selectedDecoration: createDecoration(selectedColor),
      disabledDecoration: createDecoration(disabledColor),
      iconTheme: IconThemeData(color: iconColor),
      hoverIconTheme:
          hoverIconColor != null ? IconThemeData(color: hoverIconColor) : null,
      selectedIconTheme: selectedIconColor != null
          ? IconThemeData(color: selectedIconColor)
          : null,
      disabledIconTheme: disabledIconColor != null
          ? IconThemeData(color: disabledIconColor)
          : null,
    );
  }

  /// Creates a light theme button style.
  factory FlowControlsButtonStyle.light() {
    return FlowControlsButtonStyle.colored(
      buttonColor: const Color(0xFFF9FAFB),
      hoverColor: const Color(0xFFF3F4F6),
      selectedColor: const Color(0xFFE5E7EB),
      disabledColor: const Color(0xFFF9FAFB),
      iconColor: const Color(0xFF6B7280),
      hoverIconColor: const Color(0xFF374151),
      selectedIconColor: const Color(0xFF111827),
      disabledIconColor: const Color(0xFFD1D5DB),
      shadows: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  /// Creates a dark theme button style.
  factory FlowControlsButtonStyle.dark() {
    return FlowControlsButtonStyle.colored(
      buttonColor: const Color(0xFF374151),
      hoverColor: const Color(0xFF4B5563),
      selectedColor: const Color(0xFF6B7280),
      disabledColor: const Color(0xFF374151),
      iconColor: const Color(0xFF9CA3AF),
      hoverIconColor: const Color(0xFFF9FAFB),
      selectedIconColor: const Color(0xFFFFFFFF),
      disabledIconColor: const Color(0xFF6B7280),
      shadows: const [
        BoxShadow(
          color: Colors.black38,
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  /// Creates a button style that adapts to the system brightness.
  factory FlowControlsButtonStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowControlsButtonStyle.dark()
        : FlowControlsButtonStyle.light();
  }

  /// Creates a button style from Material 3 color scheme.
  factory FlowControlsButtonStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowControlsButtonStyle.colored(
      buttonColor: colorScheme.surfaceContainerHigh,
      hoverColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primaryContainer,
      disabledColor: colorScheme.surfaceContainerLow,
      iconColor: colorScheme.onSurfaceVariant,
      hoverIconColor: colorScheme.onSurface,
      selectedIconColor: colorScheme.onPrimaryContainer,
      disabledIconColor: colorScheme.onSurfaceVariant.withAlpha(100),
    );
  }

  /// Merges this style with another, preferring the other's values.
  FlowControlsButtonStyle merge(FlowControlsButtonStyle? other) {
    if (other == null) return this;
    return copyWith(
      decoration: other.decoration,
      hoverDecoration: other.hoverDecoration,
      selectedDecoration: other.selectedDecoration,
      disabledDecoration: other.disabledDecoration,
      iconTheme: other.iconTheme,
      hoverIconTheme: other.hoverIconTheme,
      selectedIconTheme: other.selectedIconTheme,
      disabledIconTheme: other.disabledIconTheme,
    );
  }

  @override
  FlowControlsButtonStyle copyWith({
    Decoration? decoration,
    Decoration? hoverDecoration,
    Decoration? selectedDecoration,
    Decoration? disabledDecoration,
    IconThemeData? iconTheme,
    IconThemeData? hoverIconTheme,
    IconThemeData? selectedIconTheme,
    IconThemeData? disabledIconTheme,
  }) {
    return FlowControlsButtonStyle(
      decoration: decoration ?? this.decoration,
      hoverDecoration: hoverDecoration ?? this.hoverDecoration,
      selectedDecoration: selectedDecoration ?? this.selectedDecoration,
      disabledDecoration: disabledDecoration ?? this.disabledDecoration,
      iconTheme: iconTheme ?? this.iconTheme,
      hoverIconTheme: hoverIconTheme ?? this.hoverIconTheme,
      selectedIconTheme: selectedIconTheme ?? this.selectedIconTheme,
      disabledIconTheme: disabledIconTheme ?? this.disabledIconTheme,
    );
  }

  @override
  FlowControlsButtonStyle lerp(
      covariant ThemeExtension<FlowControlsButtonStyle>? other, double t) {
    if (other is! FlowControlsButtonStyle) return this;
    return FlowControlsButtonStyle(
      decoration: Decoration.lerp(decoration, other.decoration, t)!,
      hoverDecoration:
          Decoration.lerp(hoverDecoration, other.hoverDecoration, t),
      selectedDecoration:
          Decoration.lerp(selectedDecoration, other.selectedDecoration, t),
      disabledDecoration:
          Decoration.lerp(disabledDecoration, other.disabledDecoration, t),
      iconTheme: IconThemeData.lerp(iconTheme, other.iconTheme, t),
      hoverIconTheme:
          IconThemeData.lerp(hoverIconTheme, other.hoverIconTheme, t),
      selectedIconTheme:
          IconThemeData.lerp(selectedIconTheme, other.selectedIconTheme, t),
      disabledIconTheme:
          IconThemeData.lerp(disabledIconTheme, other.disabledIconTheme, t),
    );
  }

// In controls_theme.dart
  Decoration resolveDecoration(Set<FlowControlState> states) {
    if (states.contains(FlowControlState.disabled)) {
      return disabledDecoration ?? decoration;
    }
    if (states.contains(FlowControlState.selected)) {
      return selectedDecoration ?? hoverDecoration ?? decoration;
    }
    if (states.contains(FlowControlState.hovered)) {
      return hoverDecoration ?? decoration;
    }
    return decoration;
  }

  /// Resolves the appropriate icon theme based on button state.
  IconThemeData resolveIconTheme(Set<FlowControlState> states) {
    if (states.contains(FlowControlState.disabled)) {
      return disabledIconTheme ?? iconTheme;
    }
    if (states.contains(FlowControlState.selected)) {
      if (selectedIconTheme != null) return selectedIconTheme!;
    }

    if (states.contains(FlowControlState.hovered)) {
      if (hoverIconTheme != null) return hoverIconTheme!;
    }

    return iconTheme;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowControlsButtonStyle &&
        other.decoration == decoration &&
        other.hoverDecoration == hoverDecoration &&
        other.selectedDecoration == selectedDecoration &&
        other.disabledDecoration == disabledDecoration &&
        other.iconTheme == iconTheme &&
        other.hoverIconTheme == hoverIconTheme &&
        other.selectedIconTheme == selectedIconTheme &&
        other.disabledIconTheme == disabledIconTheme;
  }

  @override
  int get hashCode => Object.hash(
        decoration,
        hoverDecoration,
        selectedDecoration,
        disabledDecoration,
        iconTheme,
        hoverIconTheme,
        selectedIconTheme,
        disabledIconTheme,
      );
}

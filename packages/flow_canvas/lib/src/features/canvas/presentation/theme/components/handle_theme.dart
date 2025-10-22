import 'package:flutter/material.dart';

/// Represents the possible states of a flow handle.
enum FlowHandleState { idle, hovered, active, validTarget }

/// Defines the visual styling for flow canvas handles.
///
/// This style defines the appearance of handles through decorations,
/// which can be simple colors, gradients, images, or custom decorations.
/// For completely custom handle widgets, pass a [child] to the [FlowHandle]
/// widget instead of using the theme.
///
/// Example usage:
/// ```dart
/// // Simple colored handle
/// FlowHandleStyle.colored(
///   idleColor: Colors.grey,
///   activeColor: Colors.blue,
/// )
///
/// // Gradient handle
/// FlowHandleStyle.decorated(
///   idleDecoration: BoxDecoration(
///     gradient: RadialGradient(colors: [Colors.blue, Colors.purple]),
///     shape: BoxShape.circle,
///   ),
/// )
/// ```
@immutable
class FlowHandleStyle extends ThemeExtension<FlowHandleStyle> {
  /// Decoration for the handle in idle state.
  final Decoration idleDecoration;

  /// Decoration for the handle in hovered state.
  final Decoration? hoverDecoration;

  /// Decoration for the handle in active state.
  final Decoration? activeDecoration;

  /// Decoration for the handle when it's a valid target.
  final Decoration? validTargetDecoration;

  const FlowHandleStyle({
    required this.idleDecoration,
    this.hoverDecoration,
    this.activeDecoration,
    this.validTargetDecoration,
  });

  /// Creates a handle style from simple color values.
  ///
  /// This is the most common use case for basic colored handles.
  factory FlowHandleStyle.colored({
    Color? idleColor,
    Color? hoverColor,
    Color? activeColor,
    Color? validTargetColor,
    Color? borderColor,
    double borderWidth = 1.5,
    BoxShape shape = BoxShape.circle,
    List<BoxShadow>? shadows,
    Size size = const Size(10, 10),
    bool enableAnimations = true,
  }) {
    Decoration? createDecoration(Color? color) {
      if (color == null && borderColor == null && shadows == null) return null;
      return BoxDecoration(
        color: color,
        shape: shape,
        border: borderColor != null
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: shadows,
      );
    }

    return FlowHandleStyle(
      idleDecoration: createDecoration(idleColor)!,
      hoverDecoration: createDecoration(hoverColor),
      activeDecoration: createDecoration(activeColor),
      validTargetDecoration: createDecoration(validTargetColor),
    );
  }

  /// Creates a light theme handle style.
  factory FlowHandleStyle.light() {
    return FlowHandleStyle.colored(
      idleColor: Colors.grey.shade400,
      hoverColor: Colors.grey.shade600,
      activeColor: Colors.blue.shade600,
      validTargetColor: Colors.green.shade500,
      borderColor: Colors.white,
    );
  }

  /// Creates a dark theme handle style.
  factory FlowHandleStyle.dark() {
    return FlowHandleStyle.colored(
      idleColor: Colors.grey.shade600,
      hoverColor: Colors.grey.shade400,
      activeColor: Colors.blue.shade300,
      validTargetColor: Colors.green.shade400,
      borderColor: const Color(0xFF374151),
    );
  }

  /// Creates a handle style that adapts to the system brightness.
  factory FlowHandleStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowHandleStyle.dark()
        : FlowHandleStyle.light();
  }

  /// Creates a handle style from a Material 3 color scheme.
  factory FlowHandleStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowHandleStyle.colored(
      idleColor: colorScheme.outline,
      hoverColor: colorScheme.primary,
      activeColor: colorScheme.primary,
      validTargetColor: colorScheme.tertiary,
      borderColor: colorScheme.surface,
    );
  }

  /// Creates a handle style from a seed color using Material 3 guidelines.
  factory FlowHandleStyle.fromSeed(
    Color seedColor, {
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return FlowHandleStyle.fromColorScheme(colorScheme);
  }

  /// Resolves the appropriate decoration based on handle state.
  ///
  /// State priority (highest to lowest):
  /// 1. Valid Target
  /// 2. Active
  /// 3. Hovered
  /// 4. Idle
  Decoration resolveDecoration(Set<FlowHandleState> states) {
    if (states.contains(FlowHandleState.validTarget)) {
      return validTargetDecoration ??
          activeDecoration ??
          hoverDecoration ??
          idleDecoration;
    }
    if (states.contains(FlowHandleState.active)) {
      return activeDecoration ?? hoverDecoration ?? idleDecoration;
    }
    if (states.contains(FlowHandleState.hovered)) {
      return hoverDecoration ?? idleDecoration;
    }
    return idleDecoration;
  }

  /// Merges this style with another, preferring the other's values.
  ///
  /// Null values in [other] will fall back to this style's values.
  FlowHandleStyle merge(FlowHandleStyle? other) {
    if (other == null) return this;
    return FlowHandleStyle(
      idleDecoration: other.idleDecoration,
      hoverDecoration: other.hoverDecoration ?? hoverDecoration,
      activeDecoration: other.activeDecoration ?? activeDecoration,
      validTargetDecoration:
          other.validTargetDecoration ?? validTargetDecoration,
    );
  }

  @override
  FlowHandleStyle copyWith({
    Decoration? idleDecoration,
    Decoration? hoverDecoration,
    Decoration? activeDecoration,
    Decoration? validTargetDecoration,
  }) {
    return FlowHandleStyle(
      idleDecoration: idleDecoration ?? this.idleDecoration,
      hoverDecoration: hoverDecoration ?? this.hoverDecoration,
      activeDecoration: activeDecoration ?? this.activeDecoration,
      validTargetDecoration:
          validTargetDecoration ?? this.validTargetDecoration,
    );
  }

  @override
  FlowHandleStyle lerp(
      covariant ThemeExtension<FlowHandleStyle>? other, double t) {
    if (other is! FlowHandleStyle) return this;
    return FlowHandleStyle(
      idleDecoration: Decoration.lerp(idleDecoration, other.idleDecoration, t)!,
      hoverDecoration:
          Decoration.lerp(hoverDecoration, other.hoverDecoration, t),
      activeDecoration:
          Decoration.lerp(activeDecoration, other.activeDecoration, t),
      validTargetDecoration: Decoration.lerp(
          validTargetDecoration, other.validTargetDecoration, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowHandleStyle &&
        other.idleDecoration == idleDecoration &&
        other.hoverDecoration == hoverDecoration &&
        other.activeDecoration == activeDecoration &&
        other.validTargetDecoration == validTargetDecoration;
  }

  @override
  int get hashCode => Object.hash(
        idleDecoration,
        hoverDecoration,
        activeDecoration,
        validTargetDecoration,
      );
}

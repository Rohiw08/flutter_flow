import 'package:flutter/foundation.dart';
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
/// ## Registration
///
/// Register the theme extension in your [MaterialApp]:
///
/// ```
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [FlowHandleStyle.light()],
///   ),
///   darkTheme: ThemeData(
///     extensions: [FlowHandleStyle.dark()],
///   ),
/// )
/// ```
///
/// ## Usage
///
/// Access the style using the extension method:
///
/// ```
/// final style = Theme.of(context).flowHandleStyle;
/// final decoration = style.resolveDecoration({FlowHandleState.hovered});
/// ```
///
/// ## Examples
///
/// ```
/// // Simple colored handle
/// FlowHandleStyle.colored(
///   idleColor: Colors.grey,
///   activeColor: Colors.blue,
/// )
///
/// // Gradient handle
/// FlowHandleStyle(
///   idleDecoration: BoxDecoration(
///     gradient: RadialGradient(
///       colors: [Colors.blue, Colors.purple],
///     ),
///     shape: BoxShape.circle,
///   ),
/// )
///
/// // From Material 3 color scheme
/// FlowHandleStyle.fromColorScheme(
///   Theme.of(context).colorScheme,
/// )
/// ```
@immutable
class FlowHandleStyle extends ThemeExtension<FlowHandleStyle>
    with Diagnosticable {
  /// Decoration for the handle in idle state.
  final Decoration idleDecoration;

  /// Decoration for the handle in hovered state.
  ///
  /// Falls back to [idleDecoration] if null.
  final Decoration? hoverDecoration;

  /// Decoration for the handle in active state.
  ///
  /// Falls back to [hoverDecoration] or [idleDecoration] if null.
  final Decoration? activeDecoration;

  /// Decoration for the handle when it's a valid target.
  ///
  /// Falls back through the state hierarchy if null.
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
  ///
  /// At minimum, provide [idleColor] to create a valid style.
  ///
  /// Example:
  /// ```
  /// FlowHandleStyle.colored(
  ///   idleColor: Colors.grey.shade400,
  ///   hoverColor: Colors.blue.shade400,
  ///   activeColor: Colors.blue.shade600,
  ///   validTargetColor: Colors.green.shade500,
  ///   borderColor: Colors.white,
  ///   borderWidth: 2.0,
  ///   shape: BoxShape.circle,
  ///   shadows: [
  ///     BoxShadow(
  ///       color: Colors.black26,
  ///       blurRadius: 4,
  ///       offset: Offset(0, 2),
  ///     ),
  ///   ],
  /// )
  /// ```
  factory FlowHandleStyle.colored({
    Color? idleColor,
    Color? hoverColor,
    Color? activeColor,
    Color? validTargetColor,
    Color? borderColor,
    double borderWidth = 1.5,
    BoxShape shape = BoxShape.circle,
    List<BoxShadow>? shadows,
  }) {
    assert(
      idleColor != null || borderColor != null || shadows != null,
      'At least one of idleColor, borderColor, or shadows must be provided',
    );

    Decoration createDecoration(Color? color) {
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
      idleDecoration: createDecoration(idleColor),
      hoverDecoration: hoverColor != null ? createDecoration(hoverColor) : null,
      activeDecoration:
          activeColor != null ? createDecoration(activeColor) : null,
      validTargetDecoration:
          validTargetColor != null ? createDecoration(validTargetColor) : null,
    );
  }

  /// Creates a light theme handle style.
  ///
  /// Suitable for light mode applications with a clean, minimal aesthetic.
  factory FlowHandleStyle.light() {
    return FlowHandleStyle.colored(
      idleColor: Colors.grey.shade400,
      hoverColor: Colors.grey.shade600,
      activeColor: Colors.blue.shade600,
      validTargetColor: Colors.green.shade500,
      borderColor: Colors.white,
      borderWidth: 1.5,
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Creates a dark theme handle style.
  ///
  /// Suitable for dark mode applications with subtle contrast.
  factory FlowHandleStyle.dark() {
    return FlowHandleStyle.colored(
      idleColor: Colors.grey.shade600,
      hoverColor: Colors.grey.shade400,
      activeColor: Colors.blue.shade300,
      validTargetColor: Colors.green.shade400,
      borderColor: const Color(0xFF374151),
      borderWidth: 1.5,
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(76),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  /// Creates a handle style that adapts to the system brightness.
  ///
  /// Automatically selects [light] or [dark] based on the current theme.
  factory FlowHandleStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowHandleStyle.dark()
        : FlowHandleStyle.light();
  }

  /// Creates a handle style from a Material 3 color scheme.
  ///
  /// Uses semantic colors from the color scheme for consistent theming.
  factory FlowHandleStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowHandleStyle.colored(
      idleColor: colorScheme.outline,
      hoverColor: colorScheme.primary.withAlpha(200),
      activeColor: colorScheme.primary,
      validTargetColor: colorScheme.tertiary,
      borderColor: colorScheme.surface,
      shadows: [
        BoxShadow(
          color: colorScheme.shadow.withAlpha(50),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Creates a handle style from a seed color using Material 3 guidelines.
  ///
  /// Generates a harmonious color scheme from a single seed color.
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
  /// 1. [FlowHandleState.validTarget]
  /// 2. [FlowHandleState.active]
  /// 3. [FlowHandleState.hovered]
  /// 4. [FlowHandleState.idle]
  ///
  /// Falls back through the hierarchy if a state-specific decoration is null.
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
  /// This is useful for creating style variants.
  ///
  /// Example:
  /// ```
  /// final baseStyle = FlowHandleStyle.light();
  /// final customStyle = FlowHandleStyle.colored(
  ///   activeColor: Colors.purple,
  /// );
  /// final merged = baseStyle.merge(customStyle);
  /// // merged will use baseStyle's idle/hover/validTarget colors
  /// // but customStyle's active color
  /// ```
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
    covariant ThemeExtension<FlowHandleStyle>? other,
    double t,
  ) {
    if (other is! FlowHandleStyle) return this;
    if (identical(this, other)) return this;
    if (t == 0.0) return this;
    if (t == 1.0) return other;

    return FlowHandleStyle(
      idleDecoration:
          Decoration.lerp(idleDecoration, other.idleDecoration, t) ??
              idleDecoration,
      hoverDecoration:
          Decoration.lerp(hoverDecoration, other.hoverDecoration, t) ??
              hoverDecoration,
      activeDecoration:
          Decoration.lerp(activeDecoration, other.activeDecoration, t) ??
              activeDecoration,
      validTargetDecoration: Decoration.lerp(
              validTargetDecoration, other.validTargetDecoration, t) ??
          validTargetDecoration,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration>(
      'idleDecoration',
      idleDecoration,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<Decoration>(
      'hoverDecoration',
      hoverDecoration,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<Decoration>(
      'activeDecoration',
      activeDecoration,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<Decoration>(
      'validTargetDecoration',
      validTargetDecoration,
      defaultValue: null,
    ));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FlowHandleStyle('
        'idle: $idleDecoration, '
        'hover: $hoverDecoration, '
        'active: $activeDecoration, '
        'validTarget: $validTargetDecoration'
        ')';
  }
}

/// Extension on [ThemeData] for convenient access to [FlowHandleStyle].
///
/// Usage:
/// ```
/// final style = Theme.of(context).flowHandleStyle;
/// ```
extension FlowHandleStyleExtension on ThemeData {
  /// Returns the [FlowHandleStyle] from theme extensions.
  ///
  /// Falls back to [FlowHandleStyle.light] if not registered.
  FlowHandleStyle get flowHandleStyle =>
      extension<FlowHandleStyle>() ?? FlowHandleStyle.light();
}

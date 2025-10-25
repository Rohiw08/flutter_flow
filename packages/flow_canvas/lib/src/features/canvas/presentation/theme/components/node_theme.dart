import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Represents the possible states of a flow node.
enum FlowNodeState { normal, selected, hovered, disabled }

/// Defines the visual styling for flow canvas nodes.
///
/// This style uses [Decoration] to provide maximum flexibility while offering
/// convenient factory constructors for common cases. Each state can have its
/// own decoration, with automatic fallback through the state hierarchy.
///
/// ## Registration
///
/// Register the theme extension in your [MaterialApp]:
///
/// ```
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [FlowNodeStyle.light()],
///   ),
///   darkTheme: ThemeData(
///     extensions: [FlowNodeStyle.dark()],
///   ),
/// )
/// ```
///
/// ## Usage
///
/// Access the style using the extension method:
///
/// ```
/// final style = Theme.of(context).flowNodeStyle;
/// final decoration = style.resolveDecoration({FlowNodeState.selected});
/// ```
///
/// ## Examples
///
/// ```
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
///     gradient: LinearGradient(
///       colors: [Colors.blue, Colors.purple],
///     ),
///     borderRadius: BorderRadius.circular(12),
///   ),
/// )
///
/// // From Material 3 color scheme
/// FlowNodeStyle.fromColorScheme(
///   Theme.of(context).colorScheme,
/// )
/// ```
@immutable
class FlowNodeStyle extends ThemeExtension<FlowNodeStyle> with Diagnosticable {
  /// Decoration for the node in its normal state.
  final Decoration decoration;

  /// Decoration for the node when selected.
  ///
  /// Falls back to [hoverDecoration] or [decoration] if null.
  final Decoration? selectedDecoration;

  /// Decoration for the node when hovered.
  ///
  /// Falls back to [decoration] if null.
  final Decoration? hoverDecoration;

  /// Decoration for the node when disabled.
  ///
  /// Falls back to a dimmed version of [decoration] if null.
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
  /// 1. Disabled
  /// 2. Selected
  /// 3. Hovered
  /// 4. Normal
  ///
  /// For disabled state, if no explicit [disabledDecoration] is provided,
  /// returns a dimmed version of [decoration] (50% opacity) when possible.
  Decoration resolveDecoration(Set<FlowNodeState> states) {
    if (states.contains(FlowNodeState.disabled)) {
      if (disabledDecoration != null) {
        return disabledDecoration!;
      }

      // Try to create a dimmed version if it's a BoxDecoration
      if (decoration is BoxDecoration) {
        final boxDecoration = decoration as BoxDecoration;
        return boxDecoration.copyWith(
          color: boxDecoration.color?.withValues(alpha: 0.5),
        );
      }

      return decoration;
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
  ///
  /// Example:
  /// ```
  /// FlowNodeStyle.colored(
  ///   color: Colors.white,
  ///   borderColor: Colors.grey.shade300,
  ///   selectedBorderColor: Colors.blue.shade600,
  ///   hoverColor: Colors.grey.shade50,
  ///   borderWidth: 1.0,
  ///   selectedBorderWidth: 2.0,
  ///   borderRadius: BorderRadius.circular(8),
  ///   shadows: [
  ///     BoxShadow(
  ///       color: Colors.black12,
  ///       blurRadius: 10,
  ///       offset: Offset(0, 4),
  ///     ),
  ///   ],
  /// )
  /// ```
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
              bgColor: disabledColor ?? color.withValues(alpha: 0.5),
              bColor:
                  disabledBorderColor ?? borderColor?.withValues(alpha: 0.5),
              bWidth: borderWidth,
            )
          : null,
    );
  }

  /// Creates a light theme node style.
  ///
  /// Suitable for light mode applications with clean, modern aesthetics.
  factory FlowNodeStyle.light() {
    return FlowNodeStyle.colored(
      color: Colors.white,
      borderColor: Colors.grey.shade300,
      selectedBorderColor: Colors.blue.shade600,
      hoverColor: Colors.grey.shade50,
      disabledColor: Colors.grey.shade100,
      disabledBorderColor: Colors.grey.shade300,
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Creates a dark theme node style.
  ///
  /// Suitable for dark mode applications with subtle contrast.
  factory FlowNodeStyle.dark() {
    return FlowNodeStyle.colored(
      color: const Color(0xFF2D2D2D),
      borderColor: const Color(0xFF404040),
      selectedBorderColor: Colors.blue.shade400,
      hoverColor: const Color(0xFF3A3A3A),
      disabledColor: const Color(0xFF1A1A1A),
      disabledBorderColor: const Color(0xFF2A2A2A),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Creates a node style that adapts to the system brightness.
  ///
  /// Automatically selects [light] or [dark] based on the current theme.
  factory FlowNodeStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowNodeStyle.dark()
        : FlowNodeStyle.light();
  }

  /// Creates a node style from a Material 3 color scheme.
  ///
  /// Uses semantic colors from the color scheme for consistent theming
  /// across your application.
  factory FlowNodeStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowNodeStyle.colored(
      color: colorScheme.surfaceContainer,
      borderColor: colorScheme.outlineVariant,
      selectedBorderColor: colorScheme.primary,
      hoverColor: colorScheme.surfaceContainerHigh,
      disabledColor: colorScheme.surfaceContainerLow,
      disabledBorderColor: colorScheme.outlineVariant.withValues(alpha: 0.5),
      shadows: [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Creates a node style from a seed color using Material 3 guidelines.
  ///
  /// Generates a harmonious color scheme from a single seed color.
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
  /// This is useful for creating style variants or overriding specific states.
  ///
  /// Example:
  /// ```
  /// final baseStyle = FlowNodeStyle.light();
  /// final customStyle = FlowNodeStyle.colored(
  ///   color: Colors.white,
  ///   selectedBorderColor: Colors.purple,
  /// );
  /// final merged = baseStyle.merge(customStyle);
  /// // merged uses customStyle's selected border but baseStyle's other properties
  /// ```
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
  }) {
    return FlowNodeStyle(
      decoration: decoration ?? this.decoration,
      selectedDecoration: selectedDecoration ?? this.selectedDecoration,
      hoverDecoration: hoverDecoration ?? this.hoverDecoration,
      disabledDecoration: disabledDecoration ?? this.disabledDecoration,
    );
  }

  @override
  FlowNodeStyle lerp(
    covariant ThemeExtension<FlowNodeStyle>? other,
    double t,
  ) {
    if (other is! FlowNodeStyle) return this;
    if (identical(this, other)) return this;
    if (t == 0.0) return this;
    if (t == 1.0) return other;

    return FlowNodeStyle(
      decoration:
          Decoration.lerp(decoration, other.decoration, t) ?? decoration,
      selectedDecoration:
          Decoration.lerp(selectedDecoration, other.selectedDecoration, t) ??
              selectedDecoration,
      hoverDecoration:
          Decoration.lerp(hoverDecoration, other.hoverDecoration, t) ??
              hoverDecoration,
      disabledDecoration:
          Decoration.lerp(disabledDecoration, other.disabledDecoration, t) ??
              disabledDecoration,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration>(
      'decoration',
      decoration,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<Decoration>(
      'selectedDecoration',
      selectedDecoration,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<Decoration>(
      'hoverDecoration',
      hoverDecoration,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty<Decoration>(
      'disabledDecoration',
      disabledDecoration,
      defaultValue: null,
    ));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FlowNodeStyle('
        'decoration: $decoration, '
        'selectedDecoration: $selectedDecoration, '
        'hoverDecoration: $hoverDecoration, '
        'disabledDecoration: $disabledDecoration'
        ')';
  }
}

/// Extension on [ThemeData] for convenient access to [FlowNodeStyle].
///
/// Usage:
/// ```
/// final style = Theme.of(context).flowNodeStyle;
/// ```
extension FlowNodeStyleExtension on ThemeData {
  /// Returns the [FlowNodeStyle] from theme extensions.
  ///
  /// Falls back to [FlowNodeStyle.light] if not registered.
  FlowNodeStyle get flowNodeStyle =>
      extension<FlowNodeStyle>() ?? FlowNodeStyle.light();
}

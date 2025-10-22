import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_theme.dart';
import 'package:flutter/material.dart';

/// Defines the visual styling for edge labels in a flow diagram.
///
/// This class controls the appearance of text labels that appear along edges
/// between nodes, including their typography and background decoration.
///
/// Uses a state-based theming pattern where [textStyle] and [decoration] provide
/// the base styling, with optional state-specific overrides for hover and selection.
///
/// Example:
/// ```dart
/// FlowEdgeLabelStyle(
///   textStyle: TextStyle(
///     color: Colors.black,
///     fontSize: 12,
///     fontWeight: FontWeight.w500,
///   ),
///   decoration: BoxDecoration(
///     color: Colors.white,
///     borderRadius: BorderRadius.all(Radius.circular(4.0)),
///   ),
///   selectedTextStyle: TextStyle(
///     color: Colors.blue,
///     fontWeight: FontWeight.w600,
///   ),
/// )
/// ```
@immutable
class FlowEdgeLabelStyle extends ThemeExtension<FlowEdgeLabelStyle> {
  /// The base text style applied to the label content.
  ///
  /// Controls font size, weight, color, and other typographic properties
  /// in the normal state. Serves as fallback for other states.
  final TextStyle textStyle;

  /// The text style applied when the edge is hovered.
  ///
  /// If null, uses [textStyle] as fallback.
  final TextStyle? hoveredTextStyle;

  /// The text style applied when the edge is selected.
  ///
  /// If null, uses [textStyle] as fallback.
  final TextStyle? selectedTextStyle;

  /// The base decoration applied around the label.
  ///
  /// Typically includes background color, border, and corner radius.
  /// Serves as the required decoration for the normal state and
  /// fallback for other states.
  final Decoration decoration;

  /// The decoration applied when the edge is hovered.
  ///
  /// If null, uses [decoration] as fallback.
  final Decoration? hoveredDecoration;

  /// The decoration applied when the edge is selected.
  ///
  /// If null, uses [decoration] as fallback.
  final Decoration? selectedDecoration;

  /// Creates a new [FlowEdgeLabelStyle].
  ///
  /// [textStyle] and [decoration] are required as they provide the base styling.
  /// State-specific styles are optional and fall back to base styles when null.
  const FlowEdgeLabelStyle({
    required this.textStyle,
    required this.decoration,
    this.hoveredTextStyle,
    this.hoveredDecoration,
    this.selectedTextStyle,
    this.selectedDecoration,
  });

  /// Creates a light theme label style.
  ///
  /// Suitable for use on light backgrounds with dark text.
  factory FlowEdgeLabelStyle.light() {
    return const FlowEdgeLabelStyle(
      textStyle: TextStyle(
        color: Color(0xFF333333),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFFE0E0E0)),
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      hoveredTextStyle: TextStyle(
        color: Color(0xFF000000),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      hoveredDecoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFFBDBDBD)),
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      selectedTextStyle: TextStyle(
        color: Color(0xFF1976D2),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      selectedDecoration: BoxDecoration(
        color: Color(0xFFE3F2FD),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF90CAF9)),
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }

  /// Creates a dark theme label style.
  ///
  /// Suitable for use on dark backgrounds with light text.
  factory FlowEdgeLabelStyle.dark() {
    return const FlowEdgeLabelStyle(
      textStyle: TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF2D2D2D),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF404040)),
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      hoveredTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      hoveredDecoration: BoxDecoration(
        color: Color(0xFF3A3A3A),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF616161)),
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      selectedTextStyle: TextStyle(
        color: Color(0xFF64B5F6),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      selectedDecoration: BoxDecoration(
        color: Color(0xFF1565C0),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF90CAF9)),
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }

  /// Creates a label style that adapts to the system brightness.
  ///
  /// Uses [FlowEdgeLabelStyle.dark] when in dark mode,
  /// and [FlowEdgeLabelStyle.light] otherwise.
  factory FlowEdgeLabelStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowEdgeLabelStyle.dark()
        : FlowEdgeLabelStyle.light();
  }

  /// Creates a label style from a Material 3 [ColorScheme].
  ///
  /// This factory adapts the text and background colors based on the
  /// Material 3 color system for consistent theming.
  factory FlowEdgeLabelStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowEdgeLabelStyle(
      textStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      hoveredTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      hoveredDecoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(color: colorScheme.outline),
      ),
      selectedTextStyle: TextStyle(
        color: colorScheme.primary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      selectedDecoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(color: colorScheme.onPrimaryContainer),
      ),
    );
  }

  /// Creates a label style from a seed color using Material 3 color generation.
  ///
  /// This provides automatic theming consistency based on a single seed color.
  factory FlowEdgeLabelStyle.fromSeed(
    Color seedColor, {
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return FlowEdgeLabelStyle.fromColorScheme(colorScheme);
  }

  /// Merges this style with [other], applying [other]'s values as overrides.
  ///
  /// For the base properties ([textStyle] and [decoration]):
  /// - [textStyle] is merged using TextStyle's built-in merge
  /// - [decoration] is completely replaced by [other.decoration]
  ///
  /// For state-specific properties, [other]'s non-null values override this style's values.
  ///
  /// Example:
  /// ```dart
  /// final base = FlowEdgeLabelStyle.light();
  /// final custom = FlowEdgeLabelStyle(
  ///   textStyle: TextStyle(fontSize: 14),
  ///   decoration: BoxDecoration(color: Colors.blue),
  ///   selectedTextStyle: TextStyle(color: Colors.red),
  /// );
  ///
  /// final merged = base.merge(custom);
  /// // Uses custom's textStyle (merged), decoration, and selectedTextStyle
  /// // Keeps base's hoveredTextStyle, hoveredDecoration, selectedDecoration
  /// ```
  FlowEdgeLabelStyle merge(FlowEdgeLabelStyle? other) {
    if (other == null) return this;
    return FlowEdgeLabelStyle(
      textStyle: textStyle.merge(other.textStyle),
      decoration: other.decoration, // Decoration has no merge method

      // For state-specific properties, prefer other's value if non-null
      hoveredTextStyle: other.hoveredTextStyle ?? hoveredTextStyle,
      hoveredDecoration: other.hoveredDecoration ?? hoveredDecoration,

      selectedTextStyle: other.selectedTextStyle ?? selectedTextStyle,
      selectedDecoration: other.selectedDecoration ?? selectedDecoration,
    );
  }

  /// Returns a copy of this style with the given fields replaced by new values.
  @override
  FlowEdgeLabelStyle copyWith({
    TextStyle? textStyle,
    Decoration? decoration,
    TextStyle? hoveredTextStyle,
    Decoration? hoveredDecoration,
    TextStyle? selectedTextStyle,
    Decoration? selectedDecoration,
  }) {
    return FlowEdgeLabelStyle(
      textStyle: textStyle ?? this.textStyle,
      decoration: decoration ?? this.decoration,
      hoveredTextStyle: hoveredTextStyle ?? this.hoveredTextStyle,
      hoveredDecoration: hoveredDecoration ?? this.hoveredDecoration,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      selectedDecoration: selectedDecoration ?? this.selectedDecoration,
    );
  }

  /// Linearly interpolates between this label style and [other].
  ///
  /// Used by Flutter's theme animation system when transitioning between themes.
  /// The [t] parameter is the interpolation factor, typically between 0.0 and 1.0.
  @override
  FlowEdgeLabelStyle lerp(
      covariant ThemeExtension<FlowEdgeLabelStyle>? other, double t) {
    if (other is! FlowEdgeLabelStyle) return this;
    return FlowEdgeLabelStyle(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t) ?? textStyle,
      decoration:
          Decoration.lerp(decoration, other.decoration, t) ?? decoration,
      hoveredTextStyle:
          TextStyle.lerp(hoveredTextStyle, other.hoveredTextStyle, t),
      hoveredDecoration:
          Decoration.lerp(hoveredDecoration, other.hoveredDecoration, t),
      selectedTextStyle:
          TextStyle.lerp(selectedTextStyle, other.selectedTextStyle, t),
      selectedDecoration:
          Decoration.lerp(selectedDecoration, other.selectedDecoration, t),
    );
  }

  /// Resolves the appropriate text style based on the edge's state.
  ///
  /// State priority (highest to lowest):
  /// 1. Selected - returns [selectedTextStyle]
  /// 2. Hovered - returns [hoveredTextStyle]
  /// 3. Normal - returns [textStyle]
  ///
  /// Falls back to [textStyle] if state-specific style is not defined.
  TextStyle resolveTextStyle(Set<FlowEdgeState> states) {
    if (states.contains(FlowEdgeState.selected)) {
      return selectedTextStyle ?? textStyle;
    }
    if (states.contains(FlowEdgeState.hovered)) {
      return hoveredTextStyle ?? textStyle;
    }
    return textStyle;
  }

  /// Resolves the appropriate decoration based on the edge's state.
  ///
  /// State priority (highest to lowest):
  /// 1. Selected - returns [selectedDecoration]
  /// 2. Hovered - returns [hoveredDecoration]
  /// 3. Normal - returns [decoration]
  ///
  /// Falls back to [decoration] if state-specific decoration is not defined.
  /// Always returns a non-null decoration.
  Decoration resolveDecoration(Set<FlowEdgeState> states) {
    if (states.contains(FlowEdgeState.selected)) {
      return selectedDecoration ?? decoration;
    }
    if (states.contains(FlowEdgeState.hovered)) {
      return hoveredDecoration ?? decoration;
    }
    return decoration;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowEdgeLabelStyle &&
        other.textStyle == textStyle &&
        other.decoration == decoration &&
        other.hoveredTextStyle == hoveredTextStyle &&
        other.hoveredDecoration == hoveredDecoration &&
        other.selectedTextStyle == selectedTextStyle &&
        other.selectedDecoration == selectedDecoration;
  }

  @override
  int get hashCode => Object.hash(
        textStyle,
        decoration,
        hoveredTextStyle,
        hoveredDecoration,
        selectedTextStyle,
        selectedDecoration,
      );
}

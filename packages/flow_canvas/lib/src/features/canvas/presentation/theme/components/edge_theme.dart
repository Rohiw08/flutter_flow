import 'dart:ui' show lerpDouble;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_label_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';

/// Represents the possible states of a flow edge.
enum FlowEdgeState { normal, selected, hovered }

class FlowEdgeStrokeStyle extends Equatable {
  final double strokeWidth;
  final Color color;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;

  const FlowEdgeStrokeStyle({
    required this.strokeWidth,
    required this.color,
    this.strokeCap = StrokeCap.round,
    this.strokeJoin = StrokeJoin.round,
  });

  FlowEdgeStrokeStyle copyWith({
    double? strokeWidth,
    Color? color,
    StrokeCap? strokeCap,
    StrokeJoin? strokeJoin,
  }) {
    return FlowEdgeStrokeStyle(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      strokeCap: strokeCap ?? this.strokeCap,
      strokeJoin: strokeJoin ?? this.strokeJoin,
    );
  }

  static FlowEdgeStrokeStyle? lerp(
      FlowEdgeStrokeStyle? a, FlowEdgeStrokeStyle? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;

    return FlowEdgeStrokeStyle(
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t) ?? a.strokeWidth,
      color: Color.lerp(a.color, b.color, t)!,
      strokeCap: t < 0.5 ? a.strokeCap : b.strokeCap,
      strokeJoin: t < 0.5 ? a.strokeJoin : b.strokeJoin,
    );
  }

  @override
  List<Object?> get props => [strokeWidth, color, strokeCap, strokeJoin];
}

/// Defines the visual styling for flow canvas edges (connections between nodes).
///
/// This style uses a state-based theming pattern where [decoration] provides
/// the base styling, and optional [selectedDecoration] and [hoverDecoration]
/// override the base for specific states.
///
/// Example usage:
/// ```dart
/// FlowEdgeStyle(
///   decoration: FlowEdgeStrokeStyle(
///     strokeWidth: 2.0,
///     color: Colors.grey,
///   ),
///   selectedDecoration: FlowEdgeStrokeStyle(
///     strokeWidth: 2.5,
///     color: Colors.blue,
///   ),
///   labelStyle: FlowEdgeLabelStyle.light(),
///   endMarkerStyle: FlowEdgeMarkerStyle.arrow(),
/// )
/// ```
@immutable
class FlowEdgeStyle extends ThemeExtension<FlowEdgeStyle> {
  /// Base decoration for the edge in its normal state.
  /// This is required and serves as the fallback for all states.
  final FlowEdgeStrokeStyle decoration;

  /// Optional decoration override when the edge is selected.
  /// If null, uses [decoration].
  final FlowEdgeStrokeStyle? selectedDecoration;

  /// Optional decoration override when the edge is hovered.
  /// If null, uses [decoration].
  final FlowEdgeStrokeStyle? hoverDecoration;

  /// Optional style for edge labels (text on the edge).
  /// If null, no labels are rendered.
  final FlowEdgeLabelStyle? labelStyle;

  /// Optional style for the marker at the start of the edge.
  /// If null, no start marker is rendered.
  final FlowEdgeMarkerStyle? startMarkerStyle;

  /// Optional style for the marker at the end of the edge (typically an arrow).
  /// If null, no end marker is rendered.
  final FlowEdgeMarkerStyle? endMarkerStyle;

  const FlowEdgeStyle({
    required this.decoration,
    this.selectedDecoration,
    this.hoverDecoration,
    this.labelStyle,
    this.startMarkerStyle,
    this.endMarkerStyle,
  });

  /// Resolves the appropriate decoration based on edge state.
  ///
  /// State priority (highest to lowest):
  /// 1. Selected ([selectedDecoration])
  /// 2. Hovered ([hoverDecoration])
  /// 3. Normal ([decoration])
  ///
  /// Returns [decoration] if the state-specific decoration is not defined.
  FlowEdgeStrokeStyle resolveDecoration(Set<FlowEdgeState> states) {
    if (states.contains(FlowEdgeState.selected)) {
      return selectedDecoration ?? decoration;
    }
    if (states.contains(FlowEdgeState.hovered)) {
      return hoverDecoration ?? decoration;
    }
    return decoration;
  }

  /// Creates a light theme edge style.
  factory FlowEdgeStyle.light() {
    return FlowEdgeStyle(
      decoration: FlowEdgeStrokeStyle(
        strokeWidth: 2.0,
        color: Colors.grey.shade800,
      ),
      selectedDecoration: FlowEdgeStrokeStyle(
        strokeWidth: 2.5,
        color: Colors.blue.shade600,
      ),
      hoverDecoration: FlowEdgeStrokeStyle(
        strokeWidth: 2.0,
        color: Colors.grey.shade600,
      ),
      labelStyle: FlowEdgeLabelStyle.light(),
      startMarkerStyle: FlowEdgeMarkerStyle.light(),
      endMarkerStyle: FlowEdgeMarkerStyle.light(),
    );
  }

  /// Creates a dark theme edge style.
  factory FlowEdgeStyle.dark() {
    return FlowEdgeStyle(
      decoration: FlowEdgeStrokeStyle(
        strokeWidth: 2.0,
        color: Colors.grey.shade600,
      ),
      selectedDecoration: FlowEdgeStrokeStyle(
        strokeWidth: 2.5,
        color: Colors.blue.shade300,
      ),
      hoverDecoration: FlowEdgeStrokeStyle(
        strokeWidth: 2.0,
        color: Colors.grey.shade400,
      ),
      labelStyle: FlowEdgeLabelStyle.dark(),
      startMarkerStyle: FlowEdgeMarkerStyle.dark(),
      endMarkerStyle: FlowEdgeMarkerStyle.dark(),
    );
  }

  /// Creates an edge style that adapts to the system brightness.
  factory FlowEdgeStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowEdgeStyle.dark()
        : FlowEdgeStyle.light();
  }

  /// Creates an edge style from a Material 3 color scheme.
  factory FlowEdgeStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowEdgeStyle(
      decoration: FlowEdgeStrokeStyle(
        strokeWidth: 2.0,
        color: colorScheme.outline,
      ),
      selectedDecoration: FlowEdgeStrokeStyle(
        strokeWidth: 2.5,
        color: colorScheme.primary,
      ),
      hoverDecoration: FlowEdgeStrokeStyle(
        strokeWidth: 2.0,
        color: colorScheme.onSurfaceVariant,
      ),
      labelStyle: FlowEdgeLabelStyle.fromColorScheme(colorScheme),
      startMarkerStyle: FlowEdgeMarkerStyle.fromColorScheme(colorScheme),
      endMarkerStyle: FlowEdgeMarkerStyle.fromColorScheme(colorScheme),
    );
  }

  /// Creates an edge style from a seed color using Material 3 guidelines.
  factory FlowEdgeStyle.fromSeed(
    Color seedColor, {
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return FlowEdgeStyle.fromColorScheme(colorScheme);
  }

  /// Merges this style with another, applying [other]'s values as overrides.
  ///
  /// For the base [decoration], [other]'s value completely replaces this one.
  /// For optional state decorations and nested styles, [other]'s non-null
  /// values override this style's values.
  ///
  /// Nested styles (label and markers) are merged recursively if both exist.
  ///
  /// Example:
  /// ```dart
  /// final base = FlowEdgeStyle.light();
  /// final override = FlowEdgeStyle(
  ///   decoration: FlowEdgeStrokeStyle(strokeWidth: 3.0, color: Colors.red),
  ///   selectedDecoration: FlowEdgeStrokeStyle(strokeWidth: 4.0, color: Colors.orange),
  /// );
  ///
  /// final merged = base.merge(override);
  /// // Uses override's decoration and selectedDecoration
  /// // Keeps base's hoverDecoration, labelStyle, and marker styles
  /// ```
  FlowEdgeStyle merge(FlowEdgeStyle? other) {
    if (other == null) return this;
    return FlowEdgeStyle(
      decoration: other.decoration,
      selectedDecoration: other.selectedDecoration ?? selectedDecoration,
      hoverDecoration: other.hoverDecoration ?? hoverDecoration,
      labelStyle: _mergeNested(labelStyle, other.labelStyle),
      startMarkerStyle: _mergeNested(startMarkerStyle, other.startMarkerStyle),
      endMarkerStyle: _mergeNested(endMarkerStyle, other.endMarkerStyle),
    );
  }

  /// Helper method for merging nested nullable styles.
  ///
  /// - If override is null, returns base
  /// - If base is null, returns override
  /// - If both exist, merges them recursively
  T? _mergeNested<T extends ThemeExtension<T>>(T? base, T? override) {
    if (override == null) return base;
    if (base == null) return override;
    // Both exist - use the ThemeExtension's merge capability
    return base.lerp(override, 1.0) as T?;
  }

  @override
  FlowEdgeStyle copyWith({
    FlowEdgeStrokeStyle? decoration,
    FlowEdgeStrokeStyle? selectedDecoration,
    FlowEdgeStrokeStyle? hoverDecoration,
    FlowEdgeLabelStyle? labelStyle,
    FlowEdgeMarkerStyle? startMarkerStyle,
    FlowEdgeMarkerStyle? endMarkerStyle,
  }) {
    return FlowEdgeStyle(
      decoration: decoration ?? this.decoration,
      selectedDecoration: selectedDecoration ?? this.selectedDecoration,
      hoverDecoration: hoverDecoration ?? this.hoverDecoration,
      labelStyle: labelStyle ?? this.labelStyle,
      startMarkerStyle: startMarkerStyle ?? this.startMarkerStyle,
      endMarkerStyle: endMarkerStyle ?? this.endMarkerStyle,
    );
  }

  @override
  FlowEdgeStyle lerp(covariant ThemeExtension<FlowEdgeStyle>? other, double t) {
    if (other is! FlowEdgeStyle) return this;
    return FlowEdgeStyle(
      decoration: FlowEdgeStrokeStyle.lerp(decoration, other.decoration, t) ??
          decoration,
      selectedDecoration: FlowEdgeStrokeStyle.lerp(
          selectedDecoration, other.selectedDecoration, t),
      hoverDecoration:
          FlowEdgeStrokeStyle.lerp(hoverDecoration, other.hoverDecoration, t),
      labelStyle: labelStyle?.lerp(other.labelStyle, t),
      startMarkerStyle: startMarkerStyle?.lerp(other.startMarkerStyle, t),
      endMarkerStyle: endMarkerStyle?.lerp(other.endMarkerStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowEdgeStyle &&
        other.decoration == decoration &&
        other.selectedDecoration == selectedDecoration &&
        other.hoverDecoration == hoverDecoration &&
        other.labelStyle == labelStyle &&
        other.startMarkerStyle == startMarkerStyle &&
        other.endMarkerStyle == endMarkerStyle;
  }

  @override
  int get hashCode => Object.hash(
        decoration,
        selectedDecoration,
        hoverDecoration,
        labelStyle,
        startMarkerStyle,
        endMarkerStyle,
      );
}

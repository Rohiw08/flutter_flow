import 'dart:ui' show lerpDouble;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';
import 'package:flow_canvas/src/shared/enums.dart';

/// A function that defines a custom drawing routine for a connection path.
///
/// Use this to create custom shapes (e.g., arcs, custom curves) for the
/// interactive connection line drawn from a source to the cursor.
typedef ConnectionBuilder = void Function(
  Canvas canvas,
  Offset start,
  Offset end,
  FlowConnectionStrokeStyle style,
);

/// Defines the stroke style for a connection line.
///
/// Encapsulates properties like [strokeWidth] and [color] for a consistent
/// and reusable line style definition.
class FlowConnectionStrokeStyle extends Equatable {
  /// The thickness of the line.
  final double strokeWidth;

  /// The color of the line.
  final Color color;

  /// Creates a stroke style for a connection.
  const FlowConnectionStrokeStyle({
    required this.strokeWidth,
    required this.color,
  });

  /// Returns a new instance with the given fields replaced with the new values.
  FlowConnectionStrokeStyle copyWith({
    double? strokeWidth,
    Color? color,
  }) {
    return FlowConnectionStrokeStyle(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
    );
  }

  static FlowConnectionStrokeStyle? lerp(
      FlowConnectionStrokeStyle? a, FlowConnectionStrokeStyle? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;

    return FlowConnectionStrokeStyle(
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t) ?? a.strokeWidth,
      color: Color.lerp(a.color, b.color, t)!,
    );
  }

  @override
  List<Object?> get props => [strokeWidth, color];
}

/// Defines the visual style for the interactive connection line (edge)
/// drawn between a source port and the cursor during a connection gesture.
///
/// This style is part of the canvas theme and can be customized through
/// [ThemeExtension] to support different appearances, such as for light/dark
/// modes or dynamic color schemes.
@immutable
class FlowConnectionStyle extends ThemeExtension<FlowConnectionStyle> {
  /// The stroke style of the connection line in its default, active state.
  final FlowConnectionStrokeStyle activeDecoration;

  /// The stroke style of the connection line when hovering over a valid target port.
  final FlowConnectionStrokeStyle? validTargetDecoration;

  /// The shape of the connection line's path.
  final EdgePathType pathType;

  /// The marker style for the start of the connection line (the source port).
  final FlowEdgeMarkerStyle? startMarkerStyle;

  /// The marker style for the end of the connection line (the cursor position).
  final FlowEdgeMarkerStyle? endMarkerStyle;

  /// An optional builder to render a custom path for the connection line.
  ///
  /// When provided, this overrides the default path drawing based on [pathType].
  final ConnectionBuilder? connectionBuilder;

  const FlowConnectionStyle({
    this.pathType = EdgePathType.bezier,
    this.activeDecoration = const FlowConnectionStrokeStyle(
      strokeWidth: 2.0,
      color: Color(0xFF2196F3),
    ),
    this.validTargetDecoration,
    this.startMarkerStyle,
    this.endMarkerStyle,
    this.connectionBuilder,
  });

  /// Creates a light theme connection style.
  factory FlowConnectionStyle.light() {
    return const FlowConnectionStyle(
      activeDecoration: FlowConnectionStrokeStyle(
        strokeWidth: 2.0,
        color: Color(0xFF2196F3),
      ),
      validTargetDecoration: FlowConnectionStrokeStyle(
        strokeWidth: 2.0,
        color: Color(0xFF4CAF50),
      ),
    );
  }

  /// Creates a dark theme connection style.
  factory FlowConnectionStyle.dark() {
    return const FlowConnectionStyle(
      activeDecoration: FlowConnectionStrokeStyle(
        strokeWidth: 2.0,
        color: Color(0xFF64B5F6),
      ),
      validTargetDecoration: FlowConnectionStrokeStyle(
        strokeWidth: 2.0,
        color: Color(0xFF81C784),
      ),
    );
  }

  /// Creates a connection style that adapts to the system theme.
  factory FlowConnectionStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowConnectionStyle.dark()
        : FlowConnectionStyle.light();
  }

  /// Creates a style based on a [ColorScheme].
  factory FlowConnectionStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowConnectionStyle(
      activeDecoration: FlowConnectionStrokeStyle(
        strokeWidth: 2.0,
        color: colorScheme.primary,
      ),
      validTargetDecoration: FlowConnectionStrokeStyle(
        strokeWidth: 2.0,
        color: colorScheme.secondary,
      ),
      pathType: EdgePathType.bezier,
      startMarkerStyle: FlowEdgeMarkerStyle.fromColorScheme(colorScheme),
      endMarkerStyle: FlowEdgeMarkerStyle.fromColorScheme(colorScheme),
    );
  }

  /// Creates a style based on a single seed color using Material 3 color generation.
  factory FlowConnectionStyle.fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return FlowConnectionStyle.fromColorScheme(colorScheme);
  }

  /// Returns a new style that merges this style with another.
  ///
  /// Non-null values in [other] override values in this instance.
  FlowConnectionStyle merge(FlowConnectionStyle? other) {
    if (other == null) return this;
    return copyWith(
      activeDecoration: other.activeDecoration,
      validTargetDecoration: other.validTargetDecoration,
      pathType: other.pathType,
      startMarkerStyle: other.startMarkerStyle,
      endMarkerStyle: other.endMarkerStyle,
      connectionBuilder: other.connectionBuilder,
    );
  }

  @override
  FlowConnectionStyle copyWith({
    FlowConnectionStrokeStyle? activeDecoration,
    FlowConnectionStrokeStyle? validTargetDecoration,
    EdgePathType? pathType,
    FlowEdgeMarkerStyle? startMarkerStyle,
    FlowEdgeMarkerStyle? endMarkerStyle,
    ConnectionBuilder? connectionBuilder,
  }) {
    return FlowConnectionStyle(
      activeDecoration: activeDecoration ?? this.activeDecoration,
      validTargetDecoration:
          validTargetDecoration ?? this.validTargetDecoration,
      pathType: pathType ?? this.pathType,
      startMarkerStyle: startMarkerStyle ?? this.startMarkerStyle,
      endMarkerStyle: endMarkerStyle ?? this.endMarkerStyle,
      connectionBuilder: connectionBuilder ?? this.connectionBuilder,
    );
  }

  @override
  FlowConnectionStyle lerp(
      covariant ThemeExtension<FlowConnectionStyle>? other, double t) {
    if (other is! FlowConnectionStyle) return this;
    return FlowConnectionStyle(
      activeDecoration: FlowConnectionStrokeStyle.lerp(
          activeDecoration, other.activeDecoration, t)!,
      validTargetDecoration: FlowConnectionStrokeStyle.lerp(
          validTargetDecoration, other.validTargetDecoration, t)!,
      pathType: t < 0.5 ? pathType : other.pathType,
      startMarkerStyle:
          _lerpMarker(startMarkerStyle, other.startMarkerStyle, t),
      endMarkerStyle: _lerpMarker(endMarkerStyle, other.endMarkerStyle, t),
      connectionBuilder: t < 0.5 ? connectionBuilder : other.connectionBuilder,
    );
  }

  /// Safely interpolates between two [FlowEdgeMarkerStyle] objects.
  static FlowEdgeMarkerStyle? _lerpMarker(
    FlowEdgeMarkerStyle? a,
    FlowEdgeMarkerStyle? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return a.lerp(b, t);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowConnectionStyle &&
        other.activeDecoration == activeDecoration &&
        other.validTargetDecoration == validTargetDecoration &&
        other.pathType == pathType &&
        other.startMarkerStyle == startMarkerStyle &&
        other.endMarkerStyle == endMarkerStyle &&
        other.connectionBuilder == connectionBuilder;
  }

  @override
  int get hashCode => Object.hash(
        activeDecoration,
        validTargetDecoration,
        pathType,
        startMarkerStyle,
        endMarkerStyle,
        connectionBuilder,
      );
}

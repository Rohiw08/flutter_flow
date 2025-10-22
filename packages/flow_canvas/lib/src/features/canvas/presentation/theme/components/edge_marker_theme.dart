import 'dart:ui' show lerpDouble, Tangent;
import 'package:equatable/equatable.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_theme.dart';
import 'package:flutter/material.dart';

enum EdgeMarkerType {
  none,
  arrow,
  circle,
  arrowClosed,
}

// The custom painter typedef, using the new FlowMarkerDecoration
typedef MarkerBuilder = void Function(
  Canvas canvas,
  Tangent tangent,
  FlowMarkerDecoration style,
);

// The simple data class for resolved marker styles
@immutable
class FlowMarkerDecoration extends Equatable {
  final Size size;
  final Color color;
  final double strokeWidth;

  const FlowMarkerDecoration({
    required this.size,
    required this.color,
    this.strokeWidth = 2.0,
  });

  FlowMarkerDecoration copyWith({
    Size? size,
    Color? color,
    double? strokeWidth,
  }) {
    return FlowMarkerDecoration(
      size: size ?? this.size,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  static FlowMarkerDecoration? lerp(
      FlowMarkerDecoration? a, FlowMarkerDecoration? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return FlowMarkerDecoration(
      size: Size.lerp(a.size, b.size, t)!,
      color: Color.lerp(a.color, b.color, t)!,
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t)!,
    );
  }

  @override
  List<Object?> get props => [size, color, strokeWidth];
}

// The refactored main ThemeExtension class
@immutable
class FlowEdgeMarkerStyle extends ThemeExtension<FlowEdgeMarkerStyle> {
  // ignore: annotate_overrides
  final EdgeMarkerType type;
  final FlowMarkerDecoration decoration;
  final FlowMarkerDecoration? hoverDecoration;
  final FlowMarkerDecoration? selectedDecoration;
  final MarkerBuilder? builder;

  const FlowEdgeMarkerStyle({
    required this.decoration,
    this.type = EdgeMarkerType.arrow,
    this.builder,
    this.hoverDecoration,
    this.selectedDecoration,
  });

  /// Resolves the final marker style based on the current edge state.
  FlowMarkerDecoration resolve(Set<FlowEdgeState> states) {
    if (states.contains(FlowEdgeState.selected)) {
      return selectedDecoration ?? decoration;
    }
    if (states.contains(FlowEdgeState.hovered)) {
      return hoverDecoration ?? decoration;
    }
    return decoration;
  }

  factory FlowEdgeMarkerStyle.light() {
    return const FlowEdgeMarkerStyle(
      type: EdgeMarkerType.arrow,
      decoration: FlowMarkerDecoration(
        size: Size(12, 12),
        color: Color(0xFF9E9E9E),
        strokeWidth: 2.0,
      ),
      hoverDecoration: FlowMarkerDecoration(
        size: Size(12, 12),
        color: Colors.black,
        strokeWidth: 2.0,
      ),
      selectedDecoration: FlowMarkerDecoration(
        size: Size(14, 14),
        color: Colors.blue,
        strokeWidth: 2.5,
      ),
    );
  }

  factory FlowEdgeMarkerStyle.dark() {
    return const FlowEdgeMarkerStyle(
      type: EdgeMarkerType.arrow,
      decoration: FlowMarkerDecoration(
        size: Size(12, 12),
        color: Color(0xFFBDBDBD),
        strokeWidth: 2.0,
      ),
      hoverDecoration: FlowMarkerDecoration(
        size: Size(12, 12),
        color: Colors.white,
        strokeWidth: 2.0,
      ),
      selectedDecoration: FlowMarkerDecoration(
        size: Size(14, 14),
        color: Colors.lightBlueAccent,
        strokeWidth: 2.5,
      ),
    );
  }

  factory FlowEdgeMarkerStyle.fromColorScheme(ColorScheme colorScheme) {
    return FlowEdgeMarkerStyle(
      type: EdgeMarkerType.arrowClosed,
      decoration: FlowMarkerDecoration(
        size: const Size(12, 12),
        color: colorScheme.outline,
        strokeWidth: 1.5,
      ),
      hoverDecoration: FlowMarkerDecoration(
        size: const Size(12, 12),
        color: colorScheme.onSurfaceVariant,
        strokeWidth: 1.5,
      ),
      selectedDecoration: FlowMarkerDecoration(
        size: const Size(14, 14),
        color: colorScheme.primary,
        strokeWidth: 2.0,
      ),
    );
  }

  factory FlowEdgeMarkerStyle.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowEdgeMarkerStyle.dark()
        : FlowEdgeMarkerStyle.light();
  }

  factory FlowEdgeMarkerStyle.fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return FlowEdgeMarkerStyle.fromColorScheme(colorScheme);
  }

  factory FlowEdgeMarkerStyle.colored({
    EdgeMarkerType type = EdgeMarkerType.arrow,
    Size size = const Size(12, 12),
    double strokeWidth = 2.0,
    Color? color,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    final base = FlowMarkerDecoration(
      size: size,
      color: color ?? Colors.grey,
      strokeWidth: strokeWidth,
    );

    return FlowEdgeMarkerStyle(
      type: type,
      decoration: base,
      hoverDecoration:
          hoverColor != null ? base.copyWith(color: hoverColor) : null,
      selectedDecoration:
          selectedColor != null ? base.copyWith(color: selectedColor) : null,
    );
  }

  FlowEdgeMarkerStyle merge(FlowEdgeMarkerStyle? other) {
    if (other == null) return this;
    return copyWith(
      type: other.type,
      builder: other.builder,
      decoration: other.decoration,
      hoverDecoration: other.hoverDecoration,
      selectedDecoration: other.selectedDecoration,
    );
  }

  @override
  FlowEdgeMarkerStyle copyWith({
    EdgeMarkerType? type,
    MarkerBuilder? builder,
    FlowMarkerDecoration? decoration,
    FlowMarkerDecoration? hoverDecoration,
    FlowMarkerDecoration? selectedDecoration,
  }) {
    return FlowEdgeMarkerStyle(
      type: type ?? this.type,
      builder: builder ?? this.builder,
      decoration: decoration ?? this.decoration,
      hoverDecoration: hoverDecoration ?? this.hoverDecoration,
      selectedDecoration: selectedDecoration ?? this.selectedDecoration,
    );
  }

  @override
  FlowEdgeMarkerStyle lerp(
      covariant ThemeExtension<FlowEdgeMarkerStyle>? other, double t) {
    if (other is! FlowEdgeMarkerStyle) return this;
    return FlowEdgeMarkerStyle(
      type: t < 0.5 ? type : other.type,
      builder: t < 0.5 ? builder : other.builder,
      decoration: FlowMarkerDecoration.lerp(decoration, other.decoration, t)!,
      hoverDecoration:
          FlowMarkerDecoration.lerp(hoverDecoration, other.hoverDecoration, t),
      selectedDecoration: FlowMarkerDecoration.lerp(
          selectedDecoration, other.selectedDecoration, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowEdgeMarkerStyle &&
        other.type == type &&
        other.builder == builder &&
        other.decoration == decoration &&
        other.hoverDecoration == hoverDecoration &&
        other.selectedDecoration == selectedDecoration;
  }

  @override
  int get hashCode => Object.hash(
        type,
        builder,
        decoration,
        hoverDecoration,
        selectedDecoration,
      );
}

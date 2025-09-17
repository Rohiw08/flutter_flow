import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

@immutable
class FlowEdgeMarkerStyle {
  final EdgeMarkerType? type;
  final Color? color;
  final double? width;
  final double? height;
  final String? markerUnits;
  final String? orient;
  final double? strokeWidth;

  const FlowEdgeMarkerStyle({
    this.type,
    this.color,
    this.width,
    this.height,
    this.markerUnits,
    this.orient,
    this.strokeWidth,
  });

  FlowEdgeMarkerStyle copyWith({
    EdgeMarkerType? type,
    Color? color,
    double? width,
    double? height,
    String? markerUnits,
    String? orient,
    double? strokeWidth,
  }) {
    return FlowEdgeMarkerStyle(
      type: type ?? this.type,
      color: color ?? this.color,
      width: width ?? this.width,
      height: height ?? this.height,
      markerUnits: markerUnits ?? this.markerUnits,
      orient: orient ?? this.orient,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  FlowEdgeMarkerStyle resolveEdgeMarkerTheme(
    FlowEdgeMarkerStyle? markerTheme, {
    EdgeMarkerType? type,
    Color? color,
    double? width,
    double? height,
    String? markerUnits,
    String? orient,
    double? strokeWidth,
  }) {
    final base = markerTheme ?? const FlowEdgeMarkerStyle();
    return base.copyWith(
      type: type,
      color: color,
      width: width,
      height: height,
      markerUnits: markerUnits,
      orient: orient,
      strokeWidth: strokeWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowEdgeMarkerStyle &&
        other.type == type &&
        other.color == color &&
        other.width == width &&
        other.height == height &&
        other.markerUnits == markerUnits &&
        other.orient == orient &&
        other.strokeWidth == strokeWidth;
  }

  @override
  int get hashCode => Object.hash(
        type,
        color,
        width,
        height,
        markerUnits,
        orient,
        strokeWidth,
      );

  FlowEdgeMarkerStyle lerp(FlowEdgeMarkerStyle other, double t) {
    return FlowEdgeMarkerStyle(
      type: t < 0.5 ? type : other.type,
      color: Color.lerp(color, other.color, t),
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
      markerUnits: t < 0.5 ? markerUnits : other.markerUnits,
      orient: t < 0.5 ? orient : other.orient,
      strokeWidth: lerpDouble(strokeWidth, other.strokeWidth, t),
    );
  }
}

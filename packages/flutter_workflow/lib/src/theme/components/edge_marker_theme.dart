import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

@immutable
class FlowEdgeMarkerStyle {
  final EdgeMarkerType type;
  final Color? color;
  final double width;
  final double height;
  final String markerUnits;
  final String orient;
  final double strokeWidth;

  const FlowEdgeMarkerStyle({
    this.type = EdgeMarkerType.arrow,
    this.color,
    this.width = 12.0,
    this.height = 12.0,
    this.markerUnits = "strokeWidth",
    this.orient = "auto",
    this.strokeWidth = 1.0,
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
      color: Color.lerp(color, other.color, t) ?? color,
      width: width + (other.width - width) * t,
      height: height + (other.height - height) * t,
      markerUnits: t < 0.5 ? markerUnits : other.markerUnits,
      orient: t < 0.5 ? orient : other.orient,
      strokeWidth: strokeWidth + (other.strokeWidth - strokeWidth) * t,
    );
  }
}

// Backward compatibility until downstream references migrate
typedef EdgeMarkerStyle = FlowEdgeMarkerStyle;

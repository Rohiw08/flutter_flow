import 'package:flutter/widgets.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

class EdgeMarkerStyle {
  final EdgeMarkerType type;
  final Color? color;
  final double width;
  final double height;
  final String markerUnits;
  final String orient;
  final double strokeWidth;

  const EdgeMarkerStyle({
    this.type = EdgeMarkerType.arrow,
    this.color,
    this.width = 12.0,
    this.height = 12.0,
    this.markerUnits = "strokeWidth",
    this.orient = "auto",
    this.strokeWidth = 1.0,
  });

  EdgeMarkerStyle copyWith({
    EdgeMarkerType? type,
    Color? color,
    double? width,
    double? height,
    String? markerUnits,
    String? orient,
    double? strokeWidth,
  }) {
    return EdgeMarkerStyle(
      type: type ?? this.type,
      color: color ?? this.color,
      width: width ?? this.width,
      height: height ?? this.height,
      markerUnits: markerUnits ?? this.markerUnits,
      orient: orient ?? this.orient,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}

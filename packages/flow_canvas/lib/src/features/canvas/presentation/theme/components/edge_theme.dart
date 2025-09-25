import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_label_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';

@immutable
class FlowEdgeStyle {
  final Color? defaultColor;
  final Color? selectedColor;
  final Color? animatedColor;
  final double? defaultStrokeWidth;
  final double? selectedStrokeWidth;
  final double? arrowHeadSize;
  final Color? hoverColor;
  final FlowEdgeLabelStyle? labelStyle;
  final FlowEdgeMarkerStyle? markerStyle;

  const FlowEdgeStyle({
    this.defaultColor,
    this.selectedColor,
    this.animatedColor,
    this.defaultStrokeWidth,
    this.selectedStrokeWidth,
    this.arrowHeadSize,
    this.hoverColor,
    this.labelStyle,
    this.markerStyle,
  });

  factory FlowEdgeStyle.light() {
    return FlowEdgeStyle(
      defaultColor: const Color(0xFF9E9E9E),
      selectedColor: const Color(0xFF2196F3),
      hoverColor: const Color(0xFF757575),
      animatedColor: const Color(0xFF4CAF50),
      defaultStrokeWidth: 2.0,
      selectedStrokeWidth: 3.0,
      arrowHeadSize: 8.0,
      labelStyle: FlowEdgeLabelStyle.light(),
      markerStyle: FlowEdgeMarkerStyle.light(),
    );
  }

  factory FlowEdgeStyle.dark() {
    return FlowEdgeStyle(
      defaultColor: const Color(0xFF616161),
      selectedColor: const Color(0xFF64B5F6),
      hoverColor: const Color(0xFF9E9E9E),
      animatedColor: const Color(0xFF81C784),
      defaultStrokeWidth: 2.0,
      selectedStrokeWidth: 3.0,
      arrowHeadSize: 8.0,
      labelStyle: FlowEdgeLabelStyle.dark(),
      markerStyle: FlowEdgeMarkerStyle.dark(),
    );
  }

  FlowEdgeStyle copyWith({
    Color? defaultColor,
    Color? selectedColor,
    Color? hoverColor,
    Color? animatedColor,
    double? defaultStrokeWidth,
    double? selectedStrokeWidth,
    double? arrowHeadSize,
    FlowEdgeLabelStyle? labelStyle,
    FlowEdgeMarkerStyle? markerStyle,
  }) {
    return FlowEdgeStyle(
      defaultColor: defaultColor ?? this.defaultColor,
      selectedColor: selectedColor ?? this.selectedColor,
      hoverColor: hoverColor ?? this.hoverColor,
      animatedColor: animatedColor ?? this.animatedColor,
      defaultStrokeWidth: defaultStrokeWidth ?? this.defaultStrokeWidth,
      selectedStrokeWidth: selectedStrokeWidth ?? this.selectedStrokeWidth,
      arrowHeadSize: arrowHeadSize ?? this.arrowHeadSize,
      labelStyle: labelStyle ?? this.labelStyle,
      markerStyle: markerStyle ?? this.markerStyle,
    );
  }

  FlowEdgeStyle lerp(FlowEdgeStyle other, double t) {
    return FlowEdgeStyle(
      defaultColor:
          Color.lerp(defaultColor, other.defaultColor, t) ?? defaultColor,
      selectedColor:
          Color.lerp(selectedColor, other.selectedColor, t) ?? selectedColor,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t) ?? hoverColor,
      animatedColor:
          Color.lerp(animatedColor, other.animatedColor, t) ?? animatedColor,
      defaultStrokeWidth:
          (defaultStrokeWidth == null || other.defaultStrokeWidth == null)
              ? (t < 0.5 ? defaultStrokeWidth : other.defaultStrokeWidth)
              : defaultStrokeWidth! +
                  (other.defaultStrokeWidth! - defaultStrokeWidth!) * t,
      selectedStrokeWidth:
          (selectedStrokeWidth == null || other.selectedStrokeWidth == null)
              ? (t < 0.5 ? selectedStrokeWidth : other.selectedStrokeWidth)
              : selectedStrokeWidth! +
                  (other.selectedStrokeWidth! - selectedStrokeWidth!) * t,
      arrowHeadSize: (arrowHeadSize == null || other.arrowHeadSize == null)
          ? (t < 0.5 ? arrowHeadSize : other.arrowHeadSize)
          : arrowHeadSize! + (other.arrowHeadSize! - arrowHeadSize!) * t,
      labelStyle: labelStyle == null && other.labelStyle == null
          ? null
          : (labelStyle ?? other.labelStyle)
              ?.lerp(other.labelStyle ?? labelStyle!, t),
      markerStyle: markerStyle == null && other.markerStyle == null
          ? null
          : (markerStyle ?? other.markerStyle)
              ?.lerp(other.markerStyle ?? markerStyle!, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowEdgeStyle &&
        other.defaultColor == defaultColor &&
        other.selectedColor == selectedColor &&
        other.hoverColor == hoverColor &&
        other.animatedColor == animatedColor &&
        other.defaultStrokeWidth == defaultStrokeWidth &&
        other.selectedStrokeWidth == selectedStrokeWidth &&
        other.arrowHeadSize == arrowHeadSize &&
        other.labelStyle == labelStyle &&
        other.markerStyle == markerStyle;
  }

  @override
  int get hashCode => Object.hash(
        defaultColor,
        selectedColor,
        hoverColor,
        animatedColor,
        defaultStrokeWidth,
        selectedStrokeWidth,
        arrowHeadSize,
        labelStyle,
        markerStyle,
      );
}

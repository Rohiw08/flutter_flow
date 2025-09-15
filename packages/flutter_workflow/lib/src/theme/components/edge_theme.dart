import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/theme/components/edge_label_theme.dart';
import 'package:flutter_workflow/src/theme/theme_extensions.dart';

@immutable
class FlowEdgeStyle {
  final Color defaultColor;
  final Color selectedColor;
  final Color animatedColor;
  final double defaultStrokeWidth;
  final double selectedStrokeWidth;
  final double arrowHeadSize;
  final FlowEdgeLabelStyle? labelStyle;
  final Color? hoverColor;

  const FlowEdgeStyle({
    required this.defaultColor,
    required this.selectedColor,
    required this.animatedColor,
    this.defaultStrokeWidth = 2.0,
    this.selectedStrokeWidth = 3.0,
    this.arrowHeadSize = 8.0,
    this.hoverColor,
    this.labelStyle,
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
        other.labelStyle == labelStyle;
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
      );

  FlowEdgeStyle lerp(FlowEdgeStyle other, double t) {
    return FlowEdgeStyle(
      defaultColor:
          Color.lerp(defaultColor, other.defaultColor, t) ?? defaultColor,
      selectedColor:
          Color.lerp(selectedColor, other.selectedColor, t) ?? selectedColor,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t) ?? hoverColor,
      animatedColor:
          Color.lerp(animatedColor, other.animatedColor, t) ?? animatedColor,
      defaultStrokeWidth: defaultStrokeWidth +
          (other.defaultStrokeWidth - defaultStrokeWidth) * t,
      selectedStrokeWidth: selectedStrokeWidth +
          (other.selectedStrokeWidth - selectedStrokeWidth) * t,
      arrowHeadSize: arrowHeadSize + (other.arrowHeadSize - arrowHeadSize) * t,
      labelStyle: labelStyle == null && other.labelStyle == null
          ? null
          : (labelStyle ?? other.labelStyle)
              ?.lerp(other.labelStyle ?? labelStyle!, t),
    );
  }

  FlowEdgeStyle resolveEdgeTheme(
    BuildContext context,
    FlowEdgeStyle? theme, {
    Color? defaultColor,
    Color? selectedColor,
    Color? animatedColor,
    Color? hoverColor,
    double? defaultStrokeWidth,
    double? selectedStrokeWidth,
    double? arrowHeadSize,
    FlowEdgeLabelStyle? labelStyle,
  }) {
    final base = theme ?? context.flowCanvasTheme.edge;
    return base.copyWith(
      defaultColor: defaultColor,
      selectedColor: selectedColor,
      animatedColor: animatedColor,
      hoverColor: hoverColor,
      defaultStrokeWidth: defaultStrokeWidth,
      selectedStrokeWidth: selectedStrokeWidth,
      arrowHeadSize: arrowHeadSize,
      labelStyle: labelStyle,
    );
  }
}

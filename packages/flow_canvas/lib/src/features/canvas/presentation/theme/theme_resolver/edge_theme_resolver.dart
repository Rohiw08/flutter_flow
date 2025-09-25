import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import '../components/edge_label_theme.dart';
import '../components/edge_theme.dart';

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
  FlowEdgeMarkerStyle? markeStyle,
}) {
  final contextTheme = context.flowCanvasTheme.edge;

  return contextTheme.copyWith(
    defaultColor: defaultColor ?? theme?.defaultColor,
    selectedColor: selectedColor ?? theme?.selectedColor,
    animatedColor: animatedColor ?? theme?.animatedColor,
    hoverColor: hoverColor ?? theme?.hoverColor,
    defaultStrokeWidth: defaultStrokeWidth ?? theme?.defaultStrokeWidth,
    selectedStrokeWidth: selectedStrokeWidth ?? theme?.selectedStrokeWidth,
    arrowHeadSize: arrowHeadSize ?? theme?.arrowHeadSize,
    labelStyle: labelStyle ?? theme?.labelStyle,
    markerStyle: markeStyle ?? theme?.markerStyle,
  );
}

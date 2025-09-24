import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/minimap_theme.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_extensions.dart';

FlowMinimapStyle resolveMiniMapTheme(
  BuildContext context,
  FlowMinimapStyle? theme, {
  Color? backgroundColor,
  Color? nodeColor,
  Color? nodeStrokeColor,
  double? nodeBorderRadius,
  Color? selectedNodeColor,
  Color? maskColor,
  Color? maskStrokeColor,
  double? nodeStrokeWidth,
  double? maskStrokeWidth,
  double? borderRadius,
  List<BoxShadow>? shadows,
  double? padding,
  double? viewportBorderRadius,
  Color? selectedGlowColor,
  double? selectedGlowBlur,
  double? selectedGlowWidthMultiplier,
  Color? viewportInnerGlowColor,
  double? viewportInnerGlowWidthMultiplier,
  double? viewportInnerGlowBlur,
  Color? viewportInnerColor,
}) {
  final contextTheme = context.flowCanvasTheme.minimap;

  return contextTheme.copyWith(
    backgroundColor: backgroundColor ?? theme?.backgroundColor,
    nodeColor: nodeColor ?? theme?.nodeColor,
    nodeStrokeColor: nodeStrokeColor ?? theme?.nodeStrokeColor,
    nodeBorderRadius: nodeBorderRadius ?? theme?.nodeBorderRadius,
    selectedNodeColor: selectedNodeColor ?? theme?.selectedNodeColor,
    maskColor: maskColor ?? theme?.maskColor,
    maskStrokeColor: maskStrokeColor ?? theme?.maskStrokeColor,
    nodeStrokeWidth: nodeStrokeWidth ?? theme?.nodeStrokeWidth,
    maskStrokeWidth: maskStrokeWidth ?? theme?.maskStrokeWidth,
    borderRadius: borderRadius ?? theme?.borderRadius,
    shadows: shadows ?? theme?.shadows,
    padding: padding ?? theme?.padding,
    viewportBorderRadius: viewportBorderRadius ?? theme?.viewportBorderRadius,
    selectedGlowColor: selectedGlowColor ?? theme?.selectedGlowColor,
    selectedGlowBlur: selectedGlowBlur ?? theme?.selectedGlowBlur,
    selectedGlowWidthMultiplier:
        selectedGlowWidthMultiplier ?? theme?.selectedGlowWidthMultiplier,
    viewportInnerGlowColor:
        viewportInnerGlowColor ?? theme?.viewportInnerGlowColor,
    viewportInnerGlowWidthMultiplier: viewportInnerGlowWidthMultiplier ??
        theme?.viewportInnerGlowWidthMultiplier,
    viewportInnerGlowBlur:
        viewportInnerGlowBlur ?? theme?.viewportInnerGlowBlur,
    viewportInnerColor: viewportInnerColor ?? theme?.viewportInnerColor,
  );
}

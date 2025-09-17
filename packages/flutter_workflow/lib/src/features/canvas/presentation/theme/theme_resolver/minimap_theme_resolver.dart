import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/minimap_theme.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_extensions.dart';

FlowMinimapStyle resolveMiniMapTheme(
  BuildContext context,
  FlowMinimapStyle? theme, {
  // Optional overrides if needed in future
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
  final base = theme ?? context.flowCanvasTheme.minimap;
  return base.copyWith(
    backgroundColor: backgroundColor,
    nodeColor: nodeColor,
    nodeStrokeColor: nodeStrokeColor,
    nodeBorderRadius: nodeBorderRadius,
    selectedNodeColor: selectedNodeColor,
    maskColor: maskColor,
    maskStrokeColor: maskStrokeColor,
    nodeStrokeWidth: nodeStrokeWidth,
    maskStrokeWidth: maskStrokeWidth,
    borderRadius: borderRadius,
    shadows: shadows,
    padding: padding,
    viewportBorderRadius: viewportBorderRadius,
    selectedGlowColor: selectedGlowColor,
    selectedGlowBlur: selectedGlowBlur,
    selectedGlowWidthMultiplier: selectedGlowWidthMultiplier,
    viewportInnerGlowColor: viewportInnerGlowColor,
    viewportInnerGlowWidthMultiplier: viewportInnerGlowWidthMultiplier,
    viewportInnerGlowBlur: viewportInnerGlowBlur,
    viewportInnerColor: viewportInnerColor,
  );
}

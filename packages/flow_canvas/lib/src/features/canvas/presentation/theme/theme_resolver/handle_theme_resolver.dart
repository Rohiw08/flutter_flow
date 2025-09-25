import 'package:flutter/material.dart';
import '../components/handle_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';

FlowHandleStyle resolveHandleTheme(
  BuildContext context,
  FlowHandleStyle? handleTheme, {
  Color? idleColor,
  Color? hoverColor,
  Color? activeColor,
  Color? validTargetColor,
  Color? invalidTargetColor,
  double? size,
  double? borderWidth,
  Color? borderColor,
  List<BoxShadow>? shadows,
  bool? enableAnimations,
}) {
  final contextTheme = context.flowCanvasTheme.handle;

  return contextTheme.copyWith(
    idleColor: idleColor ?? handleTheme?.idleColor,
    hoverColor: hoverColor ?? handleTheme?.hoverColor,
    activeColor: activeColor ?? handleTheme?.activeColor,
    validTargetColor: validTargetColor ?? handleTheme?.validTargetColor,
    invalidTargetColor: invalidTargetColor ?? handleTheme?.invalidTargetColor,
    size: size ?? handleTheme?.size,
    borderWidth: borderWidth ?? handleTheme?.borderWidth,
    borderColor: borderColor ?? handleTheme?.borderColor,
    shadows: shadows ?? handleTheme?.shadows,
    enableAnimations: enableAnimations ?? handleTheme?.enableAnimations,
  );
}

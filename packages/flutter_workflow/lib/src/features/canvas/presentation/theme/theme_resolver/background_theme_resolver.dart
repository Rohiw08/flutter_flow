import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_export.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

FlowBackgroundStyle resolveBackgroundTheme(
  BuildContext context,
  FlowBackgroundStyle? theme, {
  Color? backgroundColor,
  BackgroundVariant? pattern,
  Color? patternColor,
  double? gap,
  double? lineWidth,
  double? dotRadius,
  double? crossSize,
  bool? fadeOnZoom,
  Gradient? gradient,
  Offset? patternOffset,
  BlendMode? blendMode,
  List<Color>? alternateColors,
}) {
  final contextTheme = context.flowCanvasTheme.background;

  return contextTheme.copyWith(
    backgroundColor: backgroundColor ?? theme?.backgroundColor,
    variant: pattern ?? theme?.variant,
    patternColor: patternColor ?? theme?.patternColor,
    gap: gap ?? theme?.gap,
    lineWidth: lineWidth ?? theme?.lineWidth,
    dotRadius: dotRadius ?? theme?.dotRadius,
    crossSize: crossSize ?? theme?.crossSize,
    fadeOnZoom: fadeOnZoom ?? theme?.fadeOnZoom,
    gradient: gradient ?? theme?.gradient,
    patternOffset: patternOffset ?? theme?.patternOffset,
    blendMode: blendMode ?? theme?.blendMode,
    alternateColors: alternateColors ?? theme?.alternateColors,
  );
}

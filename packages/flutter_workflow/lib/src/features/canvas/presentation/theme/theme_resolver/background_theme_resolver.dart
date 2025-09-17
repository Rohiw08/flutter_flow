import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/background_theme.dart';
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
  final base = theme ?? FlowBackgroundStyle.light();
  return base.copyWith(
    backgroundColor: backgroundColor,
    variant: pattern,
    patternColor: patternColor,
    gap: gap,
    lineWidth: lineWidth,
    dotRadius: dotRadius,
    crossSize: crossSize,
    fadeOnZoom: fadeOnZoom,
    gradient: gradient,
    patternOffset: patternOffset,
    blendMode: blendMode,
    alternateColors: alternateColors,
  );
}

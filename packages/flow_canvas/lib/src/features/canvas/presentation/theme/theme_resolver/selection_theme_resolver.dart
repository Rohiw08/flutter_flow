import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import '../components/selection_theme.dart';

FlowSelectionStyle resolveSelectionTheme(
  BuildContext context,
  FlowSelectionStyle? selectionTheme, {
  Color? fillColor,
  Color? borderColor,
  double? borderWidth,
  double? dashLength,
  double? gapLength,
}) {
  final contextTheme = context.flowCanvasTheme.selection;

  return contextTheme.copyWith(
    fillColor: fillColor ?? selectionTheme?.fillColor,
    borderColor: borderColor ?? selectionTheme?.borderColor,
    borderWidth: borderWidth ?? selectionTheme?.borderWidth,
    dashLength: dashLength ?? selectionTheme?.dashLength,
    gapLength: gapLength ?? selectionTheme?.gapLength,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_extensions.dart';
import '../components/edge_label_theme.dart';

FlowEdgeLabelStyle resolveEdgeLabelTheme(
  BuildContext context,
  FlowEdgeLabelStyle? labelTheme, {
  TextStyle? textStyle,
  Color? backgroundColor,
  Color? borderColor,
  EdgeInsetsGeometry? padding,
  BorderRadius? borderRadius,
}) {
  // 1. Get the base theme from the context's edge style.
  final contextTheme = context.flowCanvasTheme.edgeLabel;

  // 2. Merge properties.
  return contextTheme.copyWith(
    textStyle: textStyle ?? labelTheme?.textStyle,
    backgroundColor: backgroundColor ?? labelTheme?.backgroundColor,
    borderColor: borderColor ?? labelTheme?.borderColor,
    padding: padding ?? labelTheme?.padding,
    borderRadius: borderRadius ?? labelTheme?.borderRadius,
  );
}

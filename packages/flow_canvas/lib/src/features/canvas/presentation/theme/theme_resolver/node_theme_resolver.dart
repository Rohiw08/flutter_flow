import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import '../components/node_theme.dart';

FlowNodeStyle resolveNodeTheme(
  BuildContext context,
  FlowNodeStyle? nodeTheme, {
  Color? defaultBackgroundColor,
  Color? defaultBorderColor,
  Color? selectedBackgroundColor,
  Color? selectedBorderColor,
  Color? errorBackgroundColor,
  Color? errorBorderColor,
  double? defaultBorderWidth,
  double? selectedBorderWidth,
  double? borderRadius,
  List<BoxShadow>? shadows,
  TextStyle? defaultTextStyle,
  Color? hoverBackgroundColor,
  Color? hoverBorderColor,
  Color? disabledBackgroundColor,
  Color? disabledBorderColor,
  double? hoverBorderWidth,
  Duration? animationDuration,
  Curve? animationCurve,
  EdgeInsetsGeometry? defaultPadding,
  double? minWidth,
  double? minHeight,
  double? maxWidth,
  double? maxHeight,
}) {
  final contextTheme = context.flowCanvasTheme.node;

  return contextTheme.copyWith(
    defaultBackgroundColor:
        defaultBackgroundColor ?? nodeTheme?.defaultBackgroundColor,
    defaultBorderColor: nodeTheme?.defaultBorderColor,
    selectedBackgroundColor: nodeTheme?.selectedBackgroundColor,
    selectedBorderColor: nodeTheme?.selectedBorderColor,
    errorBackgroundColor: nodeTheme?.errorBackgroundColor,
    errorBorderColor: nodeTheme?.errorBorderColor,
    defaultBorderWidth: nodeTheme?.defaultBorderWidth,
    selectedBorderWidth: nodeTheme?.selectedBorderWidth,
    borderRadius: nodeTheme?.borderRadius,
    shadows: nodeTheme?.shadows,
    defaultTextStyle: nodeTheme?.defaultTextStyle,
    hoverBackgroundColor: nodeTheme?.hoverBackgroundColor,
    hoverBorderColor: nodeTheme?.hoverBorderColor,
    disabledBackgroundColor: nodeTheme?.disabledBackgroundColor,
    disabledBorderColor: nodeTheme?.disabledBorderColor,
    hoverBorderWidth: nodeTheme?.hoverBorderWidth,
    animationDuration: nodeTheme?.animationDuration,
    animationCurve: nodeTheme?.animationCurve,
    defaultPadding: nodeTheme?.defaultPadding,
    minWidth: nodeTheme?.minWidth,
    minHeight: nodeTheme?.minHeight,
    maxWidth: nodeTheme?.maxWidth,
    maxHeight: nodeTheme?.maxHeight,
  );
}

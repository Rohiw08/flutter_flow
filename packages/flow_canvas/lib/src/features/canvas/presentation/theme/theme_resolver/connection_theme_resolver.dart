import 'package:flutter/material.dart';
import '../../../../../../flow_canvas.dart';

FlowConnectionStyle resolveConnectionTheme(
  BuildContext context,
  FlowConnectionStyle? theme, {
  Color? activeColor,
  Color? validTargetColor,
  Color? invalidTargetColor,
  double? strokeWidth,
  EdgePathType? pathType,
}) {
  final contextTheme = context.flowCanvasTheme.connection;
  return contextTheme.copyWith(
    activeColor: activeColor ?? theme?.activeColor,
    validTargetColor: validTargetColor ?? theme?.validTargetColor,
    invalidTargetColor: invalidTargetColor ?? theme?.invalidTargetColor,
    strokeWidth: strokeWidth ?? theme?.strokeWidth,
    pathType: pathType ?? theme?.pathType,
  );
}

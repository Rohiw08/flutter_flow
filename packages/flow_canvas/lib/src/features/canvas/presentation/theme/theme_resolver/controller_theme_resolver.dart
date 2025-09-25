import 'package:flutter/material.dart';
import '../theme_export.dart';

FlowCanvasControlsStyle resolveControlTheme(
  BuildContext context,
  FlowCanvasControlsStyle? controlsTheme, {
  Color? containerColor,
  Color? buttonColor,
  Color? buttonHoverColor,
  Color? iconColor,
  Color? iconHoverColor,
  double? buttonSize,
  double? buttonCornerRadius,
  double? containerCornerRadius,
  EdgeInsetsGeometry? padding,
  List<BoxShadow>? shadows,
  BoxDecoration? containerDecoration,
  BoxDecoration? buttonDecoration,
  BoxDecoration? buttonHoverDecoration,
  TextStyle? iconStyle,
  TextStyle? iconHoverStyle,
}) {
  final contextTheme = context.flowCanvasTheme.controls;

  return contextTheme.copyWith(
    containerColor: containerColor ?? controlsTheme?.containerColor,
    buttonColor: buttonColor ?? controlsTheme?.buttonColor,
    buttonHoverColor: buttonHoverColor ?? controlsTheme?.buttonHoverColor,
    iconColor: iconColor ?? controlsTheme?.iconColor,
    iconHoverColor: iconHoverColor ?? controlsTheme?.iconHoverColor,
    buttonSize: buttonSize ?? controlsTheme?.buttonSize,
    buttonCornerRadius: buttonCornerRadius ?? controlsTheme?.buttonCornerRadius,
    containerCornerRadius:
        containerCornerRadius ?? controlsTheme?.containerCornerRadius,
    padding: padding ?? controlsTheme?.padding,
    shadows: shadows ?? controlsTheme?.shadows,
    containerDecoration:
        containerDecoration ?? controlsTheme?.containerDecoration,
    buttonDecoration: buttonDecoration ?? controlsTheme?.buttonDecoration,
    buttonHoverDecoration:
        buttonHoverDecoration ?? controlsTheme?.buttonHoverDecoration,
    iconStyle: iconStyle ?? controlsTheme?.iconStyle,
    iconHoverStyle: iconHoverStyle ?? controlsTheme?.iconHoverStyle,
  );
}

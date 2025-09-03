import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/theme/components/control_theme.dart';
import 'package:flutter_workflow/src/theme/theme.dart';

FlowCanvasControlTheme resolveControlTheme(
  BuildContext context,
  FlowCanvasControlTheme? controlsTheme, {
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
  // First, try to get the provided theme
  FlowCanvasControlTheme base = controlsTheme ??
      // Then try to get from Flutter theme extension (assuming FlowCanvasTheme exists)
      _getThemeFromContext(context) ??
      // Finally fall back to light theme
      FlowCanvasControlTheme.light();

  return base.copyWith(
    containerColor: containerColor,
    buttonColor: buttonColor,
    buttonHoverColor: buttonHoverColor,
    iconColor: iconColor,
    iconHoverColor: iconHoverColor,
    buttonSize: buttonSize,
    buttonCornerRadius: buttonCornerRadius,
    containerCornerRadius: containerCornerRadius,
    padding: padding,
    shadows: shadows,
    containerDecoration: containerDecoration,
    buttonDecoration: buttonDecoration,
    buttonHoverDecoration: buttonHoverDecoration,
    iconStyle: iconStyle,
    iconHoverStyle: iconHoverStyle,
  );
}

// Helper function to extract theme from context
FlowCanvasControlTheme? _getThemeFromContext(BuildContext context) {
  try {
    // This assumes you have a FlowCanvasTheme extension
    // You'll need to implement this based on your theme structure
    final themeExtension = Theme.of(context).extension<FlowCanvasTheme>();
    return themeExtension?.controls;
  } catch (e) {
    // If FlowCanvasTheme doesn't exist, fall back to brightness-based theme
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowCanvasControlTheme.dark()
        : FlowCanvasControlTheme.light();
  }
}

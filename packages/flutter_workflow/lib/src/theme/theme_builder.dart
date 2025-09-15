import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/theme/components/edge_label_theme.dart';
import 'package:flutter_workflow/src/theme/flow_theme.dart';

class FlowCanvasThemeBuilder {
  FlowCanvasTheme _theme;

  FlowCanvasThemeBuilder([FlowCanvasTheme? baseTheme])
      : _theme = baseTheme ?? FlowCanvasTheme.light();

  FlowCanvasThemeBuilder.fromColorScheme(ColorScheme colorScheme)
      : _theme = FlowCanvasTheme.fromColorScheme(colorScheme);

  FlowCanvasThemeBuilder background({
    Color? backgroundColor,
    BackgroundVariant? variant,
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
    _theme = _theme.copyWith(
      background: _theme.background.copyWith(
        backgroundColor: backgroundColor,
        variant: variant,
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
      ),
    );
    return this;
  }

  FlowCanvasThemeBuilder nodes({
    Color? defaultBackgroundColor,
    Color? defaultBorderColor,
    Color? selectedBackgroundColor,
    Color? selectedBorderColor,
    Color? errorBackgroundColor,
    Color? errorBorderColor,
    Color? hoverBackgroundColor,
    Color? hoverBorderColor,
    double? borderRadius,
    double? defaultBorderWidth,
    double? selectedBorderWidth,
    TextStyle? defaultTextStyle,
    EdgeInsets? defaultPadding,
    List<BoxShadow>? shadows,
  }) {
    _theme = _theme.copyWith(
      node: _theme.node.copyWith(
        defaultBackgroundColor: defaultBackgroundColor,
        defaultBorderColor: defaultBorderColor,
        selectedBackgroundColor: selectedBackgroundColor,
        selectedBorderColor: selectedBorderColor,
        errorBackgroundColor: errorBackgroundColor,
        errorBorderColor: errorBorderColor,
        hoverBackgroundColor: hoverBackgroundColor,
        hoverBorderColor: hoverBorderColor,
        borderRadius: borderRadius,
        defaultBorderWidth: defaultBorderWidth,
        selectedBorderWidth: selectedBorderWidth,
        defaultTextStyle: defaultTextStyle,
        defaultPadding: defaultPadding,
        shadows: shadows,
      ),
    );
    return this;
  }

  FlowCanvasThemeBuilder edges({
    Color? defaultColor,
    Color? selectedColor,
    Color? animatedColor,
    double? defaultStrokeWidth,
    double? selectedStrokeWidth,
    double? arrowHeadSize,
    FlowEdgeLabelStyle? label,
  }) {
    _theme = _theme.copyWith(
      edge: _theme.edge.copyWith(
        defaultColor: defaultColor,
        selectedColor: selectedColor,
        animatedColor: animatedColor,
        defaultStrokeWidth: defaultStrokeWidth,
        selectedStrokeWidth: selectedStrokeWidth,
        arrowHeadSize: arrowHeadSize,
        labelStyle: label,
      ),
    );
    return this;
  }

  FlowCanvasThemeBuilder handles({
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
    _theme = _theme.copyWith(
      handle: _theme.handle.copyWith(
        idleColor: idleColor,
        hoverColor: hoverColor,
        activeColor: activeColor,
        validTargetColor: validTargetColor,
        invalidTargetColor: invalidTargetColor,
        size: size,
        borderWidth: borderWidth,
        borderColor: borderColor,
        shadows: shadows,
        enableAnimations: enableAnimations,
      ),
    );
    return this;
  }

  FlowCanvasThemeBuilder miniMap(
      {Color? backgroundColor,
      Color? nodeColor,
      Color? nodeStrokeColor,
      Color? selectedNodeColor,
      Color? maskColor,
      Color? maskStrokeColor,
      double? nodeStrokeWidth,
      double? maskStrokeWidth,
      double? borderRadius,
      List<BoxShadow>? shadows}) {
    _theme = _theme.copyWith(
      minimap: _theme.minimap.copyWith(
        backgroundColor: backgroundColor,
        nodeColor: nodeColor,
        nodeStrokeColor: nodeStrokeColor,
        selectedNodeColor: selectedNodeColor,
        maskColor: maskColor,
        maskStrokeColor: maskStrokeColor,
        nodeStrokeWidth: nodeStrokeWidth,
        maskStrokeWidth: maskStrokeWidth,
        borderRadius: borderRadius,
        shadows: shadows,
      ),
    );
    return this;
  }

  FlowCanvasThemeBuilder selection({
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    double? dashLength,
    double? gapLength,
  }) {
    _theme = _theme.copyWith(
      selection: _theme.selection.copyWith(
        fillColor: fillColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        dashLength: dashLength,
        gapLength: gapLength,
      ),
    );
    return this;
  }

  FlowCanvasThemeBuilder controls({
    // Simple properties
    Color? containerColor,
    Color? buttonColor,
    Color? buttonHoverColor,
    Color? iconColor,
    Color? iconHoverColor,
    double? buttonSize,
    Size? containerSize,
    double? buttonCornerRadius,
    double? containerCornerRadius,
    EdgeInsetsGeometry? padding,
    List<BoxShadow>? shadows,

    // Advanced properties
    BoxDecoration? containerDecoration,
    BoxDecoration? buttonDecoration,
    BoxDecoration? buttonHoverDecoration,
    TextStyle? iconStyle,
    TextStyle? iconHoverStyle,
  }) {
    _theme = _theme.copyWith(
      controls: _theme.controls.copyWith(
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
      ),
    );
    return this;
  }

  FlowCanvasTheme build() => _theme;
}

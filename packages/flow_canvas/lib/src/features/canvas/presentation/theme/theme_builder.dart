import 'package:flutter/material.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_label_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';

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
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    double? defaultBorderWidth,
    double? selectedBorderWidth,
    double? hoverBorderWidth,
    double? borderRadius,
    List<BoxShadow>? shadows,
    TextStyle? defaultTextStyle,
    Duration? animationDuration,
    Curve? animationCurve,
    EdgeInsetsGeometry? defaultPadding,
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
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
        disabledBackgroundColor: disabledBackgroundColor,
        disabledBorderColor: disabledBorderColor,
        defaultBorderWidth: defaultBorderWidth,
        selectedBorderWidth: selectedBorderWidth,
        hoverBorderWidth: hoverBorderWidth,
        borderRadius: borderRadius,
        shadows: shadows,
        defaultTextStyle: defaultTextStyle,
        animationDuration: animationDuration,
        animationCurve: animationCurve,
        defaultPadding: defaultPadding,
        minWidth: minWidth,
        minHeight: minHeight,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
    );
    return this;
  }

  FlowCanvasThemeBuilder edges({
    Color? defaultColor,
    Color? selectedColor,
    Color? hoverColor,
    Color? animatedColor,
    double? defaultStrokeWidth,
    double? selectedStrokeWidth,
    double? arrowHeadSize,
    FlowEdgeLabelStyle? label,
    FlowEdgeMarkerStyle? marker,
  }) {
    _theme = _theme.copyWith(
      edge: _theme.edge.copyWith(
        defaultColor: defaultColor,
        selectedColor: selectedColor,
        hoverColor: hoverColor,
        animatedColor: animatedColor,
        defaultStrokeWidth: defaultStrokeWidth,
        selectedStrokeWidth: selectedStrokeWidth,
        arrowHeadSize: arrowHeadSize,
        labelStyle: label,
        markerStyle: marker,
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

  FlowCanvasThemeBuilder miniMap({
    Color? backgroundColor,
    Color? nodeColor,
    Color? nodeStrokeColor,
    double? nodeBorderRadius,
    Color? selectedNodeColor,
    Color? maskColor,
    Color? maskStrokeColor,
    double? nodeStrokeWidth,
    double? maskStrokeWidth,
    double? borderRadius,
    List<BoxShadow>? shadows,
    double? padding,
    double? viewportBorderRadius,
    Color? selectedGlowColor,
    double? selectedGlowBlur,
    double? selectedGlowWidthMultiplier,
    Color? viewportInnerGlowColor,
    double? viewportInnerGlowWidthMultiplier,
    double? viewportInnerGlowBlur,
    Color? viewportInnerColor,
  }) {
    _theme = _theme.copyWith(
      minimap: _theme.minimap.copyWith(
        backgroundColor: backgroundColor,
        nodeColor: nodeColor,
        nodeStrokeColor: nodeStrokeColor,
        nodeBorderRadius: nodeBorderRadius,
        selectedNodeColor: selectedNodeColor,
        maskColor: maskColor,
        maskStrokeColor: maskStrokeColor,
        nodeStrokeWidth: nodeStrokeWidth,
        maskStrokeWidth: maskStrokeWidth,
        borderRadius: borderRadius,
        shadows: shadows,
        padding: padding,
        viewportBorderRadius: viewportBorderRadius,
        selectedGlowColor: selectedGlowColor,
        selectedGlowBlur: selectedGlowBlur,
        selectedGlowWidthMultiplier: selectedGlowWidthMultiplier,
        viewportInnerGlowColor: viewportInnerGlowColor,
        viewportInnerGlowWidthMultiplier: viewportInnerGlowWidthMultiplier,
        viewportInnerGlowBlur: viewportInnerGlowBlur,
        viewportInnerColor: viewportInnerColor,
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

  FlowCanvasThemeBuilder connection({
    Color? activeColor,
    Color? validTargetColor,
    Color? invalidTargetColor,
    double? strokeWidth,
    EdgePathType? pathType,
  }) {
    _theme = _theme.copyWith(
      connection: _theme.connection.copyWith(
        activeColor: activeColor,
        validTargetColor: validTargetColor,
        invalidTargetColor: invalidTargetColor,
        strokeWidth: strokeWidth,
        pathType: pathType,
      ),
    );
    return this;
  }

  FlowCanvasThemeBuilder edgeMarker({
    EdgeMarkerType? type,
    Color? color,
    double? width,
    double? height,
    String? markerUnits,
    String? orient,
    double? strokeWidth,
  }) {
    _theme = _theme.copyWith(
      edgeMarker: _theme.edgeMarker.copyWith(
        type: type,
        color: color,
        width: width,
        height: height,
        markerUnits: markerUnits,
        orient: orient,
        strokeWidth: strokeWidth,
      ),
    );
    return this;
  }

  FlowCanvasThemeBuilder edgeLabel({
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    _theme = _theme.copyWith(
      edgeLabel: _theme.edgeLabel.copyWith(
        textStyle: textStyle,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        padding: padding,
        borderRadius: borderRadius,
      ),
    );
    return this;
  }

  FlowCanvasTheme build() => _theme;
}

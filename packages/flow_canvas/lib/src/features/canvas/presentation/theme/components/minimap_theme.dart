import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class FlowMinimapStyle extends ThemeExtension<FlowMinimapStyle> {
  final Color? backgroundColor;
  final Color? nodeColor;
  final Color? nodeStrokeColor;
  final double? nodeBorderRadius;
  final Color? selectedNodeColor;
  final Color? maskColor;
  final Color? maskStrokeColor;
  final double? nodeStrokeWidth;
  final double? maskStrokeWidth;
  final double? borderRadius;
  final List<BoxShadow>? shadows;

  // Extra properties
  final double? padding;
  final double? viewportInnerGlowBlur;
  final double? viewportBorderRadius;
  final Color? selectedGlowColor;
  final double? selectedGlowBlur;
  final double? selectedGlowWidthMultiplier;
  final Color? viewportInnerGlowColor;
  final double? viewportInnerGlowWidthMultiplier;
  final Color? viewportInnerColor;

  const FlowMinimapStyle({
    this.backgroundColor,
    this.nodeColor,
    this.nodeStrokeColor,
    this.selectedNodeColor,
    this.maskColor,
    this.maskStrokeColor,
    this.nodeStrokeWidth,
    this.maskStrokeWidth,
    this.borderRadius,
    this.shadows,
    this.nodeBorderRadius,
    this.padding,
    this.viewportBorderRadius,
    this.selectedGlowColor,
    this.selectedGlowBlur,
    this.selectedGlowWidthMultiplier,
    this.viewportInnerGlowColor,
    this.viewportInnerGlowWidthMultiplier,
    this.viewportInnerGlowBlur,
    this.viewportInnerColor,
  });

  /// Light preset
  factory FlowMinimapStyle.light() {
    return const FlowMinimapStyle(
      backgroundColor: Colors.white,
      nodeColor: Color(0xFF2196F3),
      nodeStrokeColor: Color(0xFF1976D2),
      nodeBorderRadius: 4.0,
      selectedNodeColor: Color(0xFFFF9800),
      maskColor: Color(0x99F0F2F5),
      maskStrokeColor: Color(0xFF9E9E9E),
      nodeStrokeWidth: 1.5,
      maskStrokeWidth: 1.0,
      borderRadius: 8.0,
      shadows: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      padding: 10.0,
      viewportInnerGlowBlur: 0.0,
      viewportBorderRadius: 2.0,
      selectedGlowColor: Color(0x4CFF9800),
      selectedGlowBlur: 2.0,
      selectedGlowWidthMultiplier: 2.0,
      viewportInnerGlowColor: Colors.transparent,
      viewportInnerGlowWidthMultiplier: 0.5,
      viewportInnerColor: Colors.transparent,
    );
  }

  /// Dark preset
  factory FlowMinimapStyle.dark() {
    return const FlowMinimapStyle(
      backgroundColor: Color(0xFF1E1E1E),
      nodeColor: Color(0xFF90CAF9),
      nodeStrokeColor: Color(0xFF64B5F6),
      nodeBorderRadius: 4.0,
      selectedNodeColor: Color(0xFFFFB74D),
      maskColor: Color(0x66121212),
      maskStrokeColor: Color(0xFFBDBDBD),
      nodeStrokeWidth: 1.5,
      maskStrokeWidth: 1.0,
      borderRadius: 8.0,
      shadows: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
      padding: 10.0,
      viewportInnerGlowBlur: 0.0,
      viewportBorderRadius: 2.0,
      selectedGlowColor: Color(0x4CFFB74D),
      selectedGlowBlur: 2.0,
      selectedGlowWidthMultiplier: 2.0,
      viewportInnerGlowColor: Color(0x4CFFFFFF),
      viewportInnerGlowWidthMultiplier: 0.5,
      viewportInnerColor: Colors.transparent,
    );
  }

  @override
  FlowMinimapStyle copyWith({
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
    double? viewportInnerGlowBlur,
    double? viewportBorderRadius,
    Color? selectedGlowColor,
    double? selectedGlowBlur,
    double? selectedGlowWidthMultiplier,
    Color? viewportInnerGlowColor,
    double? viewportInnerGlowWidthMultiplier,
    Color? viewportInnerColor,
  }) {
    return FlowMinimapStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      nodeColor: nodeColor ?? this.nodeColor,
      nodeStrokeColor: nodeStrokeColor ?? this.nodeStrokeColor,
      nodeBorderRadius: nodeBorderRadius ?? this.nodeBorderRadius,
      selectedNodeColor: selectedNodeColor ?? this.selectedNodeColor,
      maskColor: maskColor ?? this.maskColor,
      maskStrokeColor: maskStrokeColor ?? this.maskStrokeColor,
      nodeStrokeWidth: nodeStrokeWidth ?? this.nodeStrokeWidth,
      maskStrokeWidth: maskStrokeWidth ?? this.maskStrokeWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      padding: padding ?? this.padding,
      viewportInnerGlowBlur:
          viewportInnerGlowBlur ?? this.viewportInnerGlowBlur,
      viewportBorderRadius: viewportBorderRadius ?? this.viewportBorderRadius,
      selectedGlowColor: selectedGlowColor ?? this.selectedGlowColor,
      selectedGlowBlur: selectedGlowBlur ?? this.selectedGlowBlur,
      selectedGlowWidthMultiplier:
          selectedGlowWidthMultiplier ?? this.selectedGlowWidthMultiplier,
      viewportInnerGlowColor:
          viewportInnerGlowColor ?? this.viewportInnerGlowColor,
      viewportInnerGlowWidthMultiplier: viewportInnerGlowWidthMultiplier ??
          this.viewportInnerGlowWidthMultiplier,
    );
  }

  @override
  FlowMinimapStyle lerp(ThemeExtension<FlowMinimapStyle>? other, double t) {
    if (other is! FlowMinimapStyle) return this;

    return FlowMinimapStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      nodeColor: Color.lerp(nodeColor, other.nodeColor, t),
      nodeStrokeColor: Color.lerp(nodeStrokeColor, other.nodeStrokeColor, t),
      nodeBorderRadius: lerpDouble(nodeBorderRadius, other.nodeBorderRadius, t),
      selectedNodeColor:
          Color.lerp(selectedNodeColor, other.selectedNodeColor, t),
      maskColor: Color.lerp(maskColor, other.maskColor, t),
      maskStrokeColor: Color.lerp(maskStrokeColor, other.maskStrokeColor, t),
      nodeStrokeWidth: lerpDouble(nodeStrokeWidth, other.nodeStrokeWidth, t),
      maskStrokeWidth: lerpDouble(maskStrokeWidth, other.maskStrokeWidth, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      shadows: _lerpShadows(shadows ?? const [], other.shadows ?? const [], t),
      padding: lerpDouble(padding, other.padding, t),
      viewportInnerGlowBlur:
          lerpDouble(viewportInnerGlowBlur, other.viewportInnerGlowBlur, t),
      viewportBorderRadius:
          lerpDouble(viewportBorderRadius, other.viewportBorderRadius, t),
      selectedGlowColor:
          Color.lerp(selectedGlowColor, other.selectedGlowColor, t),
      selectedGlowBlur: lerpDouble(selectedGlowBlur, other.selectedGlowBlur, t),
      selectedGlowWidthMultiplier: lerpDouble(
          selectedGlowWidthMultiplier, other.selectedGlowWidthMultiplier, t),
      viewportInnerGlowColor:
          Color.lerp(viewportInnerGlowColor, other.viewportInnerGlowColor, t),
      viewportInnerGlowWidthMultiplier: lerpDouble(
          viewportInnerGlowWidthMultiplier,
          other.viewportInnerGlowWidthMultiplier,
          t),
      viewportInnerColor:
          Color.lerp(viewportInnerColor, other.viewportInnerColor, t),
    );
  }

  static List<BoxShadow> _lerpShadows(
      List<BoxShadow> a, List<BoxShadow> b, double t) {
    if (a.length != b.length) return t < 0.5 ? a : b;
    return List.generate(a.length, (i) => BoxShadow.lerp(a[i], b[i], t)!);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FlowMinimapStyle &&
            runtimeType == other.runtimeType &&
            backgroundColor == other.backgroundColor &&
            nodeColor == other.nodeColor &&
            nodeStrokeColor == other.nodeStrokeColor &&
            nodeBorderRadius == other.nodeBorderRadius &&
            selectedNodeColor == other.selectedNodeColor &&
            maskColor == other.maskColor &&
            maskStrokeColor == other.maskStrokeColor &&
            nodeStrokeWidth == other.nodeStrokeWidth &&
            maskStrokeWidth == other.maskStrokeWidth &&
            borderRadius == other.borderRadius &&
            listEquals(shadows, other.shadows) &&
            padding == other.padding &&
            viewportBorderRadius == other.viewportBorderRadius &&
            selectedGlowColor == other.selectedGlowColor &&
            selectedGlowBlur == other.selectedGlowBlur &&
            selectedGlowWidthMultiplier == other.selectedGlowWidthMultiplier &&
            viewportInnerGlowColor == other.viewportInnerGlowColor &&
            viewportInnerGlowWidthMultiplier ==
                other.viewportInnerGlowWidthMultiplier &&
            viewportInnerGlowBlur == other.viewportInnerGlowBlur &&
            viewportInnerColor == other.viewportInnerColor;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        nodeColor,
        nodeStrokeColor,
        nodeBorderRadius,
        selectedNodeColor,
        maskColor,
        maskStrokeColor,
        nodeStrokeWidth,
        maskStrokeWidth,
        borderRadius,
        Object.hashAll(shadows!),
        padding,
        viewportBorderRadius,
        selectedGlowColor,
        selectedGlowBlur,
        selectedGlowWidthMultiplier,
        viewportInnerGlowColor,
        viewportInnerGlowWidthMultiplier,
        viewportInnerGlowBlur,
        viewportInnerColor,
      );
}

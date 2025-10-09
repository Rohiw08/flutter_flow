import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class FlowMinimapStyle extends ThemeExtension<FlowMinimapStyle> {
  final Color backgroundColor;
  final Color nodeColor;
  final Color nodeStrokeColor;
  final double nodeBorderRadius; // Changed
  final Color selectedNodeColor;
  final Color maskColor;
  final Color maskStrokeColor;
  final double nodeStrokeWidth; // Changed
  final double maskStrokeWidth;
  final double borderRadius;
  final List<BoxShadow> shadows;
  final double padding;
  final double viewportInnerGlowBlur;
  final double viewportBorderRadius;
  final Color selectedGlowColor;
  final double selectedGlowBlur;
  final double selectedGlowWidthMultiplier;
  final Color viewportInnerGlowColor;
  final double viewportInnerGlowWidthMultiplier;
  final Color viewportInnerColor;

  const FlowMinimapStyle({
    this.backgroundColor = Colors.white,
    this.nodeColor = const Color(0xFF2196F3),
    this.nodeStrokeColor = const Color(0xFF1976D2),
    this.nodeBorderRadius = 2.0, // Changed
    this.selectedNodeColor = const Color(0xFFFF9800),
    this.maskColor = const Color(0x99F0F2F5),
    this.maskStrokeColor = const Color(0xFF9E9E9E),
    this.nodeStrokeWidth = 1.0, // Changed
    this.maskStrokeWidth = 0,
    this.borderRadius = 8.0,
    this.shadows = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    this.padding = 10.0,
    this.viewportInnerGlowBlur = 0.0,
    this.viewportBorderRadius = 2.0,
    this.selectedGlowColor = const Color(0x4CFF9800),
    this.selectedGlowBlur = 2.0,
    this.selectedGlowWidthMultiplier = 2.0,
    this.viewportInnerGlowColor = Colors.transparent,
    this.viewportInnerGlowWidthMultiplier = 0.5,
    this.viewportInnerColor = Colors.transparent,
  });

  factory FlowMinimapStyle.light() {
    return const FlowMinimapStyle();
  }

  factory FlowMinimapStyle.dark() {
    return const FlowMinimapStyle(
      backgroundColor: Color(0xFF1E1E1E),
      nodeColor: Color(0xFF90CAF9),
      nodeStrokeColor: Color(0xFF64B5F6),
      selectedNodeColor: Color(0xFFFFB74D),
      maskColor: Color(0x66121212),
      maskStrokeColor: Color(0xFFBDBDBD),
      shadows: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
      selectedGlowColor: Color(0x4CFFB74D),
      viewportInnerGlowColor: Color(0x4CFFFFFF),
    );
  }

  FlowMinimapStyle merge(FlowMinimapStyle? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      nodeColor: other.nodeColor,
      nodeStrokeColor: other.nodeStrokeColor,
      nodeBorderRadius: other.nodeBorderRadius,
      selectedNodeColor: other.selectedNodeColor,
      maskColor: other.maskColor,
      maskStrokeColor: other.maskStrokeColor,
      nodeStrokeWidth: other.nodeStrokeWidth,
      maskStrokeWidth: other.maskStrokeWidth,
      borderRadius: other.borderRadius,
      shadows: other.shadows,
      padding: other.padding,
      viewportBorderRadius: other.viewportBorderRadius,
      selectedGlowColor: other.selectedGlowColor,
      selectedGlowBlur: other.selectedGlowBlur,
      selectedGlowWidthMultiplier: other.selectedGlowWidthMultiplier,
      viewportInnerGlowColor: other.viewportInnerGlowColor,
      viewportInnerGlowWidthMultiplier: other.viewportInnerGlowWidthMultiplier,
      viewportInnerGlowBlur: other.viewportInnerGlowBlur,
      viewportInnerColor: other.viewportInnerColor,
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
      viewportInnerColor: viewportInnerColor ?? this.viewportInnerColor,
    );
  }

  @override
  FlowMinimapStyle lerp(ThemeExtension<FlowMinimapStyle>? other, double t) {
    if (other is! FlowMinimapStyle) return this;
    return FlowMinimapStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      nodeColor: Color.lerp(nodeColor, other.nodeColor, t)!,
      nodeStrokeColor: Color.lerp(nodeStrokeColor, other.nodeStrokeColor, t)!,
      nodeBorderRadius:
          lerpDouble(nodeBorderRadius, other.nodeBorderRadius, t)!,
      selectedNodeColor:
          Color.lerp(selectedNodeColor, other.selectedNodeColor, t)!,
      maskColor: Color.lerp(maskColor, other.maskColor, t)!,
      maskStrokeColor: Color.lerp(maskStrokeColor, other.maskStrokeColor, t)!,
      nodeStrokeWidth: lerpDouble(nodeStrokeWidth, other.nodeStrokeWidth, t)!,
      maskStrokeWidth: lerpDouble(maskStrokeWidth, other.maskStrokeWidth, t)!,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      shadows: BoxShadow.lerpList(shadows, other.shadows, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      viewportInnerGlowBlur:
          lerpDouble(viewportInnerGlowBlur, other.viewportInnerGlowBlur, t)!,
      viewportBorderRadius:
          lerpDouble(viewportBorderRadius, other.viewportBorderRadius, t)!,
      selectedGlowColor:
          Color.lerp(selectedGlowColor, other.selectedGlowColor, t)!,
      selectedGlowBlur:
          lerpDouble(selectedGlowBlur, other.selectedGlowBlur, t)!,
      selectedGlowWidthMultiplier: lerpDouble(
          selectedGlowWidthMultiplier, other.selectedGlowWidthMultiplier, t)!,
      viewportInnerGlowColor:
          Color.lerp(viewportInnerGlowColor, other.viewportInnerGlowColor, t)!,
      viewportInnerGlowWidthMultiplier: lerpDouble(
          viewportInnerGlowWidthMultiplier,
          other.viewportInnerGlowWidthMultiplier,
          t)!,
      viewportInnerColor:
          Color.lerp(viewportInnerColor, other.viewportInnerColor, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
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

  @override
  int get hashCode => Object.hashAll([
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
        Object.hashAll(shadows),
        padding,
        viewportBorderRadius,
        selectedGlowColor,
        selectedGlowBlur,
        selectedGlowWidthMultiplier,
        viewportInnerGlowColor,
        viewportInnerGlowWidthMultiplier,
        viewportInnerGlowBlur,
        viewportInnerColor,
      ]);
}

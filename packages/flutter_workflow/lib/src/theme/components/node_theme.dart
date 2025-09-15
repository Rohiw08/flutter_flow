import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';

@immutable
class FlowNodeStyle {
  final Color defaultBackgroundColor;
  final Color defaultBorderColor;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color errorBackgroundColor;
  final Color errorBorderColor;
  final double defaultBorderWidth;
  final double selectedBorderWidth;
  final double borderRadius;
  final List<BoxShadow> shadows;
  final TextStyle defaultTextStyle;

  // Enhanced properties
  final Color? hoverBackgroundColor;
  final Color? hoverBorderColor;
  final Color? disabledBackgroundColor;
  final Color? disabledBorderColor;
  final double? hoverBorderWidth;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry defaultPadding;
  final double? minWidth;
  final double? minHeight;
  final double? maxWidth;
  final double? maxHeight;

  const FlowNodeStyle({
    required this.defaultBackgroundColor,
    required this.defaultBorderColor,
    required this.selectedBackgroundColor,
    required this.selectedBorderColor,
    required this.errorBackgroundColor,
    required this.errorBorderColor,
    this.defaultBorderWidth = 1.0,
    this.selectedBorderWidth = 2.0,
    this.borderRadius = 8.0,
    this.shadows = const [],
    required this.defaultTextStyle,
    this.hoverBackgroundColor,
    this.hoverBorderColor,
    this.disabledBackgroundColor,
    this.disabledBorderColor,
    this.hoverBorderWidth,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.defaultPadding = const EdgeInsetsGeometry.all(12.0),
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
  });

  factory FlowNodeStyle.light() {
    return FlowNodeStyle(
      defaultBackgroundColor: Colors.white,
      defaultBorderColor: const Color(0xFFE0E0E0),
      selectedBackgroundColor: const Color(0xFFF0F8FF),
      selectedBorderColor: const Color(0xFF2196F3),
      errorBackgroundColor: const Color(0xFFFFEBEE),
      errorBorderColor: const Color(0xFFE57373),
      hoverBackgroundColor: const Color(0xFFF8F9FA),
      hoverBorderColor: const Color(0xFFB0B0B0),
      disabledBackgroundColor: const Color(0xFFF5F5F5),
      disabledBorderColor: const Color(0xFFE0E0E0),
      defaultBorderWidth: 1.0,
      selectedBorderWidth: 2.0,
      hoverBorderWidth: 1.5,
      borderRadius: 8.0,
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      defaultTextStyle: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      defaultPadding: const EdgeInsetsGeometry.all(12.0),
      minWidth: 100.0,
      minHeight: 60.0,
    );
  }

  factory FlowNodeStyle.dark() {
    return FlowNodeStyle(
      defaultBackgroundColor: const Color(0xFF2D2D2D),
      defaultBorderColor: const Color(0xFF404040),
      selectedBackgroundColor: const Color(0xFF1E3A5F),
      selectedBorderColor: const Color(0xFF64B5F6),
      errorBackgroundColor: const Color(0xFF3D1A1A),
      errorBorderColor: const Color(0xFFEF5350),
      hoverBackgroundColor: const Color(0xFF3A3A3A),
      hoverBorderColor: const Color(0xFF565656),
      disabledBackgroundColor: const Color(0xFF1A1A1A),
      disabledBorderColor: const Color(0xFF2A2A2A),
      defaultBorderWidth: 1.0,
      selectedBorderWidth: 2.0,
      hoverBorderWidth: 1.5,
      borderRadius: 8.0,
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(77),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      defaultTextStyle: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      defaultPadding: const EdgeInsetsGeometry.all(12.0),
      minWidth: 100.0,
      minHeight: 60.0,
    );
  }

  /// Get node style for specific state
  NodeStyleData getStyleForState({
    bool isSelected = false,
    bool isHovered = false,
    bool isDisabled = false,
    bool hasError = false,
  }) {
    Color backgroundColor;
    Color borderColor;
    double borderWidth;

    if (hasError) {
      backgroundColor = errorBackgroundColor;
      borderColor = errorBorderColor;
      borderWidth = selectedBorderWidth;
    } else if (isDisabled) {
      backgroundColor = disabledBackgroundColor ?? defaultBackgroundColor;
      borderColor = disabledBorderColor ?? defaultBorderColor;
      borderWidth = defaultBorderWidth;
    } else if (isSelected) {
      backgroundColor = selectedBackgroundColor;
      borderColor = selectedBorderColor;
      borderWidth = selectedBorderWidth;
    } else if (isHovered) {
      backgroundColor = hoverBackgroundColor ?? defaultBackgroundColor;
      borderColor = hoverBorderColor ?? defaultBorderColor;
      borderWidth = hoverBorderWidth ?? defaultBorderWidth;
    } else {
      backgroundColor = defaultBackgroundColor;
      borderColor = defaultBorderColor;
      borderWidth = defaultBorderWidth;
    }

    return NodeStyleData(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      shadows: shadows,
      textStyle: defaultTextStyle,
      padding: defaultPadding,
    );
  }

  FlowNodeStyle copyWith({
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
    EdgeInsets? defaultPadding,
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
  }) {
    return FlowNodeStyle(
      defaultBackgroundColor:
          defaultBackgroundColor ?? this.defaultBackgroundColor,
      defaultBorderColor: defaultBorderColor ?? this.defaultBorderColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      errorBackgroundColor: errorBackgroundColor ?? this.errorBackgroundColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      hoverBackgroundColor: hoverBackgroundColor ?? this.hoverBackgroundColor,
      hoverBorderColor: hoverBorderColor ?? this.hoverBorderColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      defaultBorderWidth: defaultBorderWidth ?? this.defaultBorderWidth,
      selectedBorderWidth: selectedBorderWidth ?? this.selectedBorderWidth,
      hoverBorderWidth: hoverBorderWidth ?? this.hoverBorderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      defaultTextStyle: defaultTextStyle ?? this.defaultTextStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      defaultPadding: defaultPadding ?? this.defaultPadding,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowNodeStyle &&
        other.defaultBackgroundColor == defaultBackgroundColor &&
        other.defaultBorderColor == defaultBorderColor &&
        other.selectedBackgroundColor == selectedBackgroundColor &&
        other.selectedBorderColor == selectedBorderColor &&
        other.errorBackgroundColor == errorBackgroundColor &&
        other.errorBorderColor == errorBorderColor &&
        other.defaultBorderWidth == defaultBorderWidth &&
        other.selectedBorderWidth == selectedBorderWidth &&
        other.borderRadius == borderRadius &&
        listEquals(other.shadows, shadows) &&
        other.defaultTextStyle == defaultTextStyle &&
        other.hoverBackgroundColor == hoverBackgroundColor &&
        other.hoverBorderColor == hoverBorderColor &&
        other.disabledBackgroundColor == disabledBackgroundColor &&
        other.disabledBorderColor == disabledBorderColor &&
        other.hoverBorderWidth == hoverBorderWidth &&
        other.animationDuration == animationDuration &&
        other.animationCurve == animationCurve &&
        other.defaultPadding == defaultPadding &&
        other.minWidth == minWidth &&
        other.minHeight == minHeight &&
        other.maxWidth == maxWidth &&
        other.maxHeight == maxHeight;
  }

  @override
  int get hashCode {
    return Object.hash(
      defaultBackgroundColor,
      defaultBorderColor,
      selectedBackgroundColor,
      selectedBorderColor,
      errorBackgroundColor,
      errorBorderColor,
      defaultBorderWidth,
      selectedBorderWidth,
      borderRadius,
      Object.hashAll(shadows),
      defaultTextStyle,
      hoverBackgroundColor,
      hoverBorderColor,
      disabledBackgroundColor,
      disabledBorderColor,
      hoverBorderWidth,
      animationDuration,
      animationCurve,
      defaultPadding,
      Object.hash(minWidth, minHeight, maxWidth, maxHeight),
    );
  }

  FlowNodeStyle lerp(FlowNodeStyle other, double t) {
    return FlowNodeStyle(
      defaultBackgroundColor:
          Color.lerp(defaultBackgroundColor, other.defaultBackgroundColor, t) ??
              defaultBackgroundColor,
      defaultBorderColor:
          Color.lerp(defaultBorderColor, other.defaultBorderColor, t) ??
              defaultBorderColor,
      selectedBackgroundColor: Color.lerp(
              selectedBackgroundColor, other.selectedBackgroundColor, t) ??
          selectedBackgroundColor,
      selectedBorderColor:
          Color.lerp(selectedBorderColor, other.selectedBorderColor, t) ??
              selectedBorderColor,
      errorBackgroundColor:
          Color.lerp(errorBackgroundColor, other.errorBackgroundColor, t) ??
              errorBackgroundColor,
      errorBorderColor:
          Color.lerp(errorBorderColor, other.errorBorderColor, t) ??
              errorBorderColor,
      defaultBorderWidth:
          lerpDouble(defaultBorderWidth, other.defaultBorderWidth, t)!,
      selectedBorderWidth:
          lerpDouble(selectedBorderWidth, other.selectedBorderWidth, t)!,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      shadows: t < 0.5 ? shadows : other.shadows,
      defaultTextStyle:
          TextStyle.lerp(defaultTextStyle, other.defaultTextStyle, t) ??
              defaultTextStyle,
      hoverBackgroundColor:
          Color.lerp(hoverBackgroundColor, other.hoverBackgroundColor, t) ??
              hoverBackgroundColor,
      hoverBorderColor:
          Color.lerp(hoverBorderColor, other.hoverBorderColor, t) ??
              hoverBorderColor,
      disabledBackgroundColor: Color.lerp(
              disabledBackgroundColor, other.disabledBackgroundColor, t) ??
          disabledBackgroundColor,
      disabledBorderColor:
          Color.lerp(disabledBorderColor, other.disabledBorderColor, t) ??
              disabledBorderColor,
      hoverBorderWidth: lerpDouble(hoverBorderWidth, other.hoverBorderWidth, t),
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
      animationCurve: t < 0.5 ? animationCurve : other.animationCurve,
      defaultPadding:
          EdgeInsetsGeometry.lerp(defaultPadding, other.defaultPadding, t) ??
              defaultPadding,
      minWidth: lerpDouble(minWidth, other.minWidth, t),
      minHeight: lerpDouble(minHeight, other.minHeight, t),
      maxWidth: lerpDouble(maxWidth, other.maxWidth, t),
      maxHeight: lerpDouble(maxHeight, other.maxHeight, t),
    );
  }
}

/// Helper class for node styling
@immutable
class NodeStyleData {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final List<BoxShadow> shadows;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;

  const NodeStyleData({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.shadows,
    required this.textStyle,
    required this.padding,
  });

  BoxDecoration get decoration {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: shadows,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_extensions.dart';

@immutable
class FlowNodeStyle {
  final Color? defaultBackgroundColor;
  final Color? defaultBorderColor;
  final Color? selectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? errorBackgroundColor;
  final Color? errorBorderColor;
  final double? defaultBorderWidth;
  final double? selectedBorderWidth;
  final double? borderRadius;
  final List<BoxShadow>? shadows;
  final TextStyle? defaultTextStyle;

  // Enhanced properties
  final Color? hoverBackgroundColor;
  final Color? hoverBorderColor;
  final Color? disabledBackgroundColor;
  final Color? disabledBorderColor;
  final double? hoverBorderWidth;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final EdgeInsetsGeometry? defaultPadding;
  final double? minWidth;
  final double? minHeight;
  final double? maxWidth;
  final double? maxHeight;

  const FlowNodeStyle({
    this.defaultBackgroundColor,
    this.defaultBorderColor,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.errorBackgroundColor,
    this.errorBorderColor,
    this.defaultBorderWidth = 1.0,
    this.selectedBorderWidth = 2.0,
    this.borderRadius = 8.0,
    this.shadows = const [],
    this.defaultTextStyle,
    this.hoverBackgroundColor,
    this.hoverBorderColor,
    this.disabledBackgroundColor,
    this.disabledBorderColor,
    this.hoverBorderWidth,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.defaultPadding = const EdgeInsets.all(12.0),
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
      shadows: const [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
      defaultTextStyle: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      defaultPadding: const EdgeInsets.all(12.0),
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
      shadows: const [
        BoxShadow(
          color: Color(0x4D000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
      defaultTextStyle: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      defaultPadding: const EdgeInsets.all(12.0),
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
      backgroundColor =
          errorBackgroundColor ?? defaultBackgroundColor ?? Colors.red;
      borderColor = errorBorderColor ?? defaultBorderColor ?? Colors.red;
      borderWidth = selectedBorderWidth ?? 2.0;
    } else if (isDisabled) {
      backgroundColor =
          disabledBackgroundColor ?? defaultBackgroundColor ?? Colors.grey;
      borderColor = disabledBorderColor ?? defaultBorderColor ?? Colors.grey;
      borderWidth = defaultBorderWidth ?? 1.0;
    } else if (isSelected) {
      backgroundColor =
          selectedBackgroundColor ?? defaultBackgroundColor ?? Colors.blue;
      borderColor = selectedBorderColor ?? defaultBorderColor ?? Colors.blue;
      borderWidth = selectedBorderWidth ?? 2.0;
    } else if (isHovered) {
      backgroundColor =
          hoverBackgroundColor ?? defaultBackgroundColor ?? Colors.white;
      borderColor = hoverBorderColor ?? defaultBorderColor ?? Colors.black12;
      borderWidth = hoverBorderWidth ?? defaultBorderWidth ?? 1.0;
    } else {
      backgroundColor = defaultBackgroundColor ?? Colors.white;
      borderColor = defaultBorderColor ?? Colors.black12;
      borderWidth = defaultBorderWidth ?? 1.0;
    }

    return NodeStyleData(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius ?? 8.0,
      shadows: shadows ?? const [],
      textStyle: defaultTextStyle ?? const TextStyle(),
      padding: defaultPadding ?? const EdgeInsets.all(12.0),
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
    EdgeInsetsGeometry? defaultPadding,
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
    final base = nodeTheme ?? context.flowCanvasTheme.node;
    return base.copyWith(
      defaultBackgroundColor: defaultBackgroundColor,
      defaultBorderColor: defaultBorderColor,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedBorderColor: selectedBorderColor,
      errorBackgroundColor: errorBackgroundColor,
      errorBorderColor: errorBorderColor,
      defaultBorderWidth: defaultBorderWidth,
      selectedBorderWidth: selectedBorderWidth,
      borderRadius: borderRadius,
      shadows: shadows,
      defaultTextStyle: defaultTextStyle,
      hoverBackgroundColor: hoverBackgroundColor,
      hoverBorderColor: hoverBorderColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      hoverBorderWidth: hoverBorderWidth,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      defaultPadding: defaultPadding,
      minWidth: minWidth,
      minHeight: minHeight,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
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
      shadows == null ? null : Object.hashAll(shadows!),
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
          Color.lerp(defaultBackgroundColor, other.defaultBackgroundColor, t),
      defaultBorderColor:
          Color.lerp(defaultBorderColor, other.defaultBorderColor, t),
      selectedBackgroundColor:
          Color.lerp(selectedBackgroundColor, other.selectedBackgroundColor, t),
      selectedBorderColor:
          Color.lerp(selectedBorderColor, other.selectedBorderColor, t),
      errorBackgroundColor:
          Color.lerp(errorBackgroundColor, other.errorBackgroundColor, t),
      errorBorderColor: Color.lerp(errorBorderColor, other.errorBorderColor, t),
      defaultBorderWidth:
          (defaultBorderWidth == null || other.defaultBorderWidth == null)
              ? (t < 0.5 ? defaultBorderWidth : other.defaultBorderWidth)
              : defaultBorderWidth! +
                  (other.defaultBorderWidth! - defaultBorderWidth!) * t,
      selectedBorderWidth:
          (selectedBorderWidth == null || other.selectedBorderWidth == null)
              ? (t < 0.5 ? selectedBorderWidth : other.selectedBorderWidth)
              : selectedBorderWidth! +
                  (other.selectedBorderWidth! - selectedBorderWidth!) * t,
      borderRadius: (borderRadius == null || other.borderRadius == null)
          ? (t < 0.5 ? borderRadius : other.borderRadius)
          : borderRadius! + (other.borderRadius! - borderRadius!) * t,
      shadows: t < 0.5 ? shadows : other.shadows,
      defaultTextStyle:
          TextStyle.lerp(defaultTextStyle, other.defaultTextStyle, t),
      hoverBackgroundColor:
          Color.lerp(hoverBackgroundColor, other.hoverBackgroundColor, t),
      hoverBorderColor: Color.lerp(hoverBorderColor, other.hoverBorderColor, t),
      disabledBackgroundColor:
          Color.lerp(disabledBackgroundColor, other.disabledBackgroundColor, t),
      disabledBorderColor:
          Color.lerp(disabledBorderColor, other.disabledBorderColor, t),
      hoverBorderWidth:
          (hoverBorderWidth == null || other.hoverBorderWidth == null)
              ? (t < 0.5 ? hoverBorderWidth : other.hoverBorderWidth)
              : hoverBorderWidth! +
                  (other.hoverBorderWidth! - hoverBorderWidth!) * t,
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
      animationCurve: t < 0.5 ? animationCurve : other.animationCurve,
      defaultPadding:
          EdgeInsetsGeometry.lerp(defaultPadding, other.defaultPadding, t),
      minWidth: (minWidth == null || other.minWidth == null)
          ? (t < 0.5 ? minWidth : other.minWidth)
          : minWidth! + (other.minWidth! - minWidth!) * t,
      minHeight: (minHeight == null || other.minHeight == null)
          ? (t < 0.5 ? minHeight : other.minHeight)
          : minHeight! + (other.minHeight! - minHeight!) * t,
      maxWidth: (maxWidth == null || other.maxWidth == null)
          ? (t < 0.5 ? maxWidth : other.maxWidth)
          : maxWidth! + (other.maxWidth! - maxWidth!) * t,
      maxHeight: (maxHeight == null || other.maxHeight == null)
          ? (t < 0.5 ? maxHeight : other.maxHeight)
          : maxHeight! + (other.maxHeight! - maxHeight!) * t,
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

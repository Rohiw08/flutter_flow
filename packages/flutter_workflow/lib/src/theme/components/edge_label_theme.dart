import 'package:flutter/material.dart';

@immutable
class FlowEdgeLabelStyle {
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const FlowEdgeLabelStyle({
    required this.textStyle,
    required this.backgroundColor,
    required this.borderColor,
    this.padding = const EdgeInsetsGeometry.all(4.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
  });

  factory FlowEdgeLabelStyle.light() {
    return const FlowEdgeLabelStyle(
      textStyle: TextStyle(
        color: Color(0xFF333333),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Colors.white,
      borderColor: Color(0xFFE0E0E0),
      padding: EdgeInsetsGeometry.all(4.0),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    );
  }

  factory FlowEdgeLabelStyle.dark() {
    return const FlowEdgeLabelStyle(
      textStyle: TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Color(0xFF2D2D2D),
      borderColor: Color(0xFF404040),
      padding: EdgeInsetsGeometry.all(4.0),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    );
  }

  FlowEdgeLabelStyle copyWith({
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) {
    return FlowEdgeLabelStyle(
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowEdgeLabelStyle &&
        other.textStyle == textStyle &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.padding == padding &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
        textStyle,
        backgroundColor,
        borderColor,
        padding,
        borderRadius,
      );

  FlowEdgeLabelStyle lerp(FlowEdgeLabelStyle other, double t) {
    return FlowEdgeLabelStyle(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t) ?? textStyle,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t) ??
          borderRadius,
    );
  }
}

import 'package:flutter/material.dart';

class EdgeLabelTheme {
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const EdgeLabelTheme({
    required this.textStyle,
    required this.backgroundColor,
    required this.borderColor,
    this.padding = const EdgeInsetsGeometry.all(4.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
  });

  factory EdgeLabelTheme.light() {
    return const EdgeLabelTheme(
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

  factory EdgeLabelTheme.dark() {
    return const EdgeLabelTheme(
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

  EdgeLabelTheme copyWith({
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) {
    return EdgeLabelTheme(
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

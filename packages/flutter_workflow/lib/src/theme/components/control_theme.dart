import 'package:flutter/material.dart';

class FlowCanvasControlTheme {
  final Color? containerColor;
  final Color? buttonColor;
  final Color? buttonHoverColor;
  final Color? iconColor;
  final Color? iconHoverColor;
  final double? buttonSize;
  final double? buttonCornerRadius;
  final double? containerCornerRadius;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? shadows;

  final BoxDecoration? containerDecoration;
  final BoxDecoration? buttonDecoration;
  final BoxDecoration? buttonHoverDecoration;
  final TextStyle? iconStyle;
  final TextStyle? iconHoverStyle;

  const FlowCanvasControlTheme({
    this.containerColor,
    this.buttonColor,
    this.buttonHoverColor,
    this.iconColor,
    this.iconHoverColor,
    this.buttonSize,
    this.buttonCornerRadius,
    this.containerCornerRadius,
    this.padding,
    this.shadows,
    this.containerDecoration,
    this.buttonDecoration,
    this.buttonHoverDecoration,
    this.iconStyle,
    this.iconHoverStyle,
  });

  BoxDecoration get effectiveContainerDecoration {
    if (containerDecoration != null) {
      return containerDecoration!;
    }
    return BoxDecoration(
      color: containerColor,
      borderRadius: BorderRadius.circular(
        containerCornerRadius ?? 8.0,
      ),
      boxShadow: shadows,
    );
  }

  BoxDecoration get effectiveButtonDecoration {
    if (buttonDecoration != null) {
      return buttonDecoration!;
    }
    return BoxDecoration(
      color: buttonColor,
      borderRadius: BorderRadius.circular(
        buttonCornerRadius ?? 8.0,
      ),
    );
  }

  BoxDecoration get effectiveButtonHoverDecoration {
    if (buttonHoverDecoration != null) {
      return buttonHoverDecoration!;
    }
    return BoxDecoration(
      color: buttonHoverColor,
      borderRadius: BorderRadius.circular(
        buttonCornerRadius ?? 8.0,
      ),
    );
  }

  TextStyle get effectiveIconStyle {
    if (iconStyle != null) {
      return iconStyle!;
    }
    return TextStyle(
      color: iconColor,
      fontSize: (buttonSize ?? 32.0) * 0.6,
    );
  }

  TextStyle get effectiveIconHoverStyle {
    if (iconHoverStyle != null) {
      return iconHoverStyle!;
    }
    return TextStyle(
      color: iconHoverColor,
      fontSize: (buttonSize ?? 32.0) * 0.6,
    );
  }

  // Added effective padding getter for consistency
  EdgeInsetsGeometry get effectivePadding {
    return padding ?? const EdgeInsets.all(8.0);
  }

  factory FlowCanvasControlTheme.light() {
    return FlowCanvasControlTheme(
      containerColor: Colors.white,
      buttonColor: const Color(0xFFF9FAFB),
      buttonHoverColor: const Color(0xFFF3F4F6),
      iconColor: const Color(0xFF6B7280),
      iconHoverColor: const Color(0xFF374151),
      buttonSize: 32.0,
      buttonCornerRadius: 8.0,
      containerCornerRadius: 8.0,
      padding: const EdgeInsets.all(8.0), // Added consistent padding
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  factory FlowCanvasControlTheme.dark() {
    return FlowCanvasControlTheme(
      containerColor: const Color(0xFF1F2937),
      buttonColor: const Color(0xFF374151),
      buttonHoverColor: const Color(0xFF4B5563),
      iconColor: const Color(0xFF9CA3AF),
      iconHoverColor: const Color(0xFFF9FAFB),
      buttonSize: 32.0,
      buttonCornerRadius: 8.0,
      containerCornerRadius: 8.0,
      padding: const EdgeInsets.all(8.0), // Added consistent padding
      shadows: [
        BoxShadow(
          color: Colors.black.withAlpha(102),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  FlowCanvasControlTheme copyWith({
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
    return FlowCanvasControlTheme(
      containerColor: containerColor ?? this.containerColor,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonHoverColor: buttonHoverColor ?? this.buttonHoverColor,
      iconColor: iconColor ?? this.iconColor,
      iconHoverColor: iconHoverColor ?? this.iconHoverColor,
      buttonSize: buttonSize ?? this.buttonSize,
      buttonCornerRadius: buttonCornerRadius ?? this.buttonCornerRadius,
      containerCornerRadius:
          containerCornerRadius ?? this.containerCornerRadius,
      padding: padding ?? this.padding,
      shadows: shadows ?? this.shadows,
      containerDecoration: containerDecoration ?? this.containerDecoration,
      buttonDecoration: buttonDecoration ?? this.buttonDecoration,
      buttonHoverDecoration:
          buttonHoverDecoration ?? this.buttonHoverDecoration,
      iconStyle: iconStyle ?? this.iconStyle,
      iconHoverStyle: iconHoverStyle ?? this.iconHoverStyle,
    );
  }
}

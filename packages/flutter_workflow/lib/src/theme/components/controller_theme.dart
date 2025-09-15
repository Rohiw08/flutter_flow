import 'package:flutter/material.dart';
import '../flow_theme.dart';
import 'package:flutter/foundation.dart';

class FlowCanvasControlsStyle {
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

  const FlowCanvasControlsStyle({
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

  factory FlowCanvasControlsStyle.light() {
    return FlowCanvasControlsStyle(
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

  factory FlowCanvasControlsStyle.dark() {
    return FlowCanvasControlsStyle(
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

  FlowCanvasControlsStyle copyWith({
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
    return FlowCanvasControlsStyle(
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

  FlowCanvasControlsStyle resolveControlTheme(
    BuildContext context,
    FlowCanvasControlsStyle? controlsTheme, {
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
    FlowCanvasControlsStyle base = controlsTheme ??
        // Then try to get from Flutter theme extension (assuming FlowCanvasTheme exists)
        _getThemeFromContext(context) ??
        // Finally fall back to light theme
        FlowCanvasControlsStyle.light();

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
  FlowCanvasControlsStyle? _getThemeFromContext(BuildContext context) {
    try {
      // This assumes you have a FlowCanvasTheme extension
      // You'll need to implement this based on your theme structure
      final themeExtension = Theme.of(context).extension<FlowCanvasTheme>();
      return themeExtension?.controls;
    } catch (e) {
      // If FlowCanvasTheme doesn't exist, fall back to brightness-based theme
      final brightness = Theme.of(context).brightness;
      return brightness == Brightness.dark
          ? FlowCanvasControlsStyle.dark()
          : FlowCanvasControlsStyle.light();
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowCanvasControlsStyle &&
        other.containerColor == containerColor &&
        other.buttonColor == buttonColor &&
        other.buttonHoverColor == buttonHoverColor &&
        other.iconColor == iconColor &&
        other.iconHoverColor == iconHoverColor &&
        other.buttonSize == buttonSize &&
        other.buttonCornerRadius == buttonCornerRadius &&
        other.containerCornerRadius == containerCornerRadius &&
        other.padding == padding &&
        listEquals(other.shadows, shadows) &&
        other.containerDecoration == containerDecoration &&
        other.buttonDecoration == buttonDecoration &&
        other.buttonHoverDecoration == buttonHoverDecoration &&
        other.iconStyle == iconStyle &&
        other.iconHoverStyle == iconHoverStyle;
  }

  @override
  int get hashCode => Object.hash(
        containerColor,
        buttonColor,
        buttonHoverColor,
        iconColor,
        iconHoverColor,
        buttonSize,
        buttonCornerRadius,
        containerCornerRadius,
        padding,
        shadows == null ? null : Object.hashAll(shadows!),
        containerDecoration,
        buttonDecoration,
        buttonHoverDecoration,
        iconStyle,
        iconHoverStyle,
      );

  FlowCanvasControlsStyle lerp(FlowCanvasControlsStyle other, double t) {
    return FlowCanvasControlsStyle(
      containerColor:
          Color.lerp(containerColor, other.containerColor, t) ?? containerColor,
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t) ?? buttonColor,
      buttonHoverColor:
          Color.lerp(buttonHoverColor, other.buttonHoverColor, t) ??
              buttonHoverColor,
      iconColor: Color.lerp(iconColor, other.iconColor, t) ?? iconColor,
      iconHoverColor:
          Color.lerp(iconHoverColor, other.iconHoverColor, t) ?? iconHoverColor,
      buttonSize: buttonSize == null || other.buttonSize == null
          ? (t < 0.5 ? buttonSize : other.buttonSize)
          : buttonSize! + (other.buttonSize! - buttonSize!) * t,
      buttonCornerRadius:
          buttonCornerRadius == null || other.buttonCornerRadius == null
              ? (t < 0.5 ? buttonCornerRadius : other.buttonCornerRadius)
              : buttonCornerRadius! +
                  (other.buttonCornerRadius! - buttonCornerRadius!) * t,
      containerCornerRadius:
          containerCornerRadius == null || other.containerCornerRadius == null
              ? (t < 0.5 ? containerCornerRadius : other.containerCornerRadius)
              : containerCornerRadius! +
                  (other.containerCornerRadius! - containerCornerRadius!) * t,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
      shadows: t < 0.5 ? shadows : other.shadows,
      containerDecoration:
          t < 0.5 ? containerDecoration : other.containerDecoration,
      buttonDecoration: t < 0.5 ? buttonDecoration : other.buttonDecoration,
      buttonHoverDecoration:
          t < 0.5 ? buttonHoverDecoration : other.buttonHoverDecoration,
      iconStyle: TextStyle.lerp(iconStyle, other.iconStyle, t) ?? iconStyle,
      iconHoverStyle: TextStyle.lerp(iconHoverStyle, other.iconHoverStyle, t) ??
          iconHoverStyle,
    );
  }
}

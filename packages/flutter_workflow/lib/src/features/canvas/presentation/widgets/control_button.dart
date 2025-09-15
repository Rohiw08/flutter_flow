import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/theme/components/controller_theme.dart';
import 'package:flutter_workflow/src/theme/theme_resolver/controller_button_inherited_theme.dart';

class ControlButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  // Simple theme overrides
  final Color? buttonColor;
  final Color? buttonHoverColor;
  final Color? iconColor;
  final Color? iconHoverColor;
  final double? buttonSize;
  final double? cornerRadius;
  final EdgeInsetsGeometry? padding; // Added missing padding parameter

  // Advanced theme overrides
  final BoxDecoration? buttonDecoration;
  final BoxDecoration? buttonHoverDecoration;
  final TextStyle? iconStyle;
  final TextStyle? iconHoverStyle;

  const ControlButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    // Theme overrides
    this.buttonColor,
    this.buttonHoverColor,
    this.iconColor,
    this.iconHoverColor,
    this.buttonSize,
    this.cornerRadius,
    this.padding, // Added padding parameter
    this.buttonDecoration,
    this.buttonHoverDecoration,
    this.iconStyle,
    this.iconHoverStyle,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final baseTheme = ControlThemeProvider.of(context);

    // Provide fallback if no theme is found
    final fallbackTheme = Theme.of(context).brightness == Brightness.dark
        ? FlowCanvasControlsStyle.dark()
        : FlowCanvasControlsStyle.light();

    final theme = (baseTheme ?? fallbackTheme).copyWith(
      buttonColor: widget.buttonColor,
      buttonHoverColor: widget.buttonHoverColor,
      iconColor: widget.iconColor,
      iconHoverColor: widget.iconHoverColor,
      buttonSize: widget.buttonSize,
      buttonCornerRadius: widget.cornerRadius,
      padding: widget.padding, // Use the padding parameter
      buttonDecoration: widget.buttonDecoration,
      buttonHoverDecoration: widget.buttonHoverDecoration,
      iconStyle: widget.iconStyle,
      iconHoverStyle: widget.iconHoverStyle,
    );

    // Use the effective theme properties
    final currentDecoration = _isHovered
        ? theme.effectiveButtonHoverDecoration
        : theme.effectiveButtonDecoration;

    final currentIconStyle =
        _isHovered ? theme.effectiveIconHoverStyle : theme.effectiveIconStyle;

    final isDisabled = widget.onPressed == null;
    final cursor =
        isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: cursor,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: theme.buttonSize,
            height: theme.buttonSize,
            decoration: currentDecoration,
            child: Center(
              child: Icon(
                widget.icon,
                size: currentIconStyle.fontSize,
                color: currentIconStyle.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

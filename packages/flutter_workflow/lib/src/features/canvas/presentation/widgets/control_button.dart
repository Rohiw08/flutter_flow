import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/theme/components/control_theme.dart';

/// A standardized button for use in control panels.
class ControlButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final FlowCanvasControlTheme theme;

  const ControlButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.theme,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color =
        _isHovered ? widget.theme.buttonHoverColor : widget.theme.buttonColor;
    final iconColor =
        _isHovered ? widget.theme.iconHoverColor : widget.theme.iconColor;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: widget.theme.borderRadius,
            ),
            child: Icon(
              widget.icon,
              color: iconColor,
              size: widget.theme.buttonSize * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/controls_theme.dart';

/// A styled button for flow canvas controls.
///
/// This button automatically adapts its appearance based on hover, selected,
/// and disabled states. It integrates with the [FlowCanvasControlsStyle] theme.
///
/// Example:
/// ```dart
/// ControlButton(
///   icon: Icons.add,
///   tooltip: 'Add Node',
///   onPressed: () => print('Add node'),
///   selected: true,
/// )
/// ```
class ControlButton extends StatefulWidget {
  /// The icon to display in the button.
  final IconData icon;

  /// Tooltip text shown on hover.
  final String tooltip;

  /// The size of the button.
  final Size buttonSize;

  /// Callback when the button is pressed.
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Whether the button is in a selected state.
  final bool selected;

  /// Optional custom style that overrides the theme.
  final FlowCanvasControlsStyle? style;

  const ControlButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.buttonSize = const Size(32.0, 32.0),
    this.selected = false,
    this.onPressed,
    this.style,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool _isHovered = false;

  void _setHover(bool hover) {
    if (mounted) {
      setState(() => _isHovered = hover);
    }
  }

  Set<FlowControlState> get _states {
    final states = <FlowControlState>{FlowControlState.normal};

    if (widget.onPressed == null) {
      states.add(FlowControlState.disabled);
    } else {
      if (_isHovered) {
        states.add(FlowControlState.hovered);
      }
      if (widget.selected) {
        states.add(FlowControlState.selected);
      }
    }

    return states;
  }

  @override
  Widget build(BuildContext context) {
    // Get base theme from context
    final baseTheme = context.flowCanvasTheme.controls;

    // Merge with custom style if provided
    final theme =
        widget.style != null ? baseTheme.merge(widget.style) : baseTheme;

    // Resolve decoration and icon theme based on current state
    final buttonDecoration = theme.resolveDecoration(_states);
    final iconTheme = theme.resolveIconTheme(_states);

    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        onEnter: widget.onPressed != null ? (_) => _setHover(true) : null,
        onExit: widget.onPressed != null ? (_) => _setHover(false) : null,
        cursor: widget.onPressed == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            width: widget.buttonSize.width,
            height: widget.buttonSize.height, // Corrected this line
            decoration: buttonDecoration,
            child: Center(
              child: IconTheme(
                data: iconTheme,
                child: Icon(widget.icon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

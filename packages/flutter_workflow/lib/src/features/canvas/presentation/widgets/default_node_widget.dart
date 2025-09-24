import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_extensions.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/node_theme.dart';

import '../../../../shared/providers.dart';

/// Default node widget that uses FlowNodeStyle and matches React Flow's appearance.
/// This widget uses ALL properties from FlowNodeStyle and serves as a fallback
/// for unregistered node types or as a base implementation.
class DefaultNodeWidget extends ConsumerStatefulWidget {
  final FlowNode node;

  const DefaultNodeWidget({
    super.key,
    required this.node,
  });

  @override
  ConsumerState<DefaultNodeWidget> createState() => _DefaultNodeWidgetState();
}

class _DefaultNodeWidgetState extends ConsumerState<DefaultNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration:
          const Duration(milliseconds: 200), // Will be overridden by theme
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Will be overridden by theme
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.flowCanvasTheme.node;
    final state = ref.watch(internalControllerProvider);

    // Get node state
    final isSelected = state.selectedNodes.contains(widget.node.id);
    final nodeRuntimeState = state.nodeStates[widget.node.id];
    final isDragging = nodeRuntimeState?.dragging ?? false;
    final isDisabled =
        !(widget.node.selectable ?? true) || !(widget.node.draggable ?? true);
    const hasError = false; // Could be extended to check for validation errors

    // Update animation controller duration and curve from theme
    _animationController.duration =
        theme.animationDuration ?? const Duration(milliseconds: 200);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: theme.animationCurve ?? Curves.easeInOut,
    ));

    // Get style for current state - THIS USES ALL FlowNodeStyle PROPERTIES
    final style = theme.getStyleForState(
      isSelected: isSelected,
      isHovered: _isHovered,
      isDisabled: isDisabled,
      hasError: hasError,
    );

    // Apply size constraints from theme
    final width = widget.node.size.width.clamp(
      theme.minWidth ?? 0.0,
      theme.maxWidth ?? double.infinity,
    );
    final height = widget.node.size.height.clamp(
      theme.minHeight ?? 0.0,
      theme.maxHeight ?? double.infinity,
    );

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        if (!isDragging) {
          _animationController.forward();
        }
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        if (!isDragging) {
          _animationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isHovered && !isDragging ? _scaleAnimation.value : 1.0,
            child: AnimatedContainer(
              duration:
                  theme.animationDuration ?? const Duration(milliseconds: 200),
              curve: theme.animationCurve ?? Curves.easeInOut,
              width: width,
              height: height,
              decoration: style.decoration.copyWith(
                // Add hover shadow if hovering and not disabled
                boxShadow: _isHovered && !isDisabled
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                        ...style.shadows,
                      ]
                    : style.shadows,
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: style.padding,
                  child: _buildContent(style),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(NodeStyleData style) {
    // Get node content - prioritize label, then data.label, then type
    String content = (widget.node.data)['label']?.toString() ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main content
        Flexible(
          child: Text(
            content,
            style: style.textStyle.copyWith(
              // Ensure text is readable on background
              color: style.textStyle.color ??
                  (ThemeData.estimateBrightnessForColor(
                              style.backgroundColor) ==
                          Brightness.dark
                      ? Colors.white
                      : Colors.black87),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),

        // Show node type if different from content
        if (widget.node.type != content && widget.node.type.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.node.type,
              style: style.textStyle.copyWith(
                fontSize: (style.textStyle.fontSize ?? 14) * 0.8,
                fontWeight: FontWeight.w300,
                color: (style.textStyle.color ?? Colors.black87)
                    .withValues(alpha: 153),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
      ],
    );
  }
}

/// Default node widget builder function for use with NodeRegistry
Widget buildDefaultNode(FlowNode node) {
  return DefaultNodeWidget(node: node);
}

/// Input node variant (React Flow equivalent)
Widget buildInputNode(FlowNode node) {
  return DefaultNodeWidget(node: node);
}

/// Output node variant (React Flow equivalent)
Widget buildOutputNode(FlowNode node) {
  return DefaultNodeWidget(node: node);
}

import 'package:flow_canvas/src/features/canvas/presentation/widgets/flow_handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/node_theme.dart';
import '../../../../shared/providers.dart';

/// A styled, theme-aware container for wrapping custom node widgets.
/// It provides handles, selection/hover states, and animations automatically.
/// An optional `style` can be provided to override the context theme for this specific node.
class DefaultNodeWidget extends ConsumerStatefulWidget {
  final FlowNode node;
  final Widget? child;
  final FlowNodeStyle? style;

  const DefaultNodeWidget({
    super.key,
    required this.node,
    this.child,
    this.style,
  });

  @override
  ConsumerState<DefaultNodeWidget> createState() => _DefaultNodeWidgetState();
}

class _DefaultNodeWidgetState extends ConsumerState<DefaultNodeWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // 1. Resolve the final theme for this widget.
    final contextTheme = context.flowCanvasTheme.node;
    // Merge the widget's specific style on top of the context theme.
    final theme = contextTheme.merge(widget.style);

    // Watch only the properties that affect this specific node's appearance.
    final isSelected = ref.watch(internalControllerProvider
        .select((state) => state.selectedNodes.contains(widget.node.id)));
    final isDragging = ref.watch(internalControllerProvider.select(
        (state) => state.nodeStates[widget.node.id]?.dragging ?? false));

    final styleData = theme.getStyleForState(
      isSelected: isSelected,
      isHovered: _isHovered,
    );

    final double scale = _isHovered && !isDragging ? 1.02 : 1.0;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration:
                theme.animationDuration ?? const Duration(milliseconds: 150),
            curve: theme.animationCurve ?? Curves.easeInOut,
            width: widget.node.size.width,
            height: widget.node.size.height,
            transform: Matrix4.identity()..scale(scale),
            transformAlignment: Alignment.center,
            decoration: styleData.decoration,
            child: Material(
              color: Colors.transparent,
              child: widget.child,
            ),
          ),
        ),
        ...widget.node.handles.values.map(
          (handle) => Handle(
            nodeId: widget.node.id,
            handleId: handle.id,
            type: handle.type,
            position: handle.position,
          ),
        ),
      ],
    );
  }
}

/// The default builder function for the 'default' node type in the NodeRegistry.
/// It creates a plain, empty DefaultNodeWidget that acts as a simple container.
Widget buildDefaultNode(FlowNode node) {
  return DefaultNodeWidget(
    node: node,
    // The child is null, creating a plain, empty node.
    // Users can place their own content inside this styled container.
    child: null,
  );
}

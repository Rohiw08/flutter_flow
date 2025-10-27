import 'package:flow_canvas/src/features/canvas/domain/state/node_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/node_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/handle_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extension.dart';
import 'package:flow_canvas/src/features/canvas/presentation/widgets/flow_handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/node_theme.dart';
import '../../../../shared/providers.dart';

/// A styled, theme-aware container for wrapping custom node widgets.
/// It provides handles, selection/hover states, and animations automatically.
/// An optional [style] can be provided to override the context theme for this specific node.
class DefaultNodeWidget extends ConsumerStatefulWidget {
  final FlowNode node;
  final bool? enableAnimations;
  final Curve? animationCurve;
  final Duration? animationDuration;
  final EdgeInsetsGeometry? padding;
  final FlowNodeStyle? style;
  final Widget? child;
  final HandleBuilder? handleBuilder;
  final FlowHandleStyle? handleStyle;

  const DefaultNodeWidget({
    super.key,
    required this.node,
    this.enableAnimations = true,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 200),
    this.padding = const EdgeInsets.all(12.0),
    this.child,
    this.style,
    this.handleBuilder,
    this.handleStyle,
  });

  @override
  ConsumerState<DefaultNodeWidget> createState() => _DefaultNodeWidgetState();
}

class _DefaultNodeWidgetState extends ConsumerState<DefaultNodeWidget> {
  bool _isHovered = false;

  // /// Computes the current set of states for this node
  Set<FlowNodeState> _computeStates(
    NodeRuntimeState nodeRuntimeState,
    FlowNode node,
  ) {
    final states = <FlowNodeState>{FlowNodeState.normal};
    // Check if node is hidden (disabled state)
    if (node.isHidden(context)) {
      states.add(FlowNodeState.disabled);
    }
    if (node.isHidden(context)) {
      states.add(FlowNodeState.disabled);
    }
    // Add selected state if node is selected
    if (node.isSelectable(context) && nodeRuntimeState.selected) {
      states.add(FlowNodeState.selected);
    }
    // Add hovered state if currently hovered
    if (_isHovered) {
      states.add(FlowNodeState.hovered);
    }
    return states;
  }

  @override
  Widget build(BuildContext context) {
    // Get base node theme and merge with any custom style override
    final baseTheme =
        context.flowCanvasTheme.node ?? FlowNodeStyle.system(context);
    final theme = baseTheme.merge(widget.style);

    // Watch node runtime state (selected, dragging, etc.)
    final nodeRuntimeState = ref.watch(
      internalControllerProvider.select(
        (state) => state.nodeStates[widget.node.id]!,
      ),
    );

    // Watch node configuration state
    final node = ref.watch(
      internalControllerProvider.select(
        (state) => state.nodes[widget.node.id]!,
      ),
    );

    // Compute current visual states
    final states = _computeStates(nodeRuntimeState, node);

    // Resolve decoration based on current states
    final decoration = theme.resolveDecoration(states);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: widget.enableAnimations!
                ? widget.animationDuration!
                : Duration.zero,
            curve: widget.animationCurve!,
            width: widget.node.size.width,
            height: widget.node.size.height,
            padding: widget.padding,
            decoration: decoration,
            transformAlignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: widget.child,
            ),
          ),
        ),

        // Render all node handles
        ...widget.node.handles.values.map(
          (handle) => Handle(
            nodeId: widget.node.id,
            handleId: handle.id,
            type: handle.type,
            position: handle.position,
            handleBuilder: widget.handleBuilder,
            handleStyle: widget.handleStyle,
          ),
        ),
      ],
    );
  }
}

/// Default builder for plain node type
Widget buildDefaultNode(FlowNode node) {
  return DefaultNodeWidget(node: node);
}

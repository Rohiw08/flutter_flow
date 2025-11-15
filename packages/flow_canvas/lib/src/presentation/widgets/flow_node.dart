import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/node_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/handle_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extension.dart';
import 'package:flow_canvas/src/features/canvas/presentation/widgets/flow_handle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/node_theme.dart';

/// A styled, theme-aware container for wrapping custom node widgets.
/// It provides handles, selection/hover states, and animations automatically.
/// An optional [style] can be provided to override the context theme for this specific node.
class DefaultNodeWidget extends ConsumerWidget {
  final FlowNode node;
  final FlowNodeStyle? style;
  final Widget? child;
  final HandleBuilder? handleBuilder;
  final FlowHandleStyle? handleStyle;

  const DefaultNodeWidget({
    super.key,
    required this.node,
    this.child,
    this.style,
    this.handleBuilder,
    this.handleStyle,
  });

  // /// Computes the current set of states for this node
  Set<FlowNodeState> _computeStates(
      NodeRuntimeState nodeRuntimeState, FlowNode node, BuildContext context) {
    final states = <FlowNodeState>{FlowNodeState.normal};
    if (nodeRuntimeState.selected) {
      states.add(FlowNodeState.selected);
    }
    if (nodeRuntimeState.hovered) {
      states.add(FlowNodeState.hovered);
    }
    return states;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get base node theme and merge with any custom style override
    final baseTheme =
        context.flowCanvasTheme.node ?? FlowNodeStyle.system(context);
    final theme = baseTheme.merge(style);

    // Watch node runtime state (selected, dragging, etc.)
    final nodeRuntimeState = ref.watch(
      internalControllerProvider.select(
        (state) => state.nodeStates[node.id]!,
      ),
    );

    // Compute current visual states
    final states = _computeStates(nodeRuntimeState, node, context);
    // Resolve decoration based on current states
    final decoration = theme.resolveDecoration(states);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: node.size.width,
          height: node.size.height,
          decoration: decoration,
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        ),

        // Render all node handles
        ...node.handles.values.map(
          (handle) => Handle(
            nodeId: node.id,
            handleId: handle.id,
            type: handle.type,
            position: handle.position,
            handleBuilder: handleBuilder,
            handleStyle: handleStyle,
          ),
        ),
      ],
    );
  }
}

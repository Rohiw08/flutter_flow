import 'package:flow_canvas/src/features/canvas/presentation/utility/flow_positioned.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/node_options.dart';

/// A layer that renders all node widgets.
///
/// This widget is highly optimized. It only rebuilds when the list of node IDs
/// changes (i.e., a node is added or removed), preventing unnecessary rebuilds
/// when nodes are dragged or other canvas state changes occur.
class FlowNodesLayer extends ConsumerWidget {
  const FlowNodesLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(internalControllerProvider);
    final nodeIds = state.nodes.keys.toList();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ...nodeIds.map(
          (nodeId) => _NodeWidget(
            key: ValueKey(nodeId),
            nodeId: nodeId,
          ),
        ),
      ],
    );
  }
}

/// A widget for rendering a single, highly optimized node.
///
/// This widget listens only to changes for its specific node's data, ensuring
/// that only the nodes that are actually updated (e.g., during a drag) will
/// rebuild. This is the core of the performance optimization.
class _NodeWidget extends ConsumerStatefulWidget {
  final String nodeId;

  const _NodeWidget({
    super.key,
    required this.nodeId,
  });

  @override
  ConsumerState<_NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends ConsumerState<_NodeWidget> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'FlowNode');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch only the data for this specific node.
    final node = ref.watch(
      internalControllerProvider.select(
        (state) => state.nodes[widget.nodeId]!,
      ),
    );
    final controller = ref.read(internalControllerProvider.notifier);
    final nodeRegistry = ref.read(nodeRegistryProvider);

    // Resolve effective options (consider node overrides and global defaults)
    final resolved = NodeOptions.resolve(context);
    final isHidden = node.hidden ?? resolved.hidden;
    final isDraggable = node.draggable ?? resolved.draggable;
    final isSelectable = node.selectable ?? resolved.selectable;
    final isFocusable = node.focusable ?? resolved.focusable;
    if (isHidden) return const SizedBox.shrink();

    final maxHandleSize =
        node.handles.values.map((h) => h.size).fold<double>(0, (max, size) {
      final larger = size.width > size.height ? size.width : size.height;
      return larger > max ? larger : max;
    });

    final hitTestPadding = node.hitTestPadding > maxHandleSize
        ? node.hitTestPadding
        : maxHandleSize;

    return FlowPositioned(
      dx: node.position.dx,
      dy: node.position.dy,
      child: SizedBox(
        height: node.size.height + hitTestPadding,
        width: node.size.width + hitTestPadding,
        child: MouseRegion(
          cursor: SystemMouseCursors.grab,
          onEnter: (e) => controller.nodes.onNodeMouseEnter(widget.nodeId, e),
          onHover: (e) => controller.nodes.onNodeMouseMove(widget.nodeId, e),
          onExit: (e) => controller.nodes.onNodeMouseLeave(widget.nodeId, e),
          child: Focus(
            focusNode: _focusNode,
            canRequestFocus: isFocusable,
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              // TODO: Simplify this
              onTapDown: (details) => controller.nodes.onNodeTap(widget.nodeId,
                  details, isSelectable, _focusNode, isFocusable),
              onDoubleTap: () =>
                  controller.nodes.onNodeDoubleClick(widget.nodeId),
              onLongPressStart: (details) =>
                  controller.nodes.onNodeContextMenu(widget.nodeId, details),
              onPanStart: isDraggable
                  ? (details) =>
                      controller.nodes.onNodeDragStart(widget.nodeId, details)
                  : null,
              onPanUpdate: isDraggable
                  ? (details) => controller.nodes
                      .onNodeDragUpdate(widget.nodeId, details, isSelectable)
                  : null,
              onPanEnd: isDraggable
                  ? (details) =>
                      controller.nodes.onNodeDragEnd(widget.nodeId, details)
                  : null,
              // Build the user-defined widget for the node.
              child: nodeRegistry.buildWidget(node),
            ),
          ),
        ),
      ),
    );
  }
}

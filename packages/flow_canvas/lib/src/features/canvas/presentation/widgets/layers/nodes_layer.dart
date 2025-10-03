import 'package:flow_canvas/src/features/canvas/presentation/widgets/flow_positioned.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/node_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/domain/registries/node_registry.dart';

import '../../../../../shared/providers.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/node_options.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/node_change_stream.dart';

/// A layer that renders all node widgets.
///
/// This widget is highly optimized. It only rebuilds when the list of node IDs
/// changes (i.e., a node is added or removed), preventing unnecessary rebuilds
/// when nodes are dragged or other canvas state changes occur.
class FlowNodesLayer extends ConsumerWidget {
  final NodeCallbacks nodeCallbacks;

  const FlowNodesLayer({
    super.key,
    required this.nodeCallbacks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch ONLY the list of node IDs.
    final nodeIds = ref.watch(
      internalControllerProvider.select((state) => state.nodes.keys.toList()),
    );

    // Read registry from provider
    final nodeRegistry = ref.read(nodeRegistryProvider);

    // Render order: zIndex then (optionally) elevate selected
    final opts = NodeOptions.resolve(context);
    final state = ref.read(internalControllerProvider);
    final selected = state.selectedNodes;
    final sortedIds = [...nodeIds]..sort((a, b) {
        final na = state.nodes[a]!;
        final nb = state.nodes[b]!;
        final za = na.zIndex;
        final zb = nb.zIndex;
        if (za != zb) return za.compareTo(zb);
        if (opts.elevateNodesOnSelected) {
          final sa = selected.contains(a) ? 1 : 0;
          final sb = selected.contains(b) ? 1 : 0;
          if (sa != sb) return sa.compareTo(sb);
        }
        return 0;
      });

    return Stack(
      clipBehavior: Clip.none,
      children: sortedIds
          .map((nodeId) => _NodeWidget(
                key: ValueKey(nodeId),
                nodeId: nodeId,
                nodeRegistry: nodeRegistry,
                nodeCallbacks: nodeCallbacks,
              ))
          .toList(),
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
  final NodeRegistry nodeRegistry;
  final NodeCallbacks nodeCallbacks;

  const _NodeWidget({
    super.key,
    required this.nodeId,
    required this.nodeRegistry,
    required this.nodeCallbacks,
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

    // Resolve effective options (consider node overrides and global defaults)
    final resolved = NodeOptions.resolve(context);
    final isHidden = node.hidden ?? resolved.hidden;
    final isDraggable = node.draggable ?? resolved.draggable;
    final isSelectable = node.selectable ?? resolved.selectable;
    final isFocusable = node.focusable ?? resolved.focusable;
    if (isHidden) return const SizedBox.shrink();

    final maxHandleSize = node.handles.values
        .map((h) => h.size)
        .fold<double>(0, (max, size) => size > max ? size : max);

    final hitTestPadding = node.hitTestPadding > maxHandleSize
        ? node.hitTestPadding
        : maxHandleSize;

    return FlowPositioned(
      dx: node.position.dx,
      dy: node.position.dy,
      child: SizedBox(
        width: node.size.width + hitTestPadding,
        height: node.size.height + hitTestPadding,
        child: MouseRegion(
          cursor: SystemMouseCursors.grab,
          onEnter: (e) {
            widget.nodeCallbacks.onMouseEnter(widget.nodeId, e);
            controller.nodeStreams.emitEvent(NodeEvent(
              nodeId: widget.nodeId,
              type: NodeEventType.mouseEnter,
              data: e,
            ));
          },
          onHover: (e) {
            widget.nodeCallbacks.onMouseMove(widget.nodeId, e);
            controller.nodeStreams.emitEvent(NodeEvent(
              nodeId: widget.nodeId,
              type: NodeEventType.mouseMove,
              data: e,
            ));
          },
          onExit: (e) {
            widget.nodeCallbacks.onMouseLeave(widget.nodeId, e);
            controller.nodeStreams.emitEvent(NodeEvent(
              nodeId: widget.nodeId,
              type: NodeEventType.mouseLeave,
              data: e,
            ));
          },
          child: Focus(
            focusNode: _focusNode,
            canRequestFocus: isFocusable,
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTapDown: (details) {
                if (isSelectable) {
                  controller.selectNode(widget.nodeId, addToSelection: false);
                }
                if (isFocusable) {
                  _focusNode.requestFocus();
                }
                widget.nodeCallbacks.onClick(widget.nodeId, details);
                controller.nodeStreams.emitEvent(NodeEvent(
                  nodeId: widget.nodeId,
                  type: NodeEventType.click,
                  data: details,
                ));
              },
              onDoubleTap: () {
                widget.nodeCallbacks.onDoubleClick(widget.nodeId);
                controller.nodeStreams.emitEvent(NodeEvent(
                  nodeId: widget.nodeId,
                  type: NodeEventType.doubleClick,
                ));
              },
              onLongPressStart: (details) {
                widget.nodeCallbacks.onContextMenu(widget.nodeId, details);
                controller.nodeStreams.emitEvent(NodeEvent(
                  nodeId: widget.nodeId,
                  type: NodeEventType.contextMenu,
                  data: details,
                ));
              },
              // Dragging
              onPanStart: isDraggable
                  ? (details) {
                      controller.startNodeDrag();
                      widget.nodeCallbacks.onDragStart(widget.nodeId, details);
                      controller.nodeStreams.emitEvent(NodeEvent(
                        nodeId: widget.nodeId,
                        type: NodeEventType.dragStart,
                        data: details,
                      ));
                    }
                  : null,
              onPanUpdate: isDraggable
                  ? (details) {
                      if (isSelectable &&
                          !controller.currentState.selectedNodes
                              .contains(widget.nodeId)) {
                        controller.selectNode(widget.nodeId,
                            addToSelection: false);
                      }
                      // Pass the reliable screenDelta to the controller.
                      controller.dragSelectedBy(details.delta);

                      widget.nodeCallbacks.onDrag(widget.nodeId, details);
                      controller.nodeStreams.emitEvent(NodeEvent(
                        nodeId: widget.nodeId,
                        type: NodeEventType.drag,
                        data: details,
                      ));
                    }
                  : null,
              onPanEnd: isDraggable
                  ? (details) {
                      controller.endNodeDrag();
                      widget.nodeCallbacks.onDragStop(widget.nodeId, details);
                      controller.nodeStreams.emitEvent(NodeEvent(
                        nodeId: widget.nodeId,
                        type: NodeEventType.dragStop,
                        data: details,
                      ));
                    }
                  : null,

              // Build the user-defined widget for the node.
              child: widget.nodeRegistry.buildWidget(node),
            ),
          ),
        ),
      ),
    );
  }
}

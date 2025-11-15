import 'package:equatable/equatable.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/options_extensions.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/custom_stack_widget.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/flow_positioned.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class NodeKeys extends Equatable {
  final Map<String, int> nodes;

  const NodeKeys({required this.nodes});

  static const _deepEq = DeepCollectionEquality.unordered();

  @override
  List<Object?> get props => [_deepEq.hash(nodes)];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeKeys && _deepEq.equals(nodes, other.nodes);

  @override
  int get hashCode => _deepEq.hash(nodes);
}

final nodesProvider = Provider<NodeKeys>((ref) {
  final nodes = ref.watch(internalControllerProvider.select((s) => s.nodes));

  debugPrint("node/nodes updated");
  final nodesMap = nodes.map((key, value) => MapEntry(key, value.zIndex));
  return NodeKeys(nodes: nodesMap);
});

class FlowNodesLayer extends ConsumerWidget {
  const FlowNodesLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodes = ref.watch(nodesProvider);
    final entries = nodes.nodes.entries.toList();

    debugPrint("nodes layer rebuilt");

    return RepaintBoundary(
      child: ZIndexStack(
        children: [
          for (final entry in entries)
            ZIndexed(
              zIndex: entry.value,
              child: RepaintBoundary(
                child: _NodeWidget(
                  key: ValueKey(entry.key),
                  nodeId: entry.key,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// This node Widget handle behaviour of node not theming
class _NodeWidget extends ConsumerWidget {
  final String nodeId;

  const _NodeWidget({
    super.key,
    required this.nodeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final node = ref.watch(
      internalControllerProvider.select(
        (state) => state.nodes[nodeId],
      ),
    );

    if (node == null) return const SizedBox.shrink();
    final controller = ref.read(internalControllerProvider.notifier).nodes;
    final nodeRegistry = ref.read(nodeRegistryProvider);

    final baseOptions = context.flowCanvasOptions.nodeOptions;
    final options = baseOptions.copyWith(
      draggable: node.draggable,
      hidden: node.hidden,
      selectable: node.selectable,
      hoverable: node.hoverable,
    );

    final isHidden = options.hidden;
    final isHoverable = options.hoverable;
    final isSelectable = options.selectable;
    final isDraggable = options.draggable;

    if (isHidden) return const SizedBox.shrink();

    return FlowPositioned(
      dx: node.position.dx,
      dy: node.position.dy,
      child: SizedBox(
        height: node.interactionRect.height,
        width: node.interactionRect.width,
        child: MouseRegion(
          onEnter: isHoverable
              ? (e) => controller.onNodeMouseEnter(nodeId, e)
              : null,
          onHover:
              isHoverable ? (e) => controller.onNodeMouseMove(nodeId, e) : null,
          onExit: isHoverable
              ? (e) => controller.onNodeMouseLeave(nodeId, e)
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            // this default gesture is required selection
            onTapDown: (details) =>
                controller.onNodeTap(nodeId, details, isSelectable),
            // these default gestures are required for dragging
            onPanStart: isDraggable
                ? (details) =>
                    controller.onNodeDragStart(nodeId, details, isSelectable)
                : null,
            onPanUpdate: isDraggable
                ? (details) => controller.onNodeDragUpdate(details)
                : null,
            onPanEnd: isDraggable
                ? (details) => controller.onNodeDragEnd(details)
                : null,
            // Build the user-defined widget for the node.
            child: nodeRegistry.buildWidget(node),
          ),
        ),
      ),
    );
  }
}

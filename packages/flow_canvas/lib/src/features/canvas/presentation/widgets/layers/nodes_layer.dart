import 'package:equatable/equatable.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/flow_positioned.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/node_options.dart';
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
  final nodesMap = nodes.map((key, value) => MapEntry(key, value.zIndex));
  return NodeKeys(nodes: nodesMap);
});

class FlowNodesLayer extends ConsumerWidget {
  const FlowNodesLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // stack is only responsible for z indexing of nodes and list of nodes
    final nodes = ref.watch(nodesProvider);
    List<MapEntry<String, int>> entries = nodes.nodes.entries.toList();
    entries.sort((a, b) => a.value.compareTo(b.value));

    print("Nodes Layer Rebuilt");

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (final MapEntry<String, int> node in entries)
          _NodeWidget(
            key: ValueKey(node.key),
            nodeId: node.key,
          )
      ],
    );
  }
}

/// This node Widget handle behaviour of node not theming
class _NodeWidget extends ConsumerWidget {
  final String nodeId;

  _NodeWidget({
    super.key,
    required this.nodeId,
  });

  final FocusNode _focusNode = FocusNode(debugLabel: 'FlowNode');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print("${nodeId} Built");
    // Watch only the data for this specific node.
    final node = ref.watch(
      internalControllerProvider.select(
        (state) => state.nodes[nodeId],
      ),
    );
    if (node == null) return const SizedBox.shrink();
    final controller = ref.read(internalControllerProvider.notifier).nodes;
    final nodeRegistry = ref.read(nodeRegistryProvider);

    // Resolve effective options (consider node overrides and global defaults)
    final resolved = NodeOptions.resolve(context);
    final isHidden = node.hidden ?? resolved.hidden;
    final isDraggable = node.draggable ?? resolved.draggable;
    final isHoverable = node.hoverable ?? resolved.hoverable;
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
          onEnter: isHoverable
              ? (e) => controller.onNodeMouseEnter(nodeId, e)
              : null,
          onHover:
              isHoverable ? (e) => controller.onNodeMouseMove(nodeId, e) : null,
          onExit: isHoverable
              ? (e) => controller.onNodeMouseLeave(nodeId, e)
              : null,
          child: Focus(
            focusNode: _focusNode,
            canRequestFocus: isFocusable,
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTapDown: (details) =>
                  controller.onNodeTap(nodeId, details, isSelectable),
              onDoubleTap: () => controller.onNodeDoubleClick(nodeId),
              onLongPressStart: (details) =>
                  controller.onNodeLongPress(nodeId, details),
              onPanStart: isDraggable
                  ? (details) => controller.onNodeDragStart(nodeId, details)
                  : null,
              onPanUpdate: isDraggable
                  ? (details) =>
                      controller.onNodeDragUpdate(nodeId, details, isSelectable)
                  : null,
              onPanEnd: isDraggable
                  ? (details) => controller.onNodeDragEnd(nodeId, details)
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

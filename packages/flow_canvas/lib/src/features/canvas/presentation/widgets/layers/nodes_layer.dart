import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/flow_positioned.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/node_options.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';

class NodesRectPainter extends CustomPainter {
  final Map<String, FlowNode> nodes;
  final CanvasCoordinateConverter converter;

  NodesRectPainter(this.nodes, this.converter);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final node in nodes.values) {
      // Each FlowNode has a rect getter:
      canvas.drawRect(converter.cartesianRectToRenderRect(node.rect), paint);

      // Optional: draw center marker
      canvas.drawCircle(node.center, 3, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(covariant NodesRectPainter oldDelegate) {
    // Repaint when node positions or sizes change
    return oldDelegate.nodes != nodes;
  }
}

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
    final converter = ref.watch(coordinateConverterProvider);

    // Sort nodes (your existing logic)
    final opts = NodeOptions.resolve(context);
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
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: NodesRectPainter(state.nodes, converter),
          ),
        ),
        ...sortedIds.map((nodeId) => _NodeWidget(
              key: ValueKey(nodeId),
              nodeId: nodeId,
            )),
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
          onEnter: (e) => controller.onNodeMouseEnter(widget.nodeId, e),
          onHover: (e) => controller.onNodeMouseMove(widget.nodeId, e),
          onExit: (e) => controller.onNodeMouseLeave(widget.nodeId, e),
          child: Focus(
            focusNode: _focusNode,
            canRequestFocus: isFocusable,
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              // TODO: Simplify this
              onTapDown: (details) => controller.onNodeTap(widget.nodeId,
                  details, isSelectable, _focusNode, isFocusable),
              onDoubleTap: () => controller.onNodeDoubleClick(widget.nodeId),
              onLongPressStart: (details) =>
                  controller.onNodeContextMenu(widget.nodeId, details),
              onPanStart: isDraggable
                  ? (details) =>
                      controller.onNodeDragStart(widget.nodeId, details)
                  : null,
              onPanUpdate: isDraggable
                  ? (details) => controller.onNodeDragUpdate(
                      widget.nodeId, details, isSelectable)
                  : null,
              onPanEnd: isDraggable
                  ? (details) =>
                      controller.onNodeDragEnd(widget.nodeId, details)
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

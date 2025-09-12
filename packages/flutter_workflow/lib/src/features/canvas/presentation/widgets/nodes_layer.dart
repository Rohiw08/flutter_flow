import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_workflow/flutter_workflow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NodesLayer extends ConsumerStatefulWidget {
  final FlowCanvasFacade facade;
  const NodesLayer({super.key, required this.facade});

  @override
  ConsumerState<NodesLayer> createState() => _NodesLayerState();
}

class _NodesLayerState extends ConsumerState<NodesLayer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<FlowNode>>(
        stream: widget.facade.nodesStream,
        builder: (context, snapshot) {
          final nodes = snapshot.data ?? [];
          return Stack(
            children: nodes
                .map(
                  (node) => _buildNode(
                    node,
                    widget.facade,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

Widget _buildNode(FlowNode node, FlowCanvasFacade facade) {
  final nodeWidget = facade.nodeRegistry.buildWidget(node);
  return Positioned(
    left: node.position.dx + node.position.dx,
    top: node.position.dy + node.position.dy,
    width: node.size.width,
    height: node.size.height,
    child: nodeWidget,
  );
}

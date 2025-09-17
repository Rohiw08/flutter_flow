import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';

class FlowNodesLayer extends StatelessWidget {
  final FlowCanvasFacade facade;
  const FlowNodesLayer({super.key, required this.facade});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<FlowNode>>(
        stream: facade.nodesStream,
        builder: (context, snapshot) {
          final nodes = snapshot.data ?? [];
          return Stack(
            children: nodes
                .map(
                  (node) => _buildNode(
                    node,
                    facade,
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
    left: node.position.dx,
    top: node.position.dy,
    width: node.size.width,
    height: node.size.height,
    child: GestureDetector(
      onPanStart: (details) {
        // Select the node when starting to drag
        facade.selectNode(node.id);
      },
      onPanUpdate: (details) {
        // Drag the selected node(s) by the delta
        facade.dragSelectedBy(details.delta);
      },
      onTap: () {
        // Select node on tap
        facade.selectNode(node.id);
      },
      child: nodeWidget,
    ),
  );
}

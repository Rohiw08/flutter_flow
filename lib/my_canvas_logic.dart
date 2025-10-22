import 'package:flutter/material.dart';
import 'package:flow_canvas/flow_canvas.dart';

class MyCanvasLogic extends ChangeNotifier {
  void handleConnectionEnd(
      FlowCanvasController controller, FlowConnection pendingConnection) {
    _addNode(controller, pendingConnection);
  }

  void _addNode(FlowCanvasController controller, FlowConnection connection) {
    if (connection.toNodeId != null || connection.toHandleId != null) {
      return;
    }
    final String id = DateTime.now().millisecondsSinceEpoch.toString();

    final node = FlowNode.create(
      id: id,
      position: connection.endPoint + const Offset(75, 25),
      size: const Size(150, 80),
      type: 'default',
      data: {'label': 'Added Node'},
      handles: [
        NodeHandle(
          id: '$id-both-1',
          type: HandleType.source,
          position: const Offset(-75, -25),
        ),
      ],
    );

    final edge = FlowEdge(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sourceNodeId: connection.fromNodeId!,
      sourceHandleId: connection.fromHandleId!,
      targetNodeId: id,
      targetHandleId: "$id-both-1",
      pathType: EdgePathType.straight,
    );

    controller.nodes.addNode(node);
    controller.edges.addEdge(edge);
  }
}

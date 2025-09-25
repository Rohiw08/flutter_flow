import 'dart:ui';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';

class NodeQueryService {
  /// Query nodes in a rectangle using the NodeIndex.
  List<FlowNode> queryInRect(FlowCanvasState state, Rect rect) {
    return state.nodeIndex.queryNodesInRect(rect);
  }

  /// Query nodes near a point using the NodeIndex.
  List<FlowNode> queryNearPoint(
      FlowCanvasState state, Offset point, double radius) {
    final rect = Rect.fromCircle(center: point, radius: radius);
    // You might want a more precise circular check here later if needed
    return state.nodeIndex.queryNodesInRect(rect);
  }

  /// Get isolated nodes (nodes with no connections).
  List<FlowNode> getIsolatedNodes(FlowCanvasState state) {
    return state.nodes.values
        .where((node) => !state.edgeIndex.isNodeConnected(node.id))
        .toList();
  }

  /// Get the IDs of all nodes connected to a specific node.
  Set<String> getConnectedNodes(FlowCanvasState state, String nodeId) {
    // This information is correctly managed by the EdgeIndex.
    return state.edgeIndex.getConnectedNodes(nodeId);
  }
}

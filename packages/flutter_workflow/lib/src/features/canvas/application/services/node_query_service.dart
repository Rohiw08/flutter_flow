import 'dart:ui';

import '../../../../../flutter_workflow.dart';
import '../../domain/state/flow_canvas_state.dart';

class NodeQueryService {
  /// Query nodes in a rectangle using the NodeIndex
  List<FlowNode> queryInRect(FlowCanvasState state, Rect rect) {
    return state.nodeIndex.queryInRect(rect);
  }

  /// Query nodes near a point using the NodeIndex
  List<FlowNode> queryNearPoint(
      FlowCanvasState state, Offset point, double radius) {
    return state.nodeIndex.queryNearPoint(point, radius);
  }

  /// Get isolated nodes using the NodeIndex
  List<FlowNode> getIsolatedNodes(FlowCanvasState state) {
    return state.nodeIndex.getIsolatedNodes();
  }

  /// Get connected nodes for a specific node
  Set<String> getConnectedNodes(FlowCanvasState state, String nodeId) {
    return state.nodeIndex.getConnectedNodes(nodeId);
  }
}

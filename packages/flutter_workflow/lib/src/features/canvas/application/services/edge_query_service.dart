import '../../domain/state/flow_canvas_state.dart';

class EdgeQueryService {
  /// Get all edge IDs connected to a specific node
  Set<String> getEdgesForNode(FlowCanvasState state, String nodeId) {
    return state.edgeIndex.getEdgesForNode(nodeId);
  }

  /// Get all edge IDs connected to a specific handle on a node
  Set<String> getEdgesForHandle(
      FlowCanvasState state, String nodeId, String handleId) {
    return state.edgeIndex.getEdgesForHandle(nodeId, handleId);
  }

  /// Get all node IDs connected to a specific node
  Set<String> getConnectedNodes(FlowCanvasState state, String nodeId) {
    return state.edgeIndex.getConnectedNodes(nodeId);
  }

  /// Check if a node has any connections
  bool isNodeConnected(FlowCanvasState state, String nodeId) {
    return state.edgeIndex.isNodeConnected(nodeId);
  }

  /// Check if a specific handle has any connections
  bool isHandleConnected(
      FlowCanvasState state, String nodeId, String handleId) {
    return state.edgeIndex.isHandleConnected(nodeId, handleId);
  }
}

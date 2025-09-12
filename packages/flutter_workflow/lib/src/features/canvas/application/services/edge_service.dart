import 'package:flutter_workflow/src/features/canvas/application/services/edge_indexing_service.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';

class EdgeService {
  /// Add edge with validation and indexing
  FlowCanvasState addEdge(FlowCanvasState currentState, FlowEdge edge) {
    // Validate nodes exist
    if (!currentState.internalNodes.containsKey(edge.sourceNodeId) ||
        !currentState.internalNodes.containsKey(edge.targetNodeId)) {
      return currentState;
    }

    // Prevent duplicate connections
    final exists = currentState.internalEdges.values.any((e) =>
        e.sourceNodeId == edge.sourceNodeId &&
        e.sourceHandleId == edge.sourceHandleId &&
        e.targetNodeId == edge.targetNodeId &&
        e.targetHandleId == edge.targetHandleId);

    if (exists) return currentState;

    // Add edge to edges map
    final edgesBuilder = currentState.internalEdges.toBuilder();
    edgesBuilder[edge.id] = edge;

    // Update edge index incrementally
    final newIndex = currentState.edgeIndex.addEdge(edge, edge.id);

    return currentState.copyWith(
      internalEdges: edgesBuilder.build(),
      edgeIndex: newIndex,
    );
  }

  /// Remove edge and update index
  FlowCanvasState removeEdge(FlowCanvasState currentState, String edgeId) {
    final edge = currentState.internalEdges[edgeId];
    if (edge == null) return currentState;

    final edgesBuilder = currentState.internalEdges.toBuilder();
    edgesBuilder.remove(edgeId);

    // Update edge index incrementally
    final newIndex = currentState.edgeIndex.removeEdge(edgeId, edge);

    return currentState.copyWith(
      internalEdges: edgesBuilder.build(),
      edgeIndex: newIndex,
    );
  }

  /// Remove multiple edges efficiently
  FlowCanvasState removeEdges(
      FlowCanvasState currentState, List<String> edgeIds) {
    if (edgeIds.isEmpty) return currentState;

    final edgesBuilder = currentState.internalEdges.toBuilder();
    EdgeIndex newIndex = currentState.edgeIndex;

    for (final edgeId in edgeIds) {
      final edge = edgesBuilder[edgeId];
      if (edge != null) {
        edgesBuilder.remove(edgeId);
        newIndex = newIndex.removeEdge(edgeId, edge);
      }
    }

    return currentState.copyWith(
      internalEdges: edgesBuilder.build(),
      edgeIndex: newIndex,
    );
  }

  /// Get edges for a node using the index
  List<FlowEdge> getEdgesForNode(FlowCanvasState state, String nodeId) {
    final edgeIds = state.edgeIndex.getEdgesForNode(nodeId);
    return edgeIds
        .map((id) => state.internalEdges[id])
        .whereType<FlowEdge>()
        .toList();
  }

  /// Get edges for a handle using the index
  List<FlowEdge> getEdgesForHandle(
      FlowCanvasState state, String nodeId, String handleId) {
    final edgeIds = state.edgeIndex.getEdgesForHandle(nodeId, handleId);
    return edgeIds
        .map((id) => state.internalEdges[id])
        .whereType<FlowEdge>()
        .toList();
  }

  /// Check if a handle is connected using the index
  bool isHandleConnected(
      FlowCanvasState state, String nodeId, String handleId) {
    return state.edgeIndex.isHandleConnected(nodeId, handleId);
  }

  /// Check if a node is connected using the index
  bool isNodeConnected(FlowCanvasState state, String nodeId) {
    return state.edgeIndex.isNodeConnected(nodeId);
  }

  /// Get all nodes connected to a specific node
  List<String> getConnectedNodes(FlowCanvasState state, String nodeId) {
    return state.edgeIndex.getConnectedNodes(nodeId).toList();
  }

  /// Disconnect all edges from a handle
  FlowCanvasState disconnectHandle(
      FlowCanvasState state, String nodeId, String handleId) {
    final edgeIds = state.edgeIndex.getEdgesForHandle(nodeId, handleId);
    if (edgeIds.isEmpty) return state;

    return removeEdges(state, edgeIds.toList());
  }

  /// Disconnect all edges from a node
  FlowCanvasState disconnectNode(FlowCanvasState state, String nodeId) {
    final edgeIds = state.edgeIndex.getEdgesForNode(nodeId);
    if (edgeIds.isEmpty) return state;

    return removeEdges(state, edgeIds.toList());
  }

  /// Update edge data
  FlowCanvasState updateEdgeData(
    FlowCanvasState state,
    String edgeId,
    Map<String, dynamic> Function(Map<String, dynamic>) updater,
  ) {
    final edge = state.internalEdges[edgeId];
    if (edge == null) return state;

    final updatedEdge = edge.updateData(updater);
    final edgesBuilder = state.internalEdges.toBuilder();
    edgesBuilder[edgeId] = updatedEdge;

    return state.copyWith(internalEdges: edgesBuilder.build());
  }

  /// Find edges by type
  List<FlowEdge> findEdgesByType(FlowCanvasState state, String type) {
    return state.internalEdges.values
        .where((edge) => edge.pathType.toString() == type)
        .toList();
  }

  /// Find edges by data property
  List<FlowEdge> findEdgesByData(
      FlowCanvasState state, String key, dynamic value) {
    return state.internalEdges.values
        .where((edge) => edge.data[key] == value)
        .toList();
  }

  /// Reconnect edge to different source/target
  FlowCanvasState reconnectEdge(
    FlowCanvasState state,
    String edgeId, {
    String? newSourceNodeId,
    String? newSourceHandleId,
    String? newTargetNodeId,
    String? newTargetHandleId,
  }) {
    final edge = state.internalEdges[edgeId];
    if (edge == null) return state;

    // Validate new nodes exist if provided
    if ((newSourceNodeId != null &&
            !state.internalNodes.containsKey(newSourceNodeId)) ||
        (newTargetNodeId != null &&
            !state.internalNodes.containsKey(newTargetNodeId))) {
      return state;
    }

    // Create updated edge (keeping same ID!)
    final updatedEdge = edge.copyWith(
      sourceNodeId: newSourceNodeId ?? edge.sourceNodeId,
      sourceHandleId: newSourceHandleId ?? edge.sourceHandleId,
      targetNodeId: newTargetNodeId ?? edge.targetNodeId,
      targetHandleId: newTargetHandleId ?? edge.targetHandleId,
    );

    // Remove old edge and add updated one
    var newState = removeEdge(state, edgeId);
    return addEdge(newState, updatedEdge);
  }

  /// Bulk import edges with efficient indexing
  FlowCanvasState importEdges(FlowCanvasState state, List<FlowEdge> edges) {
    if (edges.isEmpty) return state;

    final edgesBuilder = state.internalEdges.toBuilder();
    EdgeIndex newIndex = state.edgeIndex;

    for (final edge in edges) {
      // Skip if edge already exists
      if (state.internalEdges.containsKey(edge.id)) continue;

      // Validate nodes exist
      if (!state.internalNodes.containsKey(edge.sourceNodeId) ||
          !state.internalNodes.containsKey(edge.targetNodeId)) {
        continue;
      }

      edgesBuilder[edge.id] = edge;
      newIndex = newIndex.addEdge(edge, edge.id);
    }

    return state.copyWith(
      internalEdges: edgesBuilder.build(),
      edgeIndex: newIndex,
    );
  }

  /// Get statistics about edges for debugging
  Map<String, dynamic> getEdgeStats(FlowCanvasState state) {
    return state.edgeIndex.stats;
  }
}

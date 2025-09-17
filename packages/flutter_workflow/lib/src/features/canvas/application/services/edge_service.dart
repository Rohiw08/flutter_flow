import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';

import '../../domain/indexes/edge_index.dart';

/// Provider for the stateless EdgeService.
final edgeServiceProvider = Provider<EdgeService>((ref) {
  return EdgeService();
});

/// A function type for updating the data map of a FlowEdge.
///
/// It receives the current data map and should return a new, updated map.
typedef EdgeDataUpdater = Map<String, dynamic> Function(
    Map<String, dynamic> currentData);

/// A stateless service for handling all logic related to managing edges.
///
/// This service operates on a `FlowCanvasState` object and returns a new, updated
/// state, ensuring immutability.
class EdgeService {
  /// Adds a single edge to the canvas state.
  FlowCanvasState addEdge(FlowCanvasState state, FlowEdge edge) {
    // 1. Validation
    if (state.edges.containsKey(edge.id)) return state; // Already exists
    if (!state.nodes.containsKey(edge.sourceNodeId) ||
        !state.nodes.containsKey(edge.targetNodeId)) {
      return state; // Source or target node does not exist
    }

    // 2. Create new immutable map
    final newEdges = Map<String, FlowEdge>.from(state.edges);
    newEdges[edge.id] = edge;

    // 3. Update the index
    final newIndex = state.edgeIndex.addEdge(edge, edge.id);

    return state.copyWith(
      edges: newEdges,
      edgeIndex: newIndex,
    );
  }

  /// Removes a single edge from the canvas state.
  FlowCanvasState removeEdge(FlowCanvasState state, String edgeId) {
    final edge = state.edges[edgeId];
    if (edge == null) return state;

    final newEdges = Map<String, FlowEdge>.from(state.edges);
    newEdges.remove(edgeId);

    final newIndex = state.edgeIndex.removeEdge(edgeId, edge);

    return state.copyWith(
      edges: newEdges,
      edgeIndex: newIndex,
    );
  }

  /// Removes a list of edges efficiently.
  FlowCanvasState removeEdges(FlowCanvasState state, List<String> edgeIds) {
    if (edgeIds.isEmpty) return state;

    final newEdges = Map<String, FlowEdge>.from(state.edges);
    EdgeIndex newIndex = state.edgeIndex;
    bool changed = false;

    for (final edgeId in edgeIds) {
      final edge = newEdges[edgeId];
      if (edge != null) {
        newEdges.remove(edgeId);
        newIndex = newIndex.removeEdge(edgeId, edge);
        changed = true;
      }
    }

    return changed
        ? state.copyWith(edges: newEdges, edgeIndex: newIndex)
        : state;
  }

  /// Updates the data payload of a specific edge.
  FlowCanvasState updateEdgeData(
    FlowCanvasState state,
    String edgeId,
    EdgeDataUpdater updater,
  ) {
    final edge = state.edges[edgeId];
    if (edge == null) return state;

    // Your FlowEdge `data` property is dynamic, so we handle it safely.
    final currentData = edge.data;

    final updatedEdge = edge.copyWith(data: updater(currentData));
    final newEdges = Map<String, FlowEdge>.from(state.edges);
    newEdges[edgeId] = updatedEdge;

    return state.copyWith(edges: newEdges);
  }

  /// Reconnects an edge to a new source or target handle.
  FlowCanvasState reconnectEdge(
    FlowCanvasState state,
    String edgeId, {
    String? newSourceNodeId,
    String? newSourceHandleId,
    String? newTargetNodeId,
    String? newTargetHandleId,
  }) {
    final edge = state.edges[edgeId];
    if (edge == null) return state;

    // Validate that the new nodes exist
    if ((newSourceNodeId != null &&
            !state.nodes.containsKey(newSourceNodeId)) ||
        (newTargetNodeId != null &&
            !state.nodes.containsKey(newTargetNodeId))) {
      return state;
    }

    final updatedEdge = edge.copyWith(
      sourceNodeId: newSourceNodeId ?? edge.sourceNodeId,
      sourceHandleId: newSourceHandleId ?? edge.sourceHandleId,
      targetNodeId: newTargetNodeId ?? edge.targetNodeId,
      targetHandleId: newTargetHandleId ?? edge.targetHandleId,
    );

    // This is an atomic operation: the index is updated for the new connection.
    final stateWithoutOldEdge = removeEdge(state, edgeId);
    return addEdge(stateWithoutOldEdge, updatedEdge);
  }

  /// Imports a list of edges, skipping any that already exist or are invalid.
  FlowCanvasState importEdges(FlowCanvasState state, List<FlowEdge> edges) {
    if (edges.isEmpty) return state;

    Map<String, FlowEdge> newEdges = Map.from(state.edges);
    EdgeIndex newIndex = state.edgeIndex;
    bool changed = false;

    for (final edge in edges) {
      if (newEdges.containsKey(edge.id)) continue;
      if (!state.nodes.containsKey(edge.sourceNodeId) ||
          !state.nodes.containsKey(edge.targetNodeId)) {
        continue;
      }
      newEdges[edge.id] = edge;
      newIndex = newIndex.addEdge(edge, edge.id);
      changed = true;
    }

    return changed
        ? state.copyWith(edges: newEdges, edgeIndex: newIndex)
        : state;
  }
}

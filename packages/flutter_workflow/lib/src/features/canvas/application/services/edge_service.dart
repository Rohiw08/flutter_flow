import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';

/// Provider for the stateless EdgeService.
final edgeServiceProvider = Provider<EdgeService>((ref) => EdgeService());

/// A stateless service for handling business logic related to edges.
class EdgeService {
  /// Adds a single edge to the canvas state if it's valid.
  FlowCanvasState addEdge(FlowCanvasState currentState, FlowEdge edge) {
    final nodeIds = currentState.nodes.map((n) => n.id).toSet();

    // Validate that source and target nodes exist
    if (!nodeIds.contains(edge.sourceNodeId) ||
        !nodeIds.contains(edge.targetNodeId)) {
      // In a real library, you might want to log this warning.
      return currentState;
    }

    // Prevent duplicate connections
    final exists = currentState.edges.any((e) =>
        e.sourceNodeId == edge.sourceNodeId &&
        e.sourceHandleId == edge.sourceHandleId &&
        e.targetNodeId == edge.targetNodeId &&
        e.targetHandleId == edge.targetHandleId);

    if (exists) {
      return currentState;
    }

    final newEdges = [...currentState.edges, edge];
    return currentState.copyWith(edges: newEdges);
  }

  /// Removes a single edge from the state by its ID.
  FlowCanvasState removeEdge(FlowCanvasState currentState, String edgeId) {
    final newEdges =
        currentState.edges.where((edge) => edge.id != edgeId).toList();
    if (newEdges.length == currentState.edges.length) {
      return currentState; // Edge not found, state is unchanged
    }
    return currentState.copyWith(edges: newEdges);
  }

  /// Removes multiple edges from the state by their IDs.
  FlowCanvasState removeEdges(
      FlowCanvasState currentState, List<String> edgeIds) {
    if (edgeIds.isEmpty) {
      return currentState;
    }
    final idsToRemove = edgeIds.toSet();
    final newEdges = currentState.edges
        .where((edge) => !idsToRemove.contains(edge.id))
        .toList();

    if (newEdges.length == currentState.edges.length) {
      return currentState;
    }
    return currentState.copyWith(edges: newEdges);
  }

  /// A utility function to find all edges connected to a given list of node IDs.
  /// This does not modify state.
  List<FlowEdge> getConnectedEdges(
      FlowCanvasState currentState, List<String> nodeIds) {
    if (nodeIds.isEmpty) {
      return [];
    }
    final nodeIdsSet = nodeIds.toSet();
    return currentState.edges
        .where((edge) =>
            nodeIdsSet.contains(edge.sourceNodeId) ||
            nodeIdsSet.contains(edge.targetNodeId))
        .toList();
  }

  /// Updates an existing edge to connect to a new source or target.
  FlowCanvasState reconnectEdge(
    FlowCanvasState currentState,
    String edgeId, {
    String? newSourceNodeId,
    String? newSourceHandleId,
    String? newTargetNodeId,
    String? newTargetHandleId,
  }) {
    final newEdges = currentState.edges.map((edge) {
      if (edge.id == edgeId) {
        return edge.copyWith(
          sourceNodeId: newSourceNodeId ?? edge.sourceNodeId,
          sourceHandleId: newSourceHandleId ?? edge.sourceHandleId,
          targetNodeId: newTargetNodeId ?? edge.targetNodeId,
          targetHandleId: newTargetHandleId ?? edge.targetHandleId,
        );
      }
      return edge;
    }).toList();

    return currentState.copyWith(edges: newEdges);
  }
}

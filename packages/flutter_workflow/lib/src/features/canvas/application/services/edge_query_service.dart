import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_indexing_service.dart';

/// Service for efficient edge queries using the EdgeIndex
class EdgeQueryService {
  List<FlowEdge> getEdgesConnectedToNode(EdgeIndex edgeIndex, String nodeId) {
    return edgeIndex.byNodeId[nodeId]
            ?.map((edgeId) => edgeIndex.edges[edgeId]!)
            .toList() ??
        [];
  }

  List<FlowEdge> getEdgesBetweenNodes(
      EdgeIndex edgeIndex, String sourceNodeId, String targetNodeId) {
    return edgeIndex.bySourceNodeId[sourceNodeId]
            ?.where((edgeId) {
              final edge = edgeIndex.edges[edgeId];
              return edge != null && edge.targetNodeId == targetNodeId;
            })
            .map((edgeId) => edgeIndex.edges[edgeId]!)
            .toList() ??
        [];
  }

  List<FlowEdge> getEdgesFromNode(EdgeIndex edgeIndex, String nodeId) {
    return edgeIndex.bySourceNodeId[nodeId]
            ?.map((edgeId) => edgeIndex.edges[edgeId]!)
            .toList() ??
        [];
  }

  List<FlowEdge> getEdgesToNode(EdgeIndex edgeIndex, String nodeId) {
    return edgeIndex.byTargetNodeId[nodeId]
            ?.map((edgeId) => edgeIndex.edges[edgeId]!)
            .toList() ??
        [];
  }

  List<FlowEdge> getSelectedEdges(EdgeIndex edgeIndex) {
    return edgeIndex.edges.values.where((edge) => edge.selected).toList();
  }
}

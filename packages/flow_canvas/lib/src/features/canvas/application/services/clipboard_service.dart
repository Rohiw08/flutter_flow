import 'package:flutter/painting.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/random_id_generator.dart';
import 'edge_service.dart';
import 'node_service.dart';

/// Service to handle copy/paste operations for nodes (and their connected edges).
class ClipboardService {
  /// Copies selected nodes and returns a transferable payload.
  Map<String, dynamic> copy(FlowCanvasState state) {
    final nodeIds = state.selectedNodes.toList();
    final nodes =
        nodeIds.map((id) => state.nodes[id]).whereType<FlowNode>().toList();

    // Include edges only if both ends are selected
    final edges = state.edges.values.where((e) {
      return nodeIds.contains(e.sourceNodeId) &&
          nodeIds.contains(e.targetNodeId);
    }).toList();

    return {
      'nodes': nodes,
      'edges': edges,
    };
  }

  /// Pastes previously copied nodes/edges, remaps IDs, and offsets positions.
  /// Pastes previously copied nodes/edges, remaps IDs, and offsets positions.
  FlowCanvasState paste(
    FlowCanvasState state,
    Map<String, dynamic> payload, {
    Offset positionOffset = const Offset(40, 40),
    // You will need access to NodeService and EdgeService
    required NodeService nodeService,
    required EdgeService edgeService,
  }) {
    final originalNodes = (payload['nodes'] as List<dynamic>? ?? const [])
        .whereType<FlowNode>()
        .toList();
    final originalEdges = (payload['edges'] as List<dynamic>? ?? const [])
        .whereType<FlowEdge>()
        .toList();

    if (originalNodes.isEmpty) return state;

    final idMap = <String, String>{};
    final List<FlowNode> newNodes = [];
    final List<FlowEdge> newEdges = [];

    // Prepare new nodes with new IDs and positions
    for (final node in originalNodes) {
      final newId = generateUniqueId();
      idMap[node.id] = newId;
      newNodes.add(node.copyWith(
        id: newId,
        position: node.position + positionOffset,
      ));
    }

    // Prepare new edges with remapped source/target IDs
    for (final edge in originalEdges) {
      final newSource = idMap[edge.sourceNodeId];
      final newTarget = idMap[edge.targetNodeId];
      if (newSource == null || newTarget == null) continue;

      final newId = generateUniqueId();
      newEdges.add(edge.copyWith(
        id: newId,
        sourceNodeId: newSource,
        targetNodeId: newTarget,
      ));
    }

    // Use the services to add the new elements to the state
    // This ensures the indexes are updated correctly.
    FlowCanvasState newState = state;
    newState = nodeService.addNodes(newState, newNodes);
    newState = edgeService.addEdges(newState, newEdges);
    return newState;
  }
}

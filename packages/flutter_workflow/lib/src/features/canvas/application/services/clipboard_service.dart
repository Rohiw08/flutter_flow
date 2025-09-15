import 'package:flutter/painting.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/utility/random_id_generator.dart';

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
  FlowCanvasState paste(
    FlowCanvasState state,
    Map<String, dynamic> payload, {
    Offset positionOffset = const Offset(40, 40),
  }) {
    final originalNodes = (payload['nodes'] as List<FlowNode>? ?? const []);
    final originalEdges = (payload['edges'] as List<FlowEdge>? ?? const []);

    if (originalNodes.isEmpty) return state;

    final idMap = <String, String>{};
    final newNodes = Map<String, FlowNode>.from(state.nodes);
    final newEdges = Map<String, FlowEdge>.from(state.edges);

    // Duplicate nodes
    for (final node in originalNodes) {
      final newId = generateUniqueId();
      idMap[node.id] = newId;
      newNodes[newId] = node.copyWith(
        id: newId,
        position: node.position + positionOffset,
      );
    }

    // Duplicate edges where both endpoints exist in the copied set
    for (final edge in originalEdges) {
      final newSource = idMap[edge.sourceNodeId];
      final newTarget = idMap[edge.targetNodeId];
      if (newSource == null || newTarget == null) continue;

      final newId = generateUniqueId();
      newEdges[newId] = edge.copyWith(
        id: newId,
        sourceNodeId: newSource,
        targetNodeId: newTarget,
      );
    }

    return state.copyWith(
      nodes: newNodes,
      edges: newEdges,
    );
  }
}

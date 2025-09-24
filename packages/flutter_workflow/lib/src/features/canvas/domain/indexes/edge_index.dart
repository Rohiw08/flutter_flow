import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';

/// An immutable, optimized indexing service for fast edge-related lookups.
class EdgeIndex {
  final Map<String, Set<String>> _nodeToEdges;
  final Map<String, Set<String>> _handleToEdges;
  final Map<String, Map<String, int>> _nodeConnections; // Changed type

  const EdgeIndex._({
    required Map<String, Set<String>> nodeToEdges,
    required Map<String, Set<String>> handleToEdges,
    required Map<String, Map<String, int>> nodeConnections, // Changed type
  })  : _nodeToEdges = nodeToEdges,
        _handleToEdges = handleToEdges,
        _nodeConnections = nodeConnections;

  factory EdgeIndex.empty() => const EdgeIndex._(
        nodeToEdges: {},
        handleToEdges: {},
        nodeConnections: {},
      );

  factory EdgeIndex.fromEdges(Map<String, FlowEdge> edges) {
    final nodeToEdges = <String, Set<String>>{};
    final handleToEdges = <String, Set<String>>{};
    final nodeConnections = <String, Map<String, int>>{};

    for (final entry in edges.entries) {
      final edge = entry.value;
      final edgeId = entry.key;

      (nodeToEdges[edge.sourceNodeId] ??= {}).add(edgeId);
      (nodeToEdges[edge.targetNodeId] ??= {}).add(edgeId);

      final sourceHandleKey =
          _getHandleKey(edge.sourceNodeId, edge.sourceHandleId);
      if (sourceHandleKey != null) {
        (handleToEdges[sourceHandleKey] ??= {}).add(edgeId);
      }
      final targetHandleKey =
          _getHandleKey(edge.targetNodeId, edge.targetHandleId);
      if (targetHandleKey != null) {
        (handleToEdges[targetHandleKey] ??= {}).add(edgeId);
      }

      // Increment connection counts
      (nodeConnections[edge.sourceNodeId] ??= {})
          .update(edge.targetNodeId, (count) => count + 1, ifAbsent: () => 1);
      (nodeConnections[edge.targetNodeId] ??= {})
          .update(edge.sourceNodeId, (count) => count + 1, ifAbsent: () => 1);
    }

    return EdgeIndex._(
      nodeToEdges: nodeToEdges,
      handleToEdges: handleToEdges,
      nodeConnections: nodeConnections,
    );
  }

  static String? _getHandleKey(String nodeId, String? handleId) {
    if (handleId == null || handleId.isEmpty) return null;
    return '$nodeId/$handleId';
  }

  Set<String> getEdgesForNode(String nodeId) =>
      _nodeToEdges[nodeId] ?? const {};

  Set<String> getEdgesForHandle(String nodeId, String handleId) {
    final key = _getHandleKey(nodeId, handleId);
    return key == null ? const {} : _handleToEdges[key] ?? const {};
  }

  Set<String> getConnectedNodes(String nodeId) =>
      _nodeConnections[nodeId]?.keys.toSet() ?? const {};

  bool isNodeConnected(String nodeId) =>
      _nodeToEdges[nodeId]?.isNotEmpty ?? false;

  bool isHandleConnected(String nodeId, String handleId) {
    final key = _getHandleKey(nodeId, handleId);
    return key == null ? false : _handleToEdges[key]?.isNotEmpty ?? false;
  }

  EdgeIndex addEdge(FlowEdge edge, String edgeId) {
    final newNodeToEdges = _copyMapOfSets(_nodeToEdges);
    final newHandleToEdges = _copyMapOfSets(_handleToEdges);
    final newNodeConnections = _deepCopyConnections(_nodeConnections);

    (newNodeToEdges[edge.sourceNodeId] ??= {}).add(edgeId);
    (newNodeToEdges[edge.targetNodeId] ??= {}).add(edgeId);

    final sourceHandleKey =
        _getHandleKey(edge.sourceNodeId, edge.sourceHandleId);
    if (sourceHandleKey != null) {
      (newHandleToEdges[sourceHandleKey] ??= {}).add(edgeId);
    }
    final targetHandleKey =
        _getHandleKey(edge.targetNodeId, edge.targetHandleId);
    if (targetHandleKey != null) {
      (newHandleToEdges[targetHandleKey] ??= {}).add(edgeId);
    }

    (newNodeConnections[edge.sourceNodeId] ??= {})
        .update(edge.targetNodeId, (count) => count + 1, ifAbsent: () => 1);
    (newNodeConnections[edge.targetNodeId] ??= {})
        .update(edge.sourceNodeId, (count) => count + 1, ifAbsent: () => 1);

    return EdgeIndex._(
      nodeToEdges: newNodeToEdges,
      handleToEdges: newHandleToEdges,
      nodeConnections: newNodeConnections,
    );
  }

  EdgeIndex removeEdge(String edgeId, FlowEdge edge) {
    final newNodeToEdges = _copyMapOfSets(_nodeToEdges);
    final newHandleToEdges = _copyMapOfSets(_handleToEdges);
    final newNodeConnections = _deepCopyConnections(_nodeConnections);

    _removeFromSet(newNodeToEdges, edge.sourceNodeId, edgeId);
    _removeFromSet(newNodeToEdges, edge.targetNodeId, edgeId);

    final sourceHandleKey =
        _getHandleKey(edge.sourceNodeId, edge.sourceHandleId);
    if (sourceHandleKey != null) {
      _removeFromSet(newHandleToEdges, sourceHandleKey, edgeId);
    }
    final targetHandleKey =
        _getHandleKey(edge.targetNodeId, edge.targetHandleId);
    if (targetHandleKey != null) {
      _removeFromSet(newHandleToEdges, targetHandleKey, edgeId);
    }

    // Decrement and remove connection if count is zero
    _updateConnectionCount(
        newNodeConnections, edge.sourceNodeId, edge.targetNodeId, -1);
    _updateConnectionCount(
        newNodeConnections, edge.targetNodeId, edge.sourceNodeId, -1);

    return EdgeIndex._(
      nodeToEdges: newNodeToEdges,
      handleToEdges: newHandleToEdges,
      nodeConnections: newNodeConnections,
    );
  }

  // Private helpers
  void _updateConnectionCount(Map<String, Map<String, int>> connections,
      String node1, String node2, int change) {
    if (connections.containsKey(node1)) {
      final newCount = (connections[node1]![node2] ?? 0) + change;
      if (newCount <= 0) {
        connections[node1]!.remove(node2);
        if (connections[node1]!.isEmpty) {
          connections.remove(node1);
        }
      } else {
        connections[node1]![node2] = newCount;
      }
    }
  }

  void _removeFromSet(Map<String, Set<String>> map, String key, String value) {
    final set = map[key];
    if (set != null) {
      set.remove(value);
      if (set.isEmpty) {
        map.remove(key);
      }
    }
  }

  Map<String, Set<String>> _copyMapOfSets(Map<String, Set<String>> original) {
    final copy = <String, Set<String>>{};
    for (final entry in original.entries) {
      copy[entry.key] = Set<String>.from(entry.value);
    }
    return copy;
  }

  Map<String, Map<String, int>> _deepCopyConnections(
      Map<String, Map<String, int>> original) {
    final copy = <String, Map<String, int>>{};
    for (final entry in original.entries) {
      copy[entry.key] = Map<String, int>.from(entry.value);
    }
    return copy;
  }
}

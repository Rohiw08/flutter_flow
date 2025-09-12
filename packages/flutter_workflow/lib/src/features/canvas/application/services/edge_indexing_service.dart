import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';

/// Optimized edge indexing service for fast lookups
class EdgeIndex {
  final Map<String, Set<String>> _nodeToEdges;
  final Map<String, Set<String>> _handleToEdges;
  final Map<String, Set<String>> _nodeConnections;

  /// Private constructor
  const EdgeIndex._({
    required Map<String, Set<String>> nodeToEdges,
    required Map<String, Set<String>> handleToEdges,
    required Map<String, Set<String>> nodeConnections,
  })  : _nodeToEdges = nodeToEdges,
        _handleToEdges = handleToEdges,
        _nodeConnections = nodeConnections;

  /// Create an empty index
  factory EdgeIndex.empty() => const EdgeIndex._(
        nodeToEdges: {},
        handleToEdges: {},
        nodeConnections: {},
      );

  /// Create index from edges
  factory EdgeIndex.fromEdges(Map<String, FlowEdge> edges) {
    final nodeToEdges = <String, Set<String>>{};
    final handleToEdges = <String, Set<String>>{};
    final nodeConnections = <String, Set<String>>{};

    for (final entry in edges.entries) {
      final edge = entry.value;
      final edgeId = entry.key;

      // Node → Edge IDs
      nodeToEdges.putIfAbsent(edge.sourceNodeId, () => {}).add(edgeId);
      nodeToEdges.putIfAbsent(edge.targetNodeId, () => {}).add(edgeId);

      // Handle → Edge IDs
      final sourceHandleKey = '${edge.sourceNodeId}/${edge.sourceHandleId}';
      final targetHandleKey = '${edge.targetNodeId}/${edge.targetHandleId}';
      handleToEdges.putIfAbsent(sourceHandleKey, () => {}).add(edgeId);
      handleToEdges.putIfAbsent(targetHandleKey, () => {}).add(edgeId);

      // Node connections (bidirectional)
      nodeConnections
          .putIfAbsent(edge.sourceNodeId, () => {})
          .add(edge.targetNodeId);
      nodeConnections
          .putIfAbsent(edge.targetNodeId, () => {})
          .add(edge.sourceNodeId);
    }

    return EdgeIndex._(
      nodeToEdges: nodeToEdges,
      handleToEdges: handleToEdges,
      nodeConnections: nodeConnections,
    );
  }

  /// Get edges for a node
  Set<String> getEdgesForNode(String nodeId) =>
      _nodeToEdges[nodeId] ?? <String>{};

  /// Get edges for a specific handle
  Set<String> getEdgesForHandle(String nodeId, String handleId) =>
      _handleToEdges['$nodeId/$handleId'] ?? <String>{};

  /// Get nodes connected to a specific node
  Set<String> getConnectedNodes(String nodeId) =>
      _nodeConnections[nodeId] ?? <String>{};

  /// Check if a node has any edges
  bool isNodeConnected(String nodeId) =>
      _nodeToEdges.containsKey(nodeId) && _nodeToEdges[nodeId]!.isNotEmpty;

  /// Check if a handle has any edges
  bool isHandleConnected(String nodeId, String handleId) =>
      _handleToEdges.containsKey('$nodeId/$handleId') &&
      _handleToEdges['$nodeId/$handleId']!.isNotEmpty;

  /// Add an edge to the index
  EdgeIndex addEdge(FlowEdge edge, String edgeId) {
    final newNodeToEdges = _copyMapOfSets(_nodeToEdges);
    final newHandleToEdges = _copyMapOfSets(_handleToEdges);
    final newNodeConnections = _copyMapOfSets(_nodeConnections);

    // Add to node → edges mapping
    newNodeToEdges.putIfAbsent(edge.sourceNodeId, () => {}).add(edgeId);
    newNodeToEdges.putIfAbsent(edge.targetNodeId, () => {}).add(edgeId);

    // Add to handle → edges mapping
    final sourceHandleKey = '${edge.sourceNodeId}/${edge.sourceHandleId}';
    final targetHandleKey = '${edge.targetNodeId}/${edge.targetHandleId}';
    newHandleToEdges.putIfAbsent(sourceHandleKey, () => {}).add(edgeId);
    newHandleToEdges.putIfAbsent(targetHandleKey, () => {}).add(edgeId);

    // Add to node connections
    newNodeConnections
        .putIfAbsent(edge.sourceNodeId, () => {})
        .add(edge.targetNodeId);
    newNodeConnections
        .putIfAbsent(edge.targetNodeId, () => {})
        .add(edge.sourceNodeId);

    return EdgeIndex._(
      nodeToEdges: newNodeToEdges,
      handleToEdges: newHandleToEdges,
      nodeConnections: newNodeConnections,
    );
  }

  /// Remove an edge from the index
  EdgeIndex removeEdge(String edgeId, FlowEdge edge) {
    final newNodeToEdges = _copyMapOfSets(_nodeToEdges);
    final newHandleToEdges = _copyMapOfSets(_handleToEdges);
    final newNodeConnections = _copyMapOfSets(_nodeConnections);

    // Remove from node → edges mapping
    _removeFromSet(newNodeToEdges, edge.sourceNodeId, edgeId);
    _removeFromSet(newNodeToEdges, edge.targetNodeId, edgeId);

    // Remove from handle → edges mapping
    final sourceHandleKey = '${edge.sourceNodeId}/${edge.sourceHandleId}';
    final targetHandleKey = '${edge.targetNodeId}/${edge.targetHandleId}';
    _removeFromSet(newHandleToEdges, sourceHandleKey, edgeId);
    _removeFromSet(newHandleToEdges, targetHandleKey, edgeId);

    // Remove from node connections
    _removeFromSet(newNodeConnections, edge.sourceNodeId, edge.targetNodeId);
    _removeFromSet(newNodeConnections, edge.targetNodeId, edge.sourceNodeId);

    return EdgeIndex._(
      nodeToEdges: newNodeToEdges,
      handleToEdges: newHandleToEdges,
      nodeConnections: newNodeConnections,
    );
  }

  /// Helper to remove an item from a set in a map
  void _removeFromSet(Map<String, Set<String>> map, String key, String value) {
    final set = map[key];
    if (set != null) {
      set.remove(value);
      if (set.isEmpty) {
        map.remove(key);
      }
    }
  }

  /// Deep copy a map of sets
  Map<String, Set<String>> _copyMapOfSets(Map<String, Set<String>> original) {
    final copy = <String, Set<String>>{};
    for (final entry in original.entries) {
      copy[entry.key] = Set<String>.from(entry.value);
    }
    return copy;
  }

  /// Get statistics for debugging
  Map<String, dynamic> get stats {
    final totalEdges =
        _nodeToEdges.values.fold<int>(0, (sum, set) => sum + set.length) ~/ 2;
    final nodesWithEdges = _nodeToEdges.keys.length;
    final avgEdgesPerNode =
        nodesWithEdges > 0 ? totalEdges / nodesWithEdges : 0;

    return {
      'total_edges': totalEdges,
      'nodes_with_edges': nodesWithEdges,
      'avg_edges_per_node': avgEdgesPerNode,
      'handle_entries': _handleToEdges.length,
    };
  }
}

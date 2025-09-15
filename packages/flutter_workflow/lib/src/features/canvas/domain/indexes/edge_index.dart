import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';

/// An immutable, optimized indexing service for fast edge-related lookups.
///
/// This class creates and maintains several maps to answer questions like:
/// - "Which edges are connected to this node?"
/// - "Which nodes are connected to this node?"
/// - "Is this handle connected to anything?"
///
/// All modification methods (`addEdge`, `removeEdge`) return a new instance
/// of the index, preserving immutability.
class EdgeIndex {
  final Map<String, Set<String>> _nodeToEdges;
  final Map<String, Set<String>> _handleToEdges;
  final Map<String, Set<String>> _nodeConnections;

  const EdgeIndex._({
    required Map<String, Set<String>> nodeToEdges,
    required Map<String, Set<String>> handleToEdges,
    required Map<String, Set<String>> nodeConnections,
  })  : _nodeToEdges = nodeToEdges,
        _handleToEdges = handleToEdges,
        _nodeConnections = nodeConnections;

  /// Creates a new, empty index.
  factory EdgeIndex.empty() => const EdgeIndex._(
        nodeToEdges: {},
        handleToEdges: {},
        nodeConnections: {},
      );

  /// Creates a new index from an existing map of edges.
  factory EdgeIndex.fromEdges(Map<String, FlowEdge> edges) {
    final nodeToEdges = <String, Set<String>>{};
    final handleToEdges = <String, Set<String>>{};
    final nodeConnections = <String, Set<String>>{};

    for (final entry in edges.entries) {
      final edge = entry.value;
      final edgeId = entry.key;

      // Node to Edges Index
      (nodeToEdges[edge.sourceNodeId] ??= {}).add(edgeId);
      (nodeToEdges[edge.targetNodeId] ??= {}).add(edgeId);

      // Handle to Edges Index (handles null safety)
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

      // Node to Node Connections Index
      (nodeConnections[edge.sourceNodeId] ??= {}).add(edge.targetNodeId);
      (nodeConnections[edge.targetNodeId] ??= {}).add(edge.sourceNodeId);
    }

    return EdgeIndex._(
      nodeToEdges: nodeToEdges,
      handleToEdges: handleToEdges,
      nodeConnections: nodeConnections,
    );
  }

  /// Creates a unique, safe key for a handle.
  static String? _getHandleKey(String nodeId, String? handleId) {
    if (handleId == null || handleId.isEmpty) return null;
    return '$nodeId/$handleId';
  }

  // Public getters

  /// Returns the set of edge IDs connected to a given node.
  Set<String> getEdgesForNode(String nodeId) =>
      _nodeToEdges[nodeId] ?? const {};

  /// Returns the set of edge IDs connected to a specific handle on a node.
  Set<String> getEdgesForHandle(String nodeId, String handleId) {
    final key = _getHandleKey(nodeId, handleId);
    return key == null ? const {} : _handleToEdges[key] ?? const {};
  }

  /// Returns the set of node IDs connected to a given node.
  Set<String> getConnectedNodes(String nodeId) =>
      _nodeConnections[nodeId] ?? const {};

  /// Checks if a node has any edges connected to it.
  bool isNodeConnected(String nodeId) =>
      _nodeToEdges[nodeId]?.isNotEmpty ?? false;

  /// Checks if a specific handle has any edges connected to it.
  bool isHandleConnected(String nodeId, String handleId) {
    final key = _getHandleKey(nodeId, handleId);
    return key == null ? false : _handleToEdges[key]?.isNotEmpty ?? false;
  }

  // Immutable modification methods

  /// Returns a new `EdgeIndex` instance with the added edge.
  EdgeIndex addEdge(FlowEdge edge, String edgeId) {
    final newNodeToEdges = _copyMapOfSets(_nodeToEdges);
    final newHandleToEdges = _copyMapOfSets(_handleToEdges);
    final newNodeConnections = _copyMapOfSets(_nodeConnections);

    // Add to node -> edges mapping
    (newNodeToEdges[edge.sourceNodeId] ??= {}).add(edgeId);
    (newNodeToEdges[edge.targetNodeId] ??= {}).add(edgeId);

    // Add to handle -> edges mapping
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

    // Add to node connections
    (newNodeConnections[edge.sourceNodeId] ??= {}).add(edge.targetNodeId);
    (newNodeConnections[edge.targetNodeId] ??= {}).add(edge.sourceNodeId);

    return EdgeIndex._(
      nodeToEdges: newNodeToEdges,
      handleToEdges: newHandleToEdges,
      nodeConnections: newNodeConnections,
    );
  }

  /// Returns a new `EdgeIndex` instance with the removed edge.
  EdgeIndex removeEdge(String edgeId, FlowEdge edge) {
    final newNodeToEdges = _copyMapOfSets(_nodeToEdges);
    final newHandleToEdges = _copyMapOfSets(_handleToEdges);
    final newNodeConnections = _copyMapOfSets(_nodeConnections);

    // Remove from node -> edges mapping
    _removeFromSet(newNodeToEdges, edge.sourceNodeId, edgeId);
    _removeFromSet(newNodeToEdges, edge.targetNodeId, edgeId);

    // Remove from handle -> edges mapping
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

    // Remove from node connections (only if no other edges connect the two nodes)
    final remainingEdges = newNodeToEdges[edge.sourceNodeId]?.intersection(
      newNodeToEdges[edge.targetNodeId] ?? {},
    );
    if (remainingEdges?.isEmpty ?? true) {
      newNodeConnections[edge.sourceNodeId]?.remove(edge.targetNodeId);
      newNodeConnections[edge.targetNodeId]?.remove(edge.sourceNodeId);
    }

    return EdgeIndex._(
      nodeToEdges: newNodeToEdges,
      handleToEdges: newHandleToEdges,
      nodeConnections: newNodeConnections,
    );
  }

  // Private helpers

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
}

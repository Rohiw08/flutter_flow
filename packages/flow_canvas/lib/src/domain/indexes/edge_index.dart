import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';

/// Immutable, optimized spatial index for edge relationships.
///
/// Provides efficient lookup of edges connected to nodes or handles,
/// and tracks bidirectional connection counts between nodes.
///
/// This class is **immutable**: all mutation operations (add/remove)
/// return new `EdgeIndex` instances with updated internal maps.
///
/// Design inspired by React Flow's edge caching and immutable update pattern.
class EdgeIndex {
  /// Maps node IDs → connected edge IDs (both directions).
  final Map<String, Set<String>> _nodeToEdges;

  /// Maps "nodeId/handleId" keys → edge IDs connected to specific handles.
  final Map<String, Set<String>> _handleToEdges;

  /// Maps node A → (node B → connection count).
  ///
  /// Used for quickly checking connection multiplicity
  /// and adjacency relationships.
  final Map<String, Map<String, int>> _nodeConnections;

  /// Private core constructor — internal use only.
  const EdgeIndex._({
    required Map<String, Set<String>> nodeToEdges,
    required Map<String, Set<String>> handleToEdges,
    required Map<String, Map<String, int>> nodeConnections,
  })  : _nodeToEdges = nodeToEdges,
        _handleToEdges = handleToEdges,
        _nodeConnections = nodeConnections;

  /// Returns an empty index for new or reset graphs.
  factory EdgeIndex.empty() => const EdgeIndex._(
        nodeToEdges: {},
        handleToEdges: {},
        nodeConnections: {},
      );

  /// Builds a full index for all given edges.
  factory EdgeIndex.fromEdges(Map<String, FlowEdge> edges) {
    final nodeToEdges = <String, Set<String>>{};
    final handleToEdges = <String, Set<String>>{};
    final nodeConnections = <String, Map<String, int>>{};

    for (final entry in edges.entries) {
      final edgeId = entry.key;
      final edge = entry.value;

      // Register node → edges
      (nodeToEdges[edge.sourceNodeId] ??= <String>{}).add(edgeId);
      (nodeToEdges[edge.targetNodeId] ??= <String>{}).add(edgeId);

      // Register handle → edges
      final srcKey = _handleKey(edge.sourceNodeId, edge.sourceHandleId);
      final tgtKey = _handleKey(edge.targetNodeId, edge.targetHandleId);
      if (srcKey != null) (handleToEdges[srcKey] ??= <String>{}).add(edgeId);
      if (tgtKey != null) (handleToEdges[tgtKey] ??= <String>{}).add(edgeId);

      // Register connection counts
      _incrementConnection(
          nodeConnections, edge.sourceNodeId, edge.targetNodeId);
      _incrementConnection(
          nodeConnections, edge.targetNodeId, edge.sourceNodeId);
    }

    return EdgeIndex._(
      nodeToEdges: nodeToEdges,
      handleToEdges: handleToEdges,
      nodeConnections: nodeConnections,
    );
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Returns all edge IDs connected to the given node.
  Set<String> getEdgesForNode(String nodeId) =>
      _nodeToEdges[nodeId] ?? const {};

  /// Returns all edge IDs for a specific node handle.
  Set<String> getEdgesForHandle(String nodeId, String handleId) {
    final key = _handleKey(nodeId, handleId);
    return key == null ? const {} : _handleToEdges[key] ?? const {};
  }

  /// Returns all node IDs directly connected to [nodeId].
  Set<String> getConnectedNodes(String nodeId) =>
      _nodeConnections[nodeId]?.keys.toSet() ?? const {};

  /// Whether [nodeId] has any connected edges.
  bool isNodeConnected(String nodeId) =>
      _nodeToEdges[nodeId]?.isNotEmpty ?? false;

  /// Whether a handle has at least one connected edge.
  bool isHandleConnected(String nodeId, String handleId) {
    final key = _handleKey(nodeId, handleId);
    return key != null && (_handleToEdges[key]?.isNotEmpty ?? false);
  }

  // ---------------------------------------------------------------------------
  // Mutation — returns new instances
  // ---------------------------------------------------------------------------

  /// Adds [edge] to the index and returns a new immutable index.
  EdgeIndex addEdge(FlowEdge edge, String edgeId) {
    final nodeToEdges = _cloneMapOfSets(_nodeToEdges);
    final handleToEdges = _cloneMapOfSets(_handleToEdges);
    final nodeConnections = _cloneConnections(_nodeConnections);

    // Register node/handle → edge
    (nodeToEdges[edge.sourceNodeId] ??= <String>{}).add(edgeId);
    (nodeToEdges[edge.targetNodeId] ??= <String>{}).add(edgeId);

    final srcKey = _handleKey(edge.sourceNodeId, edge.sourceHandleId);
    final tgtKey = _handleKey(edge.targetNodeId, edge.targetHandleId);
    if (srcKey != null) (handleToEdges[srcKey] ??= <String>{}).add(edgeId);
    if (tgtKey != null) (handleToEdges[tgtKey] ??= <String>{}).add(edgeId);

    _incrementConnection(nodeConnections, edge.sourceNodeId, edge.targetNodeId);
    _incrementConnection(nodeConnections, edge.targetNodeId, edge.sourceNodeId);

    return EdgeIndex._(
      nodeToEdges: nodeToEdges,
      handleToEdges: handleToEdges,
      nodeConnections: nodeConnections,
    );
  }

  /// Removes [edge] by ID and returns a new immutable index.
  EdgeIndex removeEdge(String edgeId, FlowEdge edge) {
    final nodeToEdges = _cloneMapOfSets(_nodeToEdges);
    final handleToEdges = _cloneMapOfSets(_handleToEdges);
    final nodeConnections = _cloneConnections(_nodeConnections);

    _removeValue(nodeToEdges, edge.sourceNodeId, edgeId);
    _removeValue(nodeToEdges, edge.targetNodeId, edgeId);

    final srcKey = _handleKey(edge.sourceNodeId, edge.sourceHandleId);
    final tgtKey = _handleKey(edge.targetNodeId, edge.targetHandleId);
    if (srcKey != null) _removeValue(handleToEdges, srcKey, edgeId);
    if (tgtKey != null) _removeValue(handleToEdges, tgtKey, edgeId);

    _decrementConnection(nodeConnections, edge.sourceNodeId, edge.targetNodeId);
    _decrementConnection(nodeConnections, edge.targetNodeId, edge.sourceNodeId);

    return EdgeIndex._(
      nodeToEdges: nodeToEdges,
      handleToEdges: handleToEdges,
      nodeConnections: nodeConnections,
    );
  }

  // ---------------------------------------------------------------------------
  // Utility functions
  // ---------------------------------------------------------------------------

  /// Helper: builds a consistent handle map key.
  static String? _handleKey(String nodeId, String? handleId) {
    if (handleId == null || handleId.isEmpty) return null;
    return '$nodeId/$handleId';
  }

  /// Increments a node→node edge count.
  static void _incrementConnection(
    Map<String, Map<String, int>> map,
    String from,
    String to,
  ) =>
      (map[from] ??= <String, int>{})
          .update(to, (c) => c + 1, ifAbsent: () => 1);

  /// Decrements connection count or removes entry if zero.
  static void _decrementConnection(
    Map<String, Map<String, int>> map,
    String from,
    String to,
  ) {
    final entry = map[from];
    if (entry == null) return;
    final count = (entry[to] ?? 0) - 1;
    if (count <= 0) {
      entry.remove(to);
      if (entry.isEmpty) map.remove(from);
    } else {
      entry[to] = count;
    }
  }

  /// Removes a value from a [Map]<String,Set<String>> immutably.
  static void _removeValue(
      Map<String, Set<String>> map, String key, String value) {
    final set = map[key];
    if (set == null) return;
    set.remove(value);
    if (set.isEmpty) map.remove(key);
  }

  /// Deep clones a map of sets.
  static Map<String, Set<String>> _cloneMapOfSets(
      Map<String, Set<String>> src) {
    final copy = <String, Set<String>>{};
    for (final e in src.entries) {
      copy[e.key] = Set<String>.from(e.value);
    }
    return copy;
  }

  /// Deep clones a map of map<int>.
  static Map<String, Map<String, int>> _cloneConnections(
    Map<String, Map<String, int>> src,
  ) {
    final copy = <String, Map<String, int>>{};
    for (final e in src.entries) {
      copy[e.key] = Map<String, int>.from(e.value);
    }
    return copy;
  }

  // ---------------------------------------------------------------------------
  // Diagnostics
  // ---------------------------------------------------------------------------

  /// Returns the total edge count in the index (for debug/validation).
  int get totalEdges {
    final seen = <String>{};
    for (final edges in _nodeToEdges.values) {
      seen.addAll(edges);
    }
    return seen.length;
  }

  /// Returns true if the index contains no connections.
  bool get isEmpty =>
      _nodeToEdges.isEmpty &&
      _handleToEdges.isEmpty &&
      _nodeConnections.isEmpty;

  @override
  String toString() =>
      'EdgeIndex(nodes: ${_nodeToEdges.length}, handles: ${_handleToEdges.length})';
}

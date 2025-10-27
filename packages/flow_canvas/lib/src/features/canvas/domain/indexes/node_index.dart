import 'package:flutter/painting.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';

typedef CellKey = String;

/// Immutable, spatial index optimized for fast node and handle lookups.
///
/// ### Coordinate System
/// - Origin `(0, 0)` is at the **canvas center**
/// - +X → right, -X → left
/// - +Y → **up**, -Y → **down**
/// - Matches [`FlowNode.position`]
///
/// This index supports efficient querying of nodes and handles in Cartesian space.
/// It is **purely immutable**, making it safe for use with state management systems
/// like Riverpod or Redux.
class NodeIndex {
  static const double _defaultCellSize = 10.0;

  final Map<String, FlowNode> _nodes;
  final Map<CellKey, Set<String>> _nodeSpatialGrid;
  final Map<CellKey, Set<String>> _handleSpatialGrid;
  final double _cellSize;

  const NodeIndex._({
    required Map<String, FlowNode> nodes,
    required Map<CellKey, Set<String>> nodeSpatialGrid,
    required Map<CellKey, Set<String>> handleSpatialGrid,
    required double cellSize,
  })  : _nodes = nodes,
        _nodeSpatialGrid = nodeSpatialGrid,
        _handleSpatialGrid = handleSpatialGrid,
        _cellSize = cellSize;

  /// Creates an empty spatial index.
  factory NodeIndex.empty({double cellSize = _defaultCellSize}) => NodeIndex._(
        nodes: const {},
        nodeSpatialGrid: const {},
        handleSpatialGrid: const {},
        cellSize: cellSize,
      );

  /// Builds an index from an initial set of nodes.
  factory NodeIndex.fromNodes(
    Iterable<FlowNode> nodes, {
    double cellSize = _defaultCellSize,
  }) {
    final nodeMap = <String, FlowNode>{};
    final nodeGrid = <CellKey, Set<String>>{};
    final handleGrid = <CellKey, Set<String>>{};

    for (final node in nodes) {
      nodeMap[node.id] = node;
      _addNodeToGrids(node, nodeGrid, handleGrid, cellSize);
    }

    return NodeIndex._(
      nodes: nodeMap,
      nodeSpatialGrid: nodeGrid,
      handleSpatialGrid: handleGrid,
      cellSize: cellSize,
    );
  }

  // --- PUBLIC API ---

  /// Returns the node with the given [nodeId], or `null` if not found.
  FlowNode? getNode(String nodeId) => _nodes[nodeId];

  /// Returns all nodes in this index.
  Iterable<FlowNode> get allNodes => _nodes.values;

  /// Queries nodes whose bounding boxes intersect the given [rect].
  ///
  /// The rectangle must be specified in **Cartesian coordinates**.
  Set<String> queryNodesInRect(Rect rect) {
    final resultIds = <String>{};
    final cells = _getCellsInRect(rect, _cellSize);

    for (final cellKey in cells) {
      final ids = _nodeSpatialGrid[cellKey];
      if (ids != null) resultIds.addAll(ids);
    }
    return resultIds;
  }

  /// Queries handles near the given [position] (checks surrounding 9 cells).
  Set<String> queryHandlesNear(Offset position) {
    final gridX = (position.dx / _cellSize).floor();
    final gridY = (position.dy / _cellSize).floor();
    final nearbyHandles = <String>{};

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        final key = '${gridX + dx}:${gridY + dy}';
        final handles = _handleSpatialGrid[key];
        if (handles != null) nearbyHandles.addAll(handles);
      }
    }
    return nearbyHandles;
  }

  /// Adds [node] to the index and returns a new updated instance.
  NodeIndex addNode(FlowNode node) {
    final newNodeMap = Map<String, FlowNode>.from(_nodes)..[node.id] = node;
    final newNodeGrid = _cloneGrid(_nodeSpatialGrid);
    final newHandleGrid = _cloneGrid(_handleSpatialGrid);

    _addNodeToGrids(node, newNodeGrid, newHandleGrid, _cellSize);

    return NodeIndex._(
      nodes: newNodeMap,
      nodeSpatialGrid: newNodeGrid,
      handleSpatialGrid: newHandleGrid,
      cellSize: _cellSize,
    );
  }

  /// Removes [node] from the index and returns a new updated instance.
  NodeIndex removeNode(FlowNode node) {
    if (!_nodes.containsKey(node.id)) return this;

    final newNodeMap = Map<String, FlowNode>.from(_nodes)..remove(node.id);
    final newNodeGrid = _cloneGrid(_nodeSpatialGrid);
    final newHandleGrid = _cloneGrid(_handleSpatialGrid);

    _removeNodeFromGrids(node, newNodeGrid, newHandleGrid, _cellSize);

    return NodeIndex._(
      nodes: newNodeMap,
      nodeSpatialGrid: newNodeGrid,
      handleSpatialGrid: newHandleGrid,
      cellSize: _cellSize,
    );
  }

  /// Updates [oldNode] to [newNode] within the index.
  ///
  /// If [oldNode] does not exist, it behaves like [addNode].
  NodeIndex updateNode(FlowNode oldNode, FlowNode newNode) {
    if (!_nodes.containsKey(oldNode.id)) return addNode(newNode);

    // Fast path: skip update if identical in geometry
    if (identical(oldNode, newNode) || oldNode == newNode) return this;

    final newNodeMap = Map<String, FlowNode>.from(_nodes)
      ..[newNode.id] = newNode;
    final newNodeGrid = _cloneGrid(_nodeSpatialGrid);
    final newHandleGrid = _cloneGrid(_handleSpatialGrid);

    _removeNodeFromGrids(oldNode, newNodeGrid, newHandleGrid, _cellSize);
    _addNodeToGrids(newNode, newNodeGrid, newHandleGrid, _cellSize);

    return NodeIndex._(
      nodes: newNodeMap,
      nodeSpatialGrid: newNodeGrid,
      handleSpatialGrid: newHandleGrid,
      cellSize: _cellSize,
    );
  }

  // --- INTERNAL HELPERS ---

  static void _addNodeToGrids(
    FlowNode node,
    Map<CellKey, Set<String>> nodeGrid,
    Map<CellKey, Set<String>> handleGrid,
    double cellSize,
  ) {
    final nodeCells = _getCellsInRect(node.rect, cellSize);
    for (final key in nodeCells) {
      nodeGrid.putIfAbsent(key, () => <String>{}).add(node.id);
    }

    for (final handle in node.handles.values) {
      final handlePos = node.position + handle.position;
      final key = _getCellKey(handlePos, cellSize);
      handleGrid
          .putIfAbsent(key, () => <String>{})
          .add('${node.id}/${handle.id}');
    }
  }

  static void _removeNodeFromGrids(
    FlowNode node,
    Map<CellKey, Set<String>> nodeGrid,
    Map<CellKey, Set<String>> handleGrid,
    double cellSize,
  ) {
    final nodeCells = _getCellsInRect(node.rect, cellSize);
    for (final key in nodeCells) {
      _removeFromGrid(nodeGrid, key, node.id);
    }

    for (final handle in node.handles.values) {
      final handlePos = node.position + handle.position;
      final key = _getCellKey(handlePos, cellSize);
      _removeFromGrid(handleGrid, key, '${node.id}/${handle.id}');
    }
  }

  static void _removeFromGrid(
    Map<CellKey, Set<String>> grid,
    CellKey key,
    String id,
  ) {
    final cell = grid[key];
    if (cell == null) return;
    cell.remove(id);
    if (cell.isEmpty) grid.remove(key);
  }

  static Set<CellKey> _getCellsInRect(Rect rect, double cellSize) {
    final cells = <CellKey>{};
    final minX = (rect.left / cellSize).floor();
    final maxX = (rect.right / cellSize).floor();
    final minY = (rect.top / cellSize).floor();
    final maxY = (rect.bottom / cellSize).floor();

    for (int x = minX; x <= maxX; x++) {
      for (int y = minY; y <= maxY; y++) {
        cells.add('$x:$y');
      }
    }
    return cells;
  }

  static CellKey _getCellKey(Offset pos, double cellSize) {
    final cx = (pos.dx / cellSize).floor();
    final cy = (pos.dy / cellSize).floor();
    return '$cx:$cy';
  }

  static Map<CellKey, Set<String>> _cloneGrid(
      Map<CellKey, Set<String>> original) {
    if (original.isEmpty) return {};
    final copy = <CellKey, Set<String>>{};
    for (final entry in original.entries) {
      copy[entry.key] = Set<String>.from(entry.value);
    }
    return copy;
  }

  @override
  String toString() =>
      'NodeIndex(nodes: ${_nodes.length}, cells: ${_nodeSpatialGrid.length}, handles: ${_handleSpatialGrid.length})';
}

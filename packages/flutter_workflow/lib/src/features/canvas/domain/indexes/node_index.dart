import 'package:flutter/painting.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';

typedef CellKey = String;

/// Highly optimized, immutable index for nodes and their handles.
///
/// This class uses a spatial grid to provide high-performance queries for:
/// - Finding nodes within a rectangle (for culling and box selection).
/// - Finding handles near a point (for making connections).
class NodeIndex {
  static const double _defaultCellSize = 200.0;

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

  /// Creates a new, empty index.
  factory NodeIndex.empty({double cellSize = _defaultCellSize}) {
    return NodeIndex._(
      nodes: {},
      nodeSpatialGrid: {},
      handleSpatialGrid: {},
      cellSize: cellSize,
    );
  }

  /// Creates a new index from an existing collection of nodes.
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

  // --- PUBLIC GETTERS ---

  /// Returns a node by its ID, or null if not found.
  FlowNode? getNode(String nodeId) => _nodes[nodeId];

  /// Returns an iterable of all nodes in the index.
  Iterable<FlowNode> get allNodes => _nodes.values;

  /// Finds all nodes whose bounding boxes overlap with the given rectangle.
  /// This is a broad-phase query; a more precise filter may be needed.
  List<FlowNode> queryNodesInRect(Rect rect) {
    final result = <String>{}; // Use a set to avoid duplicates
    final cells = _getCellsInRect(rect);

    for (final cellKey in cells) {
      final nodeIds = _nodeSpatialGrid[cellKey];
      if (nodeIds != null) {
        result.addAll(nodeIds);
      }
    }

    // Final filter, as the grid is an approximation based on top-left position.
    return result
        .map((id) => _nodes[id])
        .where((node) => node != null && rect.overlaps(node.rect))
        .cast<FlowNode>()
        .toList();
  }

  /// Finds all handle IDs within a 3x3 grid area around the given position.
  Set<String> queryHandlesNear(Offset position) {
    final gridX = (position.dx / _cellSize).floor();
    final gridY = (position.dy / _cellSize).floor();
    final nearbyHandles = <String>{};

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        final key = '${gridX + x}:${gridY + y}';
        final handlesInCell = _handleSpatialGrid[key];
        if (handlesInCell != null) {
          nearbyHandles.addAll(handlesInCell);
        }
      }
    }
    return nearbyHandles;
  }

  // --- IMMUTABLE MODIFICATION METHODS ---

  /// Returns a new index with the added node.
  NodeIndex addNode(FlowNode node) {
    final newNodeMap = Map<String, FlowNode>.from(_nodes)..[node.id] = node;
    final newNodeGrid = _deepCopyGrid(_nodeSpatialGrid);
    final newHandleGrid = _deepCopyGrid(_handleSpatialGrid);

    _addNodeToGrids(node, newNodeGrid, newHandleGrid, _cellSize);

    return NodeIndex._(
      nodes: newNodeMap,
      nodeSpatialGrid: newNodeGrid,
      handleSpatialGrid: newHandleGrid,
      cellSize: _cellSize,
    );
  }

  /// Returns a new index with the removed node.
  NodeIndex removeNode(FlowNode node) {
    if (!_nodes.containsKey(node.id)) return this;

    final newNodeMap = Map<String, FlowNode>.from(_nodes)..remove(node.id);
    final newNodeGrid = _deepCopyGrid(_nodeSpatialGrid);
    final newHandleGrid = _deepCopyGrid(_handleSpatialGrid);

    _removeNodeFromGrids(node, newNodeGrid, newHandleGrid, _cellSize);

    return NodeIndex._(
      nodes: newNodeMap,
      nodeSpatialGrid: newNodeGrid,
      handleSpatialGrid: newHandleGrid,
      cellSize: _cellSize,
    );
  }

  /// Returns a new index with the updated node. This is more efficient
  /// than a remove and add, especially for position changes.
  NodeIndex updateNode(FlowNode oldNode, FlowNode newNode) {
    if (!_nodes.containsKey(oldNode.id)) return addNode(newNode);

    final newNodeMap = Map<String, FlowNode>.from(_nodes)
      ..[newNode.id] = newNode;
    final newNodeGrid = _deepCopyGrid(_nodeSpatialGrid);
    final newHandleGrid = _deepCopyGrid(_handleSpatialGrid);

    _removeNodeFromGrids(oldNode, newNodeGrid, newHandleGrid, _cellSize);
    _addNodeToGrids(newNode, newNodeGrid, newHandleGrid, _cellSize);

    return NodeIndex._(
      nodes: newNodeMap,
      nodeSpatialGrid: newNodeGrid,
      handleSpatialGrid: newHandleGrid,
      cellSize: _cellSize,
    );
  }

  // --- PRIVATE HELPERS ---

  static void _addNodeToGrids(FlowNode node, Map<CellKey, Set<String>> nodeGrid,
      Map<CellKey, Set<String>> handleGrid, double cellSize) {
    // Add node's top-left position to its grid for broad-phase checks
    final nodeCellKey = _getCellKey(node.position, cellSize);
    nodeGrid.putIfAbsent(nodeCellKey, () => {}).add(node.id);

    // Add all of its handles to the handle spatial grid
    for (final handle in node.handles.values) {
      final handlePosition = node.position + handle.position;
      final handleCellKey = _getCellKey(handlePosition, cellSize);
      // Store as 'nodeId/handleId' for easy parsing later
      handleGrid
          .putIfAbsent(handleCellKey, () => {})
          .add('${node.id}/${handle.id}');
    }
  }

  static void _removeNodeFromGrids(
      FlowNode node,
      Map<CellKey, Set<String>> nodeGrid,
      Map<CellKey, Set<String>> handleGrid,
      double cellSize) {
    // Remove node
    final nodeCellKey = _getCellKey(node.position, cellSize);
    _removeFromGrid(nodeGrid, nodeCellKey, node.id);

    // Remove handles
    for (final handle in node.handles.values) {
      final handlePosition = node.position + handle.position;
      final handleCellKey = _getCellKey(handlePosition, cellSize);
      _removeFromGrid(handleGrid, handleCellKey, '${node.id}/${handle.id}');
    }
  }

  static void _removeFromGrid(
      Map<CellKey, Set<String>> grid, CellKey key, String id) {
    final cell = grid[key];
    if (cell != null) {
      cell.remove(id);
      if (cell.isEmpty) {
        grid.remove(key);
      }
    }
  }

  Set<CellKey> _getCellsInRect(Rect rect) {
    final cells = <CellKey>{};
    final minX = (rect.left / _cellSize).floor();
    final maxX = (rect.right / _cellSize).floor();
    final minY = (rect.top / _cellSize).floor();
    final maxY = (rect.bottom / _cellSize).floor();

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

  Map<CellKey, Set<String>> _deepCopyGrid(Map<CellKey, Set<String>> original) {
    final copy = <CellKey, Set<String>>{};
    for (final entry in original.entries) {
      copy[entry.key] = Set<String>.from(entry.value);
    }
    return copy;
  }
}

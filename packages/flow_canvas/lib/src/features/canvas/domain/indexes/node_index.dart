import 'package:flutter/painting.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';

typedef CellKey = String;

/// Highly optimized, immutable index for nodes and their handles.
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

  factory NodeIndex.empty({double cellSize = _defaultCellSize}) {
    return NodeIndex._(
      nodes: {},
      nodeSpatialGrid: {},
      handleSpatialGrid: {},
      cellSize: cellSize,
    );
  }

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

  FlowNode? getNode(String nodeId) => _nodes[nodeId];

  Iterable<FlowNode> get allNodes => _nodes.values;

  List<FlowNode> queryNodesInRect(Rect rect) {
    final resultIds = <String>{};
    final cells = _getCellsInRect(rect, _cellSize);

    for (final cellKey in cells) {
      final nodeIds = _nodeSpatialGrid[cellKey];
      if (nodeIds != null) {
        resultIds.addAll(nodeIds);
      }
    }

    // The final filter is no longer needed because the grid is more accurate
    return resultIds
        .map((id) => _nodes[id])
        .where((node) => node != null)
        .cast<FlowNode>()
        .toList();
  }

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
    final cells = _getCellsInRect(node.rect, cellSize);
    for (final cellKey in cells) {
      nodeGrid.putIfAbsent(cellKey, () => {}).add(node.id);
    }

    for (final handle in node.handles.values) {
      final handlePosition = node.position +
          Offset(
            handle.position.dx,
            -handle.position.dy,
          );
      final handleCellKey = _getCellKey(handlePosition, cellSize);
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
    final cells = _getCellsInRect(node.rect, cellSize);
    for (final cellKey in cells) {
      _removeFromGrid(nodeGrid, cellKey, node.id);
    }

    for (final handle in node.handles.values) {
      final handlePosition = node.position +
          Offset(
            handle.position.dx,
            -handle.position.dy,
          );
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

  Map<CellKey, Set<String>> _deepCopyGrid(Map<CellKey, Set<String>> original) {
    final copy = <CellKey, Set<String>>{};
    for (final entry in original.entries) {
      copy[entry.key] = Set<String>.from(entry.value);
    }
    return copy;
  }
}

import 'package:flutter/painting.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';

/// Spatial grid cell key
typedef CellKey = String;

/// Highly optimized node indexing for node-based editors
class NodeIndex {
  static const double _defaultCellSize = 200.0;

  final Map<String, FlowNode> _nodes;
  final Map<String, Set<String>> _connections;
  final Map<CellKey, Set<String>> _spatialGrid;
  final double _cellSize;

  NodeIndex._({
    required Map<String, FlowNode> nodes,
    required Map<String, Set<String>> connections,
    required Map<CellKey, Set<String>> spatialGrid,
    required double cellSize,
  })  : _nodes = nodes,
        _connections = connections,
        _spatialGrid = spatialGrid,
        _cellSize = cellSize;

  /// Create an empty index with optional cell size
  factory NodeIndex.empty({double cellSize = _defaultCellSize}) {
    return NodeIndex._(
      nodes: {},
      connections: {},
      spatialGrid: {},
      cellSize: cellSize,
    );
  }

  /// Create index from nodes with optional adjacency list
  factory NodeIndex.fromNodes(
    Iterable<FlowNode> nodes, {
    Map<String, Set<String>>? adjacency,
    double cellSize = _defaultCellSize,
  }) {
    final nodeMap = <String, FlowNode>{};
    final connectionMap = <String, Set<String>>{};
    final spatialGrid = <CellKey, Set<String>>{};

    for (final node in nodes) {
      nodeMap[node.id] = node;
      connectionMap[node.id] = Set<String>.from(adjacency?[node.id] ?? {});
      final cellKey = _cellKey(node.position, cellSize);
      spatialGrid.putIfAbsent(cellKey, () => {}).add(node.id);
    }

    // Ensure bidirectional connections
    for (final nodeId in connectionMap.keys) {
      for (final neighborId in connectionMap[nodeId]!) {
        connectionMap.putIfAbsent(neighborId, () => {}).add(nodeId);
      }
    }

    return NodeIndex._(
      nodes: nodeMap,
      connections: connectionMap,
      spatialGrid: spatialGrid,
      cellSize: cellSize,
    );
  }

  /// Get a node by ID
  FlowNode? getNode(String nodeId) => _nodes[nodeId];

  /// Get connected nodes for a given node
  Set<String> getConnectedNodes(String nodeId) =>
      _connections[nodeId] ?? <String>{};

  /// Query nodes within a rectangle using spatial grid
  List<FlowNode> queryInRect(Rect rect) {
    final result = <FlowNode>[];
    final cells = _getCellsInRect(rect);

    for (final cell in cells) {
      final nodeIds = _spatialGrid[cell];
      if (nodeIds == null) continue;

      for (final nodeId in nodeIds) {
        final node = _nodes[nodeId];
        if (node != null && rect.contains(node.position)) {
          result.add(node);
        }
      }
    }

    return result;
  }

  /// Query nodes near a point within radius using spatial grid
  List<FlowNode> queryNearPoint(Offset point, double radius) {
    final rect = Rect.fromCircle(center: point, radius: radius);
    return queryInRect(rect);
  }

  /// Get all isolated nodes (no connections)
  List<FlowNode> getIsolatedNodes() {
    return _nodes.values
        .where((node) => _connections[node.id]?.isEmpty ?? true)
        .toList();
  }

  /// Add a node to the index
  NodeIndex addNode(FlowNode node, {Iterable<String> connectedTo = const []}) {
    final newNodeMap = Map<String, FlowNode>.from(_nodes);
    final newConnectionMap = _deepCopyConnections();
    final newSpatialGrid = _deepCopySpatialGrid();

    newNodeMap[node.id] = node;
    final cellKey = _cellKey(node.position, _cellSize);
    newSpatialGrid.putIfAbsent(cellKey, () => {}).add(node.id);

    newConnectionMap[node.id] = Set<String>.from(connectedTo);
    for (final neighborId in connectedTo) {
      newConnectionMap.putIfAbsent(neighborId, () => {}).add(node.id);
    }

    return NodeIndex._(
      nodes: newNodeMap,
      connections: newConnectionMap,
      spatialGrid: newSpatialGrid,
      cellSize: _cellSize,
    );
  }

  /// Remove a node from the index
  NodeIndex removeNode(String nodeId) {
    if (!_nodes.containsKey(nodeId)) return this;

    final newNodeMap = Map<String, FlowNode>.from(_nodes);
    final newConnectionMap = _deepCopyConnections();
    final newSpatialGrid = _deepCopySpatialGrid();

    final removedNode = newNodeMap.remove(nodeId);

    if (removedNode != null) {
      final cellKey = _cellKey(removedNode.position, _cellSize);
      newSpatialGrid[cellKey]?.remove(nodeId);
      if (newSpatialGrid[cellKey]?.isEmpty ?? false) {
        newSpatialGrid.remove(cellKey);
      }
    }

    final neighbors = newConnectionMap.remove(nodeId) ?? {};
    for (final neighborId in neighbors) {
      newConnectionMap[neighborId]?.remove(nodeId);
    }

    return NodeIndex._(
      nodes: newNodeMap,
      connections: newConnectionMap,
      spatialGrid: newSpatialGrid,
      cellSize: _cellSize,
    );
  }

  /// Update a node's position
  NodeIndex updateNodePosition(String nodeId, Offset newPosition) {
    if (!_nodes.containsKey(nodeId)) return this;

    final newNodeMap = Map<String, FlowNode>.from(_nodes);
    final newSpatialGrid = _deepCopySpatialGrid();

    final oldNode = newNodeMap[nodeId]!;
    final updatedNode = oldNode.copyWith(position: newPosition);
    newNodeMap[nodeId] = updatedNode;

    final oldCellKey = _cellKey(oldNode.position, _cellSize);
    final newCellKey = _cellKey(newPosition, _cellSize);

    if (oldCellKey != newCellKey) {
      newSpatialGrid[oldCellKey]?.remove(nodeId);
      if (newSpatialGrid[oldCellKey]?.isEmpty ?? false) {
        newSpatialGrid.remove(oldCellKey);
      }
      newSpatialGrid.putIfAbsent(newCellKey, () => {}).add(nodeId);
    }

    return NodeIndex._(
      nodes: newNodeMap,
      connections: _connections,
      spatialGrid: newSpatialGrid,
      cellSize: _cellSize,
    );
  }

  // Helpers

  Set<CellKey> _getCellsInRect(Rect rect) {
    final cells = <CellKey>{};
    final minX = rect.left ~/ _cellSize;
    final maxX = rect.right ~/ _cellSize;
    final minY = rect.top ~/ _cellSize;
    final maxY = rect.bottom ~/ _cellSize;

    for (int x = minX; x <= maxX; x++) {
      for (int y = minY; y <= maxY; y++) {
        cells.add('$x:$y');
      }
    }

    return cells;
  }

  Map<String, Set<String>> _deepCopyConnections() {
    final copy = <String, Set<String>>{};
    for (final entry in _connections.entries) {
      copy[entry.key] = Set<String>.from(entry.value);
    }
    return copy;
  }

  Map<CellKey, Set<String>> _deepCopySpatialGrid() {
    final copy = <CellKey, Set<String>>{};
    for (final entry in _spatialGrid.entries) {
      copy[entry.key] = Set<String>.from(entry.value);
    }
    return copy;
  }

  static CellKey _cellKey(Offset pos, double cellSize) {
    final cx = (pos.dx / cellSize).floor();
    final cy = (pos.dy / cellSize).floor();
    return '$cx:$cy';
  }

  Map<String, dynamic> get stats {
    final totalNodes = _nodes.length;
    final totalConnections =
        _connections.values.fold(0, (sum, c) => sum + c.length) ~/ 2;
    final gridCells = _spatialGrid.length;
    final avgNodesPerCell = totalNodes > 0 ? totalNodes / gridCells : 0;

    return {
      'nodes': totalNodes,
      'connections': totalConnections,
      'grid_cells': gridCells,
      'avg_nodes_per_cell': avgNodesPerCell,
      'cell_size': _cellSize,
    };
  }
}

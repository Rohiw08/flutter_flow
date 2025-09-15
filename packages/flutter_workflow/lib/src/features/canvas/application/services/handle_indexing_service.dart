import 'dart:ui' show Offset;

import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';

class HandleService {
  static const double _gridSize = 200.0;
  final Map<String, Set<String>> _spatialHash = {};

  /// Full rebuild when needed
  void rebuildSpatialHash(List<FlowNode> nodes) {
    _spatialHash.clear();
    for (final node in nodes) {
      addNodeToSpatialHash(node);
    }
  }

  /// Incremental updates for efficiency
  void addNodeToSpatialHash(FlowNode node) {
    final nodePosition = node.position;
    for (final handle in node.handles.values) {
      final handlePosition = nodePosition + handle.position;
      final gridKey = _getGridKey(handlePosition);
      final handleId = '${node.id}/${handle.id}';
      _spatialHash.putIfAbsent(gridKey, () => <String>{}).add(handleId);
    }
  }

  void removeNodeFromSpatialHash(FlowNode node) {
    final nodePosition = node.position;
    for (final handle in node.handles.values) {
      final handlePosition = nodePosition + handle.position;
      final gridKey = _getGridKey(handlePosition);
      final handleId = '${node.id}/${handle.id}';
      _spatialHash[gridKey]?.remove(handleId);
      if (_spatialHash[gridKey]?.isEmpty ?? false) {
        _spatialHash.remove(gridKey);
      }
    }
  }

  void updateNodeInSpatialHash(FlowNode oldNode, FlowNode newNode) {
    removeNodeFromSpatialHash(oldNode);
    addNodeToSpatialHash(newNode);
  }

  Set<String> getHandlesNear(Offset position) {
    final gridX = (position.dx / _gridSize).floor();
    final gridY = (position.dy / _gridSize).floor();
    final nearbyHandles = <String>{};

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        final key = '${gridX + x},${gridY + y}';
        final handlesInCell = _spatialHash[key];
        if (handlesInCell != null) {
          nearbyHandles.addAll(handlesInCell);
        }
      }
    }

    return nearbyHandles;
  }

  String _getGridKey(Offset position) {
    final gridX = (position.dx / _gridSize).floor();
    final gridY = (position.dy / _gridSize).floor();
    return '$gridX,$gridY';
  }
}

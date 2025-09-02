import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';

/// Provider for the stateless HandleService.
final handleServiceProvider = Provider<HandleService>((ref) => HandleService());

/// A stateless service for handle-related calculations, like the spatial hash.
class HandleService {
  static const double _gridSize = 200.0;

  /// Rebuilds the spatial hash map based on the current nodes.
  /// This is a pure function that should be called whenever nodes are moved,
  /// added, or removed.
  Map<String, Set<String>> buildSpatialHash(List<FlowNode> nodes) {
    final grid = <String, Set<String>>{};
    for (final node in nodes) {
      // Assumes FlowNode now has a list of its handles.
      for (final handle in node.handles) {
        // Calculate the absolute position of the handle in the canvas
        final handlePosition = node.position + handle.position;
        final gridKey = _getGridKey(handlePosition);
        final handleId = '${node.id}/${handle.id}';

        grid.putIfAbsent(gridKey, () => {}).add(handleId);
      }
    }
    return grid;
  }

  /// Gets a list of handle keys near a given position using the spatial hash.
  /// This does not modify state.
  Iterable<String> getHandlesNear(
    Map<String, Set<String>> spatialHash,
    Offset position,
  ) {
    final gridX = (position.dx / _gridSize).floor();
    final gridY = (position.dy / _gridSize).floor();
    final nearbyHandles = <String>{};

    // Check the 9 cells around the cursor's position
    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        final key = '${gridX + x},${gridY + y}';
        if (spatialHash.containsKey(key)) {
          nearbyHandles.addAll(spatialHash[key]!);
        }
      }
    }
    return nearbyHandles;
  }

  /// Determines the grid key for a given position.
  String _getGridKey(Offset position) {
    final gridX = (position.dx / _gridSize).floor();
    final gridY = (position.dy / _gridSize).floor();
    return '$gridX,$gridY';
  }
}

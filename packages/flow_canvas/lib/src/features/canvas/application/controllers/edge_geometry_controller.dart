import 'dart:ui';

import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_geometry_service.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/shared/enums.dart';

class _EdgeUpdateInfo {
  final bool needsUpdate;
  final bool fullUpdate;
  final Set<String> specificNodes;
  final Set<String> specificEdges; // NEW: Track specific edges

  _EdgeUpdateInfo({
    required this.needsUpdate,
    this.fullUpdate = false,
    this.specificNodes = const {},
    this.specificEdges = const {},
  });
}

class EdgeGeometryController {
  final EdgeGeometryService _edgeGeometryService;
  FlowCanvasState? _previousState;

  // Cache node positions for fast comparison
  Map<String, Offset> _previousNodePositions = {};
  Map<String, Size> _previousNodeSizes = {};
  Set<String> _previousEdgeKeys = {};

  EdgeGeometryController({
    required FlowCanvasController controller,
    required EdgeGeometryService edgeGeometryService,
  }) : _edgeGeometryService = edgeGeometryService;

  void updateGeometryIfNeeded(FlowCanvasState newState) {
    final updateInfo = _shouldUpdateEdgeGeometry(newState);

    if (updateInfo.needsUpdate) {
      if (updateInfo.specificEdges.isNotEmpty) {
        // MOST efficient: update only specific edges that changed
        _edgeGeometryService.updateCache(newState, updateInfo.specificEdges);
      } else if (updateInfo.specificNodes.isNotEmpty) {
        // Efficient: update edges connected to changed nodes
        _edgeGeometryService.updateEdgesForNodes(
            newState, updateInfo.specificNodes);
      } else if (updateInfo.fullUpdate) {
        // Full update when necessary
        _edgeGeometryService.updateCache(newState, newState.edges.keys);
      }
    }

    // Update caches
    _previousState = newState;
    _updateCaches(newState);
  }

  _EdgeUpdateInfo _shouldUpdateEdgeGeometry(FlowCanvasState newState) {
    if (_previousState == null) {
      return _EdgeUpdateInfo(needsUpdate: true, fullUpdate: true);
    }

    final old = _previousState!;

    // Check for edge changes more efficiently
    final edgeChanges = _detectEdgeChanges(old.edges, newState.edges);
    if (edgeChanges.added.isNotEmpty || edgeChanges.removed.isNotEmpty) {
      // Only update the specific edges that were added
      if (edgeChanges.removed.isEmpty && edgeChanges.modified.isEmpty) {
        return _EdgeUpdateInfo(
          needsUpdate: true,
          fullUpdate: false,
          specificEdges: edgeChanges.added,
        );
      }
      return _EdgeUpdateInfo(needsUpdate: true, fullUpdate: true);
    }

    // Check for edge property modifications (source/target changes)
    if (edgeChanges.modified.isNotEmpty) {
      return _EdgeUpdateInfo(
        needsUpdate: true,
        fullUpdate: false,
        specificEdges: edgeChanges.modified,
      );
    }

    // During node drag, only update edges connected to moving nodes
    if (newState.dragMode == DragMode.node) {
      final movedNodes = _getMovedNodesOptimized(newState);
      if (movedNodes.isNotEmpty) {
        return _EdgeUpdateInfo(
          needsUpdate: true,
          fullUpdate: false,
          specificNodes: movedNodes,
        );
      }
    }

    // Check for node property changes using cached data
    final changedNodes = _getChangedNodesOptimized(newState);
    if (changedNodes.isNotEmpty) {
      return _EdgeUpdateInfo(
        needsUpdate: true,
        fullUpdate: false,
        specificNodes: changedNodes,
      );
    }

    return _EdgeUpdateInfo(needsUpdate: false);
  }

  Set<String> _getMovedNodesOptimized(FlowCanvasState current) {
    final movedNodes = <String>{};

    for (final nodeId in current.selectedNodes) {
      final cachedPos = _previousNodePositions[nodeId];
      final currentPos = current.nodes[nodeId]?.position;

      if (cachedPos != null && currentPos != null && cachedPos != currentPos) {
        movedNodes.add(nodeId);
      }
    }

    return movedNodes;
  }

  Set<String> _getChangedNodesOptimized(FlowCanvasState current) {
    final changedNodes = <String>{};

    // Only check nodes that exist in both states
    for (final nodeId in current.nodes.keys) {
      final cachedPos = _previousNodePositions[nodeId];
      final cachedSize = _previousNodeSizes[nodeId];
      final node = current.nodes[nodeId];

      if (node == null) continue;

      final posChanged = cachedPos != null && cachedPos != node.position;
      final sizeChanged = cachedSize != null && cachedSize != node.size;

      if (posChanged || sizeChanged) {
        changedNodes.add(nodeId);
      }
    }

    return changedNodes;
  }

  _EdgeChanges _detectEdgeChanges(
      Map<String, FlowEdge> oldEdges, Map<String, FlowEdge> newEdges) {
    final added = <String>{};
    final removed = <String>{};
    final modified = <String>{};

    for (final key in newEdges.keys) {
      if (!_previousEdgeKeys.contains(key)) {
        added.add(key);
      } else {
        final oldEdge = oldEdges[key];
        final newEdge = newEdges[key];

        if (oldEdge != newEdge) {
          modified.add(key);
        }
      }
    }

    for (final key in _previousEdgeKeys) {
      if (!newEdges.containsKey(key)) {
        removed.add(key);
      }
    }

    return _EdgeChanges(added: added, removed: removed, modified: modified);
  }

  void _updateCaches(FlowCanvasState state) {
    _previousNodePositions = {
      for (final entry in state.nodes.entries) entry.key: entry.value.position
    };
    _previousNodeSizes = {
      for (final entry in state.nodes.entries) entry.key: entry.value.size
    };
    _previousEdgeKeys = state.edges.keys.toSet();
  }
}

class _EdgeChanges {
  final Set<String> added;
  final Set<String> removed;
  final Set<String> modified;

  _EdgeChanges({
    required this.added,
    required this.removed,
    required this.modified,
  });
}

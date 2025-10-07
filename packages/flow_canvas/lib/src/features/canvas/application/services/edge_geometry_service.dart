import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/edge_path_creator.dart';
import 'package:flutter/widgets.dart';

/// A data class holding the pre-calculated geometry for an edge.
class EdgeGeom {
  final Path path;
  final Rect bounds;
  final List<Offset> samples;

  const EdgeGeom({
    required this.path,
    required this.bounds,
    required this.samples,
  });
}

/// Manages the calculation, caching, and hit-testing of edge geometry.
class EdgeGeometryService {
  final CanvasCoordinateConverter coordinateConverter;

  EdgeGeometryService(this.coordinateConverter);

  final Map<String, EdgeGeom> _edgeCache = {};
  final Map<String, int> _edgeVersion = {};

  /// Retrieves the cached geometry for a given edge ID.
  EdgeGeom? getGeom(String edgeId) => _edgeCache[edgeId];

  /// Returns a map of all precomputed paths for the painter.
  Map<String, Path> getPrecomputedPaths() {
    return _edgeCache.map((key, value) => MapEntry(key, value.path));
  }

  /// Updates the cache for all visible edges, removing any that no longer exist.
  void updateCache(FlowCanvasState state, Iterable<String> visibleEdgeIds) {
    final currentEdgeIds = Set<String>.from(visibleEdgeIds);
    _edgeCache.removeWhere((id, _) => !currentEdgeIds.contains(id));
    _edgeVersion.removeWhere((id, _) => !currentEdgeIds.contains(id));

    for (final id in currentEdgeIds) {
      _ensureEdgeGeom(state, id);
    }
  }

  /// Updates only edges connected to specific nodes (OPTIMIZED).
  /// This is much faster when only a few nodes have moved.
  void updateEdgesForNodes(FlowCanvasState state, Set<String> nodeIds) {
    if (nodeIds.isEmpty) return;

    final edgesToUpdate = <String>{};

    // Collect all edges connected to the changed nodes
    for (final nodeId in nodeIds) {
      edgesToUpdate.addAll(state.edgeIndex.getEdgesForNode(nodeId));
    }
    // Only update those specific edges
    for (final edgeId in edgesToUpdate) {
      _ensureEdgeGeom(state, edgeId);
    }
  }

  /// Updates a single edge (useful when adding/modifying one edge).
  void updateEdge(FlowCanvasState state, String edgeId) {
    _edgeVersion.remove(edgeId); // Force recalculation
    _ensureEdgeGeom(state, edgeId);
  }

  /// Removes edges from the cache (useful when edges are deleted).
  void removeEdges(Set<String> edgeIds) {
    for (final edgeId in edgeIds) {
      _edgeCache.remove(edgeId);
      _edgeVersion.remove(edgeId);
    }
  }

  /// Clears the entire cache.
  void clearCache() {
    _edgeCache.clear();
    _edgeVersion.clear();
  }

  void _ensureEdgeGeom(FlowCanvasState state, String edgeId) {
    final edge = state.edges[edgeId];
    if (edge == null) return;

    final sourceNode = state.nodes[edge.sourceNodeId];
    final targetNode = state.nodes[edge.targetNodeId];
    if (sourceNode == null || targetNode == null) return;

    // Version check based on node positions - prevents unnecessary recalculation
    final version = Object.hash(
      sourceNode.position,
      targetNode.position,
      edge.sourceHandleId,
      edge.targetHandleId,
      edge.pathType,
    );

    final oldVersion = _edgeVersion[edgeId];
    if (oldVersion == version) return;

    final sourceHandle = edge.sourceHandleId != null
        ? sourceNode.handles[edge.sourceHandleId!]
        : null;
    final targetHandle = edge.targetHandleId != null
        ? targetNode.handles[edge.targetHandleId!]
        : null;
    if (sourceHandle == null || targetHandle == null) return;

    final sourceHandlePosition = coordinateConverter
        .toRenderPosition(sourceNode.center + sourceHandle.center);
    final targetHandlePosition = coordinateConverter
        .toRenderPosition(targetNode.center + targetHandle.center);

    final path = EdgePathCreator.createPath(
      edge.pathType,
      sourceHandlePosition,
      targetHandlePosition,
    );
    final bounds = path.getBounds().inflate(8);

    final samples = <Offset>[];
    final metrics = path.computeMetrics();
    for (final m in metrics) {
      const step = 12.0;
      for (double d = 0; d <= m.length; d += step) {
        final pos = m.getTangentForOffset(d)?.position;
        if (pos != null) samples.add(pos);
      }
    }

    _edgeCache[edgeId] = EdgeGeom(path: path, bounds: bounds, samples: samples);
    _edgeVersion[edgeId] = version;
  }

  String? hitTestEdgeAt(Offset localPos, FlowCanvasState state, double zoom) {
    const double baseTolerance = 8.0;

    for (final edgeId in _edgeCache.keys.toList().reversed) {
      final geom = _edgeCache[edgeId];
      if (geom == null) continue;

      final tolerance =
          ((state.edges[edgeId]?.interactionWidth ?? 10.0) / (2.0 * zoom))
              .clamp(baseTolerance, 64.0);

      if (_isPointNearSamples(geom.samples, localPos, tolerance)) {
        return edgeId;
      }
    }
    return null;
  }

  bool _isPointNearSamples(List<Offset> samples, Offset p, double tolerance) {
    final tolSq = tolerance * tolerance;
    for (final s in samples) {
      if ((s - p).distanceSquared <= tolSq) {
        return true;
      }
    }
    return false;
  }
}

import 'dart:math';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/edge_state.dart';

/// A painter for drawing persistent edges (connections between nodes) on the canvas.
///
/// This painter renders all edges using pre-computed paths for performance.
/// It applies theming based on edge states (selected, hovered) and supports
/// custom markers (arrows, circles) at edge start and end points.
///
/// {@template edge_painter_performance}
/// ## Performance Optimizations
///
/// - Reuses [Paint] objects to avoid allocation overhead
/// - Uses pre-computed paths from geometry service
/// - Only repaints when edges, nodes, or theme actually change
/// {@endtemplate}
///
/// {@template edge_painter_theming}
/// ## Theming Priority
///
/// Edge styling is resolved in this priority order:
/// 1. Individual [FlowEdge.style] (per-edge override)
/// 2. [FlowCanvasTheme.edge] (theme-level default)
/// 3. [FlowEdgeStyle.light] (fallback if theme has no edge style)
/// {@endtemplate}
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   painter: EdgePainter(
///     nodes: nodeMap,
///     edges: edgeMap,
///     theme: theme.resolve(), // Ensure complete theme
///     canvasHeight: size.height,
///     canvasWidth: size.width,
///     precomputedPaths: pathCache,
///     edgeStates: stateManager.edgeStates,
///   ),
/// )
/// ```
///
/// See also:
///
///  * [FlowEdge], the edge model being rendered
///  * [FlowEdgeStyle], for edge theming options
///  * [FlowEdgeMarkerStyle], for marker customization
class EdgePainter extends CustomPainter with DiagnosticableTreeMixin {
  /// All nodes in the canvas, indexed by their IDs.
  ///
  /// Required for edge path computation and validation.
  final Map<String, FlowNode> nodes;

  /// All edges to be drawn, indexed by their IDs.
  ///
  /// Each edge contains its source/target node IDs and optional styling.
  final Map<String, FlowEdge> edges;

  /// Runtime state for each edge (selected, hovered, etc.).
  ///
  /// Used to determine which visual style to apply. Defaults to empty
  /// map if not provided, meaning all edges use normal state styling.
  final Map<String, EdgeRuntimeState> edgeStates;

  /// The theme containing all styling information.
  ///
  /// If [FlowCanvasTheme.edge] is null, falls back to [FlowEdgeStyle.light].
  /// Consider using [FlowCanvasTheme.resolve] to ensure all components exist.
  final FlowCanvasTheme theme;

  /// The height of the canvas in logical pixels.
  final double canvasHeight;

  /// The width of the canvas in logical pixels.
  final double canvasWidth;

  /// Pre-computed paths for each edge, indexed by edge ID.
  ///
  /// These paths should be computed by a geometry service for performance.
  /// Edges without a path in this map will be skipped during rendering.
  final Map<String, Path> precomputedPaths;

  // Reusable paint objects to avoid allocation overhead during paint calls
  final Paint _edgePaint;
  final Paint _markerPaint;

  /// Creates an edge painter.
  ///
  /// The [nodes], [edges], [theme], [canvasHeight], [canvasWidth], and
  /// [precomputedPaths] parameters must not be null.
  ///
  /// [edgeStates] is optional and defaults to an empty map, meaning all
  /// edges will use their normal (non-selected, non-hovered) styling.
  EdgePainter({
    required this.nodes,
    required this.edges,
    required this.theme,
    required this.canvasHeight,
    required this.canvasWidth,
    required this.precomputedPaths,
    this.edgeStates = const {},
  })  : _edgePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _markerPaint = Paint()..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    // Guard: No edges to draw
    if (edges.isEmpty) return;

    _drawEdges(canvas);
  }

  /// Draws all edges on the canvas.
  ///
  /// For each edge:
  /// 1. Retrieves pre-computed path
  /// 2. Resolves styling based on edge state
  /// 3. Draws the edge line
  /// 4. Draws start/end markers if defined
  void _drawEdges(Canvas canvas) {
    // Resolve the default edge style once to avoid repeated null checks
    // Priority: theme.edge > FlowEdgeStyle.light()
    final defaultEdgeStyle = theme.edge ?? FlowEdgeStyle.light();

    for (final entry in edges.entries) {
      final edgeId = entry.key;
      final edge = entry.value;

      // Skip edges without pre-computed paths
      final path = precomputedPaths[edgeId];
      if (path == null) {
        assert(
          false,
          'Edge $edgeId has no pre-computed path. '
          'Ensure geometry service computed paths before painting.',
        );
        continue;
      }

      // Resolve edge state
      final state = edgeStates[edgeId];
      final states = _resolveEdgeStates(state);

      // Resolve styling with proper priority:
      // edge.style > theme.edge > FlowEdgeStyle.light()
      final edgeStyle = edge.style ?? defaultEdgeStyle;
      final strokeStyle = edgeStyle.resolveDecoration(states);

      // Draw the edge line
      _drawEdgeLine(canvas, path, strokeStyle);

      // Draw markers
      _drawEdgeMarkers(
        canvas,
        path,
        edge,
        edgeStyle,
        strokeStyle,
        states,
      );
    }
  }

  /// Resolves the set of states for an edge.
  ///
  /// Converts [EdgeRuntimeState] to a [Set<FlowEdgeState>] for theming.
  Set<FlowEdgeState> _resolveEdgeStates(EdgeRuntimeState? state) {
    final states = <FlowEdgeState>{};
    if (state?.selected ?? false) states.add(FlowEdgeState.selected);
    if (state?.hovered ?? false) states.add(FlowEdgeState.hovered);
    // Always include normal state as base
    if (states.isEmpty) states.add(FlowEdgeState.normal);
    return states;
  }

  /// Draws the main edge line using the resolved stroke style.
  void _drawEdgeLine(
    Canvas canvas,
    Path path,
    FlowEdgeStrokeStyle strokeStyle,
  ) {
    _edgePaint
      ..color = strokeStyle.color
      ..strokeWidth = strokeStyle.strokeWidth
      ..strokeCap = strokeStyle.strokeCap
      ..strokeJoin = strokeStyle.strokeJoin;

    canvas.drawPath(path, _edgePaint);
  }

  /// Draws start and end markers for an edge, if defined.
  void _drawEdgeMarkers(
    Canvas canvas,
    Path path,
    FlowEdge edge,
    FlowEdgeStyle edgeStyle,
    FlowEdgeStrokeStyle strokeStyle,
    Set<FlowEdgeState> states,
  ) {
    // Draw start marker (at source node)
    final startMarkerStyle =
        edge.startMarkerStyle ?? edgeStyle.startMarkerStyle;
    if (startMarkerStyle != null) {
      _drawMarker(
        canvas,
        path,
        strokeStyle,
        startMarkerStyle,
        states,
        atStart: true,
      );
    }

    // Draw end marker (at target node, typically an arrow)
    final endMarkerStyle = edge.endMarkerStyle ?? edgeStyle.endMarkerStyle;
    if (endMarkerStyle != null) {
      _drawMarker(
        canvas,
        path,
        strokeStyle,
        endMarkerStyle,
        states,
        atStart: false,
      );
    }
  }

  /// Draws a single marker (arrow, circle, etc.) at the start or end of a path.
  ///
  /// The marker's appearance is determined by:
  /// - [markerStyle.type]: The marker shape (arrow, circle, none)
  /// - [markerStyle.builder]: Custom drawing function (overrides type)
  /// - [states]: Current edge state for theming
  void _drawMarker(
    Canvas canvas,
    Path path,
    FlowEdgeStrokeStyle strokeStyle,
    FlowEdgeMarkerStyle markerStyle,
    Set<FlowEdgeState> states, {
    required bool atStart,
  }) {
    // Get path metrics for tangent calculation
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    // Get the tangent at the appropriate end of the path
    final metric = atStart ? metrics.first : metrics.last;
    final tangent = atStart
        ? metric.getTangentForOffset(0)
        : metric.getTangentForOffset(metric.length);

    if (tangent == null) {
      assert(
        false,
        'Failed to compute tangent for marker at ${atStart ? "start" : "end"} of path',
      );
      return;
    }

    // Resolve marker style based on edge state
    final resolvedMarkerStyle = markerStyle.resolve(states);

    // Configure base marker paint
    _markerPaint
      ..color = resolvedMarkerStyle.color
      ..strokeWidth = resolvedMarkerStyle.strokeWidth
      ..style = PaintingStyle.stroke;

    final size = resolvedMarkerStyle.size.width;

    // Handle custom builder (highest priority)
    if (markerStyle.builder != null) {
      _markerPaint.style = PaintingStyle.fill;
      markerStyle.builder!(canvas, tangent, resolvedMarkerStyle);
      return;
    }

    // Calculate marker rotation angle
    // For start markers, add 180° to point towards source
    final angle =
        atStart ? tangent.vector.direction + pi : tangent.vector.direction;

    // Draw built-in marker types
    _drawBuiltInMarker(
      canvas,
      markerStyle.markerType,
      tangent.position,
      angle,
      size,
    );
  }

  /// Draws a built-in marker type at the specified position and angle.
  void _drawBuiltInMarker(
    Canvas canvas,
    EdgeMarkerType type,
    Offset position,
    double angle,
    double size,
  ) {
    switch (type) {
      case EdgeMarkerType.arrow:
        _drawArrow(canvas, position, angle, size, _markerPaint);
        break;

      case EdgeMarkerType.arrowClosed:
        _markerPaint.style = PaintingStyle.fill;
        _drawArrow(canvas, position, angle, size, _markerPaint, closed: true);
        break;

      case EdgeMarkerType.circle:
        _markerPaint.style = PaintingStyle.fill;
        canvas.drawCircle(position, size / 2, _markerPaint);
        break;

      case EdgeMarkerType.none:
        // No-op: explicitly handled for clarity
        break;
    }
  }

  /// Draws an arrow marker.
  ///
  /// Creates a V-shaped arrow pointing in the direction of [angle].
  /// If [closed] is true, draws a filled triangular arrow instead.
  void _drawArrow(
    Canvas canvas,
    Offset position,
    double angle,
    double size,
    Paint paint, {
    bool closed = false,
  }) {
    // Arrow has 30° angle between sides (pi/6 radians)
    const angleOffset = pi / 6;
    final leftAngle = angle - angleOffset;
    final rightAngle = angle + angleOffset;

    // Calculate arrow endpoints
    final leftPoint = Offset(
      position.dx - size * cos(leftAngle),
      position.dy - size * sin(leftAngle),
    );
    final rightPoint = Offset(
      position.dx - size * cos(rightAngle),
      position.dy - size * sin(rightAngle),
    );

    // Draw arrow path
    final arrowPath = Path();
    if (closed) {
      // Filled triangle
      arrowPath
        ..moveTo(position.dx, position.dy)
        ..lineTo(leftPoint.dx, leftPoint.dy)
        ..lineTo(rightPoint.dx, rightPoint.dy)
        ..close();
    } else {
      // Open V-shape
      arrowPath
        ..moveTo(leftPoint.dx, leftPoint.dy)
        ..lineTo(position.dx, position.dy)
        ..lineTo(rightPoint.dx, rightPoint.dy);
    }

    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant EdgePainter oldDelegate) {
    // Repaint if any input data or theme has changed
    return oldDelegate.nodes != nodes ||
        oldDelegate.edges != edges ||
        oldDelegate.edgeStates != edgeStates ||
        oldDelegate.theme != theme ||
        oldDelegate.precomputedPaths != precomputedPaths ||
        oldDelegate.canvasHeight != canvasHeight ||
        oldDelegate.canvasWidth != canvasWidth;
  }

  @override
  bool shouldRebuildSemantics(covariant EdgePainter oldDelegate) {
    // Edges don't provide semantic information, so no rebuild needed
    return false;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('nodes', nodes.length));
    properties.add(IntProperty('edges', edges.length));
    properties.add(IntProperty('edgeStates', edgeStates.length));
    properties.add(IntProperty('precomputedPaths', precomputedPaths.length));
    properties.add(DiagnosticsProperty<FlowCanvasTheme>('theme', theme));
    properties.add(DoubleProperty('canvasHeight', canvasHeight));
    properties.add(DoubleProperty('canvasWidth', canvasWidth));

    // Debug info: which edges are selected/hovered
    final selectedEdges = edgeStates.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();
    final hoveredEdges = edgeStates.entries
        .where((e) => e.value.hovered)
        .map((e) => e.key)
        .toList();

    if (selectedEdges.isNotEmpty) {
      properties.add(IterableProperty<String>(
        'selectedEdges',
        selectedEdges,
        ifEmpty: 'none',
      ));
    }
    if (hoveredEdges.isNotEmpty) {
      properties.add(IterableProperty<String>(
        'hoveredEdges',
        hoveredEdges,
        ifEmpty: 'none',
      ));
    }
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EdgePainter(edges: ${edges.length}, nodes: ${nodes.length}, '
        'selected: ${edgeStates.values.where((s) => s.selected).length})';
  }
}

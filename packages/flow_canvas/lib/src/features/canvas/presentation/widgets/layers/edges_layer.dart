import 'package:equatable/equatable.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_provider.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/providers.dart';
import '../../../application/callbacks/edge_callbacks.dart';
import '../../../application/callbacks/pane_callbacks.dart';
import '../../../domain/flow_canvas_state.dart';
import '../../../domain/models/connection.dart';
import '../../../domain/models/edge.dart';
import '../../../domain/models/node.dart';
import '../../painters/flow_painter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/edge_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/edge_path_creator.dart';
import 'package:flow_canvas/src/features/canvas/application/events/edge_change_event.dart';

class FlowEdgeLayer extends ConsumerStatefulWidget {
  final EdgeCallbacks edgeCallbacks;
  final PaneCallbacks paneCallbacks;
  const FlowEdgeLayer({
    super.key,
    required this.edgeCallbacks,
    required this.paneCallbacks,
  });

  @override
  ConsumerState<FlowEdgeLayer> createState() => _FlowEdgeLayerState();
}

class _EdgeGeom {
  final Path path;
  final Rect bounds;
  final List<Offset> samples;
  const _EdgeGeom(
      {required this.path, required this.bounds, required this.samples});
}

class _FlowEdgeLayerState extends ConsumerState<FlowEdgeLayer> {
  String? _hoveredEdgeId;
  String? _lastDownEdgeId;

  // Geometry cache
  final Map<String, _EdgeGeom> _edgeCache = {};

  // Throttle
  int _lastMoveMs = 0;
  static const int _moveThrottleMs = 8; // ~120 Hz

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(internalControllerProvider.notifier);
    final theme = FlowCanvasThemeProvider.of(context);

    // Get full state for spatial indexing
    final fullState = ref.watch(internalControllerProvider);

    // This widget only rebuilds when painter-specific data changes.
    final paintState = ref.watch(internalControllerProvider.select(
      (s) => PainterState.fromState(s),
    ));

    final options = ref.read(flowOptionsProvider);

    // Respect hidden edges option globally by filtering before painting
    final visibleEntries = paintState.edges.entries.where(
      (e) => !(e.value.isHidden(context)),
    );

    // Elevate selected edges if option is enabled by painting them last
    final elevate = EdgeOptions.resolve(context).elevateEdgesOnSelect;
    final selected = ref.read(internalControllerProvider).selectedEdges;

    final orderedEdges = <MapEntry<String, FlowEdge>>[];
    if (elevate) {
      orderedEdges
          .addAll(visibleEntries.where((e) => !selected.contains(e.key)));
      orderedEdges
          .addAll(visibleEntries.where((e) => selected.contains(e.key)));
    } else {
      orderedEdges.addAll(visibleEntries);
    }

    // Defer viewport sizing and hit-index updates to LayoutBuilder to avoid
    // accessing context.size during build (which throws in tests / first build).
    return LayoutBuilder(builder: (context, constraints) {
      // Rebuild cache when needed
      double handleSize = theme.handle.size!;
      Offset edgePointOffset = Offset(handleSize, handleSize);
      _refreshCacheForChangedEdges(
          fullState, orderedEdges.map((e) => e.key), edgePointOffset);

      final edgesForPainter = <String, FlowEdge>{};
      final precomputed = <String, Path>{};

      // No culling - render all edges
      for (final entry in orderedEdges) {
        final id = entry.key;
        final edge = entry.value;
        final geom = _edgeCache[id];
        if (geom == null) continue; // not ready yet

        edgesForPainter[id] = edge;
        precomputed[id] = geom.path;
      }

      final painter = FlowPainter(
        nodes: paintState.nodes,
        edges: edgesForPainter,
        connection: paintState.connection,
        selectionRect: paintState.selectionRect,
        style: theme,
        zoom: paintState.zoom,
        canvasHeight: options.canvasHeight,
        canvasWidth: options.canvasWidth,
        nodeStates: fullState.nodeStates,
        edgeStates: fullState.edgeStates,
        connectionState: fullState.connectionState,
        precomputedPaths: precomputed,
      );

      return Listener(
        onPointerHover: (event) {
          final now = DateTime.now().millisecondsSinceEpoch;
          if (now - _lastMoveMs < _moveThrottleMs) return;
          _lastMoveMs = now;

          final box = context.findRenderObject() as RenderBox?;
          if (box == null) return;
          final local = box.globalToLocal(event.position);
          final hit =
              _hitTestEdgeAt(local, fullState, precomputed, paintState.zoom);
          if (hit != _hoveredEdgeId) {
            if (_hoveredEdgeId != null) {
              final exitEvent = PointerExitEvent(position: event.position);
              widget.edgeCallbacks.onMouseLeave(_hoveredEdgeId!, exitEvent);
              controller.edgeStreams.emitEvent(EdgeChangeEvent(
                  edgeId: _hoveredEdgeId!,
                  type: EdgeEventType.mouseLeave,
                  data: exitEvent));
            }
            if (hit != null) {
              final enterEvent = PointerEnterEvent(position: event.position);
              widget.edgeCallbacks.onMouseEnter(hit, enterEvent);
              controller.edgeStreams.emitEvent(EdgeChangeEvent(
                  edgeId: hit,
                  type: EdgeEventType.mouseEnter,
                  data: enterEvent));
            }
            _hoveredEdgeId = hit;
          }
          if (hit != null) {
            widget.edgeCallbacks.onMouseMove(hit, event);
            controller.edgeStreams.emitEvent(EdgeChangeEvent(
                edgeId: hit, type: EdgeEventType.mouseMove, data: event));
          }
        },
        child: GestureDetector(
          onTapDown: (details) {
            final box = context.findRenderObject() as RenderBox?;
            if (box == null) return;
            final local = box.globalToLocal(details.globalPosition);
            final hit =
                _hitTestEdgeAt(local, fullState, precomputed, paintState.zoom);
            if (hit != null) {
              // Selection
              if (paintState.edges[hit]?.isSelectable(context) ?? true) {
                ref
                    .read(internalControllerProvider.notifier)
                    .selectEdge(hit, addToSelection: false);
              }
              widget.edgeCallbacks.onClick(hit, details);
              controller.edgeStreams.emitEvent(EdgeChangeEvent(
                  edgeId: hit, type: EdgeEventType.click, data: details));
              _lastDownEdgeId = hit;
            } else {
              controller.deselectAll();
              widget.paneCallbacks.onTap(details);
            }
          },
          onDoubleTap: () {
            if (_lastDownEdgeId != null) {
              widget.edgeCallbacks.onDoubleClick(_lastDownEdgeId!);
              controller.edgeStreams.emitEvent(EdgeChangeEvent(
                  edgeId: _lastDownEdgeId!, type: EdgeEventType.doubleClick));
            }
          },
          onLongPressStart: (details) {
            final box = context.findRenderObject() as RenderBox?;
            if (box == null) return;
            final local = box.globalToLocal(details.globalPosition);
            final hit =
                _hitTestEdgeAt(local, fullState, precomputed, paintState.zoom);
            if (hit != null) {
              widget.edgeCallbacks.onContextMenu(hit, details);
              controller.edgeStreams.emitEvent(EdgeChangeEvent(
                  edgeId: hit, type: EdgeEventType.contextMenu, data: details));
            }
          },
          child: CustomPaint(
            painter: painter,
            size: Size.infinite,
          ),
        ),
      );
    });
  }

  void _refreshCacheForChangedEdges(
      FlowCanvasState state, Iterable<String> edgeIds, Offset handleOffset) {
    for (final id in edgeIds) {
      _ensureEdgeGeom(state, id, handleOffset);
    }
  }

  void _ensureEdgeGeom(FlowCanvasState state, String edgeId, Offset offset) {
    final edge = state.edges[edgeId];
    if (edge == null) return;
    final sourceNode = state.nodes[edge.sourceNodeId];
    final targetNode = state.nodes[edge.targetNodeId];
    if (sourceNode == null || targetNode == null) return;
    final sourceHandle = edge.sourceHandleId != null
        ? sourceNode.handles[edge.sourceHandleId!]
        : null;
    final targetHandle = edge.targetHandleId != null
        ? targetNode.handles[edge.targetHandleId!]
        : null;
    if (sourceHandle == null || targetHandle == null) return;

    final options = ref.read(flowOptionsProvider);
    final coordinateConverter = CanvasCoordinateConverter(
      canvasWidth: options.canvasWidth,
      canvasHeight: options.canvasHeight,
    );
    // Convert node positions from Cartesian to render coordinates
    final sourceHandlePosition = coordinateConverter
        .toRenderPosition(sourceNode.center + sourceHandle.center);
    final targetHandlePosition = coordinateConverter
        .toRenderPosition(targetNode.center + targetHandle.center);

    // Create path using render coordinates (same coordinate system as positioned nodes)
    final path = EdgePathCreator.createPath(
        edge.pathType, sourceHandlePosition, targetHandlePosition);
    final bounds = path.getBounds().inflate(8);

    // Sample polyline for fast distance checks
    final samples = <Offset>[];
    final metrics = path.computeMetrics();
    for (final m in metrics) {
      const step = 12.0; // adaptive later if needed
      for (double d = 0; d <= m.length; d += step) {
        final pos = m.getTangentForOffset(d)?.position;
        if (pos != null) samples.add(pos);
      }
    }

    _edgeCache[edgeId] =
        _EdgeGeom(path: path, bounds: bounds, samples: samples);
  }

  String? _hitTestEdgeAt(
    Offset localPos,
    FlowCanvasState state,
    Map<String, Path> precomputed,
    double zoom,
  ) {
    const double baseTolerance = 8.0;

    // Narrow phase: distance to sampled polyline
    for (final edgeId in precomputed.keys) {
      final geom = _edgeCache[edgeId];
      if (geom == null) continue;
      final tolerance =
          ((state.edges[edgeId]?.interactionWidth ?? 10.0) / (2.0 * zoom))
              .clamp(baseTolerance, 64.0)
              .toDouble();

      if (_isPointNearSamples(geom.samples, localPos, tolerance)) {
        return edgeId;
      }
    }
    return null;
  }

  bool _isPointNearSamples(List<Offset> samples, Offset p, double tolerance) {
    final tol2 = tolerance * tolerance;
    for (final s in samples) {
      final dx = s.dx - p.dx;
      final dy = s.dy - p.dy;
      if (dx * dx + dy * dy <= tol2) return true;
    }
    return false;
  }
}

class PainterState extends Equatable {
  final Map<String, FlowNode> nodes;
  final Map<String, FlowEdge> edges;
  final FlowConnection? connection;
  final Rect? selectionRect;
  final double zoom;

  const PainterState({
    required this.nodes,
    required this.edges,
    this.connection,
    this.selectionRect,
    required this.zoom,
  });

  factory PainterState.fromState(FlowCanvasState s) {
    return PainterState(
      nodes: s.nodes,
      edges: s.edges,
      connection: s.connection,
      selectionRect: s.selectionRect,
      zoom: s.viewport.zoom,
    );
  }

  @override
  List<Object?> get props => [nodes, edges, connection, selectionRect, zoom];
}

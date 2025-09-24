import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/flutter_workflow.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/edge_callbacks.dart';
import '../../../application/callbacks/pane_callbacks.dart';
import '../../../domain/flow_canvas_state.dart';
import '../../../domain/models/connection.dart';
import '../../painters/flow_painter.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/edge_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/utility/edge_path_creator.dart';
import 'package:flutter_workflow/src/features/canvas/application/events/edge_change_event.dart';

class FlowEdgeLayer extends ConsumerStatefulWidget {
  final EdgeRegistry edgeRegistry;
  final EdgeCallbacks edgeCallbacks;
  final PaneCallbacks paneCallbacks;
  const FlowEdgeLayer({
    super.key,
    required this.edgeCallbacks,
    required this.paneCallbacks,
    required this.edgeRegistry,
  });

  @override
  ConsumerState<FlowEdgeLayer> createState() => _FlowEdgeLayerState();
}

class _FlowEdgeLayerState extends ConsumerState<FlowEdgeLayer> {
  String? _hoveredEdgeId;
  String? _lastDownEdgeId;

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

    final edgesForPainter = Map<String, FlowEdge>.fromEntries(orderedEdges);

    final painter = FlowPainter(
      nodes: paintState.nodes,
      edges: edgesForPainter,
      connection: paintState.connection,
      selectionRect: paintState.selectionRect,
      style: theme,
      zoom: paintState.zoom,
    );

    return Listener(
      onPointerHover: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final local = box.globalToLocal(event.position);
        final hit = _hitTestEdgeAt(local, fullState, edgesForPainter);
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
                edgeId: hit, type: EdgeEventType.mouseEnter, data: enterEvent));
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
          final hit = _hitTestEdgeAt(local, fullState, edgesForPainter);
          if (hit != null) {
            // Selection
            if (paintState.edges[hit]?.isSelectable(context) ?? true) {
              controller.selectEdge(hit, addToSelection: false);
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
          final hit = _hitTestEdgeAt(local, fullState, edgesForPainter);
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
  }

  String? _hitTestEdgeAt(
    Offset localPos,
    FlowCanvasState state,
    Map<String, FlowEdge> edges,
  ) {
    const double tolerance = 8.0;
    const double searchRadius = 50.0;

    // Use spatial indexing to pre-filter nodes near the click position
    final searchRect = Rect.fromCircle(center: localPos, radius: searchRadius);
    final nearbyNodes = state.nodeIndex.queryNodesInRect(searchRect);

    // Get all edges connected to nearby nodes
    final candidateEdgeIds = <String>{};
    for (final node in nearbyNodes) {
      candidateEdgeIds.addAll(state.edgeIndex.getEdgesForNode(node.id));
    }

    // Only test edges that are both visible and connected to nearby nodes
    for (final edgeId in candidateEdgeIds) {
      if (!edges.containsKey(edgeId)) continue;

      final edge = edges[edgeId]!;
      final sourceNode = state.nodes[edge.sourceNodeId];
      final targetNode = state.nodes[edge.targetNodeId];
      if (sourceNode == null || targetNode == null) continue;

      final sourceHandle = edge.sourceHandleId != null
          ? sourceNode.handles[edge.sourceHandleId!]
          : null;
      final targetHandle = edge.targetHandleId != null
          ? targetNode.handles[edge.targetHandleId!]
          : null;
      if (sourceHandle == null || targetHandle == null) continue;

      final start = sourceNode.position + sourceHandle.position;
      final end = targetNode.position + targetHandle.position;
      final path = EdgePathCreator.createPath(edge.pathType, start, end);

      if (_isPointNearPath(path, localPos, tolerance)) {
        return edgeId;
      }
    }
    return null;
  }

  bool _isPointNearPath(Path path, Offset p, double tolerance) {
    final metrics = path.computeMetrics();
    for (final m in metrics) {
      for (double d = 0; d < m.length; d += 8) {
        final pos = m.getTangentForOffset(d)?.position;
        if (pos == null) continue;
        if ((pos - p).distance <= tolerance) return true;
      }
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

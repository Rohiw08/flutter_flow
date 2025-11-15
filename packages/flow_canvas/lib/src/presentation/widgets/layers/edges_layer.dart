import 'package:equatable/equatable.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/connection.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/connection_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/edge_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/edge_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/painters/connection_painter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/painters/edge_painter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_provider.dart';
import 'package:flow_canvas/src/features/canvas/presentation/widgets/flow_edge_label.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A lean state class derived from FlowCanvasState, used to trigger repaints
/// of the painters efficiently.
class PainterState extends Equatable {
  final Map<String, FlowNode> nodes;
  final Map<String, FlowEdge> edges;
  final Set<String> selectedEdges;
  final Map<String, EdgeRuntimeState> edgeStates;
  final FlowConnection? connection;
  final FlowConnectionRuntimeState? connectionState;
  final Rect? selectionRect;
  final double zoom;

  // Hashes to detect changes
  final int _nodePositionsHash;
  final int _edgesHash;

  const PainterState({
    required this.nodes,
    required this.edges,
    required this.selectedEdges,
    required this.edgeStates,
    this.connection,
    this.connectionState,
    this.selectionRect,
    required this.zoom,
    required int nodePositionsHash,
    required int edgesHash,
  })  : _nodePositionsHash = nodePositionsHash,
        _edgesHash = edgesHash;

  factory PainterState.fromState(FlowCanvasState s) {
    final positionsHash = Object.hashAll(
      s.nodes.values.map((node) => node.position),
    );
    final edgesHash = Object.hashAll(s.edges.keys);

    return PainterState(
      nodes: s.nodes,
      edges: s.edges,
      selectedEdges: s.selectedEdges,
      edgeStates: s.edgeStates,
      connection: s.activeConnection,
      connectionState: s.connectionState,
      selectionRect: s.selectionRect,
      zoom: s.viewport.zoom,
      nodePositionsHash: positionsHash,
      edgesHash: edgesHash,
    );
  }

  @override
  List<Object?> get props => [
        _edgesHash,
        selectedEdges,
        edgeStates,
        connection,
        connectionState,
        selectionRect,
        zoom,
        _nodePositionsHash,
      ];
}

/// Widget layer responsible for rendering edges and their labels.
///
/// This uses a hybrid approach:
/// - Edge paths, strokes, and markers are drawn via CustomPaint (efficient)
/// - Edge labels are rendered as actual Widgets (required for Widget support)
class FlowEdgeLayer extends ConsumerWidget {
  const FlowEdgeLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(internalControllerProvider.notifier);
    final options = ref.read(flowOptionsProvider);
    final theme = FlowCanvasThemeProvider.of(context);

    // This widget only rebuilds when data relevant to the painter changes.
    final paintState = ref.watch(internalControllerProvider.select(
      (s) => PainterState.fromState(s),
    ));

    final precomputedPaths =
        controller.edgeGeometryService.getPrecomputedPaths();

    // Correctly filters for visible edges
    final visibleEntries = paintState.edges.entries.where(
      (e) => !e.value.isHidden(context), // Use the resolved value and negate it
    );

    // Determine edge ordering based on selection elevation
    final elevate = EdgeOptions.resolve(context).elevateEdgeOnSelect;
    final selected = paintState.selectedEdges;

    final orderedEdges = <MapEntry<String, FlowEdge>>[];
    if (elevate) {
      // Non-selected edges first, then selected edges on top
      orderedEdges
          .addAll(visibleEntries.where((e) => !selected.contains(e.key)));
      orderedEdges
          .addAll(visibleEntries.where((e) => selected.contains(e.key)));
    } else {
      // Use natural order (by zIndex if you implement sorting)
      orderedEdges.addAll(visibleEntries);
    }

    return Listener(
      onPointerHover: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final local = box.globalToLocal(event.position);
        controller.edges.onEdgePointerHover(event, local);
      },
      child: GestureDetector(
        onTapDown: (details) {
          final box = context.findRenderObject() as RenderBox?;
          if (box == null) return;
          final local = box.globalToLocal(details.globalPosition);
          controller.edges.onEdgeTapDown(details, local);
        },
        onDoubleTap: () {
          controller.edges.onEdgeDoubleTap();
        },
        onLongPressStart: (details) {
          final box = context.findRenderObject() as RenderBox?;
          if (box == null) return;
          final local = box.globalToLocal(details.globalPosition);
          controller.edges.onEdgeLongPressStart(details, local);
        },
        child: Stack(
          children: [
            // Layer 1: Edge paths and markers (CustomPaint)
            CustomPaint(
              painter: EdgePainter(
                nodes: paintState.nodes,
                edges: Map.fromEntries(orderedEdges),
                edgeStates: paintState.edgeStates,
                theme: theme,
                precomputedPaths: precomputedPaths,
                canvasHeight: options.canvasSize.height,
                canvasWidth: options.canvasSize.width,
              ),
              size: Size.infinite,
            ),

            // Layer 2: Edge labels (Positioned Widgets)
            ...orderedEdges
                .where((entry) => entry.value.label != null)
                .map((entry) => _buildEdgeLabel(
                      context,
                      ref,
                      entry.key,
                      entry.value,
                      paintState,
                      precomputedPaths,
                      theme,
                    )),

            // Layer 3: Temporary connection line (CustomPaint)
            CustomPaint(
              painter: ConnectionPainter(
                connection: paintState.connection,
                connectionState: paintState.connectionState,
                style: theme.connection!,
                canvasHeight: options.canvasSize.height,
                canvasWidth: options.canvasSize.width,
              ),
              size: Size.infinite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEdgeLabel(
    BuildContext context,
    WidgetRef ref,
    String edgeId,
    FlowEdge edge,
    PainterState paintState,
    Map<String, Path> precomputedPaths,
    FlowCanvasTheme theme,
  ) {
    final path = precomputedPaths[edgeId];
    if (path == null) return const SizedBox.shrink();

    final metrics = path.computeMetrics().firstOrNull;
    if (metrics == null) return const SizedBox.shrink();

    final midpoint = metrics.length / 2;
    final tangent = metrics.getTangentForOffset(midpoint);
    if (tangent == null) return const SizedBox.shrink();

    final renderPosition = tangent.position;
    final coordinateConverter = ref.read(coordinateConverterProvider);

    final cartesianPosition =
        coordinateConverter.toCartesianPosition(renderPosition);

    final edgeState = paintState.edgeStates[edgeId];
    final states = <FlowEdgeState>{};
    if (paintState.selectedEdges.contains(edgeId)) {
      states.add(FlowEdgeState.selected);
    }
    if (edgeState?.hovered ?? false) {
      states.add(FlowEdgeState.hovered);
    }

    final labelStyle = edge.labelDecoration ??
        edge.style?.labelStyle ??
        theme.edge!.labelStyle;

    return FlowEdgeLabel(
      id: 'label-$edgeId',
      position: cartesianPosition,
      parentId: edgeId,
      selected: edgeState?.selected ?? false,
      hovered: edgeState?.hovered ?? false,
      style: labelStyle,
      child: edge.label,
    );
  }
}

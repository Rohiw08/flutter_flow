import 'package:equatable/equatable.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/connection_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/edge_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/node_state.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/providers.dart';
import '../../../domain/flow_canvas_state.dart';
import '../../../domain/models/connection.dart';
import '../../../domain/models/edge.dart';
import '../../../domain/models/node.dart';
import '../../painters/flow_painter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/edge_options.dart';

class FlowEdgeLayer extends ConsumerWidget {
  const FlowEdgeLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(internalControllerProvider.notifier);
    final options = ref.read(flowOptionsProvider);

    // This widget only rebuilds when data relevant to the painter changes.
    final paintState = ref.watch(internalControllerProvider.select(
      (s) => PainterState.fromState(s),
    ));

    // Get precomputed paths directly from the controller/service
    final precomputedPaths =
        controller.edgeGeometryService.getPrecomputedPaths();
    // Respect hidden edges option globally by filtering before painting
    final visibleEntries = paintState.edges.entries.where(
      (e) => !(e.value.isHidden(context)),
    );

    // Elevate selected edges if option is enabled by painting them last
    final elevate = EdgeOptions.resolve(context).elevateEdgesOnSelect;
    final selected = paintState.selectedEdges;

    final orderedEdges = <MapEntry<String, FlowEdge>>[];
    if (elevate) {
      orderedEdges
          .addAll(visibleEntries.where((e) => !selected.contains(e.key)));
      orderedEdges
          .addAll(visibleEntries.where((e) => selected.contains(e.key)));
    } else {
      orderedEdges.addAll(visibleEntries);
    }

    final painter = FlowPainter(
      nodes: paintState.nodes,
      edges: Map.fromEntries(orderedEdges),
      connection: paintState.connection,
      style: FlowCanvasThemeProvider.of(context),
      zoom: paintState.zoom,
      nodeStates: paintState.nodeStates,
      edgeStates: paintState.edgeStates,
      connectionState: paintState.connectionState,
      precomputedPaths: precomputedPaths,
      canvasHeight: options.canvasHeight,
      canvasWidth: options.canvasWidth,
    );

    return Listener(
      onPointerHover: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final local = box.globalToLocal(event.position);
        controller.onEdgePointerHover(event, local);
      },
      child: GestureDetector(
        onTapDown: (details) {
          final box = context.findRenderObject() as RenderBox?;
          if (box == null) return;
          final local = box.globalToLocal(details.globalPosition);
          controller.onEdgeTapDown(details, local);
        },
        onDoubleTap: () {
          controller.onEdgeDoubleTap();
        },
        onLongPressStart: (details) {
          final box = context.findRenderObject() as RenderBox?;
          if (box == null) return;
          final local = box.globalToLocal(details.globalPosition);
          controller.onEdgeLongPressStart(details, local);
        },
        child: CustomPaint(
          painter: painter,
          size: Size.infinite,
        ),
      ),
    );
  }
}

/// A lean state class derived from FlowCanvasState, used to trigger repaints
/// of the FlowPainter efficiently.
class PainterState extends Equatable {
  final Map<String, FlowNode> nodes;
  final Map<String, FlowEdge> edges;
  final Set<String> selectedEdges;
  final Map<String, NodeRuntimeState> nodeStates;
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
    required this.nodeStates,
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
    // Hash node positions
    final positionsHash = Object.hashAll(
      s.nodes.values.map((node) => node.position),
    );

    // Hash edge keys
    final edgesHash = Object.hashAll(s.edges.keys);

    return PainterState(
      nodes: s.nodes,
      edges: s.edges,
      selectedEdges: s.selectedEdges,
      nodeStates: s.nodeStates,
      edgeStates: s.edgeStates,
      connection: s.connection,
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
        nodeStates,
        edgeStates,
        connection,
        connectionState,
        selectionRect,
        zoom,
        _nodePositionsHash,
      ];
}

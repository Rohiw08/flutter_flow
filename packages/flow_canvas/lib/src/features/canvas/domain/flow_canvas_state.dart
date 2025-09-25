import 'package:flow_canvas/src/features/canvas/domain/indexes/edge_index.dart';
import 'package:flow_canvas/src/features/canvas/domain/indexes/node_index.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/connection.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/connection_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/edge_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/node_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/painting.dart';

part 'flow_canvas_state.freezed.dart';

@freezed
abstract class FlowCanvasState with _$FlowCanvasState {
  const FlowCanvasState._();

  const factory FlowCanvasState({
    // Core data
    @Default({}) Map<String, FlowNode> nodes,
    @Default({}) Map<String, FlowEdge> edges,
    @Default({}) Map<String, NodeRuntimeState> nodeStates,
    @Default({}) Map<String, EdgeRuntimeState> edgeStates,
    @Default({}) Set<String> selectedNodes,
    @Default({}) Set<String> selectedEdges,
    @Default({}) Map<String, Set<String>> spatialHash,

    // Edge indexing
    required EdgeIndex edgeIndex,
    required NodeIndex nodeIndex,

    // Z-index management
    @Default(0) int minZIndex,
    @Default(0) int maxZIndex,

    // Viewport state
    @Default(false) bool isPanZoomLocked,
    @Default(FlowViewport()) FlowViewport viewport,
    Size? viewportSize,

    // Interaction state
    FlowConnection? connection,
    FlowConnectionRuntimeState? connectionState,
    Rect? selectionRect,
    @Default(DragMode.none) DragMode dragMode,
  }) = _FlowCanvasState;

  factory FlowCanvasState.initial() => FlowCanvasState(
        nodes: {},
        edges: {},
        selectedNodes: {},
        selectedEdges: {},
        nodeStates: {},
        edgeStates: {},
        spatialHash: {},
        edgeIndex: EdgeIndex.empty(),
        nodeIndex: NodeIndex.empty(),
      );
}

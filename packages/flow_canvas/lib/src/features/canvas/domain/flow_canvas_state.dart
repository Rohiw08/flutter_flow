import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flow_canvas/src/features/canvas/domain/indexes/edge_index.dart';
import 'package:flow_canvas/src/features/canvas/domain/indexes/node_index.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/connection.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/connection_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/edge_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/handle_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/node_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';

part 'flow_canvas_state.freezed.dart';

@freezed
abstract class FlowCanvasState with _$FlowCanvasState {
  const FlowCanvasState._();

  const factory FlowCanvasState({
    // Core graph data
    @Default({}) Map<String, FlowNode> nodes,
    @Default({}) Map<String, FlowEdge> edges,

    // Runtime node/edge/handle states
    @Default({}) Map<String, NodeRuntimeState> nodeStates,
    @Default({}) Map<String, EdgeRuntimeState> edgeStates,
    @Default({}) Map<String, HandleRuntimeState> handleStates,

    // Selection and z-ordering
    @Default({}) Set<String> selectedNodes,
    @Default({}) Set<String> selectedEdges,
    @Default(0) int minZIndex,
    @Default(0) int maxZIndex,

    // Spatial indexing
    required NodeIndex nodeIndex,
    required EdgeIndex edgeIndex,

    // Viewport
    @Default(FlowViewport()) FlowViewport viewport,
    Size? viewportSize,
    @Default(false) bool isPanZoomLocked,

    // Interaction state
    @Default(DragMode.none) DragMode dragMode,
    FlowConnection? activeConnection,
    @Default(FlowConnectionRuntimeState.idle())
    FlowConnectionRuntimeState connectionState,
    @Default(Rect.zero) Rect selectionRect,
    @Default('') String hoveredEdgeId,
    @Default('') String lastClickedEdgeId,
  }) = _FlowCanvasState;

  factory FlowCanvasState.initial() => FlowCanvasState(
        nodeIndex: NodeIndex.empty(),
        edgeIndex: EdgeIndex.empty(),
      );
}

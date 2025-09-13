import 'package:built_collection/built_collection.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_indexing_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/node_indexing_service.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/connection_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
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
    @Default({}) Set<String> selectedNodes,
    @Default({}) Set<String> selectedEdges,
    @Default({}) Map<String, BuiltSet<String>> spatialHash,

    // Edge indexing
    required EdgeIndex edgeIndex,
    required NodeIndex nodeIndex,

    // Z-index management
    @Default(0) int minZIndex,
    @Default(0) int maxZIndex,

    // Viewport state
    @Default(1.0) double zoom,
    @Default(Offset.zero) Offset viewportOffset,
    @Default(false) bool isPanZoomLocked,
    Size? viewportSize,

    // Interaction state
    FlowConnectionState? connection,
    Rect? selectionRect,
    @Default(DragMode.none) DragMode dragMode,
  }) = _FlowCanvasState;

  factory FlowCanvasState.initial() => FlowCanvasState(
      nodes: {},
      edges: {},
      selectedNodes: {},
      selectedEdges: {},
      spatialHash: {},
      edgeIndex: EdgeIndex.empty(),
      nodeIndex: NodeIndex.empty());
}

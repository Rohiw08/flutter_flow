import 'package:built_collection/built_collection.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_indexing_service.dart';
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
    required BuiltMap<String, FlowNode> internalNodes,
    required BuiltMap<String, FlowEdge> internalEdges,
    required BuiltSet<String> internalSelectedNodes,
    required BuiltMap<String, BuiltSet<String>> internalSpatialHash,

    // Edge indexing
    required EdgeIndex edgeIndex,

    // Interaction state
    FlowConnectionState? connection,
    Rect? selectionRect,
    @Default(DragMode.none) DragMode dragMode,
  }) = _FlowCanvasState;

  // Getters
  Map<String, FlowNode> get nodes => Map.unmodifiable(internalNodes.asMap());
  Map<String, FlowEdge> get edges => Map.unmodifiable(internalEdges.asMap());
  Set<String> get selectedNodes =>
      Set.unmodifiable(internalSelectedNodes.asSet());
  Map<String, Set<String>> get spatialHash => Map.unmodifiable(
        internalSpatialHash.map((k, v) => MapEntry(k, v.toSet())).asMap(),
      );

  factory FlowCanvasState.initial() => FlowCanvasState(
        internalNodes: BuiltMap<String, FlowNode>(),
        internalEdges: BuiltMap<String, FlowEdge>(),
        internalSelectedNodes: BuiltSet<String>(),
        internalSpatialHash: BuiltMap<String, BuiltSet<String>>(),
        edgeIndex: EdgeIndex.empty(),
      );
}

/*
// Viewport State
    @Default(1.0) double zoom,
    @Default(Offset.zero) Offset viewportOffset,
    @Default(false) bool isPanZoomLocked,
    Size? viewportSize,

    // Configuration
    @Default(true) bool enableMultiSelection,
    @Default(true) bool enableKeyboardShortcuts,
    @Default(true) bool enableBoxSelection,
    @Default(500000) double canvasWidth,
    @Default(500000) double canvasHeight,

    // Z-index management
    @Default(0) int minZIndex,
    @Default(0) int maxZIndex,
*/

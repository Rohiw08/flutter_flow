import 'dart:ui' show Rect, Size;

import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'models/connection_state.dart';
import 'models/edge.dart';
import 'models/node.dart';

part 'flow_canvas_state.freezed.dart';

@freezed
abstract class FlowCanvasState with _$FlowCanvasState {
  const factory FlowCanvasState({
    // Core data
    @Default([]) List<FlowNode> nodes,
    @Default([]) List<FlowEdge> edges,
    @Default({}) Set<String> selectedNodes,
    @Default({}) Map<String, Set<String>> spatialHash,

    // Interaction state
    FlowConnectionState? connection,
    Rect? selectionRect,
    @Default(DragMode.none) DragMode dragMode,

    // Viewport State
    @Default(1.0) double zoom,
    @Default(false) bool isPanZoomLocked,
    Size? viewportSize,
    Rect? viewport,

    // Configuration
    @Default(true) bool enableMultiSelection,
    @Default(true) bool enableKeyboardShortcuts,
    @Default(true) bool enableBoxSelection,
    @Default(50000) double canvasWidth,
    @Default(50000) double canvasHeight,
  }) = _FlowCanvasState;

  factory FlowCanvasState.initial() => const FlowCanvasState();
}

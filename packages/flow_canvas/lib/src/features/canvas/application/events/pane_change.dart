import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flutter/gestures.dart';

enum PaneEventType {
  moveStart,
  move,
  moveEnd,
  click,
  doubleClick,
  scroll,
  contextMenu,
  mouseEnter,
  mouseMove,
  mouseLeave,
}

/// Represents a user interaction event that occurs on the canvas pane itself.
class PaneEvent {
  final PaneEventType type;
  final FlowCanvasState state;
  final Offset? canvasPosition;
  final dynamic details;

  PaneEvent({
    required this.type,
    required this.state,
    this.canvasPosition,
    this.details,
  });

  FlowViewport get viewport => state.viewport;

  @override
  String toString() {
    return 'PaneEvent{type: $type, canvasPosition: $canvasPosition, viewport: $viewport}';
  }
}

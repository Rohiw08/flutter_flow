import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';

enum ViewportEventType {
  pan, // For pan and zoom
  zoom,
  resize, // For when the widget size changes
}

class ViewportEvent {
  final ViewportEventType type;
  final FlowCanvasState state;
  final DateTime timestamp;

  ViewportEvent({
    required this.type,
    required this.state,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  FlowViewport get viewport => state.viewport;
  Size? get viewportSize => state.viewportSize;

  @override
  String toString() =>
      'ViewportEvent{type: $type, viewport: $viewport, size: $viewportSize}';
}

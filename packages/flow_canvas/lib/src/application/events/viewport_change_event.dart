import 'dart:ui';

import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';

enum ViewportEventType {
  /// Event for pan (translate) and zoom changes.
  transform,

  /// Event for when the canvas widget itself is resized.
  resize,
}

class ViewportEvent {
  final ViewportEventType type;

  /// The new state of the viewport after the event.
  final FlowViewport viewport;

  /// The size of the canvas widget.
  final Size? viewportSize;
  final DateTime timestamp;

  ViewportEvent({
    required this.type,
    required this.viewport,
    this.viewportSize,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'ViewportEvent{type: $type, viewport: $viewport, size: $viewportSize}';
}

import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/viewport_state.dart';

enum ViewportEventType {
  change,
  resize,
}

class ViewportEvent {
  final ViewportEventType type;
  final FlowViewport viewport;
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

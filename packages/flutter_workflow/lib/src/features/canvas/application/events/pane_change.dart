import '../../../../options/components/viewport_options.dart';

enum PaneEventType {
  move,
  moveStart,
  moveEnd,
  click,
  contextMenu,
  scroll,
  mouseMove,
  mouseEnter,
  mouseLeave,
}

class PaneEvent {
  final PaneEventType type;
  final FlowViewport? viewport;
  final dynamic details;
  final DateTime timestamp;

  PaneEvent({
    required this.type,
    this.viewport,
    this.details,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'PaneEvent{type: $type, viewport: $viewport, details: $details, timestamp: $timestamp}';
  }
}

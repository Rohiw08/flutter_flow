import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';

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

  PaneEvent({
    required this.type,
    this.viewport,
    this.details,
    DateTime? timestamp,
  });

  @override
  String toString() {
    return 'PaneEvent{type: $type, viewport: $viewport, details: $details}';
  }
}

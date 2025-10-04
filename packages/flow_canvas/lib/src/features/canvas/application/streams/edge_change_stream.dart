import 'dart:async';
import 'package:flow_canvas/src/features/canvas/application/events/edge_change_event.dart';

/// Streams for edge interaction events (click, hover, reconnect, etc.)
class EdgeInteractionStreams {
  final StreamController<EdgeInteractionEvent> _controller =
      StreamController<EdgeInteractionEvent>.broadcast();

  Stream<EdgeInteractionEvent> get events => _controller.stream;

  // Filtered streams
  Stream<EdgeInteractionEvent> get clickEvents =>
      events.where((e) => e.type == EdgeInteractionType.click);
  Stream<EdgeInteractionEvent> get doubleClickEvents =>
      events.where((e) => e.type == EdgeInteractionType.doubleClick);
  Stream<EdgeInteractionEvent> get mouseEnterEvents =>
      events.where((e) => e.type == EdgeInteractionType.mouseEnter);
  Stream<EdgeInteractionEvent> get mouseMoveEvents =>
      events.where((e) => e.type == EdgeInteractionType.mouseMove);
  Stream<EdgeInteractionEvent> get mouseLeaveEvents =>
      events.where((e) => e.type == EdgeInteractionType.mouseLeave);
  Stream<EdgeInteractionEvent> get contextMenuEvents =>
      events.where((e) => e.type == EdgeInteractionType.contextMenu);

  void emitEvent(EdgeInteractionEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void dispose() {
    _controller.close();
  }
}

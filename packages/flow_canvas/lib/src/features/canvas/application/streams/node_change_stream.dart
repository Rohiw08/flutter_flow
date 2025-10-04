import 'dart:async';
import 'package:flow_canvas/src/features/canvas/application/events/node_change_event.dart';

/// Streams for user-driven node interactions (click, drag, hover, context menu)
class NodeInteractionStreams {
  final StreamController<NodeInteractionEvent> _controller =
      StreamController<NodeInteractionEvent>.broadcast();

  Stream<NodeInteractionEvent> get events => _controller.stream;

  Stream<NodeInteractionEvent> get clickEvents =>
      events.where((e) => e.type == NodeInteractionType.click);
  Stream<NodeInteractionEvent> get doubleClickEvents =>
      events.where((e) => e.type == NodeInteractionType.doubleClick);
  Stream<NodeInteractionEvent> get dragStartEvents =>
      events.where((e) => e.type == NodeInteractionType.dragStart);
  Stream<NodeInteractionEvent> get dragEvents =>
      events.where((e) => e.type == NodeInteractionType.drag);
  Stream<NodeInteractionEvent> get dragStopEvents =>
      events.where((e) => e.type == NodeInteractionType.dragStop);
  Stream<NodeInteractionEvent> get mouseEnterEvents =>
      events.where((e) => e.type == NodeInteractionType.mouseEnter);
  Stream<NodeInteractionEvent> get mouseMoveEvents =>
      events.where((e) => e.type == NodeInteractionType.mouseMove);
  Stream<NodeInteractionEvent> get mouseLeaveEvents =>
      events.where((e) => e.type == NodeInteractionType.mouseLeave);
  Stream<NodeInteractionEvent> get contextMenuEvents =>
      events.where((e) => e.type == NodeInteractionType.contextMenu);

  void emitEvent(NodeInteractionEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void dispose() {
    _controller.close();
  }
}

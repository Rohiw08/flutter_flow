import 'dart:async';

import '../events/pane_change.dart';

class PaneStreams {
  final StreamController<PaneEvent> _paneEventController =
      StreamController<PaneEvent>.broadcast();

  Stream<PaneEvent> get events => _paneEventController.stream;

  // Filtered streams for specific event types
  Stream<PaneEvent> get moveEvents =>
      events.where((event) => event.type == PaneEventType.move);
  Stream<PaneEvent> get moveStartEvents =>
      events.where((event) => event.type == PaneEventType.moveStart);
  Stream<PaneEvent> get moveEndEvents =>
      events.where((event) => event.type == PaneEventType.moveEnd);
  Stream<PaneEvent> get clickEvents =>
      events.where((event) => event.type == PaneEventType.click);
  Stream<PaneEvent> get contextMenuEvents =>
      events.where((event) => event.type == PaneEventType.contextMenu);
  Stream<PaneEvent> get scrollEvents =>
      events.where((event) => event.type == PaneEventType.scroll);
  Stream<PaneEvent> get mouseMoveEvents =>
      events.where((event) => event.type == PaneEventType.mouseMove);
  Stream<PaneEvent> get mouseEnterEvents =>
      events.where((event) => event.type == PaneEventType.mouseEnter);
  Stream<PaneEvent> get mouseLeaveEvents =>
      events.where((event) => event.type == PaneEventType.mouseLeave);

  void emitEvent(PaneEvent event) {
    if (!_paneEventController.isClosed) {
      _paneEventController.add(event);
    }
  }

  void dispose() {
    _paneEventController.close();
  }
}

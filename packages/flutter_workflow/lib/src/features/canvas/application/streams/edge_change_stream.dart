import 'dart:async';

import 'package:flutter_workflow/src/features/canvas/domain/events/edge_change_event.dart';

class EdgeStreams {
  final StreamController<EdgeChangeEvent> _edgeChangeEventController =
      StreamController<EdgeChangeEvent>.broadcast();
  final StreamController<List<EdgeChangeEvent>> _edgeChangeController =
      StreamController<List<EdgeChangeEvent>>.broadcast();

  Stream<EdgeChangeEvent> get events => _edgeChangeEventController.stream;
  Stream<List<EdgeChangeEvent>> get changes => _edgeChangeController.stream;

  // Filtered streams for specific event types
  Stream<EdgeChangeEvent> get clickEvents =>
      events.where((event) => event.type == EdgeEventType.click);
  Stream<EdgeChangeEvent> get doubleClickEvents =>
      events.where((event) => event.type == EdgeEventType.doubleClick);
  Stream<EdgeChangeEvent> get mouseEvents => events.where((event) =>
      event.type == EdgeEventType.mouseEnter ||
      event.type == EdgeEventType.mouseMove ||
      event.type == EdgeEventType.mouseLeave);
  Stream<EdgeChangeEvent> get contextMenuEvents =>
      events.where((event) => event.type == EdgeEventType.contextMenu);
  Stream<EdgeChangeEvent> get deleteEvents =>
      events.where((event) => event.type == EdgeEventType.delete);
  Stream<EdgeChangeEvent> get reconnectEvents =>
      events.where((event) => event.type == EdgeEventType.reconnect);

  void emitEvent(EdgeChangeEvent event) {
    if (!_edgeChangeEventController.isClosed) {
      _edgeChangeEventController.add(event);
    }
  }

  void emitChanges(List<EdgeChangeEvent> changes) {
    if (!_edgeChangeController.isClosed && changes.isNotEmpty) {
      _edgeChangeController.add(changes);
    }
  }

  void dispose() {
    _edgeChangeEventController.close();
    _edgeChangeController.close();
  }
}

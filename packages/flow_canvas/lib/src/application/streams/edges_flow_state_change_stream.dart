import 'dart:async';
import 'package:flow_canvas/src/features/canvas/application/events/edges_flow_state_chnage_event.dart';

/// Streams for edge lifecycle/state change events (add, remove, update)
class EdgesStateStreams {
  final StreamController<EdgeLifecycleEvent> _controller =
      StreamController<EdgeLifecycleEvent>.broadcast();
  final StreamController<List<EdgeLifecycleEvent>> _bulkController =
      StreamController<List<EdgeLifecycleEvent>>.broadcast();

  Stream<EdgeLifecycleEvent> get changes => _controller.stream;
  Stream<List<EdgeLifecycleEvent>> get bulkChanges => _bulkController.stream;

  // Filtered streams
  Stream<EdgeLifecycleEvent> get addEvents =>
      changes.where((e) => e.type == EdgeLifecycleType.add);
  Stream<EdgeLifecycleEvent> get removeEvents =>
      changes.where((e) => e.type == EdgeLifecycleType.remove);
  Stream<EdgeLifecycleEvent> get updateEvents =>
      changes.where((e) => e.type == EdgeLifecycleType.update);
  Stream<EdgeLifecycleEvent> get reconnectEvents =>
      changes.where((e) => e.type == EdgeLifecycleType.reconnect);

  void emitEvent(EdgeLifecycleEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void emitBulk(List<EdgeLifecycleEvent> events) {
    if (!_bulkController.isClosed && events.isNotEmpty) {
      _bulkController.add(events);
    }
  }

  void dispose() {
    _controller.close();
    _bulkController.close();
  }
}

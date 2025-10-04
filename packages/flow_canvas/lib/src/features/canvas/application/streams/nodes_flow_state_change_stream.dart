import 'dart:async';
import 'package:flow_canvas/src/features/canvas/application/events/nodes_flow_state_change_event.dart';

/// Streams for node lifecycle/state change events (add, remove, update)
class NodesStateStreams {
  final StreamController<NodeLifecycleEvent> _controller =
      StreamController<NodeLifecycleEvent>.broadcast();
  final StreamController<List<NodeLifecycleEvent>> _bulkController =
      StreamController<List<NodeLifecycleEvent>>.broadcast();

  Stream<NodeLifecycleEvent> get changes => _controller.stream;
  Stream<List<NodeLifecycleEvent>> get bulkChanges => _bulkController.stream;

  // Filtered streams
  Stream<NodeLifecycleEvent> get addEvents =>
      changes.where((e) => e.type == NodeLifecycleType.add);
  Stream<NodeLifecycleEvent> get removeEvents =>
      changes.where((e) => e.type == NodeLifecycleType.remove);
  Stream<NodeLifecycleEvent> get updateEvents =>
      changes.where((e) => e.type == NodeLifecycleType.update);

  void emitEvent(NodeLifecycleEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void emitBulk(List<NodeLifecycleEvent> events) {
    if (!_bulkController.isClosed && events.isNotEmpty) {
      _bulkController.add(events);
    }
  }

  void dispose() {
    _controller.close();
    _bulkController.close();
  }
}

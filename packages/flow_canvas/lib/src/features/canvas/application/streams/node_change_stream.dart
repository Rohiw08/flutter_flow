import 'dart:async';
import '../../../../shared/enums.dart';
import '../events/node_change_event.dart';

class NodeEvent {
  final String nodeId;
  final NodeEventType type;
  final dynamic data;
  final DateTime timestamp;

  NodeEvent({
    required this.nodeId,
    required this.type,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'NodeEvent{nodeId: $nodeId, type: $type, data: $data, timestamp: $timestamp}';
  }
}

class NodeStreams {
  final StreamController<NodeEvent> _nodeEventController =
      StreamController<NodeEvent>.broadcast();
  final StreamController<List<NodeChangeEvent>> _nodeChangeController =
      StreamController<List<NodeChangeEvent>>.broadcast();

  Stream<NodeEvent> get events => _nodeEventController.stream;
  Stream<List<NodeChangeEvent>> get changes => _nodeChangeController.stream;

  // Filtered streams for specific event types
  Stream<NodeEvent> get clickEvents =>
      events.where((event) => event.type == NodeEventType.click);
  Stream<NodeEvent> get doubleClickEvents =>
      events.where((event) => event.type == NodeEventType.doubleClick);
  Stream<NodeEvent> get dragEvents => events.where((event) =>
      event.type == NodeEventType.dragStart ||
      event.type == NodeEventType.drag ||
      event.type == NodeEventType.dragStop);
  Stream<NodeEvent> get mouseEvents => events.where((event) =>
      event.type == NodeEventType.mouseEnter ||
      event.type == NodeEventType.mouseMove ||
      event.type == NodeEventType.mouseLeave);
  Stream<NodeEvent> get contextMenuEvents =>
      events.where((event) => event.type == NodeEventType.contextMenu);
  Stream<NodeEvent> get deleteEvents =>
      events.where((event) => event.type == NodeEventType.delete);

  void emitEvent(NodeEvent event) {
    if (!_nodeEventController.isClosed) {
      _nodeEventController.add(event);
    }
  }

  void emitChanges(List<NodeChangeEvent> changes) {
    if (!_nodeChangeController.isClosed && changes.isNotEmpty) {
      _nodeChangeController.add(changes);
    }
  }

  void dispose() {
    _nodeEventController.close();
    _nodeChangeController.close();
  }
}

import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';

/// state mutation events that affect nodes in the graph.
enum NodeLifecycleType {
  add,
  remove,
  update,
}

class NodeLifecycleEvent {
  final NodeLifecycleType type;
  final FlowCanvasState state;
  final String? nodeId;
  final dynamic data;

  final DateTime timestamp;

  NodeLifecycleEvent({
    required this.type,
    required this.state,
    this.nodeId,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'NodeLifecycleEvent{nodeId: $nodeId, type: $type, timestamp: $timestamp}';
}

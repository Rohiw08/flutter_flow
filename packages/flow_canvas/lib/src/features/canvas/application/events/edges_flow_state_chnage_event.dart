import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';

/// state mutation events that affect edges in the graph.
enum EdgeLifecycleType {
  add,
  remove,
  update,
  reconnect,
}

class EdgeLifecycleEvent {
  final EdgeLifecycleType type;
  final FlowCanvasState state; // snapshot of canvas at the moment
  final String? edgeId; // optional: may be null for bulk updates
  final dynamic data; // e.g., the new FlowEdge object, diff info
  final DateTime timestamp;

  EdgeLifecycleEvent({
    required this.type,
    required this.state,
    this.edgeId,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'EdgeLifecycleEvent{edgeId: $edgeId, type: $type, data: $data, timestamp: $timestamp}';
}

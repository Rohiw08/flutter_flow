import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';

/// state mutation events that affect nodes in the graph.
enum NodeLifecycleType {
  add,
  remove,
  update,
}

class NodeLifecycleEvent {
  final NodeLifecycleType type;

  /// Snapshot of the entire canvas after the change.
  final FlowCanvasState state;

  /// The node ID this event is about (if applicable).
  final String? nodeId;

  /// Extra payload (e.g., new FlowNode object, diff data).
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

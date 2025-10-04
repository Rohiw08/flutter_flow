import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';

/// User interaction events specific to one node.
enum NodeInteractionType {
  click,
  doubleClick,
  dragStart,
  drag,
  dragStop,
  mouseEnter,
  mouseMove,
  mouseLeave,
  contextMenu,
}

class NodeInteractionEvent {
  final String nodeId;
  final NodeInteractionType type;

  /// Snapshot of the canvas at the moment (useful for contextual data).
  final FlowCanvasState state;

  /// Original low-level gesture/pointer details from Flutter.
  final dynamic details;

  final DateTime timestamp;

  NodeInteractionEvent({
    required this.nodeId,
    required this.type,
    required this.state,
    this.details,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'NodeInteractionEvent{nodeId: $nodeId, type: $type, timestamp: $timestamp}';
}

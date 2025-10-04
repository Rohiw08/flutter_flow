/// User interaction events specific to one edge.
enum EdgeInteractionType {
  click,
  doubleClick,
  mouseEnter,
  mouseMove,
  mouseLeave,
  contextMenu,
}

class EdgeInteractionEvent {
  final String edgeId;
  final EdgeInteractionType type;
  final dynamic data; // e.g., gesture details, pointer position
  final DateTime timestamp;

  EdgeInteractionEvent({
    required this.edgeId,
    required this.type,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'EdgeInteractionEvent{edgeId: $edgeId, type: $type, data: $data, timestamp: $timestamp}';
}

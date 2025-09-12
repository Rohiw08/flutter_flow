enum EdgeEventType {
  click,
  doubleClick,
  mouseEnter,
  mouseMove,
  mouseLeave,
  contextMenu,
  delete,
  change,
  reconnect,
}

class EdgeChangeEvent {
  final String edgeId;
  final EdgeEventType type;
  final dynamic data;
  final DateTime timestamp;

  EdgeChangeEvent({
    required this.edgeId,
    required this.type,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'EdgeChangeEvent{edgeId: $edgeId, type: $type, data: $data, timestamp: $timestamp}';
  }
}

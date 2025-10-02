enum NodeChangeType {
  position,
  selection,
  dimensions,
  data,
  add,
  remove,
  update,
}

class NodeChangeEvent {
  final String nodeId;
  final NodeChangeType type;
  final dynamic oldValue;
  final dynamic newValue;
  final DateTime timestamp;

  NodeChangeEvent({
    required this.nodeId,
    required this.type,
    this.oldValue,
    this.newValue,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'NodeChangeEvent{nodeId: $nodeId, type: $type, oldValue: $oldValue, newValue: $newValue}';
  }
}

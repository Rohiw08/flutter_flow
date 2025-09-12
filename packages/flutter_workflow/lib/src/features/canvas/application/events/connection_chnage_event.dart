import 'package:flutter_workflow/src/features/canvas/domain/state/connection_state.dart';

enum ConnectionEventType {
  connectStart,
  connect,
  connectEnd,
  clickConnectStart,
  clickConnectEnd,
}

class ConnectionEvent {
  final ConnectionEventType type;
  final FlowConnectionState? connectionState;
  final dynamic data; // For any additional data
  final DateTime timestamp;

  ConnectionEvent({
    required this.type,
    this.connectionState,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'ConnectionEvent{type: $type, connectionState: $connectionState, data: $data, timestamp: $timestamp}';
  }
}

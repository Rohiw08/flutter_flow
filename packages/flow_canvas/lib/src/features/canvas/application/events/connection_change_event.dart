import '../../domain/models/connection.dart';

enum ConnectionEventType {
  start,
  connect,
  end,
}

class ConnectionEvent {
  final ConnectionEventType type;
  final FlowConnection connection;

  ConnectionEvent({
    required this.type,
    required this.connection,
  });

  @override
  String toString() {
    return 'ConnectionEvent(type: $type, connection: $connection)';
  }
}

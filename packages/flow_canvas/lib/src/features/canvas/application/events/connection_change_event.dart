import '../../domain/models/connection.dart';

/// Defines the types of events that can occur during a connection gesture.
enum ConnectionEventType {
  /// Fired when a connection gesture starts.
  start,

  /// Fired when a valid connection is successfully made.
  connect,

  /// Fired when a connection gesture ends, regardless of success.
  end,
}

/// Represents an event related to a connection action in the canvas.
class ConnectionEvent {
  final ConnectionEventType type;

  /// The connection object, which may be in a pending state or fully formed.
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

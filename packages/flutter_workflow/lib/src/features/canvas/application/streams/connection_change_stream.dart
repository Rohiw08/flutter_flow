import 'dart:async';
import '../events/connection_chnage_event.dart';

class ConnectionStreams {
  final StreamController<ConnectionEvent> _connectionEventController =
      StreamController<ConnectionEvent>.broadcast();

  Stream<ConnectionEvent> get events => _connectionEventController.stream;

  // Filtered streams for specific event types
  Stream<ConnectionEvent> get connectStartEvents =>
      events.where((event) => event.type == ConnectionEventType.connectStart);
  Stream<ConnectionEvent> get connectEvents =>
      events.where((event) => event.type == ConnectionEventType.connect);
  Stream<ConnectionEvent> get connectEndEvents =>
      events.where((event) => event.type == ConnectionEventType.connectEnd);
  Stream<ConnectionEvent> get clickConnectStartEvents => events
      .where((event) => event.type == ConnectionEventType.clickConnectStart);
  Stream<ConnectionEvent> get clickConnectEndEvents => events
      .where((event) => event.type == ConnectionEventType.clickConnectEnd);

  void emitEvent(ConnectionEvent event) {
    if (!_connectionEventController.isClosed) {
      _connectionEventController.add(event);
    }
  }

  void dispose() {
    _connectionEventController.close();
  }
}

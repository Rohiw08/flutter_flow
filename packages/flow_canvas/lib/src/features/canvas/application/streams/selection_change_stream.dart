import 'dart:async';
import '../events/selection_change_event.dart';

class SelectionStreams {
  final _controller = StreamController<SelectionChangeEvent>.broadcast();
  Stream<SelectionChangeEvent> get events => _controller.stream;

  void emit(SelectionChangeEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}

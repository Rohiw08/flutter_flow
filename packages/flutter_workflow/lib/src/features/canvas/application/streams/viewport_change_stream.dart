import 'dart:async';
import 'package:flutter/scheduler.dart';
import '../events/viewport_change_event.dart';

class ViewportStreams {
  final StreamController<ViewportEvent> _controller =
      StreamController<ViewportEvent>.broadcast();

  Stream<ViewportEvent> get events => _controller.stream;

  // Simple frame-throttling: only emit once per frame
  ViewportEvent? _pending;
  bool _scheduled = false;

  void emit(ViewportEvent event) {
    _pending = event;
    if (_scheduled) return;
    _scheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      final e = _pending;
      _pending = null;
      if (e != null && !_controller.isClosed) {
        _controller.add(e);
      }
    });
  }

  void dispose() {
    _controller.close();
  }
}

import 'dart:async';
import 'package:flutter/scheduler.dart';
import '../events/viewport_change_event.dart';

/// Manages and exposes streams for viewport-related events, with built-in
/// frame-based throttling for high-frequency events like panning and zooming.
class ViewportStreams {
  final StreamController<ViewportEvent> _controller =
      StreamController<ViewportEvent>.broadcast();

  /// The main stream of throttled viewport events.
  /// An event will be emitted at most once per frame.
  Stream<ViewportEvent> get events => _controller.stream;

  // --- Filtered Convenience Streams ---

  /// A stream that emits events only when the viewport's pan or zoom changes.
  Stream<ViewportEvent> get panEvents =>
      events.where((event) => event.type == ViewportEventType.pan);

  Stream<ViewportEvent> get zoomEvents =>
      events.where((event) => event.type == ViewportEventType.zoom);

  /// A stream that emits events only when the canvas widget itself is resized.
  Stream<ViewportEvent> get resizeEvents =>
      events.where((event) => event.type == ViewportEventType.resize);

  // --- Throttling Logic ---

  ViewportEvent? _pendingEvent;
  bool _isScheduled = false;

  /// Emits a viewport event.
  ///
  /// This method uses frame-based throttling. No matter how many times it's
  /// called during a frame, it will only queue the *last* event to be
  /// dispatched after the frame is complete.
  void emitEvent(ViewportEvent event) {
    // Always store the latest event.
    _pendingEvent = event;

    // If a dispatch is already scheduled for the end of this frame, do nothing more.
    if (_isScheduled) return;

    _isScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // After the frame, reset the schedule flag.
      _isScheduled = false;

      // Get the last event that was pending.
      final eventToEmit = _pendingEvent;
      _pendingEvent = null; // Clear the pending event

      // If there was an event and the stream is still open, dispatch it.
      if (eventToEmit != null && !_controller.isClosed) {
        _controller.add(eventToEmit);
      }
    });
  }

  void dispose() {
    _controller.close();
  }
}

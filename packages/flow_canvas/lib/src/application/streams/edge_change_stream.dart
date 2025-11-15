import 'dart:async';
import 'package:flow_canvas/src/features/canvas/application/events/edge_change_event.dart';

/// Streams for edge interaction events (click, hover, context menu, etc.)
class EdgeInteractionStreams {
  final StreamController<EdgeInteractionEvent> _controller =
      StreamController<EdgeInteractionEvent>.broadcast();

  /// A stream of all edge interaction events.
  Stream<EdgeInteractionEvent> get events => _controller.stream;

  // --- Type-Safe Filtered Streams ---

  /// A stream that emits events only when an edge is clicked.
  Stream<EdgeClickEvent> get clickEvents =>
      events.where((e) => e is EdgeClickEvent).cast<EdgeClickEvent>();

  /// A stream that emits events only when an edge is double-clicked.
  Stream<EdgeDoubleClickEvent> get doubleClickEvents => events
      .where((e) => e is EdgeDoubleClickEvent)
      .cast<EdgeDoubleClickEvent>();

  /// A stream that emits events only when the mouse pointer enters an edge.
  Stream<EdgeMouseEnterEvent> get mouseEnterEvents =>
      events.where((e) => e is EdgeMouseEnterEvent).cast<EdgeMouseEnterEvent>();

  /// A stream that emits events only when the mouse pointer moves over an edge.
  Stream<EdgeMouseMoveEvent> get mouseMoveEvents =>
      events.where((e) => e is EdgeMouseMoveEvent).cast<EdgeMouseMoveEvent>();

  /// A stream that emits events only when the mouse pointer leaves an edge.
  Stream<EdgeMouseLeaveEvent> get mouseLeaveEvents =>
      events.where((e) => e is EdgeMouseLeaveEvent).cast<EdgeMouseLeaveEvent>();

  /// A stream that emits events only for edge context menu interactions.
  Stream<EdgeContextMenuEvent> get contextMenuEvents => events
      .where((e) => e is EdgeContextMenuEvent)
      .cast<EdgeContextMenuEvent>();

  /// Emits a new edge interaction event to the appropriate stream.
  void emitEvent(EdgeInteractionEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Emits multiple edge interaction events at once.
  void emitBulk(List<EdgeInteractionEvent> events) {
    if (!_controller.isClosed) {
      for (final event in events) {
        _controller.add(event);
      }
    }
  }

  /// Closes the stream controller. Should be called when the widget is disposed.
  void dispose() {
    _controller.close();
  }
}

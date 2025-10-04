import 'dart:async';
import 'package:flow_canvas/src/features/canvas/application/events/node_change_event.dart';

/// Streams for user-driven node interactions (click, drag, hover, context menu)
class NodeInteractionStreams {
  final StreamController<NodeInteractionEvent> _controller =
      StreamController<NodeInteractionEvent>.broadcast();

  /// A stream of all node interaction events.
  Stream<NodeInteractionEvent> get events => _controller.stream;

  // --- Type-Safe Filtered Streams ---

  /// A stream that emits events only when a node is clicked.
  Stream<NodeClickEvent> get clickEvents =>
      events.where((e) => e is NodeClickEvent).cast<NodeClickEvent>();

  /// A stream that emits events only when a node is double-clicked.
  Stream<NodeDoubleClickEvent> get doubleClickEvents => events
      .where((e) => e is NodeDoubleClickEvent)
      .cast<NodeDoubleClickEvent>();

  /// A stream that emits events when a node drag gesture starts.
  Stream<NodeDragStartEvent> get dragStartEvents =>
      events.where((e) => e is NodeDragStartEvent).cast<NodeDragStartEvent>();

  /// A stream that emits events as a node is being dragged.
  Stream<NodeDragEvent> get dragEvents =>
      events.where((e) => e is NodeDragEvent).cast<NodeDragEvent>();

  /// A stream that emits events when a node drag gesture stops.
  Stream<NodeDragStopEvent> get dragStopEvents =>
      events.where((e) => e is NodeDragStopEvent).cast<NodeDragStopEvent>();

  /// A stream that emits events when the mouse pointer enters a node.
  Stream<NodeMouseEnterEvent> get mouseEnterEvents =>
      events.where((e) => e is NodeMouseEnterEvent).cast<NodeMouseEnterEvent>();

  /// A stream that emits events as the mouse pointer moves over a node.
  Stream<NodeMouseMoveEvent> get mouseMoveEvents =>
      events.where((e) => e is NodeMouseMoveEvent).cast<NodeMouseMoveEvent>();

  /// A stream that emits events when the mouse pointer leaves a node.
  Stream<NodeMouseLeaveEvent> get mouseLeaveEvents =>
      events.where((e) => e is NodeMouseLeaveEvent).cast<NodeMouseLeaveEvent>();

  /// A stream that emits events for node context menu interactions.
  Stream<NodeContextMenuEvent> get contextMenuEvents => events
      .where((e) => e is NodeContextMenuEvent)
      .cast<NodeContextMenuEvent>();

  /// Emits a new node interaction event to the appropriate stream.
  void emitEvent(NodeInteractionEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Closes the stream controller. Should be called when the widget is disposed.
  void dispose() {
    _controller.close();
  }
}

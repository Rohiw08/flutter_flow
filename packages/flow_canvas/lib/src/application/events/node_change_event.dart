import 'package:flutter/gestures.dart';

// =======================================================================
// == New Base Class for All Events                                     ==
// =======================================================================
/// The base class for all events originating from the canvas.
abstract class FlowCanvasEvent {
  final DateTime timestamp;
  FlowCanvasEvent({DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

/// Base class for user interaction events specific to **one node**.
abstract class NodeInteractionEvent extends FlowCanvasEvent {
  final String nodeId;

  NodeInteractionEvent({
    required this.nodeId,
    super.timestamp,
  });
}

// --- High-Frequency Events ---

class NodeDragStartEvent extends NodeInteractionEvent {
  final DragStartDetails details;
  NodeDragStartEvent(
      {required super.nodeId, required this.details, super.timestamp});
}

// =======================================================================
// == OPTIMIZED BATCH EVENT                                             ==
// =======================================================================
/// Event fired when a group of one or more nodes is dragged.
/// This event is batched for performance.
class NodesDragEvent extends FlowCanvasEvent {
  /// A map of the moved node IDs to their new canvas positions.
  final Map<String, Offset> positions;
  final Offset delta;
  final DragUpdateDetails details;
  NodesDragEvent({
    required this.positions,
    required this.delta,
    required this.details,
    super.timestamp,
  });
}

class NodeDragStopEvent extends NodeInteractionEvent {
  final DragEndDetails details;
  NodeDragStopEvent(
      {required super.nodeId, required this.details, super.timestamp});
}

class NodeMouseMoveEvent extends NodeInteractionEvent {
  final PointerEvent details;
  NodeMouseMoveEvent(
      {required super.nodeId, required this.details, super.timestamp});
}

// --- Low-Frequency Events (Unchanged) ---

class NodeClickEvent extends NodeInteractionEvent {
  final TapDownDetails details;
  NodeClickEvent(
      {required super.nodeId, required this.details, super.timestamp});
}

class NodeDoubleClickEvent extends NodeInteractionEvent {
  NodeDoubleClickEvent({required super.nodeId, super.timestamp});
}

class NodeContextMenuEvent extends NodeInteractionEvent {
  final LongPressStartDetails details;
  NodeContextMenuEvent(
      {required super.nodeId, required this.details, super.timestamp});
}

class NodeMouseEnterEvent extends NodeInteractionEvent {
  final PointerEvent details;
  NodeMouseEnterEvent(
      {required super.nodeId, required this.details, super.timestamp});
}

class NodeMouseLeaveEvent extends NodeInteractionEvent {
  final PointerEvent details;
  NodeMouseLeaveEvent(
      {required super.nodeId, required this.details, super.timestamp});
}

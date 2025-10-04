import 'package:flutter/gestures.dart';

/// User interaction events specific to one node.
enum NodeInteractionType {
  click,
  doubleClick,
  dragStart,
  drag,
  dragStop,
  mouseEnter,
  mouseMove,
  mouseLeave,
  contextMenu,
}

/// Base class for user interaction events specific to one node.
abstract class NodeInteractionEvent {
  final String nodeId;
  final DateTime timestamp;

  NodeInteractionEvent({
    required this.nodeId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

// --- High-Frequency Events (Minimalist) ---

class NodeDragStartEvent extends NodeInteractionEvent {
  final DragStartDetails details;
  NodeDragStartEvent(
      {required super.nodeId, required this.details, super.timestamp});
}

class NodeDragEvent extends NodeInteractionEvent {
  final Offset position;
  final Offset delta;
  final DragUpdateDetails details;
  NodeDragEvent({
    required super.nodeId,
    required this.position,
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

// --- Low-Frequency Events (Can be richer if needed) ---

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

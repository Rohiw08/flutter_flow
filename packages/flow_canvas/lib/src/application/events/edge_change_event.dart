import 'package:flutter/gestures.dart';

/// User interaction events specific to one edge.
enum EdgeInteractionType {
  click,
  doubleClick,
  mouseEnter,
  mouseMove,
  mouseLeave,
  contextMenu,
}

/// Base class for user interaction events specific to one edge.
abstract class EdgeInteractionEvent {
  final String edgeId;
  final DateTime timestamp;

  EdgeInteractionEvent({
    required this.edgeId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

// --- High-Frequency Events (Minimalist) ---

class EdgeMouseMoveEvent extends EdgeInteractionEvent {
  final PointerEvent details;
  EdgeMouseMoveEvent(
      {required super.edgeId, required this.details, super.timestamp});
}

// --- Low-Frequency Events ---

class EdgeClickEvent extends EdgeInteractionEvent {
  final TapDownDetails details;
  EdgeClickEvent(
      {required super.edgeId, required this.details, super.timestamp});
}

class EdgeDoubleClickEvent extends EdgeInteractionEvent {
  EdgeDoubleClickEvent({required super.edgeId, super.timestamp});
}

class EdgeContextMenuEvent extends EdgeInteractionEvent {
  final LongPressStartDetails details;
  EdgeContextMenuEvent(
      {required super.edgeId, required this.details, super.timestamp});
}

class EdgeMouseEnterEvent extends EdgeInteractionEvent {
  final PointerEvent details;
  EdgeMouseEnterEvent(
      {required super.edgeId, required this.details, super.timestamp});
}

class EdgeMouseLeaveEvent extends EdgeInteractionEvent {
  final PointerEvent details;
  EdgeMouseLeaveEvent(
      {required super.edgeId, required this.details, super.timestamp});
}

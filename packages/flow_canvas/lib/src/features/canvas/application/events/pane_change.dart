import 'package:flutter/gestures.dart';

enum PaneEventType {
  moveStart,
  move,
  moveEnd,
  tap,
  contextMenu,
  scroll,
}

abstract class PaneEvent {
  final PaneEventType type;
  final DateTime timestamp;

  PaneEvent({required this.type, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class PaneMoveStartEvent extends PaneEvent {
  final DragStartDetails details;
  PaneMoveStartEvent({required this.details})
      : super(type: PaneEventType.moveStart);
}

class PaneMoveEvent extends PaneEvent {
  final Offset position;
  final Offset delta;
  final DragUpdateDetails details;
  PaneMoveEvent({
    required this.position,
    required this.delta,
    required this.details,
  }) : super(type: PaneEventType.move);
}

class PaneMoveEndEvent extends PaneEvent {
  final DragEndDetails details;
  PaneMoveEndEvent({required this.details})
      : super(type: PaneEventType.moveEnd);
}

class PaneTapEvent extends PaneEvent {
  final TapDownDetails details;
  PaneTapEvent({required this.details}) : super(type: PaneEventType.tap);
}

class PaneContextMenuEvent extends PaneEvent {
  final LongPressStartDetails details;
  PaneContextMenuEvent({required this.details})
      : super(type: PaneEventType.contextMenu);
}

class PaneScrollEvent extends PaneEvent {
  final PointerScrollEvent details;
  PaneScrollEvent({required this.details}) : super(type: PaneEventType.scroll);
}

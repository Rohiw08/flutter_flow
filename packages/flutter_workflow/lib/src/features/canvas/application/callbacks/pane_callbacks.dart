import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../shared/enums.dart';
import '../options/viewport_options.dart';
import '../streams/pane_change_stream.dart';

typedef OnMove = void Function(FlowViewport viewport, DragDetails? details);
typedef OnMoveStart = void Function(
    FlowViewport viewport, DragDetails? details);
typedef OnMoveEnd = void Function(FlowViewport viewport, DragDetails? details);
typedef OnPaneClick = void Function(TapDownDetails details);
typedef OnPaneContextMenu = void Function(LongPressStartDetails details);
typedef OnPaneScroll = void Function(PointerScrollEvent event);
typedef OnPaneMouseMove = void Function(PointerHoverEvent event);
typedef OnPaneMouseEnter = void Function(PointerEnterEvent event);
typedef OnPaneMouseLeave = void Function(PointerExitEvent event);

@immutable
class PaneCallbacks {
  final OnMove onMove;
  final OnMoveStart onMoveStart;
  final OnMoveEnd onMoveEnd;
  final OnPaneClick onPaneClick;
  final OnPaneContextMenu onPaneContextMenu;
  final OnPaneScroll onPaneScroll;
  final OnPaneMouseMove onPaneMouseMove;
  final OnPaneMouseEnter onPaneMouseEnter;
  final OnPaneMouseLeave onPaneMouseLeave;
  final PaneStreams? streams;

  const PaneCallbacks({
    this.onMove = _defaultOnMove,
    this.onMoveStart = _defaultOnMoveStart,
    this.onMoveEnd = _defaultOnMoveEnd,
    this.onPaneClick = _defaultOnPaneClick,
    this.onPaneContextMenu = _defaultOnPaneContextMenu,
    this.onPaneScroll = _defaultOnPaneScroll,
    this.onPaneMouseMove = _defaultOnPaneMouseMove,
    this.onPaneMouseEnter = _defaultOnPaneMouseEnter,
    this.onPaneMouseLeave = _defaultOnPaneMouseLeave,
    this.streams,
  });

  // Default implementations (do nothing)
  static void _defaultOnMove(FlowViewport viewport, DragDetails? details) {}
  static void _defaultOnMoveStart(
      FlowViewport viewport, DragDetails? details) {}
  static void _defaultOnMoveEnd(FlowViewport viewport, DragDetails? details) {}
  static void _defaultOnPaneClick(TapDownDetails details) {}
  static void _defaultOnPaneContextMenu(LongPressStartDetails details) {}
  static void _defaultOnPaneScroll(PointerScrollEvent event) {}
  static void _defaultOnPaneMouseMove(PointerHoverEvent event) {}
  static void _defaultOnPaneMouseEnter(PointerEnterEvent event) {}
  static void _defaultOnPaneMouseLeave(PointerExitEvent event) {}

  PaneCallbacks copyWith({
    OnMove? onMove,
    OnMoveStart? onMoveStart,
    OnMoveEnd? onMoveEnd,
    OnPaneClick? onPaneClick,
    OnPaneContextMenu? onPaneContextMenu,
    OnPaneScroll? onPaneScroll,
    OnPaneMouseMove? onPaneMouseMove,
    OnPaneMouseEnter? onPaneMouseEnter,
    OnPaneMouseLeave? onPaneMouseLeave,
    PaneStreams? streams,
  }) {
    return PaneCallbacks(
      onMove: onMove ?? this.onMove,
      onMoveStart: onMoveStart ?? this.onMoveStart,
      onMoveEnd: onMoveEnd ?? this.onMoveEnd,
      onPaneClick: onPaneClick ?? this.onPaneClick,
      onPaneContextMenu: onPaneContextMenu ?? this.onPaneContextMenu,
      onPaneScroll: onPaneScroll ?? this.onPaneScroll,
      onPaneMouseMove: onPaneMouseMove ?? this.onPaneMouseMove,
      onPaneMouseEnter: onPaneMouseEnter ?? this.onPaneMouseEnter,
      onPaneMouseLeave: onPaneMouseLeave ?? this.onPaneMouseLeave,
      streams: streams ?? this.streams,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaneCallbacks &&
        other.onMove == onMove &&
        other.onMoveStart == onMoveStart &&
        other.onMoveEnd == onMoveEnd &&
        other.onPaneClick == onPaneClick &&
        other.onPaneContextMenu == onPaneContextMenu &&
        other.onPaneScroll == onPaneScroll &&
        other.onPaneMouseMove == onPaneMouseMove &&
        other.onPaneMouseEnter == onPaneMouseEnter &&
        other.onPaneMouseLeave == onPaneMouseLeave &&
        other.streams == streams;
  }

  @override
  int get hashCode {
    return Object.hash(
      onMove,
      onMoveStart,
      onMoveEnd,
      onPaneClick,
      onPaneContextMenu,
      onPaneScroll,
      onPaneMouseMove,
      onPaneMouseEnter,
      onPaneMouseLeave,
      streams,
    );
  }
}

class DragDetails {
  final DragMode dragMode;
  final Offset localPosition;
  final Offset globalPosition;
  final Offset delta;

  const DragDetails({
    required this.dragMode,
    required this.localPosition,
    required this.globalPosition,
    required this.delta,
  });

  @override
  String toString() {
    return 'DragDetails{dragMode: $dragMode, localPosition: $localPosition, globalPosition: $globalPosition, delta: $delta}';
  }
}

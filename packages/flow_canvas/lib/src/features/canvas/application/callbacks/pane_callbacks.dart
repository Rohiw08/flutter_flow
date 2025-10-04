import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import '../../../../shared/enums.dart';
import '../streams/pane_change_stream.dart';

typedef PaneMoveCallback = void Function(
  FlowViewport viewport,
  DragDetails? details,
);
typedef PaneMoveStartCallback = void Function(
  FlowViewport viewport,
  DragDetails? details,
);
typedef PaneMoveEndCallback = void Function(
  FlowViewport viewport,
  DragDetails? details,
);
typedef PaneTapCallback = void Function(TapDownDetails details);
typedef PaneContextMenuCallback = void Function(LongPressStartDetails details);
typedef PaneScrollCallback = void Function(PointerScrollEvent event);
// UPDATED: Standardized to PointerEvent for consistency
typedef PaneMouseMoveCallback = void Function(PointerEvent event);
typedef PaneMouseEnterCallback = void Function(PointerEvent event);
typedef PaneMouseLeaveCallback = void Function(PointerEvent event);

@immutable
class PaneCallbacks {
  final PaneMoveCallback onMove;
  final PaneMoveStartCallback onMoveStart;
  final PaneMoveEndCallback onMoveEnd;
  final PaneTapCallback onTap;
  final PaneContextMenuCallback onContextMenu;
  final PaneScrollCallback onScroll;
  final PaneMouseMoveCallback onMouseMove;
  final PaneMouseEnterCallback onMouseEnter;
  final PaneMouseLeaveCallback onMouseLeave;
  final PaneStreams? streams;

  const PaneCallbacks({
    this.onMove = _defaultOnMove,
    this.onMoveStart = _defaultOnMoveStart,
    this.onMoveEnd = _defaultOnMoveEnd,
    this.onTap = _defaultOnTap,
    this.onContextMenu = _defaultOnContextMenu,
    this.onScroll = _defaultOnScroll,
    this.onMouseMove = _defaultOnMouseMove,
    this.onMouseEnter = _defaultOnMouseEnter,
    this.onMouseLeave = _defaultOnMouseLeave,
    this.streams,
  });

  // ---- Default no-op implementations ----
  static void _defaultOnMove(FlowViewport viewport, DragDetails? details) {}
  static void _defaultOnMoveStart(
      FlowViewport viewport, DragDetails? details) {}
  static void _defaultOnMoveEnd(FlowViewport viewport, DragDetails? details) {}
  static void _defaultOnTap(TapDownDetails details) {}
  static void _defaultOnContextMenu(LongPressStartDetails details) {}
  static void _defaultOnScroll(PointerScrollEvent event) {}
  // UPDATED: Standardized to PointerEvent
  static void _defaultOnMouseMove(PointerEvent event) {}
  static void _defaultOnMouseEnter(PointerEvent event) {}
  static void _defaultOnMouseLeave(PointerEvent event) {}

  PaneCallbacks copyWith({
    PaneMoveCallback? onMove,
    PaneMoveStartCallback? onMoveStart,
    PaneMoveEndCallback? onMoveEnd,
    PaneTapCallback? onTap,
    PaneContextMenuCallback? onContextMenu,
    PaneScrollCallback? onScroll,
    PaneMouseMoveCallback? onMouseMove,
    PaneMouseEnterCallback? onMouseEnter,
    PaneMouseLeaveCallback? onMouseLeave,
    PaneStreams? streams,
  }) {
    return PaneCallbacks(
      onMove: onMove ?? this.onMove,
      onMoveStart: onMoveStart ?? this.onMoveStart,
      onMoveEnd: onMoveEnd ?? this.onMoveEnd,
      onTap: onTap ?? this.onTap,
      onContextMenu: onContextMenu ?? this.onContextMenu,
      onScroll: onScroll ?? this.onScroll,
      onMouseMove: onMouseMove ?? this.onMouseMove,
      onMouseEnter: onMouseEnter ?? this.onMouseEnter,
      onMouseLeave: onMouseLeave ?? this.onMouseLeave,
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
        other.onTap == onTap &&
        other.onContextMenu == onContextMenu &&
        other.onScroll == onScroll &&
        other.onMouseMove == onMouseMove &&
        other.onMouseEnter == onMouseEnter &&
        other.onMouseLeave == onMouseLeave &&
        other.streams == streams;
  }

  @override
  int get hashCode => Object.hash(
        onMove,
        onMoveStart,
        onMoveEnd,
        onTap,
        onContextMenu,
        onScroll,
        onMouseMove,
        onMouseEnter,
        onMouseLeave,
        streams,
      );
}

/// Details for a viewport drag/pan gesture.
class DragDetails {
  final DragMode dragMode;
  final Offset localPosition;
  final Offset globalPosition;
  final Offset delta;
  final Offset canvasPosition;

  const DragDetails({
    required this.dragMode,
    required this.localPosition,
    required this.globalPosition,
    required this.delta,
    required this.canvasPosition,
  });

  @override
  String toString() =>
      'DragDetails(dragMode: $dragMode, local: $localPosition, '
      'global: $globalPosition, delta: $delta, canvas: $canvasPosition)';
}

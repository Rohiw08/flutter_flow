import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import '../../../../shared/enums.dart';
import '../streams/pane_change_stream.dart';

/// Called when the viewport is moved (panned or zoomed).
typedef PaneMoveCallback = void Function(
  FlowViewport viewport,
  DragDetails? details,
);

/// Called when a viewport move gesture starts.
typedef PaneMoveStartCallback = void Function(
  FlowViewport viewport,
  DragDetails? details,
);

/// Called when a viewport move gesture ends.
typedef PaneMoveEndCallback = void Function(
  FlowViewport viewport,
  DragDetails? details,
);

/// Called when the user taps the empty pane area.
typedef PaneTapCallback = void Function(TapDownDetails details);

/// Called when the user opens a context menu (long-press) on the pane.
typedef PaneContextMenuCallback = void Function(LongPressStartDetails details);

/// Called when the user scrolls inside the pane (e.g., for zoom).
typedef PaneScrollCallback = void Function(PointerScrollEvent event);

/// Called when the mouse moves over the pane.
typedef PaneMouseMoveCallback = void Function(PointerHoverEvent event);

/// Called when the mouse enters the pane.
typedef PaneMouseEnterCallback = void Function(PointerEnterEvent event);

/// Called when the mouse leaves the pane.
typedef PaneMouseLeaveCallback = void Function(PointerExitEvent event);

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
  static void _defaultOnMouseMove(PointerHoverEvent event) {}
  static void _defaultOnMouseEnter(PointerEnterEvent event) {}
  static void _defaultOnMouseLeave(PointerExitEvent event) {}

  /// Returns a copy with selectively overridden callbacks/streams.
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

  const DragDetails({
    required this.dragMode,
    required this.localPosition,
    required this.globalPosition,
    required this.delta,
  });

  @override
  String toString() =>
      'DragDetails(dragMode: $dragMode, local: $localPosition, '
      'global: $globalPosition, delta: $delta)';
}

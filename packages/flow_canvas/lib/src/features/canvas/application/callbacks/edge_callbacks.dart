import 'package:flutter/material.dart';
import '../streams/edge_change_stream.dart';
import '../streams/edges_flow_state_change_stream.dart';
import '../events/edges_flow_state_chnage_event.dart';

/// --- Interaction Callbacks ---
typedef EdgeClickCallback = void Function(
    String edgeId, TapDownDetails details);
typedef EdgeDoubleClickCallback = void Function(String edgeId);
typedef EdgeMouseEnterCallback = void Function(
    String edgeId, PointerEvent event);
typedef EdgeMouseMoveCallback = void Function(
    String edgeId, PointerEvent event);
typedef EdgeMouseLeaveCallback = void Function(
    String edgeId, PointerEvent event);
typedef EdgeContextMenuCallback = void Function(
    String edgeId, LongPressStartDetails details);

@immutable
class EdgeInteractionCallbacks {
  final EdgeClickCallback onClick;
  final EdgeDoubleClickCallback onDoubleClick;
  final EdgeMouseEnterCallback onMouseEnter;
  final EdgeMouseMoveCallback onMouseMove;
  final EdgeMouseLeaveCallback onMouseLeave;
  final EdgeContextMenuCallback onContextMenu;
  final EdgeInteractionStreams? streams;

  const EdgeInteractionCallbacks({
    this.onClick = _defaultOnClick,
    this.onDoubleClick = _defaultOnDoubleClick,
    this.onMouseEnter = _defaultOnMouseEnter,
    this.onMouseMove = _defaultOnMouseMove,
    this.onMouseLeave = _defaultOnMouseLeave,
    this.onContextMenu = _defaultOnContextMenu,
    this.streams,
  });

  static void _defaultOnClick(String edgeId, TapDownDetails details) {}
  static void _defaultOnDoubleClick(String edgeId) {}
  static void _defaultOnMouseEnter(String edgeId, PointerEvent event) {}
  static void _defaultOnMouseMove(String edgeId, PointerEvent event) {}
  static void _defaultOnMouseLeave(String edgeId, PointerEvent event) {}
  static void _defaultOnContextMenu(
      String edgeId, LongPressStartDetails details) {}

  EdgeInteractionCallbacks copyWith({
    EdgeClickCallback? onClick,
    EdgeDoubleClickCallback? onDoubleClick,
    EdgeMouseEnterCallback? onMouseEnter,
    EdgeMouseMoveCallback? onMouseMove,
    EdgeMouseLeaveCallback? onMouseLeave,
    EdgeContextMenuCallback? onContextMenu,
    EdgeInteractionStreams? streams,
  }) {
    return EdgeInteractionCallbacks(
      onClick: onClick ?? this.onClick,
      onDoubleClick: onDoubleClick ?? this.onDoubleClick,
      onMouseEnter: onMouseEnter ?? this.onMouseEnter,
      onMouseMove: onMouseMove ?? this.onMouseMove,
      onMouseLeave: onMouseLeave ?? this.onMouseLeave,
      onContextMenu: onContextMenu ?? this.onContextMenu,
      streams: streams ?? this.streams,
    );
  }
}

/// --- Edge State Change Callbacks ---
typedef EdgeAddCallback = void Function(EdgeLifecycleEvent event);
typedef EdgeUpdateCallback = void Function(EdgeLifecycleEvent event);
typedef EdgeRemoveCallback = void Function(EdgeLifecycleEvent event);
typedef EdgeReconnectCallback = void Function(EdgeLifecycleEvent event);

@immutable
class EdgeStateCallbacks {
  final EdgeAddCallback onEdgeAdd;
  final EdgeUpdateCallback onEdgeUpdate;
  final EdgeRemoveCallback onEdgeRemove;
  final EdgeReconnectCallback onEdgeReconnect;
  final EdgesStateStreams? streams;

  const EdgeStateCallbacks({
    this.onEdgeAdd = _defaultOnEdgeAdd,
    this.onEdgeUpdate = _defaultOnEdgeUpdate,
    this.onEdgeRemove = _defaultOnEdgeRemove,
    this.onEdgeReconnect = _defaultOnEdgeReconnect,
    this.streams,
  });

  static void _defaultOnEdgeAdd(EdgeLifecycleEvent event) {}
  static void _defaultOnEdgeUpdate(EdgeLifecycleEvent event) {}
  static void _defaultOnEdgeRemove(EdgeLifecycleEvent event) {}
  static void _defaultOnEdgeReconnect(EdgeLifecycleEvent event) {}

  EdgeStateCallbacks copyWith({
    EdgeAddCallback? onEdgeAdd,
    EdgeUpdateCallback? onEdgeUpdate,
    EdgeRemoveCallback? onEdgeRemove,
    EdgeReconnectCallback? onEdgeReconnect,
    EdgesStateStreams? streams,
  }) {
    return EdgeStateCallbacks(
      onEdgeAdd: onEdgeAdd ?? this.onEdgeAdd,
      onEdgeUpdate: onEdgeUpdate ?? this.onEdgeUpdate,
      onEdgeRemove: onEdgeRemove ?? this.onEdgeRemove,
      onEdgeReconnect: onEdgeReconnect ?? this.onEdgeReconnect,
      streams: streams ?? this.streams,
    );
  }
}

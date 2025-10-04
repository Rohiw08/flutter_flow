import 'package:flutter/material.dart';
import '../streams/node_change_stream.dart';
import '../streams/nodes_flow_state_change_stream.dart';
import '../events/nodes_flow_state_change_event.dart';

/// --- Interaction Callbacks ---
typedef NodeClickCallback = void Function(
    String nodeId, TapDownDetails details);
typedef NodeDoubleClickCallback = void Function(String nodeId);
typedef NodeDragStartCallback = void Function(
    String nodeId, DragStartDetails details);
typedef NodeDragCallback = void Function(
    String nodeId, DragUpdateDetails details);
typedef NodeDragStopCallback = void Function(
    String nodeId, DragEndDetails details);
typedef NodeMouseEnterCallback = void Function(
    String nodeId, PointerEvent event);
typedef NodeMouseMoveCallback = void Function(
    String nodeId, PointerEvent event);
typedef NodeMouseLeaveCallback = void Function(
    String nodeId, PointerEvent event);
typedef NodeContextMenuCallback = void Function(
    String nodeId, LongPressStartDetails details);

@immutable
class NodeInteractionCallbacks {
  final NodeClickCallback onClick;
  final NodeDoubleClickCallback onDoubleClick;
  final NodeDragStartCallback onDragStart;
  final NodeDragCallback onDrag;
  final NodeDragStopCallback onDragStop;
  final NodeMouseEnterCallback onMouseEnter;
  final NodeMouseMoveCallback onMouseMove;
  final NodeMouseLeaveCallback onMouseLeave;
  final NodeContextMenuCallback onContextMenu;
  final NodeInteractionStreams? streams;

  const NodeInteractionCallbacks({
    this.onClick = _defaultOnClick,
    this.onDoubleClick = _defaultOnDoubleClick,
    this.onDragStart = _defaultOnDragStart,
    this.onDrag = _defaultOnDrag,
    this.onDragStop = _defaultOnDragStop,
    this.onMouseEnter = _defaultOnMouseEnter,
    this.onMouseMove = _defaultOnMouseMove,
    this.onMouseLeave = _defaultOnMouseLeave,
    this.onContextMenu = _defaultOnContextMenu,
    this.streams,
  });

  static void _defaultOnClick(String nodeId, TapDownDetails details) {}
  static void _defaultOnDoubleClick(String nodeId) {}
  static void _defaultOnDragStart(String nodeId, DragStartDetails details) {}
  static void _defaultOnDrag(String nodeId, DragUpdateDetails details) {}
  static void _defaultOnDragStop(String nodeId, DragEndDetails details) {}
  static void _defaultOnMouseEnter(String nodeId, PointerEvent event) {}
  static void _defaultOnMouseMove(String nodeId, PointerEvent event) {}
  static void _defaultOnMouseLeave(String nodeId, PointerEvent event) {}
  static void _defaultOnContextMenu(
      String nodeId, LongPressStartDetails details) {}

  NodeInteractionCallbacks copyWith({
    NodeClickCallback? onClick,
    NodeDoubleClickCallback? onDoubleClick,
    NodeDragStartCallback? onDragStart,
    NodeDragCallback? onDrag,
    NodeDragStopCallback? onDragStop,
    NodeMouseEnterCallback? onMouseEnter,
    NodeMouseMoveCallback? onMouseMove,
    NodeMouseLeaveCallback? onMouseLeave,
    NodeContextMenuCallback? onContextMenu,
    NodeInteractionStreams? streams,
  }) {
    return NodeInteractionCallbacks(
      onClick: onClick ?? this.onClick,
      onDoubleClick: onDoubleClick ?? this.onDoubleClick,
      onDragStart: onDragStart ?? this.onDragStart,
      onDrag: onDrag ?? this.onDrag,
      onDragStop: onDragStop ?? this.onDragStop,
      onMouseEnter: onMouseEnter ?? this.onMouseEnter,
      onMouseMove: onMouseMove ?? this.onMouseMove,
      onMouseLeave: onMouseLeave ?? this.onMouseLeave,
      onContextMenu: onContextMenu ?? this.onContextMenu,
      streams: streams ?? this.streams,
    );
  }
}

/// --- Node State Change Callbacks ---
typedef NodeAddCallback = void Function(NodeLifecycleEvent event);
typedef NodeUpdateCallback = void Function(NodeLifecycleEvent event);
typedef NodeRemoveCallback = void Function(NodeLifecycleEvent event);

@immutable
class NodeStateCallbacks {
  final NodeAddCallback onNodeAdd;
  final NodeUpdateCallback onNodeUpdate;
  final NodeRemoveCallback onNodeRemove;
  final NodesStateStreams? streams;

  const NodeStateCallbacks({
    this.onNodeAdd = _defaultOnNodeAdd,
    this.onNodeUpdate = _defaultOnNodeUpdate,
    this.onNodeRemove = _defaultOnNodeRemove,
    this.streams,
  });

  static void _defaultOnNodeAdd(NodeLifecycleEvent event) {}
  static void _defaultOnNodeUpdate(NodeLifecycleEvent event) {}
  static void _defaultOnNodeRemove(NodeLifecycleEvent event) {}

  NodeStateCallbacks copyWith({
    NodeAddCallback? onNodeAdd,
    NodeUpdateCallback? onNodeUpdate,
    NodeRemoveCallback? onNodeRemove,
    NodesStateStreams? streams,
  }) {
    return NodeStateCallbacks(
      onNodeAdd: onNodeAdd ?? this.onNodeAdd,
      onNodeUpdate: onNodeUpdate ?? this.onNodeUpdate,
      onNodeRemove: onNodeRemove ?? this.onNodeRemove,
      streams: streams ?? this.streams,
    );
  }
}

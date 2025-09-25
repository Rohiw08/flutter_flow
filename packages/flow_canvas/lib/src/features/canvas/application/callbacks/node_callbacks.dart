import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/node_change_stream.dart';
import '../events/node_change_event.dart';

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
    String nodeId, PointerEnterEvent event);
typedef NodeMouseMoveCallback = void Function(
    String nodeId, PointerHoverEvent event);
typedef NodeMouseLeaveCallback = void Function(
    String nodeId, PointerExitEvent event);
typedef NodeContextMenuCallback = void Function(
    String nodeId, LongPressStartDetails details);
typedef NodesDeleteCallback = void Function(List<String> nodeIds);
typedef NodesChangeCallback = void Function(List<NodeChangeEvent> changes);

@immutable
class NodeCallbacks {
  final NodeClickCallback onClick;
  final NodeDoubleClickCallback onDoubleClick;
  final NodeDragStartCallback onDragStart;
  final NodeDragCallback onDrag;
  final NodeDragStopCallback onDragStop;
  final NodeMouseEnterCallback onMouseEnter;
  final NodeMouseMoveCallback onMouseMove;
  final NodeMouseLeaveCallback onMouseLeave;
  final NodeContextMenuCallback onContextMenu;
  final NodesDeleteCallback onNodesDelete;
  final NodesChangeCallback onNodesChange;
  final NodeStreams? streams;

  const NodeCallbacks({
    this.onClick = _defaultOnClick,
    this.onDoubleClick = _defaultOnDoubleClick,
    this.onDragStart = _defaultOnDragStart,
    this.onDrag = _defaultOnDrag,
    this.onDragStop = _defaultOnDragStop,
    this.onMouseEnter = _defaultOnMouseEnter,
    this.onMouseMove = _defaultOnMouseMove,
    this.onMouseLeave = _defaultOnMouseLeave,
    this.onContextMenu = _defaultOnContextMenu,
    this.onNodesDelete = _defaultOnNodesDelete,
    this.onNodesChange = _defaultOnNodesChange,
    this.streams,
  });

  // Default implementations (do nothing)
  static void _defaultOnClick(String nodeId, TapDownDetails details) {}
  static void _defaultOnDoubleClick(String nodeId) {}
  static void _defaultOnDragStart(String nodeId, DragStartDetails details) {}
  static void _defaultOnDrag(String nodeId, DragUpdateDetails details) {}
  static void _defaultOnDragStop(String nodeId, DragEndDetails details) {}
  static void _defaultOnMouseEnter(String nodeId, PointerEnterEvent event) {}
  static void _defaultOnMouseMove(String nodeId, PointerHoverEvent event) {}
  static void _defaultOnMouseLeave(String nodeId, PointerExitEvent event) {}
  static void _defaultOnContextMenu(
      String nodeId, LongPressStartDetails details) {}
  static void _defaultOnNodesDelete(List<String> nodeIds) {}
  static void _defaultOnNodesChange(List<NodeChangeEvent> changes) {}

  NodeCallbacks copyWith({
    NodeClickCallback? onClick,
    NodeDoubleClickCallback? onDoubleClick,
    NodeDragStartCallback? onDragStart,
    NodeDragCallback? onDrag,
    NodeDragStopCallback? onDragStop,
    NodeMouseEnterCallback? onMouseEnter,
    NodeMouseMoveCallback? onMouseMove,
    NodeMouseLeaveCallback? onMouseLeave,
    NodeContextMenuCallback? onContextMenu,
    NodesDeleteCallback? onNodesDelete,
    NodesChangeCallback? onNodesChange,
    NodeStreams? streams,
  }) {
    return NodeCallbacks(
      onClick: onClick ?? this.onClick,
      onDoubleClick: onDoubleClick ?? this.onDoubleClick,
      onDragStart: onDragStart ?? this.onDragStart,
      onDrag: onDrag ?? this.onDrag,
      onDragStop: onDragStop ?? this.onDragStop,
      onMouseEnter: onMouseEnter ?? this.onMouseEnter,
      onMouseMove: onMouseMove ?? this.onMouseMove,
      onMouseLeave: onMouseLeave ?? this.onMouseLeave,
      onContextMenu: onContextMenu ?? this.onContextMenu,
      onNodesDelete: onNodesDelete ?? this.onNodesDelete,
      onNodesChange: onNodesChange ?? this.onNodesChange,
      streams: streams ?? this.streams,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NodeCallbacks &&
        other.onClick == onClick &&
        other.onDoubleClick == onDoubleClick &&
        other.onDragStart == onDragStart &&
        other.onDrag == onDrag &&
        other.onDragStop == onDragStop &&
        other.onMouseEnter == onMouseEnter &&
        other.onMouseMove == onMouseMove &&
        other.onMouseLeave == onMouseLeave &&
        other.onContextMenu == onContextMenu &&
        other.onNodesDelete == onNodesDelete &&
        other.onNodesChange == onNodesChange &&
        other.streams == streams;
  }

  @override
  int get hashCode {
    return Object.hash(
      onClick,
      onDoubleClick,
      onDragStart,
      onDrag,
      onDragStop,
      onMouseEnter,
      onMouseMove,
      onMouseLeave,
      onContextMenu,
      onNodesDelete,
      onNodesChange,
      streams,
    );
  }
}

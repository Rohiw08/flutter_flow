import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../events/edge_change_event.dart';
import '../streams/edge_change_stream.dart';

typedef EdgeClickCallback = void Function(
    String edgeId, TapDownDetails details);
typedef EdgeDoubleClickCallback = void Function(String edgeId);
typedef EdgeMouseEnterCallback = void Function(
    String edgeId, PointerEnterEvent event);
typedef EdgeMouseMoveCallback = void Function(
    String edgeId, PointerHoverEvent event);
typedef EdgeMouseLeaveCallback = void Function(
    String edgeId, PointerExitEvent event);
typedef EdgeContextMenuCallback = void Function(
    String edgeId, LongPressStartDetails details);
typedef EdgesDeleteCallback = void Function(List<String> edgeIds);
typedef EdgesChangeCallback = void Function(List<EdgeChangeEvent> changes);

@immutable
class EdgeCallbacks {
  final EdgeClickCallback onClick;
  final EdgeDoubleClickCallback onDoubleClick;
  final EdgeMouseEnterCallback onMouseEnter;
  final EdgeMouseMoveCallback onMouseMove;
  final EdgeMouseLeaveCallback onMouseLeave;
  final EdgeContextMenuCallback onContextMenu;
  final EdgesDeleteCallback onEdgesDelete;
  final EdgesChangeCallback onEdgesChange;
  final EdgeStreams? streams;

  const EdgeCallbacks({
    this.onClick = _defaultOnClick,
    this.onDoubleClick = _defaultOnDoubleClick,
    this.onMouseEnter = _defaultOnMouseEnter,
    this.onMouseMove = _defaultOnMouseMove,
    this.onMouseLeave = _defaultOnMouseLeave,
    this.onContextMenu = _defaultOnContextMenu,
    this.onEdgesDelete = _defaultOnEdgesDelete,
    this.onEdgesChange = _defaultOnEdgesChange,
    this.streams,
  });

  // Default implementations (do nothing)
  static void _defaultOnClick(String edgeId, TapDownDetails details) {}
  static void _defaultOnDoubleClick(String edgeId) {}
  static void _defaultOnMouseEnter(String edgeId, PointerEnterEvent event) {}
  static void _defaultOnMouseMove(String edgeId, PointerHoverEvent event) {}
  static void _defaultOnMouseLeave(String edgeId, PointerExitEvent event) {}
  static void _defaultOnContextMenu(
      String edgeId, LongPressStartDetails details) {}
  static void _defaultOnEdgesDelete(List<String> edgeIds) {}
  static void _defaultOnEdgesChange(List<EdgeChangeEvent> changes) {}

  EdgeCallbacks copyWith({
    EdgeClickCallback? onClick,
    EdgeDoubleClickCallback? onDoubleClick,
    EdgeMouseEnterCallback? onMouseEnter,
    EdgeMouseMoveCallback? onMouseMove,
    EdgeMouseLeaveCallback? onMouseLeave,
    EdgeContextMenuCallback? onContextMenu,
    EdgesDeleteCallback? onEdgesDelete,
    EdgesChangeCallback? onEdgesChange,
    EdgeStreams? streams,
  }) {
    return EdgeCallbacks(
      onClick: onClick ?? this.onClick,
      onDoubleClick: onDoubleClick ?? this.onDoubleClick,
      onMouseEnter: onMouseEnter ?? this.onMouseEnter,
      onMouseMove: onMouseMove ?? this.onMouseMove,
      onMouseLeave: onMouseLeave ?? this.onMouseLeave,
      onContextMenu: onContextMenu ?? this.onContextMenu,
      onEdgesDelete: onEdgesDelete ?? this.onEdgesDelete,
      onEdgesChange: onEdgesChange ?? this.onEdgesChange,
      streams: streams ?? this.streams,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EdgeCallbacks &&
        other.onClick == onClick &&
        other.onDoubleClick == onDoubleClick &&
        other.onMouseEnter == onMouseEnter &&
        other.onMouseMove == onMouseMove &&
        other.onMouseLeave == onMouseLeave &&
        other.onContextMenu == onContextMenu &&
        other.onEdgesDelete == onEdgesDelete &&
        other.onEdgesChange == onEdgesChange &&
        other.streams == streams;
  }

  @override
  int get hashCode {
    return Object.hash(
      onClick,
      onDoubleClick,
      onMouseEnter,
      onMouseMove,
      onMouseLeave,
      onContextMenu,
      onEdgesDelete,
      onEdgesChange,
      streams,
    );
  }
}

import 'package:flow_canvas/src/features/canvas/presentation/options/options_extensions.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_label_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edge.freezed.dart';

/// Represents a connection (an edge) between two nodes in the flow canvas.
///
/// An edge connects a source node to a target node, optionally through specific
/// handles on those nodes. Edges can be customized with labels, markers, and
/// various interaction behaviors.
///
/// Example:
/// ```dart
/// final edge = FlowEdge(
///   id: 'edge-1',
///   sourceNodeId: 'node-1',
///   targetNodeId: 'node-2',
///   sourceHandleId: 'output-1',
///   targetHandleId: 'input-1',
///   pathType: EdgePathType.bezier,
///   label: Text('Connection'),
///   endMarkerStyle: FlowEdgeMarkerStyle.arrow(),
/// );
/// ```
@freezed
abstract class FlowEdge with _$FlowEdge {
  const FlowEdge._();

  @Assert('sourceNodeId != targetNodeId',
      'Source and target cannot be the same node')
  const factory FlowEdge({
    /// Unique identifier for this edge.
    required String id,

    /// ID of the source node this edge originates from.
    required String sourceNodeId,

    /// ID of the target node this edge points to.
    required String targetNodeId,

    /// Optional handle ID on the source node where the edge connects.
    /// If null, the edge connects to the node's center or default position.
    String? sourceHandleId,

    /// Optional handle ID on the target node where the edge connects.
    /// If null, the edge connects to the node's center or default position.
    String? targetHandleId,

    /// Z-index for layering edges. Higher values render on top.
    @Default(0) int zIndex,

    /// The path rendering algorithm for this edge.
    @Default(EdgePathType.bezier) EdgePathType pathType,

    /// Width of the invisible interaction area around the edge for easier selection.
    /// Makes thin edges easier to click/hover.
    @Default(10.0) double interactionWidth,

    /// Optional widget to display as a label on the edge.
    Widget? label,

    /// Optional decoration for the label container.
    /// If null, uses a default decoration or no decoration.
    FlowEdgeLabelStyle? labelDecoration,

    /// Optional custom marker style for the start of the edge.
    /// Overrides the theme's start marker style.
    FlowEdgeMarkerStyle? startMarkerStyle,

    /// Optional custom marker style for the end of the edge.
    /// Overrides the theme's end marker style.
    FlowEdgeMarkerStyle? endMarkerStyle,

    /// Optional custom style for this edge.
    /// If null, uses the style from the current theme.
    FlowEdgeStyle? style,

    /// Custom data that can be attached to this edge.
    /// Useful for storing application-specific metadata.
    @Default(<String, dynamic>{}) Map<String, dynamic> data,

    /// Whether this edge should be animated (e.g., flowing dots).
    /// If null, uses the global canvas setting.
    bool? animated,

    /// Whether this edge should be hidden from view.
    /// Hidden edges are not rendered but remain in the data structure.
    bool? hidden,

    /// Whether this edge can be deleted by the user.
    /// If null, uses the global canvas setting.
    bool? deletable,

    /// Whether this edge can be selected by the user.
    /// If null, uses the global canvas setting.
    bool? selectable,

    /// Whether this edge can receive keyboard focus.
    /// If null, uses the global canvas setting.
    bool? focusable,

    /// Whether this edge's connections can be changed by dragging.
    /// If null, uses the global canvas setting.
    bool? reconnectable,

    /// Whether this edge should be elevated (z-index increased) when selected.
    /// If null, uses the global canvas setting.
    bool? elevateEdgeOnSelect,
  }) = _FlowEdge;

  /// Checks if this edge is connected to the specified node.
  ///
  /// Returns true if [nodeId] matches either the source or target node.
  bool isConnectedToNode(String nodeId) =>
      sourceNodeId == nodeId || targetNodeId == nodeId;

  /// Checks if this edge connects between the two specified nodes in either direction.
  ///
  /// Returns true if the edge connects [nodeId1] to [nodeId2] or vice versa.
  bool connectsNodes(String nodeId1, String nodeId2) =>
      (sourceNodeId == nodeId1 && targetNodeId == nodeId2) ||
      (sourceNodeId == nodeId2 && targetNodeId == nodeId1);

  /// Checks if this edge is connected to the specified handle.
  ///
  /// Returns true if [handleId] matches either the source or target handle.
  bool isConnectedToHandle(String handleId) =>
      sourceHandleId == handleId || targetHandleId == handleId;

  /// Returns the ID of the node at the opposite end from [nodeId].
  ///
  /// Returns null if [nodeId] is not connected to this edge.
  String? getOppositeNodeId(String nodeId) {
    if (sourceNodeId == nodeId) return targetNodeId;
    if (targetNodeId == nodeId) return sourceNodeId;
    return null;
  }

  /// Checks if this edge is a self-loop (both ends connect to the same node).
  ///
  /// Note: This should not occur due to the assertion in the constructor,
  /// but is provided for completeness.
  bool get isSelfLoop => sourceNodeId == targetNodeId;

  bool isSelectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return selectable ?? globalOptions.selectable;
  }

  bool isDeletable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return deletable ?? globalOptions.deletable;
  }

  bool isAnimated(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return animated ?? globalOptions.animated;
  }

  bool isHidden(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return hidden ?? globalOptions.hidden;
  }

  bool isReconnectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return reconnectable ?? globalOptions.reconnectable;
  }

  bool elevateOnSelect(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return elevateEdgeOnSelect ?? globalOptions.elevateEdgeOnSelect;
  }

  bool isFocusable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return focusable ?? globalOptions.focusable;
  }
}

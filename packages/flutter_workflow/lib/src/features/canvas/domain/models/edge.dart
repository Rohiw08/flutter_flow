import 'package:flutter/widgets.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/theme/components/edge_marker_theme.dart';
import 'package:flutter_workflow/src/theme/components/edge_theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edge.freezed.dart';

/// Represents a connection (an edge) between two nodes.
@freezed
abstract class FlowEdge with _$FlowEdge {
  const FlowEdge._();

  @Assert('sourceNodeId != targetNodeId',
      'Source and target cannot be the same node')
  const factory FlowEdge({
    required String id,
    required String sourceNodeId,
    required String targetNodeId,
    required String? sourceHandleId,
    required String? targetHandleId,
    @Default(0) int zIndex,
    @Default(EdgePathType.bezier) EdgePathType pathType,
    @Default(10.0) double interactionWidth,
    Widget? label,
    BoxDecoration? labelDecoration,
    EdgeMarkerStyle? startMarkerStyle,
    EdgeMarkerStyle? endMarkerStyle,
    FlowEdgeStyle? style,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
    bool? animated,
    bool? hidden,
    bool? deletable,
    bool? selectable,
    bool? focusable,
    bool? reconnectable,
    bool? elevateEdgeOnSelected,
  }) = _FlowEdge;

  /// convenience method
  bool isEdgeConnectedTo(String nodeId) =>
      sourceNodeId == nodeId || targetNodeId == nodeId;
}

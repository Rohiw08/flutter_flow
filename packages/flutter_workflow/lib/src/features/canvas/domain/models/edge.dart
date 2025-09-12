import 'package:flutter/widgets.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/theme/components/edge_marker_theme.dart';
import 'package:flutter_workflow/src/theme/components/edge_theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:built_collection/built_collection.dart';

part 'edge.freezed.dart';

/// Represents a connection (an edge) between two nodes.
@freezed
abstract class FlowEdge with _$FlowEdge {
  const FlowEdge._();

  @Assert('sourceNodeId != targetNodeId',
      'Source and target cannot be the same node')
  const factory FlowEdge({
    // Core identifiers
    required String id,
    required String sourceNodeId,
    required String targetNodeId,
    required String? sourceHandleId,
    required String? targetHandleId,
    required BuiltMap<String, dynamic> internalData,

    // Rendering
    @Default(EdgePathType.bezier) EdgePathType pathType,
    @Default(false) bool animated,
    @Default(false) bool hidden,
    @Default(true) bool deletable,
    @Default(true) bool selectable,
    @Default(false) bool selected,
    @Default(0) int zIndex,

    // Interaction
    bool? focusable,
    @Default(true) bool reconnectable,
    @Default(10.0) double interactionWidth,

    // Label
    Widget? label,
    BoxDecoration? labelDecoration,

    // Markers
    EdgeMarkerStyle? startMarkerStyle,
    EdgeMarkerStyle? endMarkerStyle,

    // Style
    EdgeStyle? style,
  }) = _FlowEdge;

  /// Public getter (read-only plain Map view of data)
  Map<String, dynamic> get data => Map.unmodifiable(internalData.asMap());

  /// convenience method
  bool isEdgeConnectedTo(String nodeId) =>
      sourceNodeId == nodeId || targetNodeId == nodeId;

  factory FlowEdge.withData({
    required String id,
    required String sourceNodeId,
    required String targetNodeId,
    required String? sourceHandleId,
    required String? targetHandleId,
    EdgePathType pathType = EdgePathType.bezier,
    bool animated = false,
    bool hidden = false,
    bool deletable = true,
    bool selectable = true,
    bool selected = false,
    int zIndex = 0,
    bool reconnectable = true,
    double interactionWidth = 10.0,
    Widget? label,
    BoxDecoration? labelDecoration,
    EdgeStyle? style,
    EdgeMarkerStyle? startMarkerStyle,
    EdgeMarkerStyle? endMarkerStyle,
    Map<String, dynamic>? data,
  }) {
    return FlowEdge(
      id: id,
      sourceNodeId: sourceNodeId,
      targetNodeId: targetNodeId,
      sourceHandleId: sourceHandleId,
      targetHandleId: targetHandleId,
      pathType: pathType,
      animated: animated,
      hidden: hidden,
      deletable: deletable,
      selectable: selectable,
      selected: selected,
      zIndex: zIndex,
      reconnectable: reconnectable,
      interactionWidth: interactionWidth,
      label: label,
      labelDecoration: labelDecoration,
      style: style,
      startMarkerStyle: startMarkerStyle,
      endMarkerStyle: endMarkerStyle,
      internalData: BuiltMap<String, dynamic>(data ?? {}),
    );
  }

  /// Method to update data efficiently
  FlowEdge updateData(
      Map<String, dynamic> Function(Map<String, dynamic>) updater) {
    final currentData = internalData.asMap();
    final updatedData = updater(Map<String, dynamic>.from(currentData));
    return copyWith(internalData: BuiltMap<String, dynamic>(updatedData));
  }
}

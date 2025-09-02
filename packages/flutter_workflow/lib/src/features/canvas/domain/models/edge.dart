import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edge.freezed.dart';

/// Represents a connection (an edge) between two nodes.
@freezed
abstract class FlowEdge with _$FlowEdge {
  const factory FlowEdge({
    required String id,
    required String sourceNodeId,
    required String sourceHandleId,
    required String targetNodeId,
    required String targetHandleId,

    /// The type of the edge, used to look up a custom painter in the EdgeRegistry.
    String? type,

    /// The shape of the edge's path.
    @Default(EdgePathType.bezier) EdgePathType pathType,

    /// A generic data map for any other custom properties.
    @Default({}) Map<String, dynamic> data,

    // Note: Visual properties like Paint, label styles etc.,
    // are best handled in the presentation layer (the painter)
    // based on the theme, rather than storing them in the data model.
    String? label,
  }) = _FlowEdge;
}

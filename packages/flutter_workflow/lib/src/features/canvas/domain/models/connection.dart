import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_export.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';

part 'connection.freezed.dart';

@freezed
abstract class FlowConnection with _$FlowConnection {
  const FlowConnection._();

  const factory FlowConnection({
    required String id,
    required String type,
    required Offset startPoint,
    required Offset endPoint,
    String? fromNodeId,
    String? fromHandleId,
    String? toNodeId,
    String? toHandleId,
    @Default(0) int zIndex,
    FlowConnectionStyle? connectionStyle,
    FlowEdgeMarkerStyle? startMarker,
    FlowEdgeMarkerStyle? endMarker,
  }) = _FlowConnection;
}

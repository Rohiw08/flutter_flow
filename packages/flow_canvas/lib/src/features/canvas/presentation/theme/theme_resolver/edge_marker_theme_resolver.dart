import 'package:flutter/material.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import '../components/edge_marker_theme.dart';

FlowEdgeMarkerStyle resolveEdgeMarkerTheme(
  BuildContext context,
  FlowEdgeMarkerStyle? markerTheme, {
  EdgeMarkerType? type,
  Color? color,
  double? width,
  double? height,
  String? markerUnits,
  String? orient,
  double? strokeWidth,
}) {
  final contextTheme = context.flowCanvasTheme.edgeMarker;

  return contextTheme.copyWith(
    type: type ?? markerTheme?.type,
    color: color ?? markerTheme?.color,
    width: width ?? markerTheme?.width,
    height: height ?? markerTheme?.height,
    markerUnits: markerUnits ?? markerTheme?.markerUnits,
    orient: orient ?? markerTheme?.orient,
    strokeWidth: strokeWidth ?? markerTheme?.strokeWidth,
  );
}

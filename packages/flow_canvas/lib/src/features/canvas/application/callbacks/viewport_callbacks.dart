import 'package:flow_canvas/src/features/canvas/application/events/viewport_change_event.dart';
import 'package:flutter/material.dart';

/// --- Viewport Callbacks ---
typedef ViewportPanCallback = void Function(ViewportEvent event);
typedef ViewportZoomCallback = void Function(ViewportEvent event);
typedef ViewportResizeCallback = void Function(ViewportEvent event);
typedef ViewportTransformCallback = void Function(ViewportEvent event);

@immutable
class ViewportCallbacks {
  // User interactions
  final ViewportPanCallback onPan;
  final ViewportZoomCallback onZoom;

  // State changes
  final ViewportResizeCallback onResize;
  final ViewportTransformCallback onTransform;

  const ViewportCallbacks({
    this.onPan = _defaultOnPan,
    this.onZoom = _defaultOnZoom,
    this.onResize = _defaultOnResize,
    this.onTransform = _defaultOnTransform,
  });

  static void _defaultOnPan(ViewportEvent event) {}
  static void _defaultOnZoom(ViewportEvent event) {}
  static void _defaultOnResize(ViewportEvent event) {}
  static void _defaultOnTransform(ViewportEvent event) {}

  ViewportCallbacks copyWith({
    ViewportPanCallback? onPan,
    ViewportZoomCallback? onZoom,
    ViewportResizeCallback? onResize,
    ViewportTransformCallback? onTransform,
  }) {
    return ViewportCallbacks(
      onPan: onPan ?? this.onPan,
      onZoom: onZoom ?? this.onZoom,
      onResize: onResize ?? this.onResize,
      onTransform: onTransform ?? this.onTransform,
    );
  }
}

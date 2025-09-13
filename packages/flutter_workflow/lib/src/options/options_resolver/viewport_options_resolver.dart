import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/options/components/fitview_options.dart';
import 'package:flutter_workflow/src/options/components/viewport_options.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flutter_workflow/src/options/options_extensions.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

ViewportOptions resolveViewportOptions(
  BuildContext context,
  ViewportOptions? localOptions, {
  // Local property overrides for one-time use
  FlowViewport? defaultViewport,
  FlowViewport? viewport,
  bool? fitView,
  FitViewOptions? fitViewOptions,
  double? minZoom,
  double? maxZoom,
  bool? snapToGrid,
  SnapGrid? snapGrid,
  bool? onlyRenderVisibleElements,
  CoordinateExtent? translateExtent,
  CoordinateExtent? nodeExtent,
  bool? preventScrolling,
  bool? autoPanOnConnect,
  bool? autoPanOnNodeDrag,
  double? autoPanSpeed,
  bool? panOnDrag,
  bool? selectionOnDrag,
  SelectionMode? selectionMode,
  bool? panOnScroll,
  double? panOnScrollSpeed,
  PanOnScrollMode? panOnScrollMode,
  bool? zoomOnScroll,
  bool? zoomOnPinch,
  bool? zoomOnDoubleClick,
}) {
  // Start with the local options object if provided, otherwise fall back to the global theme.
  final base = localOptions ?? context.flowCanvasOptions.viewportOptions;

  // Apply all local property overrides on top of the base theme.
  return base.copyWith(
    defaultViewport: defaultViewport,
    viewport: viewport,
    fitView: fitView,
    fitViewOptions: fitViewOptions,
    minZoom: minZoom,
    maxZoom: maxZoom,
    snapToGrid: snapToGrid,
    snapGrid: snapGrid,
    onlyRenderVisibleElements: onlyRenderVisibleElements,
    translateExtent: translateExtent,
    nodeExtent: nodeExtent,
    preventScrolling: preventScrolling,
    autoPanOnConnect: autoPanOnConnect,
    autoPanOnNodeDrag: autoPanOnNodeDrag,
    autoPanSpeed: autoPanSpeed,
    panOnDrag: panOnDrag,
    selectionOnDrag: selectionOnDrag,
    selectionMode: selectionMode,
    panOnScroll: panOnScroll,
    panOnScrollSpeed: panOnScrollSpeed,
    panOnScrollMode: panOnScrollMode,
    zoomOnScroll: zoomOnScroll,
    zoomOnPinch: zoomOnPinch,
    zoomOnDoubleClick: zoomOnDoubleClick,
  );
}

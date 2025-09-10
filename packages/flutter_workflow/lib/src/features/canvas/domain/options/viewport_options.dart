import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/options/fitview_options.dart';

/// Configuration options for the viewport behavior
class ViewportOptions {
  final FlowViewport? defaultViewport;
  final FlowViewport? viewport;
  final ValueChanged<FlowViewport>? onViewportChange;
  final bool fitView;
  final FitViewOptions fitViewOptions;
  final double minZoom;
  final double maxZoom;
  final bool snapToGrid;
  final SnapGrid snapGrid;
  final bool onlyRenderVisibleElements;
  final CoordinateExtent translateExtent;
  final CoordinateExtent nodeExtent;
  final bool preventScrolling;

  const ViewportOptions({
    this.defaultViewport,
    this.viewport,
    this.onViewportChange,
    this.fitView = false,
    this.fitViewOptions = const FitViewOptions(),
    this.minZoom = 0.5,
    this.maxZoom = 2,
    this.snapToGrid = false,
    this.snapGrid = const SnapGrid(),
    this.onlyRenderVisibleElements = false,
    this.translateExtent = const CoordinateExtent(),
    this.nodeExtent = const CoordinateExtent(),
    this.preventScrolling = true,
  });

  ViewportOptions copyWith({
    FlowViewport? defaultViewport,
    FlowViewport? viewport,
    ValueChanged<FlowViewport>? onViewportChange,
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
  }) {
    return ViewportOptions(
      defaultViewport: defaultViewport ?? this.defaultViewport,
      viewport: viewport ?? this.viewport,
      onViewportChange: onViewportChange ?? this.onViewportChange,
      fitView: fitView ?? this.fitView,
      fitViewOptions: fitViewOptions ?? this.fitViewOptions,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      snapGrid: snapGrid ?? this.snapGrid,
      onlyRenderVisibleElements:
          onlyRenderVisibleElements ?? this.onlyRenderVisibleElements,
      translateExtent: translateExtent ?? this.translateExtent,
      nodeExtent: nodeExtent ?? this.nodeExtent,
      preventScrolling: preventScrolling ?? this.preventScrolling,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ViewportOptions &&
            runtimeType == other.runtimeType &&
            defaultViewport == other.defaultViewport &&
            viewport == other.viewport &&
            onViewportChange == other.onViewportChange &&
            fitView == other.fitView &&
            fitViewOptions == other.fitViewOptions &&
            minZoom == other.minZoom &&
            maxZoom == other.maxZoom &&
            snapToGrid == other.snapToGrid &&
            snapGrid == other.snapGrid &&
            onlyRenderVisibleElements == other.onlyRenderVisibleElements &&
            translateExtent == other.translateExtent &&
            nodeExtent == other.nodeExtent &&
            preventScrolling == other.preventScrolling;
  }

  @override
  int get hashCode {
    return Object.hash(
      defaultViewport,
      viewport,
      onViewportChange,
      fitView,
      fitViewOptions,
      minZoom,
      maxZoom,
      snapToGrid,
      snapGrid,
      onlyRenderVisibleElements,
      translateExtent,
      nodeExtent,
      preventScrolling,
    );
  }
}

class FlowViewport {
  final Offset offset;
  final double zoom;
  FlowViewport({
    required this.offset,
    required this.zoom,
  });

  FlowViewport copyWith({
    Offset? offset,
    double? zoom,
  }) {
    return FlowViewport(
      offset: offset ?? this.offset,
      zoom: zoom ?? this.zoom,
    );
  }

  @override
  String toString() => 'FlowViewport(offset: $offset, zoom: $zoom)';

  @override
  bool operator ==(covariant FlowViewport other) {
    if (identical(this, other)) return true;

    return other.offset == offset && other.zoom == zoom;
  }

  @override
  int get hashCode => offset.hashCode ^ zoom.hashCode;
}

/// Defines the coordinate extent for viewport and node boundaries
class CoordinateExtent {
  final Offset min;
  final Offset max;

  const CoordinateExtent(
      {this.min = const Offset(-double.infinity, -double.infinity),
      this.max = const Offset(double.infinity, double.infinity)});

  CoordinateExtent copyWith({Offset? min, Offset? max}) {
    return CoordinateExtent(
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CoordinateExtent &&
            runtimeType == other.runtimeType &&
            min == other.min &&
            max == other.max;
  }

  @override
  int get hashCode => min.hashCode ^ max.hashCode;
}

/// Defines the grid for snapping
class SnapGrid {
  final double width;
  final double height;

  const SnapGrid({this.width = 10, this.height = 10});

  SnapGrid copyWith({double? width, double? height}) {
    return SnapGrid(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SnapGrid &&
            runtimeType == other.runtimeType &&
            width == other.width &&
            height == other.height;
  }

  @override
  int get hashCode => width.hashCode ^ height.hashCode;
}

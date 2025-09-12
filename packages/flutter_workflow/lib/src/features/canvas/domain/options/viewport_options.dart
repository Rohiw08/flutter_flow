import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/options/fitview_options.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

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
  final bool autoPanOnConnect;
  final bool autoPanOnNodeDrag;
  final double autoPanSpeed;
  final bool panOnDrag;
  final bool selectionOnDrag;
  final SelectionMode selectionMode;
  final bool panOnScroll;
  final double panOnScrollSpeed;
  final PanOnScrollMode panOnScrollMode;
  final bool zoomOnScroll;
  final bool zoomOnPinch;
  final bool zoomOnDoubleClick;

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
    this.autoPanOnConnect = true,
    this.autoPanOnNodeDrag = true,
    this.autoPanSpeed = 15.0,
    this.panOnDrag = true,
    this.selectionOnDrag = false,
    this.selectionMode = SelectionMode.full,
    this.panOnScroll = false,
    this.panOnScrollSpeed = 0.5,
    this.panOnScrollMode = PanOnScrollMode.free,
    this.zoomOnScroll = true,
    this.zoomOnPinch = true,
    this.zoomOnDoubleClick = true,
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
      autoPanOnConnect: autoPanOnConnect ?? this.autoPanOnConnect,
      autoPanOnNodeDrag: autoPanOnNodeDrag ?? this.autoPanOnNodeDrag,
      autoPanSpeed: autoPanSpeed ?? this.autoPanSpeed,
      panOnDrag: panOnDrag ?? this.panOnDrag,
      selectionOnDrag: selectionOnDrag ?? this.selectionOnDrag,
      selectionMode: selectionMode ?? this.selectionMode,
      panOnScroll: panOnScroll ?? this.panOnScroll,
      panOnScrollSpeed: panOnScrollSpeed ?? this.panOnScrollSpeed,
      panOnScrollMode: panOnScrollMode ?? this.panOnScrollMode,
      zoomOnScroll: zoomOnScroll ?? this.zoomOnScroll,
      zoomOnPinch: zoomOnPinch ?? this.zoomOnPinch,
      zoomOnDoubleClick: zoomOnDoubleClick ?? this.zoomOnDoubleClick,
    );
  }

  @override
  bool operator ==(covariant ViewportOptions other) {
    if (identical(this, other)) return true;

    return other.defaultViewport == defaultViewport &&
        other.viewport == viewport &&
        other.onViewportChange == onViewportChange &&
        other.fitView == fitView &&
        other.fitViewOptions == fitViewOptions &&
        other.minZoom == minZoom &&
        other.maxZoom == maxZoom &&
        other.snapToGrid == snapToGrid &&
        other.snapGrid == snapGrid &&
        other.onlyRenderVisibleElements == onlyRenderVisibleElements &&
        other.translateExtent == translateExtent &&
        other.nodeExtent == nodeExtent &&
        other.preventScrolling == preventScrolling &&
        other.autoPanOnConnect == autoPanOnConnect &&
        other.autoPanOnNodeDrag == autoPanOnNodeDrag &&
        other.autoPanSpeed == autoPanSpeed &&
        other.panOnDrag == panOnDrag &&
        other.selectionOnDrag == selectionOnDrag &&
        other.selectionMode == selectionMode &&
        other.panOnScroll == panOnScroll &&
        other.panOnScrollSpeed == panOnScrollSpeed &&
        other.panOnScrollMode == panOnScrollMode &&
        other.zoomOnScroll == zoomOnScroll &&
        other.zoomOnPinch == zoomOnPinch &&
        other.zoomOnDoubleClick == zoomOnDoubleClick;
  }

  @override
  int get hashCode {
    return defaultViewport.hashCode ^
        viewport.hashCode ^
        onViewportChange.hashCode ^
        fitView.hashCode ^
        fitViewOptions.hashCode ^
        minZoom.hashCode ^
        maxZoom.hashCode ^
        snapToGrid.hashCode ^
        snapGrid.hashCode ^
        onlyRenderVisibleElements.hashCode ^
        translateExtent.hashCode ^
        nodeExtent.hashCode ^
        preventScrolling.hashCode ^
        autoPanOnConnect.hashCode ^
        autoPanOnNodeDrag.hashCode ^
        autoPanSpeed.hashCode ^
        panOnDrag.hashCode ^
        selectionOnDrag.hashCode ^
        selectionMode.hashCode ^
        panOnScroll.hashCode ^
        panOnScrollSpeed.hashCode ^
        panOnScrollMode.hashCode ^
        zoomOnScroll.hashCode ^
        zoomOnPinch.hashCode ^
        zoomOnDoubleClick.hashCode;
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

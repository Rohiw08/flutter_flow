import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/coordinate_extent.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/fitview_options.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';

/// Configuration options for the viewport behavior
@immutable
class ViewportOptions {
  final FlowViewport? defaultViewport;
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
    this.fitView = false,
    this.fitViewOptions = const FitViewOptions(),
    this.minZoom = 0.5,
    this.maxZoom = 3,
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

  ViewportOptions lerp(ViewportOptions other, double t) {
    return ViewportOptions(
      // Discrete or nullable fields
      defaultViewport: t < 0.5 ? defaultViewport : other.defaultViewport,
      fitView: t < 0.5 ? fitView : other.fitView,
      fitViewOptions: fitViewOptions, // keep discrete; runtime animates fit
      snapToGrid: t < 0.5 ? snapToGrid : other.snapToGrid,
      snapGrid: snapGrid, // discrete
      onlyRenderVisibleElements:
          t < 0.5 ? onlyRenderVisibleElements : other.onlyRenderVisibleElements,
      translateExtent: translateExtent, // discrete
      nodeExtent: nodeExtent, // discrete
      preventScrolling: t < 0.5 ? preventScrolling : other.preventScrolling,
      autoPanOnConnect: t < 0.5 ? autoPanOnConnect : other.autoPanOnConnect,
      autoPanOnNodeDrag: t < 0.5 ? autoPanOnNodeDrag : other.autoPanOnNodeDrag,
      panOnDrag: t < 0.5 ? panOnDrag : other.panOnDrag,
      selectionOnDrag: t < 0.5 ? selectionOnDrag : other.selectionOnDrag,
      selectionMode: t < 0.5 ? selectionMode : other.selectionMode,
      panOnScroll: t < 0.5 ? panOnScroll : other.panOnScroll,
      panOnScrollMode: t < 0.5 ? panOnScrollMode : other.panOnScrollMode,
      zoomOnScroll: t < 0.5 ? zoomOnScroll : other.zoomOnScroll,
      zoomOnPinch: t < 0.5 ? zoomOnPinch : other.zoomOnPinch,
      zoomOnDoubleClick: t < 0.5 ? zoomOnDoubleClick : other.zoomOnDoubleClick,

      // Interpolated numeric fields
      minZoom: minZoom + (other.minZoom - minZoom) * t,
      maxZoom: maxZoom + (other.maxZoom - maxZoom) * t,
      autoPanSpeed: autoPanSpeed + (other.autoPanSpeed - autoPanSpeed) * t,
      panOnScrollSpeed:
          panOnScrollSpeed + (other.panOnScrollSpeed - panOnScrollSpeed) * t,
    );
  }

  @override
  bool operator ==(covariant ViewportOptions other) {
    if (identical(this, other)) return true;

    return other.defaultViewport == defaultViewport &&
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

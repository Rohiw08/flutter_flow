import 'package:flow_canvas/src/features/canvas/domain/models/snap_grid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/coordinate_extent.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/fitview_options.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';

/// Configuration options for viewport behavior and user interactions.
///
/// Controls panning, zooming, selection, and other viewport interactions.
/// These options closely match React Flow's interaction props.
///
/// ## React Flow Compatibility
///
/// This maps to React Flow's interaction props [web:241]:
/// - Pan: `panOnDrag`, `panOnScroll`, `panOnScrollSpeed`, `panOnScrollMode`
/// - Zoom: `zoomOnScroll`, `zoomOnPinch`, `zoomOnDoubleClick`, `minZoom`, `maxZoom`
/// - Selection: `selectionOnDrag`, `selectionMode`, `elementsSelectable`
/// - Auto Pan: `autoPanOnConnect`, `autoPanOnNodeDrag`, `autoPanSpeed`
/// - Nodes: `nodesDraggable`, `nodesConnectable`, `nodesFocusable`
/// - Edges: `edgesFocusable`
/// - Other: `elevateNodesOnSelect`, `fitView`, `fitViewOptions`
///
/// ## Usage
///
/// Default interactive viewport:
/// ```
/// ViewportOptions()
/// ```
///
/// Read-only viewport (no interactions):
/// ```
/// ViewportOptions.readOnly()
/// ```
///
/// Custom configuration:
/// ```
/// ViewportOptions(
///   minZoom: 0.1,
///   maxZoom: 4.0,
///   panOnScroll: true,
///   zoomOnScroll: false,
/// )
/// ```
///
/// See also:
///
///  * [FitViewOptions], for fit view configuration
///  * [FlowViewport], for viewport state
@immutable
class ViewportOptions with Diagnosticable {
  // ==========================================================================
  // Viewport State
  // ==========================================================================

  /// The initial viewport position and zoom.
  ///
  /// If provided, sets the starting viewport state. Use `fitView` to
  /// automatically fit content instead.
  ///
  /// React Flow equivalent: `defaultViewport` prop.
  final FlowViewport? defaultViewport;

  /// Whether to fit the view to show all nodes on initial render.
  ///
  /// When true, automatically calculates viewport to fit all nodes.
  /// Use `fitViewOptions` to customize the fit behavior.
  ///
  /// React Flow equivalent: `fitView` prop.
  /// Defaults to false.
  final bool fitView;

  /// Options for how fitView should behave.
  ///
  /// Controls padding, zoom limits, and animation for fit operations.
  ///
  /// React Flow equivalent: `fitViewOptions` prop.
  final FitViewOptions fitViewOptions;

  // ==========================================================================
  // Zoom Constraints
  // ==========================================================================

  /// Minimum allowed zoom level.
  ///
  /// Users cannot zoom out beyond this level. Must be greater than 0.
  /// React Flow default: 0.5
  ///
  /// React Flow equivalent: `minZoom` prop.
  /// Defaults to 0.5.
  final double minZoom;

  /// Maximum allowed zoom level.
  ///
  /// Users cannot zoom in beyond this level. Must be greater than minZoom.
  /// React Flow default: 2.0
  ///
  /// React Flow equivalent: `maxZoom` prop.
  /// Defaults to 2.0.
  final double maxZoom;

  // ==========================================================================
  // Pan Interactions
  // ==========================================================================

  /// Whether users can pan by clicking and dragging.
  ///
  /// When true, users can drag the canvas to pan the viewport.
  /// React Flow also supports limiting to specific mouse buttons.
  ///
  /// React Flow equivalent: `panOnDrag` prop.
  /// Defaults to true.
  final bool panOnDrag;

  /// Whether scrolling pans the viewport instead of zooming.
  ///
  /// When true, scrolling moves the canvas. Set `zoomOnScroll` to false
  /// to prevent scroll from zooming.
  ///
  /// React Flow equivalent: `panOnScroll` prop.
  /// Defaults to false.
  final bool panOnScroll;

  /// Speed multiplier for pan-on-scroll.
  ///
  /// Higher values pan faster. Only applies when `panOnScroll` is true.
  /// React Flow default: 0.5
  ///
  /// React Flow equivalent: `panOnScrollSpeed` prop.
  /// Defaults to 0.5.
  final double panOnScrollSpeed;

  /// Direction constraint for pan-on-scroll.
  ///
  /// Controls which directions are allowed when panning via scroll.
  /// - `free`: Pan in any direction
  /// - `horizontal`: Only pan left/right
  /// - `vertical`: Only pan up/down
  ///
  /// React Flow equivalent: `panOnScrollMode` prop.
  /// Defaults to `free`.
  final PanOnScrollMode panOnScrollMode;

  // ==========================================================================
  // Zoom Interactions
  // ==========================================================================

  /// Whether scrolling zooms the viewport.
  ///
  /// When true, scrolling zooms in/out. Disable this if using `panOnScroll`.
  ///
  /// React Flow equivalent: `zoomOnScroll` prop.
  /// Defaults to true.
  final bool zoomOnScroll;

  /// Whether pinch gestures zoom on touch screens.
  ///
  /// When true, two-finger pinch gestures control zoom on mobile/tablet.
  ///
  /// React Flow equivalent: `zoomOnPinch` prop.
  /// Defaults to true.
  final bool zoomOnPinch;

  /// Whether double-clicking zooms the viewport.
  ///
  /// When true, double-clicking zooms in at the click position.
  ///
  /// React Flow equivalent: `zoomOnDoubleClick` prop.
  /// Defaults to true.
  final bool zoomOnDoubleClick;

  // ==========================================================================
  // Selection Interactions
  // ==========================================================================

  /// Whether dragging creates a selection box without modifier keys.
  ///
  /// When true, click-and-drag creates a selection box immediately.
  /// When false, requires a modifier key (typically Shift) to select.
  ///
  /// React Flow equivalent: `selectionOnDrag` prop.
  /// Defaults to false.
  final bool selectionOnDrag;

  /// How nodes are selected within the selection box.
  ///
  /// - `full`: Node must be fully inside the box
  /// - `partial`: Node partially inside is selected
  ///
  /// React Flow equivalent: `selectionMode` prop.
  /// Defaults to `full`.
  final SelectionMode selectionMode;

  // ==========================================================================
  // Auto-Pan
  // ==========================================================================

  /// Whether viewport auto-pans during connection creation.
  ///
  /// When true, viewport automatically pans when dragging a connection
  /// near the edge of the canvas.
  ///
  /// React Flow equivalent: `autoPanOnConnect` prop.
  /// Defaults to true.
  final bool autoPanOnConnect;

  /// Whether viewport auto-pans while dragging nodes.
  ///
  /// When true, viewport automatically pans when dragging nodes
  /// near the edge of the canvas.
  ///
  /// React Flow equivalent: `autoPanOnNodeDrag` prop.
  /// Defaults to true.
  final bool autoPanOnNodeDrag;

  /// Speed of auto-panning in pixels per frame.
  ///
  /// Higher values pan faster during auto-pan operations.
  /// React Flow default: 15
  ///
  /// React Flow equivalent: `autoPanSpeed` prop.
  /// Defaults to 15.0.
  final double autoPanSpeed;

  // ==========================================================================
  // Advanced Options
  // ==========================================================================

  /// Whether to snap node positions to a grid.
  ///
  /// When true, node positions snap to grid points defined by `snapGrid`.
  final bool snapToGrid;

  /// Grid configuration for snapping.
  ///
  /// Defines the grid spacing when `snapToGrid` is enabled.
  final SnapGrid snapGrid;

  /// Performance optimization: only render visible elements.
  ///
  /// When true, nodes/edges outside the viewport are not rendered.
  /// Improves performance for large graphs.
  final bool onlyRenderVisibleElements;

  /// Extent to which the viewport can be moved.
  ///
  /// Constrains how far users can pan the canvas.
  /// Unbounded by default.
  final CoordinateExtent translateExtent;

  /// Extent to which nodes can be moved.
  ///
  /// Constrains where nodes can be dragged.
  /// Unbounded by default.
  final CoordinateExtent nodeExtent;

  /// Whether to prevent native browser scrolling.
  ///
  /// When true, prevents page scroll when interacting with the canvas.
  /// Recommended for full-page canvas applications.
  ///
  /// Defaults to true.
  final bool preventScrolling;

  /// Creates viewport options with the specified parameters.
  ///
  /// All parameters have sensible defaults matching React Flow's behavior.
  const ViewportOptions({
    this.defaultViewport,
    this.fitView = false,
    this.fitViewOptions = const FitViewOptions(),
    this.minZoom = 0.5,
    this.maxZoom = 2.0,
    this.panOnDrag = true,
    this.panOnScroll = false,
    this.panOnScrollSpeed = 0.5,
    this.panOnScrollMode = PanOnScrollMode.free,
    this.zoomOnScroll = true,
    this.zoomOnPinch = true,
    this.zoomOnDoubleClick = true,
    this.selectionOnDrag = false,
    this.selectionMode = SelectionMode.full,
    this.autoPanOnConnect = true,
    this.autoPanOnNodeDrag = true,
    this.autoPanSpeed = 15.0,
    this.snapToGrid = false,
    this.snapGrid = const SnapGrid(),
    this.onlyRenderVisibleElements = false,
    this.translateExtent = const CoordinateExtent(),
    this.nodeExtent = const CoordinateExtent(),
    this.preventScrolling = true,
  })  : assert(minZoom > 0, 'minZoom must be greater than 0'),
        assert(maxZoom > 0, 'maxZoom must be greater than 0'),
        assert(maxZoom >= minZoom, 'maxZoom must be >= minZoom'),
        assert(autoPanSpeed > 0, 'autoPanSpeed must be positive'),
        assert(panOnScrollSpeed > 0, 'panOnScrollSpeed must be positive');

  /// Creates viewport options for read-only viewing.
  ///
  /// Disables all user interactions except viewing and zooming with controls.
  /// Users cannot pan, select, or modify the diagram.
  ///
  /// Example:
  /// ```
  /// FlowCanvas(
  ///   viewportOptions: ViewportOptions.readOnly(),
  /// )
  /// ```
  const ViewportOptions.readOnly({
    this.defaultViewport,
    this.fitView = false,
    this.minZoom = 0.5,
    this.maxZoom = 2.0,
  })  : fitViewOptions = const FitViewOptions(),
        panOnDrag = false,
        panOnScroll = false,
        panOnScrollSpeed = 0.5,
        panOnScrollMode = PanOnScrollMode.free,
        zoomOnScroll = false,
        zoomOnPinch = false,
        zoomOnDoubleClick = false,
        selectionOnDrag = false,
        selectionMode = SelectionMode.full,
        autoPanOnConnect = false,
        autoPanOnNodeDrag = false,
        autoPanSpeed = 15.0,
        snapToGrid = false,
        snapGrid = const SnapGrid(),
        onlyRenderVisibleElements = false,
        translateExtent = const CoordinateExtent(),
        nodeExtent = const CoordinateExtent(),
        preventScrolling = true,
        assert(minZoom > 0, 'minZoom must be greater than 0'),
        assert(maxZoom > 0, 'maxZoom must be greater than 0'),
        assert(maxZoom >= minZoom, 'maxZoom must be >= minZoom');

  /// Returns a copy of these options with the given fields replaced.
  ViewportOptions copyWith({
    FlowViewport? defaultViewport,
    bool? fitView,
    FitViewOptions? fitViewOptions,
    double? minZoom,
    double? maxZoom,
    bool? panOnDrag,
    bool? panOnScroll,
    double? panOnScrollSpeed,
    PanOnScrollMode? panOnScrollMode,
    bool? zoomOnScroll,
    bool? zoomOnPinch,
    bool? zoomOnDoubleClick,
    bool? selectionOnDrag,
    SelectionMode? selectionMode,
    bool? autoPanOnConnect,
    bool? autoPanOnNodeDrag,
    double? autoPanSpeed,
    bool? snapToGrid,
    SnapGrid? snapGrid,
    bool? onlyRenderVisibleElements,
    CoordinateExtent? translateExtent,
    CoordinateExtent? nodeExtent,
    bool? preventScrolling,
  }) {
    return ViewportOptions(
      defaultViewport: defaultViewport ?? this.defaultViewport,
      fitView: fitView ?? this.fitView,
      fitViewOptions: fitViewOptions ?? this.fitViewOptions,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      panOnDrag: panOnDrag ?? this.panOnDrag,
      panOnScroll: panOnScroll ?? this.panOnScroll,
      panOnScrollSpeed: panOnScrollSpeed ?? this.panOnScrollSpeed,
      panOnScrollMode: panOnScrollMode ?? this.panOnScrollMode,
      zoomOnScroll: zoomOnScroll ?? this.zoomOnScroll,
      zoomOnPinch: zoomOnPinch ?? this.zoomOnPinch,
      zoomOnDoubleClick: zoomOnDoubleClick ?? this.zoomOnDoubleClick,
      selectionOnDrag: selectionOnDrag ?? this.selectionOnDrag,
      selectionMode: selectionMode ?? this.selectionMode,
      autoPanOnConnect: autoPanOnConnect ?? this.autoPanOnConnect,
      autoPanOnNodeDrag: autoPanOnNodeDrag ?? this.autoPanOnNodeDrag,
      autoPanSpeed: autoPanSpeed ?? this.autoPanSpeed,
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
    if (identical(this, other)) return true;

    return other is ViewportOptions &&
        other.defaultViewport == defaultViewport &&
        other.fitView == fitView &&
        other.fitViewOptions == fitViewOptions &&
        other.minZoom == minZoom &&
        other.maxZoom == maxZoom &&
        other.panOnDrag == panOnDrag &&
        other.panOnScroll == panOnScroll &&
        other.panOnScrollSpeed == panOnScrollSpeed &&
        other.panOnScrollMode == panOnScrollMode &&
        other.zoomOnScroll == zoomOnScroll &&
        other.zoomOnPinch == zoomOnPinch &&
        other.zoomOnDoubleClick == zoomOnDoubleClick &&
        other.selectionOnDrag == selectionOnDrag &&
        other.selectionMode == selectionMode &&
        other.autoPanOnConnect == autoPanOnConnect &&
        other.autoPanOnNodeDrag == autoPanOnNodeDrag &&
        other.autoPanSpeed == autoPanSpeed &&
        other.snapToGrid == snapToGrid &&
        other.snapGrid == snapGrid &&
        other.onlyRenderVisibleElements == onlyRenderVisibleElements &&
        other.translateExtent == translateExtent &&
        other.nodeExtent == nodeExtent &&
        other.preventScrolling == preventScrolling;
  }

  @override
  int get hashCode => Object.hashAll([
        defaultViewport,
        fitView,
        fitViewOptions,
        minZoom,
        maxZoom,
        panOnDrag,
        panOnScroll,
        panOnScrollSpeed,
        panOnScrollMode,
        zoomOnScroll,
        zoomOnPinch,
        zoomOnDoubleClick,
        selectionOnDrag,
        selectionMode,
        autoPanOnConnect,
        autoPanOnNodeDrag,
        autoPanSpeed,
        snapToGrid,
        snapGrid,
        onlyRenderVisibleElements,
        translateExtent,
        nodeExtent,
        preventScrolling,
      ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<FlowViewport?>('defaultViewport', defaultViewport));
    properties
        .add(FlagProperty('fitView', value: fitView, ifTrue: 'fit on init'));
    properties.add(DoubleProperty('minZoom', minZoom, defaultValue: 0.5));
    properties.add(DoubleProperty('maxZoom', maxZoom, defaultValue: 2.0));
    properties.add(FlagProperty('panOnDrag',
        value: panOnDrag, defaultValue: true, ifFalse: 'no pan on drag'));
    properties.add(FlagProperty('panOnScroll',
        value: panOnScroll, defaultValue: false, ifTrue: 'pan on scroll'));
    properties.add(FlagProperty('zoomOnScroll',
        value: zoomOnScroll, defaultValue: true, ifFalse: 'no zoom on scroll'));
    properties.add(FlagProperty('selectionOnDrag',
        value: selectionOnDrag,
        defaultValue: false,
        ifTrue: 'selection on drag'));
    properties.add(EnumProperty<SelectionMode>('selectionMode', selectionMode));
    properties
        .add(DoubleProperty('autoPanSpeed', autoPanSpeed, defaultValue: 15.0));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ViewportOptions(zoom: $minZoom-$maxZoom, pan: $panOnDrag, scroll: ${zoomOnScroll ? "zoom" : panOnScroll ? "pan" : "disabled"})';
  }
}

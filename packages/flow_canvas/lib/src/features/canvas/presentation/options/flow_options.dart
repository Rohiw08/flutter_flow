import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/edge_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/keyboard_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/node_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/viewport_options.dart';

/// Global configuration options for the flow canvas.
///
/// This is the top-level options container that aggregates all component-specific
/// options (nodes, edges, viewport, keyboard) into a single configuration object.
///
/// ## React Flow Comparison
///
/// React Flow passes options as props directly to the `<ReactFlow>` component.
/// This class serves the same purpose but groups related options for cleaner API.
///
/// Flutter equivalent:
/// ```
/// FlowCanvas(
///   nodes: nodes,
///   edges: edges,
///   options: FlowCanvasOptions(
///     nodeOptions: NodeOptions(...),
///     edgeOptions: EdgeOptions(...),
///     viewportOptions: ViewportOptions(...),
///   ),
/// )
/// ```
///
/// ## Usage
///
/// Default interactive canvas:
/// ```
/// FlowCanvas(
///   options: FlowCanvasOptions(),
/// )
/// ```
///
/// Read-only presentation:
/// ```
/// FlowCanvas(
///   options: FlowCanvasOptions.readOnly(),
/// )
/// ```
///
/// Custom configuration:
/// ```
/// FlowCanvas(
///   options: FlowCanvasOptions(
///     nodeOptions: NodeOptions.interactive(),
///     edgeOptions: EdgeOptions.readOnly(),
///     viewportOptions: ViewportOptions(
///       minZoom: 0.1,
///       maxZoom: 4.0,
///     ),
///   ),
/// )
/// ```
@immutable
class FlowCanvasOptions with Diagnosticable {
  final Size canvasSize;

  /// Options controlling node behavior and interactions.
  ///
  /// Determines if nodes can be dragged, selected, connected, etc.
  final NodeOptions nodeOptions;

  /// Options controlling edge behavior and interactions.
  ///
  /// Determines if edges can be selected, deleted, reconnected, etc.
  final EdgeOptions edgeOptions;

  /// Options controlling viewport behavior and interactions.
  ///
  /// Controls panning, zooming, selection box, auto-pan, etc.
  final ViewportOptions viewportOptions;

  /// Options controlling keyboard shortcuts and interactions.
  ///
  /// Defines keyboard shortcuts for common actions like select all, delete, etc.
  final KeyboardOptions keyboardOptions;

  /// Creates flow canvas options with the specified configurations.
  ///
  /// All sub-options default to their respective interactive defaults.
  const FlowCanvasOptions({
    this.canvasSize = const Size(2000, 2000),
    this.nodeOptions = const NodeOptions(),
    this.edgeOptions = const EdgeOptions(),
    this.viewportOptions = const ViewportOptions(),
    this.keyboardOptions = const KeyboardOptions(),
  });

  /// Creates read-only canvas options.
  ///
  /// Disables all user interactions - no dragging, selecting, editing, etc.
  /// Useful for displaying fixed diagrams or presentations.
  ///
  /// Example:
  /// ```
  /// FlowCanvas(
  ///   nodes: nodes,
  ///   edges: edges,
  ///   options: FlowCanvasOptions.readOnly(),
  /// )
  /// ```
  FlowCanvasOptions.readOnly()
      : canvasSize = const Size(2000, 2000),
        nodeOptions = const NodeOptions.readOnly(),
        edgeOptions = const EdgeOptions.readOnly(),
        viewportOptions = const ViewportOptions.readOnly(),
        keyboardOptions = const KeyboardOptions.disabled();

  /// Creates fully interactive canvas options.
  ///
  /// Enables all interactions and features. This is more permissive
  /// than the default constructor.
  ///
  /// Example:
  /// ```
  /// FlowCanvas(
  ///   nodes: nodes,
  ///   edges: edges,
  ///   options: FlowCanvasOptions.interactive(),
  /// )
  /// ```
  FlowCanvasOptions.interactive()
      : canvasSize = const Size(2000, 2000),
        nodeOptions = const NodeOptions.interactive(),
        edgeOptions = const EdgeOptions.interactive(),
        viewportOptions = const ViewportOptions(),
        keyboardOptions = KeyboardOptions.withDefaults();

  /// Creates canvas options optimized for presentations.
  ///
  /// Allows viewing and navigation but disables editing.
  /// Users can pan, zoom, and select but not modify content.
  ///
  /// Example:
  /// ```
  /// FlowCanvas(
  ///   nodes: nodes,
  ///   edges: edges,
  ///   options: FlowCanvasOptions.presentation(),
  /// )
  /// ```
  FlowCanvasOptions.presentation()
      : canvasSize = const Size(2000, 2000),
        nodeOptions = const NodeOptions.readOnly(),
        edgeOptions = const EdgeOptions.readOnly(),
        viewportOptions = const ViewportOptions(
          panOnDrag: true,
          zoomOnScroll: true,
          selectionOnDrag: false,
        ),
        keyboardOptions = KeyboardOptions.navigationOnly();

  /// Returns a copy of these options with the given fields replaced.
  ///
  /// All parameters are optional. Null values retain the current value.
  ///
  /// Example:
  /// ```
  /// final newOptions = options.copyWith(
  ///   nodeOptions: NodeOptions.readOnly(),
  /// );
  /// ```
  FlowCanvasOptions copyWith({
    NodeOptions? nodeOptions,
    EdgeOptions? edgeOptions,
    ViewportOptions? viewportOptions,
    KeyboardOptions? keyboardOptions,
  }) {
    return FlowCanvasOptions(
      nodeOptions: nodeOptions ?? this.nodeOptions,
      edgeOptions: edgeOptions ?? this.edgeOptions,
      viewportOptions: viewportOptions ?? this.viewportOptions,
      keyboardOptions: keyboardOptions ?? this.keyboardOptions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FlowCanvasOptions &&
        other.nodeOptions == nodeOptions &&
        other.edgeOptions == edgeOptions &&
        other.viewportOptions == viewportOptions &&
        other.keyboardOptions == keyboardOptions;
  }

  @override
  int get hashCode => Object.hash(
        nodeOptions,
        edgeOptions,
        viewportOptions,
        keyboardOptions,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<NodeOptions>('nodeOptions', nodeOptions));
    properties
        .add(DiagnosticsProperty<EdgeOptions>('edgeOptions', edgeOptions));
    properties.add(DiagnosticsProperty<ViewportOptions>(
        'viewportOptions', viewportOptions));
    properties.add(DiagnosticsProperty<KeyboardOptions>(
        'keyboardOptions', keyboardOptions));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FlowCanvasOptions(nodes: ${nodeOptions.nodeType ?? "default"}, edges: ${edgeOptions.type ?? "default"})';
  }
}

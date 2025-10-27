import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flow_canvas/src/features/canvas/presentation/options/options_extensions.dart';

/// Defines the behavior and interaction options for edges in the flow canvas.
///
/// Edge options control how edges behave and respond to user interactions,
/// including selection, deletion, reconnection, and visual effects.
///
/// ## Usage
///
/// Create custom edge options:
/// ```
/// const options = EdgeOptions(
///   deletable: true,
///   selectable: true,
///   reconnectable: true,
/// );
/// ```
///
/// Use preset options:
/// ```
/// // Static edges that can't be modified
/// final readOnly = EdgeOptions.readOnly();
///
/// // Fully interactive edges
/// final interactive = EdgeOptions.interactive();
/// ```
///
/// Access from context:
/// ```
/// final options = EdgeOptions.resolve(context);
/// // Or using extension
/// final options = context.flowCanvasOptions.edgeOptions;
/// ```
///
/// ## Common Patterns
///
/// **Read-only diagram**:
/// ```
/// EdgeOptions(
///   deletable: false,
///   selectable: false,
///   reconnectable: false,
/// )
/// ```
///
/// See also:
///
///  * [NodeOptions], for node behavior configuration
///  * [FlowCanvasOptions], for global canvas options
@immutable
class EdgeOptions with Diagnosticable {
  /// The type identifier for the edge (e.g., 'default', 'bezier', 'step').
  ///
  /// If null, uses the default edge type. Custom types can be registered
  /// and used for different visual styles or behaviors.
  final String? type;

  // ============================================================================
  // ANIMATION FEATURE - COMMENTED OUT
  // ============================================================================
  //
  // /// Whether the edge should show an animated flow effect.
  // ///
  // /// When true, displays a moving dash pattern along the edge to indicate
  // /// data/signal direction, similar to React Flow's animated edges.
  // ///
  // /// **Why this is disabled:**
  // /// - **Performance**: Animating edges requires continuous repainting,
  // ///   which is expensive with many edges. React Flow uses CSS animations
  // ///   which are GPU-accelerated, but Flutter requires custom solutions.
  // /// - **Shader Complexity**: Implementing smooth animated dashes requires
  // ///   either custom shaders (Fragment shaders are complex and platform-specific)
  // ///   or continuous Path updates (expensive on CPU).
  // /// - **Battery Impact**: Continuous animations drain battery on mobile devices.
  // ///
  // /// **Potential Implementation Approaches:**
  // /// 1. **Custom Shader** (Best performance, hard to implement):
  // ///    - Use Fragment shader with dash pattern and time uniform
  // ///    - GPU-accelerated, smooth 60fps animations
  // ///    - Requires GLSL/HLSL knowledge, platform-specific code
  // ///    - Example: dashPattern moving based on time offset
  // ///
  // /// 2. **AnimatedBuilder with CustomPainter** (Moderate performance):
  // ///    - Use AnimationController to update dash offset
  // ///    - Repaint only animated edges, not entire canvas
  // ///    - Simpler than shaders but CPU-intensive with many edges
  // ///
  // /// 3. **Rive/Lottie Animations** (Good for specific use cases):
  // ///    - Pre-animated edge assets
  // ///    - Limited flexibility but good performance
  // ///
  // /// 4. **Selective Animation** (Compromise):
  // ///    - Only animate edges currently in viewport
  // ///    - Pause animations when canvas is static
  // ///    - Limit max number of animated edges
  // ///
  // /// **If you decide to implement this:**
  // /// - Start with Fragment shader approach for best performance
  // /// - Add animation budget system (max N animated edges)
  // /// - Provide opt-in rather than default-on
  // /// - Consider reduced motion accessibility settings
  // ///
  // /// See also:
  // ///  * Flutter CustomPainter: https://api.flutter.dev/flutter/rendering/CustomPainter-class.html
  // ///  * Fragment Shaders: https://docs.flutter.dev/development/ui/advanced/shaders
  // ///  * React Flow Animated Edges: https://reactflow.dev/examples/edges/animated-edges
  // final bool animated;

  /// Whether the edge is hidden from view.
  ///
  /// Hidden edges still exist in the graph but are not rendered.
  /// Useful for temporarily hiding connections without removing them.
  final bool hidden;

  /// Whether the edge can be deleted by the user.
  ///
  /// When false, prevents deletion via keyboard shortcuts or UI actions.
  /// The edge can still be removed programmatically.
  final bool deletable;

  /// Whether the edge can be selected by clicking or dragging.
  ///
  /// When false, the edge cannot be interacted with for selection.
  /// Useful for background or decorative edges.
  final bool selectable;

  /// Whether the edge endpoints can be reconnected to different nodes.
  ///
  /// When true, users can drag edge endpoints to connect them to
  /// different source or target nodes.
  final bool reconnectable;

  /// Whether the edge can receive keyboard focus.
  ///
  /// When true, the edge can be focused and respond to keyboard events
  /// like Delete or arrow keys for navigation.
  final bool focusable;

  /// Whether to elevate the edge visually when selected.
  ///
  /// When true, selected edges are rendered on top of other edges,
  /// making them more prominent. This typically increases their z-index.
  final bool elevateEdgeOnSelect;

  /// Creates edge options with the specified behaviors.
  ///
  /// All boolean parameters default to common interactive settings:
  /// - Most interactions enabled (deletable, selectable, reconnectable, focusable)
  /// - Visual effects disabled by default (hidden)
  /// - Selection elevation enabled
  const EdgeOptions({
    this.type,
    // this.animated = false,
    this.hidden = false,
    this.deletable = true,
    this.selectable = true,
    this.reconnectable = true,
    this.focusable = true,
    this.elevateEdgeOnSelect = true,
  });

  /// Creates edge options for read-only/static edges.
  ///
  /// Disables all user modifications while keeping edges visible and selectable.
  /// Useful for displaying fixed diagrams or template structures.
  ///
  /// Example:
  /// ```
  /// final readOnlyEdge = Edge(
  ///   id: 'edge1',
  ///   source: 'node1',
  ///   target: 'node2',
  ///   options: EdgeOptions.readOnly(),
  /// );
  /// ```
  const EdgeOptions.readOnly({
    this.type,
    // bool animated = false,
    this.hidden = false,
  })  : deletable = false,
        selectable = true,
        reconnectable = false,
        focusable = true,
        elevateEdgeOnSelect = true;

  /// Creates edge options for fully interactive edges.
  ///
  /// Enables all interactive features.
  /// This is the most permissive configuration.
  ///
  /// Example:
  /// ```
  /// final interactiveEdge = Edge(
  ///   id: 'edge1',
  ///   source: 'node1',
  ///   target: 'node2',
  ///   options: EdgeOptions.interactive(),
  /// );
  /// ```
  const EdgeOptions.interactive({
    this.type,
    // bool animated = false, // Removed: too expensive, needs shader implementation
  })  : hidden = false,
        deletable = true,
        selectable = true,
        reconnectable = true,
        focusable = true,
        elevateEdgeOnSelect = true;

  /// Creates edge options for decorative/background edges.
  ///
  /// These edges are visible but non-interactive, useful for
  /// visual guides or background connections.
  ///
  /// Example:
  /// ```
  /// final decorativeEdge = Edge(
  ///   id: 'guide1',
  ///   source: 'node1',
  ///   target: 'node2',
  ///   options: EdgeOptions.decorative(),
  /// );
  /// ```
  const EdgeOptions.decorative({
    this.type,
    // bool animated = false,
  })  : hidden = false,
        deletable = false,
        selectable = false,
        reconnectable = false,
        focusable = false,
        elevateEdgeOnSelect = false;

  /// Returns a copy of this options object with specified fields replaced.
  ///
  /// All parameters are optional. Null values retain the current value.
  ///
  /// Example:
  /// ```
  /// final newOptions = options.copyWith(
  ///   deletable: false,
  /// );
  /// ```
  EdgeOptions copyWith({
    String? type,
    // bool? animated,
    bool? hidden,
    bool? deletable,
    bool? selectable,
    bool? reconnectable,
    bool? focusable,
    bool? elevateEdgeOnSelect,
  }) {
    return EdgeOptions(
      type: type ?? this.type,
      // animated: animated ?? this.animated,
      hidden: hidden ?? this.hidden,
      deletable: deletable ?? this.deletable,
      selectable: selectable ?? this.selectable,
      reconnectable: reconnectable ?? this.reconnectable,
      focusable: focusable ?? this.focusable,
      elevateEdgeOnSelect: elevateEdgeOnSelect ?? this.elevateEdgeOnSelect,
    );
  }

  /// Merges this options object with another, preferring the other's values.
  ///
  /// Creates a new [EdgeOptions] where non-null values from [other] override
  /// corresponding values from this instance. Useful for applying overrides
  /// or combining default options with custom settings.
  ///
  /// Example:
  /// ```
  /// final baseOptions = EdgeOptions.interactive();
  /// final customOptions = EdgeOptions(deletable: false);
  /// final merged = baseOptions.merge(customOptions);
  /// // Result: interactive options but with deletable = false
  /// ```
  EdgeOptions merge(EdgeOptions? other) {
    if (other == null) return this;

    return EdgeOptions(
      type: other.type ?? type,
      // animated: other.animated,
      hidden: other.hidden,
      deletable: other.deletable,
      selectable: other.selectable,
      reconnectable: other.reconnectable,
      focusable: other.focusable,
      elevateEdgeOnSelect: other.elevateEdgeOnSelect,
    );
  }

  /// Resolves edge options from the nearest [FlowCanvasOptions] in the widget tree.
  ///
  /// This is a convenience method that looks up the canvas options in the
  /// provided [context] and returns the configured edge options.
  ///
  /// Example:
  /// ```
  /// @override
  /// Widget build(BuildContext context) {
  ///   final options = EdgeOptions.resolve(context);
  ///   // Use options...
  /// }
  /// ```
  ///
  /// See also:
  ///
  ///  * [FlowCanvasOptions.of], for accessing the full canvas options
  static EdgeOptions resolve(BuildContext context) {
    return context.flowCanvasOptions.edgeOptions;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EdgeOptions &&
        other.type == type &&
        // other.animated == animated &&
        other.hidden == hidden &&
        other.deletable == deletable &&
        other.selectable == selectable &&
        other.reconnectable == reconnectable &&
        other.focusable == focusable &&
        other.elevateEdgeOnSelect == elevateEdgeOnSelect;
  }

  @override
  int get hashCode => Object.hash(
        type,
        // animated,
        hidden,
        deletable,
        selectable,
        reconnectable,
        focusable,
        elevateEdgeOnSelect,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('type', type, defaultValue: null));
    // properties.add(FlagProperty('animated',
    //     value: animated,
    //     defaultValue: false,
    //     ifTrue: 'animated'));
    properties.add(FlagProperty('hidden',
        value: hidden, defaultValue: false, ifTrue: 'HIDDEN'));
    properties.add(FlagProperty('deletable',
        value: deletable, defaultValue: true, ifFalse: 'not deletable'));
    properties.add(FlagProperty('selectable',
        value: selectable, defaultValue: true, ifFalse: 'not selectable'));
    properties.add(FlagProperty('reconnectable',
        value: reconnectable,
        defaultValue: true,
        ifFalse: 'not reconnectable'));
    properties.add(FlagProperty('focusable',
        value: focusable, defaultValue: true, ifFalse: 'not focusable'));
    properties.add(FlagProperty('elevateEdgeOnSelect',
        value: elevateEdgeOnSelect,
        defaultValue: true,
        ifFalse: 'no elevation on select'));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    final flags = <String>[];
    // if (animated) flags.add('animated');
    if (hidden) flags.add('hidden');
    if (!deletable) flags.add('locked');
    if (!selectable) flags.add('non-selectable');
    if (!reconnectable) flags.add('fixed');

    final flagStr = flags.isEmpty ? 'default' : flags.join(', ');
    return 'EdgeOptions(type: ${type ?? "default"}, $flagStr)';
  }
}

/// Extension methods for resolving edge options from [FlowEdge] instances.
///
/// These methods combine edge-specific options with global canvas defaults,
/// following the pattern: edge override > global default.
///
/// Example:
/// ```
/// if (edge.isSelectable(context)) {
///   // Allow selection
/// }
/// ```
extension ResolvedEdgeOptions on FlowEdge {
  /// Returns whether this edge can be selected.
  ///
  /// Uses the edge's specific `selectable` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isSelectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return selectable ?? globalOptions.selectable;
  }

  /// Returns whether this edge can be deleted.
  ///
  /// Uses the edge's specific `deletable` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isDeletable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return deletable ?? globalOptions.deletable;
  }

  /// Returns whether this edge is hidden from view.
  ///
  /// Uses the edge's specific `hidden` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isHidden(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return hidden ?? globalOptions.hidden;
  }

  /// Returns whether this edge endpoints can be reconnected.
  ///
  /// Uses the edge's specific `reconnectable` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isReconnectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return reconnectable ?? globalOptions.reconnectable;
  }

  /// Returns whether this edge can receive keyboard focus.
  ///
  /// Uses the edge's specific `focusable` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isFocusable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return focusable ?? globalOptions.focusable;
  }

  /// Returns whether this edge should be elevated when selected.
  ///
  /// Uses the edge's specific `elevateEdgeOnSelect` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  ///
  /// When true, selected edges are rendered with higher z-index.
  bool elevateOnSelect(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return elevateEdgeOnSelect ?? globalOptions.elevateEdgeOnSelect;
  }

  /// Returns the resolved edge type identifier.
  ///
  /// Uses the edge's specific `edgeType` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  String? resolvedEdgeType(BuildContext context) {
    // final globalOptions = context.flowCanvasOptions.edgeOptions;
    return type.toString();
  }
}

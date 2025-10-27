import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/options_extensions.dart';

/// Defines the behavior and interaction options for nodes in the flow canvas.
///
/// Node options control how nodes behave and respond to user interactions,
/// including dragging, selection, deletion, and connection capabilities.
///
/// ## React Flow Compatibility
///
/// This matches React Flow's node properties [web:318]:
/// ```
/// {
///   type?: string;
///   hidden?: boolean;
///   draggable?: boolean;
///   selectable?: boolean;
///   connectable?: boolean;
///   deletable?: boolean;
///   focusable?: boolean;
///   zIndex?: number; // Similar to elevateNodesOnSelected
/// }
/// ```
///
/// ## Usage
///
/// Create custom node options:
/// ```
/// const options = NodeOptions(
///   draggable: true,
///   selectable: true,
///   connectable: true,
/// );
/// ```
///
/// Use preset options:
/// ```
/// // Static nodes that can't be modified
/// final readOnly = NodeOptions.readOnly();
///
/// // Fully interactive nodes
/// final interactive = NodeOptions.interactive();
/// ```
///
/// Access from context:
/// ```
/// final options = NodeOptions.resolve(context);
/// // Or using extension
/// final options = context.flowCanvasOptions.nodeOptions;
/// ```
///
/// ## Common Patterns
///
/// **Read-only diagram**:
/// ```
/// NodeOptions(
///   draggable: false,
///   selectable: false,
///   deletable: false,
///   connectable: false,
/// )
/// ```
///
/// **Template nodes** (can be copied but not modified):
/// ```
/// NodeOptions(
///   draggable: false,
///   deletable: false,
///   selectable: true,
///   connectable: false,
/// )
/// ```
///
/// See also:
///
///  * [EdgeOptions], for edge behavior configuration
///  * [FlowCanvasOptions], for global canvas options
///  * [FlowNode], which uses these options
@immutable
class NodeOptions with Diagnosticable {
  /// The type identifier for the node (e.g., 'default', 'input', 'output').
  ///
  /// If null, uses the default node type. Custom types can be registered
  /// and used for different visual styles or behaviors.
  ///
  /// React Flow equivalent: `type`.
  final String? nodeType;

  /// Whether the node is hidden from view.
  ///
  /// Hidden nodes still exist in the graph but are not rendered.
  /// Useful for temporarily hiding nodes without removing them.
  ///
  /// React Flow equivalent: `hidden`.
  /// Defaults to false.
  final bool hidden;

  /// Whether the node can be dragged by the user.
  ///
  /// When false, the node is fixed in place and cannot be moved
  /// by dragging, though it can still be moved programmatically.
  ///
  /// React Flow equivalent: `draggable`.
  /// Defaults to true.
  final bool draggable;

  /// Whether the node can be selected by clicking or dragging.
  ///
  /// When false, the node cannot be interacted with for selection.
  /// Useful for background or decorative nodes.
  ///
  /// React Flow equivalent: `selectable`.
  /// Defaults to true.
  final bool selectable;

  /// Whether edges can be connected to/from this node.
  ///
  /// When false, users cannot create new connections to or from this node.
  /// Existing connections remain, but no new ones can be made.
  ///
  /// React Flow equivalent: `connectable`.
  /// Defaults to true.
  final bool connectable;

  /// Whether the node can be deleted by the user.
  ///
  /// When false, prevents deletion via keyboard shortcuts or UI actions.
  /// The node can still be removed programmatically.
  ///
  /// React Flow equivalent: `deletable`.
  /// Defaults to true.
  final bool deletable;

  /// Whether the node can receive keyboard focus.
  ///
  /// When true, the node can be focused and respond to keyboard events
  /// like Delete or arrow keys for navigation.
  ///
  /// React Flow equivalent: `focusable`.
  /// Defaults to true (React Flow defaults to false).
  final bool focusable;

  /// Whether to elevate the node visually when selected.
  ///
  /// When true, selected nodes are rendered on top of other nodes,
  /// making them more prominent. This typically increases their z-index.
  ///
  /// React Flow equivalent: `zIndex` (managed differently).
  /// Defaults to false.
  final bool elevateNodesOnSelected;

  /// Creates node options with the specified behaviors.
  ///
  /// All boolean parameters default to common interactive settings:
  /// - Most interactions enabled (draggable, selectable, connectable, deletable, focusable)
  /// - Visual effects disabled by default (hidden, elevateNodesOnSelected)
  const NodeOptions({
    this.nodeType,
    this.hidden = false,
    this.draggable = true,
    this.selectable = true,
    this.connectable = true,
    this.deletable = true,
    this.focusable = true,
    this.elevateNodesOnSelected = false,
  });

  /// Creates node options for read-only/static nodes.
  ///
  /// Disables all user modifications while keeping nodes visible and selectable.
  /// Useful for displaying fixed diagrams or template structures.
  ///
  /// Example:
  /// ```
  /// final readOnlyNode = FlowNode(
  ///   id: 'node1',
  ///   position: Offset(0, 0),
  ///   options: NodeOptions.readOnly(),
  /// );
  /// ```
  const NodeOptions.readOnly({
    String? nodeType,
    bool hidden = false,
  })  : nodeType = nodeType,
        hidden = hidden,
        draggable = false,
        selectable = true,
        connectable = false,
        deletable = false,
        focusable = true,
        elevateNodesOnSelected = false;

  /// Creates node options for fully interactive nodes.
  ///
  /// Enables all interactive features with visual effects.
  /// This is the most permissive configuration.
  ///
  /// Example:
  /// ```
  /// final interactiveNode = FlowNode(
  ///   id: 'node1',
  ///   position: Offset(0, 0),
  ///   options: NodeOptions.interactive(),
  /// );
  /// ```
  const NodeOptions.interactive({
    String? nodeType,
  })  : nodeType = nodeType,
        hidden = false,
        draggable = true,
        selectable = true,
        connectable = true,
        deletable = true,
        focusable = true,
        elevateNodesOnSelected = true;

  /// Creates node options for template/palette nodes.
  ///
  /// These nodes can be selected and copied but not modified directly.
  /// Useful for node palettes or template libraries.
  ///
  /// Example:
  /// ```
  /// final templateNode = FlowNode(
  ///   id: 'template1',
  ///   position: Offset(0, 0),
  ///   options: NodeOptions.template(),
  /// );
  /// ```
  const NodeOptions.template({
    String? nodeType,
  })  : nodeType = nodeType,
        hidden = false,
        draggable = false,
        selectable = true,
        connectable = false,
        deletable = false,
        focusable = true,
        elevateNodesOnSelected = false;

  /// Creates node options for decorative/background nodes.
  ///
  /// These nodes are visible but non-interactive, useful for
  /// background graphics or visual guides.
  ///
  /// Example:
  /// ```
  /// final decorativeNode = FlowNode(
  ///   id: 'background1',
  ///   position: Offset(0, 0),
  ///   options: NodeOptions.decorative(),
  /// );
  /// ```
  const NodeOptions.decorative({
    String? nodeType,
  })  : nodeType = nodeType,
        hidden = false,
        draggable = false,
        selectable = false,
        connectable = false,
        deletable = false,
        focusable = false,
        elevateNodesOnSelected = false;

  /// Returns a copy of this options object with specified fields replaced.
  ///
  /// All parameters are optional. Null values retain the current value.
  ///
  /// Example:
  /// ```
  /// final newOptions = options.copyWith(
  ///   draggable: false,
  ///   deletable: false,
  /// );
  /// ```
  NodeOptions copyWith({
    String? nodeType,
    bool? hidden,
    bool? draggable,
    bool? selectable,
    bool? connectable,
    bool? deletable,
    bool? focusable,
    bool? elevateNodesOnSelected,
  }) {
    return NodeOptions(
      nodeType: nodeType ?? this.nodeType,
      hidden: hidden ?? this.hidden,
      draggable: draggable ?? this.draggable,
      selectable: selectable ?? this.selectable,
      connectable: connectable ?? this.connectable,
      deletable: deletable ?? this.deletable,
      focusable: focusable ?? this.focusable,
      elevateNodesOnSelected:
          elevateNodesOnSelected ?? this.elevateNodesOnSelected,
    );
  }

  /// Merges this options object with another, preferring the other's values.
  ///
  /// Creates a new [NodeOptions] where non-null values from [other] override
  /// corresponding values from this instance. Useful for applying overrides
  /// or combining default options with custom settings.
  ///
  /// Example:
  /// ```
  /// final baseOptions = NodeOptions.interactive();
  /// final customOptions = NodeOptions(deletable: false);
  /// final merged = baseOptions.merge(customOptions);
  /// // Result: interactive options but with deletable = false
  /// ```
  NodeOptions merge(NodeOptions? other) {
    if (other == null) return this;

    return NodeOptions(
      nodeType: other.nodeType ?? nodeType,
      hidden: other.hidden,
      draggable: other.draggable,
      selectable: other.selectable,
      connectable: other.connectable,
      deletable: other.deletable,
      focusable: other.focusable,
      elevateNodesOnSelected: other.elevateNodesOnSelected,
    );
  }

  /// Resolves node options from the nearest [FlowCanvasOptions] in the widget tree.
  ///
  /// This is a convenience method that looks up the canvas options in the
  /// provided [context] and returns the configured node options.
  ///
  /// Example:
  /// ```
  /// @override
  /// Widget build(BuildContext context) {
  ///   final options = NodeOptions.resolve(context);
  ///   // Use options...
  /// }
  /// ```
  ///
  /// See also:
  ///
  ///  * [FlowCanvasOptions.of], for accessing the full canvas options
  static NodeOptions resolve(BuildContext context) {
    return context.flowCanvasOptions.nodeOptions;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NodeOptions &&
        other.nodeType == nodeType &&
        other.hidden == hidden &&
        other.draggable == draggable &&
        other.selectable == selectable &&
        other.connectable == connectable &&
        other.deletable == deletable &&
        other.focusable == focusable &&
        other.elevateNodesOnSelected == elevateNodesOnSelected;
  }

  @override
  int get hashCode => Object.hash(
        nodeType,
        hidden,
        draggable,
        selectable,
        connectable,
        deletable,
        focusable,
        elevateNodesOnSelected,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('nodeType', nodeType, defaultValue: null));
    properties.add(FlagProperty('hidden',
        value: hidden, defaultValue: false, ifTrue: 'HIDDEN'));
    properties.add(FlagProperty('draggable',
        value: draggable, defaultValue: true, ifFalse: 'not draggable'));
    properties.add(FlagProperty('selectable',
        value: selectable, defaultValue: true, ifFalse: 'not selectable'));
    properties.add(FlagProperty('connectable',
        value: connectable, defaultValue: true, ifFalse: 'not connectable'));
    properties.add(FlagProperty('deletable',
        value: deletable, defaultValue: true, ifFalse: 'not deletable'));
    properties.add(FlagProperty('focusable',
        value: focusable, defaultValue: true, ifFalse: 'not focusable'));
    properties.add(FlagProperty('elevateNodesOnSelected',
        value: elevateNodesOnSelected,
        defaultValue: false,
        ifTrue: 'elevates on select'));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    final flags = <String>[];
    if (hidden) flags.add('hidden');
    if (!draggable) flags.add('locked');
    if (!selectable) flags.add('non-selectable');
    if (!connectable) flags.add('isolated');
    if (!deletable) flags.add('permanent');

    final flagStr = flags.isEmpty ? 'default' : flags.join(', ');
    return 'NodeOptions(nodeType: ${nodeType ?? "default"}, $flagStr)';
  }
}

/// Extension methods for resolving node options from [FlowNode] instances.
///
/// These methods combine node-specific options with global canvas defaults,
/// following the pattern: node override > global default.
///
/// Example:
/// ```
/// if (node.isDraggable(context)) {
///   // Allow dragging
/// }
/// ```
extension ResolvedNodeOptions on FlowNode {
  /// Returns whether this node can be dragged.
  ///
  /// Uses the node's specific `draggable` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isDraggable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return draggable ?? globalOptions.draggable;
  }

  /// Returns whether this node can be selected.
  ///
  /// Uses the node's specific `selectable` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isSelectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return selectable ?? globalOptions.selectable;
  }

  /// Returns whether this node can be deleted.
  ///
  /// Uses the node's specific `deletable` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isDeletable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return deletable ?? globalOptions.deletable;
  }

  /// Returns whether this node is hidden from view.
  ///
  /// Uses the node's specific `hidden` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isHidden(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return hidden ?? globalOptions.hidden;
  }

  /// Returns whether edges can be connected to/from this node.
  ///
  /// Uses the node's specific `connectable` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isConnectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return connectable ?? globalOptions.connectable;
  }

  /// Returns whether this node should be elevated when selected.
  ///
  /// Uses the node's specific `elevateNodeOnSelected` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  ///
  /// When true, selected nodes are rendered with higher z-index.
  bool elevateOnSelect(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return elevateNodeOnSelected ?? globalOptions.elevateNodesOnSelected;
  }

  /// Returns whether this node can receive keyboard focus.
  ///
  /// Uses the node's specific `focusable` option if set, otherwise
  /// falls back to the global default from [FlowCanvasOptions].
  bool isFocusable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return focusable ?? globalOptions.focusable;
  }
}

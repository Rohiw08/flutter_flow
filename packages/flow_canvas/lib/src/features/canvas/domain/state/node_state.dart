import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_state.freezed.dart';

/// Represents the runtime (ephemeral) state of a single node.
///
/// This is **not persisted** — it exists only while the canvas is active.
/// It tracks UI and interaction-level details for a node, separate from
/// its core model ([FlowNode]) which contains structural data.
///
/// ## Examples
///
/// ```
/// // Mark node as selected
/// state = state.copyWith(selected: true);
///
/// // Mark node as being dragged and provide movement bounds
/// state = state.copyWith(dragging: true, extent: nodeDragExtent);
///
/// // Reset all transient flags
/// state = const NodeRuntimeState();
/// ```
@freezed
abstract class NodeRuntimeState with _$NodeRuntimeState {
  /// Creates a runtime state for a node.
  ///
  /// The [extent] represents visual or movement boundaries that apply
  /// only while the node is actively being manipulated.
  const factory NodeRuntimeState({
    /// Whether this node is currently hovered.
    @Default(false) bool hovered,

    /// Whether this node is currently selected.
    ///
    /// Selected nodes are typically rendered with an outline, bring-to-front
    /// highlight, or show resize handles.
    @Default(false) bool selected,

    /// Whether this node is currently being dragged.
    ///
    /// This flag is set when the user initiates a drag gesture to move
    /// the node across the canvas.
    @Default(false) bool dragging,

    /// Whether this node is in resize mode.
    ///
    /// This is true if the user is currently resizing the node via
    /// corner or edge controls.
    @Default(false) bool resizing,

    /// Whether this node triggers an automatic expansion of its parent group.
    ///
    /// Useful when dragging or resizing causes a containing node or group
    /// to expand dynamically to fit this node.
    @Default(false) bool expandParent,

    /// The rectangular bounds that define the node's
    /// interactive or layout extent.
    ///
    /// This can represent spatial constraints (drag limits) or
    /// the node's visual boundary on the canvas during a gesture.
    Rect? extent,
  }) = _NodeRuntimeState;

  /// Returns a fresh, unselected, inactive runtime state.
  static const NodeRuntimeState idle = NodeRuntimeState();
}

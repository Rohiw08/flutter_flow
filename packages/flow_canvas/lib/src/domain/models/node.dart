import 'dart:math' as math;
import 'package:flow_canvas/src/features/canvas/domain/models/handle.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'node.freezed.dart';

@freezed
abstract class FlowNode<T> with _$FlowNode<T> {
  const FlowNode._();

  // The primary, generated constructor
  const factory FlowNode({
    /// Unique identifier for this node.
    required String id,

    /// Optional ID of the parent node (for nested/grouped nodes).
    String? parentId,

    /// Type identifier for this node (e.g., 'default', 'input', 'output').
    required String type,

    /// Position of the node's center in canvas coordinates.
    required Offset position,

    /// Custom data attached to this node.
    ///
    /// Use a sealed class hierarchy for type-safe node variants:
    /// ```dart
    /// sealed class NodeData {}
    /// class InputData extends NodeData { ... }
    /// class ProcessData extends NodeData { ... }
    /// ```
    required T data,

    /// Size of the node in logical pixels.
    @Default(Size(200, 100)) Size size,

    /// Z-index for rendering order (higher values render on top).
    @Default(0) int zIndex,

    /// Map of handles (connection points) attached to this node.
    @Default({}) Map<String, FlowHandle> handles,

    /// Whether this node should be hidden from view.
    bool? hidden,

    /// Whether this node can be dragged by the user.
    bool? draggable,

    /// Whether this node can be selected by the user.
    bool? selectable,

    /// Whether this node can be hovered by the user.
    bool? hoverable,

    /// Whether edges can be connected to/from this node.
    bool? connectable,

    /// Whether this node can be deleted by the user.
    bool? deletable,

    /// Whether this node can receive keyboard focus.
    bool? focusable,

    /// Whether this node triggers an automatic expansion of its parent group.
    @Default(false) bool expandParent,
  }) = _FlowNode<T>;

  /// Custom factory method to create a FlowNode with common defaults,
  /// especially for converting a list of handles to a map.
  factory FlowNode.create({
    /// Unique identifier for this node.
    required String id,

    /// Optional ID of the parent node (for nested/grouped nodes).
    String? parentId,

    /// Type identifier for this node (e.g., 'default', 'input', 'output').
    required String type,

    /// Position of the node's center in canvas coordinates.
    required Offset position,

    /// Custom data attached to this node.
    ///
    /// Use a sealed class hierarchy for type-safe node variants:
    /// ```dart
    /// sealed class NodeData {}
    /// class InputData extends NodeData { ... }
    /// class ProcessData extends NodeData { ... }
    /// ```
    required T data,

    /// Size of the node in logical pixels.
    Size size = const Size(200, 100),

    /// Z-index for rendering order (higher values render on top).
    int zIndex = 0,

    /// Map of handles (connection points) attached to this node.
    List<FlowHandle> handles = const [],

    /// Whether this node should be hidden from view.
    bool? hidden,

    /// Whether this node can be dragged by the user.
    bool? draggable,

    /// Whether this node can be selected by the user.
    bool? selectable,

    /// Whether this node can be hovered by the user.
    bool? hoverable,

    /// Whether edges can be connected to/from this node.
    bool? connectable,

    /// Whether this node can be deleted by the user.
    bool? deletable,

    /// Whether this node can receive keyboard focus.
    bool? focusable,

    /// Whether this node triggers an automatic expansion of its parent group.
    bool expandParent = false,
  }) {
    final handlesMap = {
      for (var handle in handles) handle.id: handle,
    };
    // Call the primary constructor with the correctly formatted map
    return FlowNode(
      id: id,
      type: type,
      position: position,
      size: size,
      parentId: parentId,
      data: data,
      handles: handlesMap,
      zIndex: zIndex,
      hidden: hidden,
      draggable: draggable,
      selectable: selectable,
      hoverable: hoverable,
      connectable: connectable,
      deletable: deletable,
      focusable: focusable,
      expandParent: expandParent,
    );
  }

  /// Returns the center point of the node.
  Offset get center => position;

  /// Returns the top-left corner of the node's bounding box.
  Offset get topLeft => Offset(
        position.dx - size.width / 2,
        position.dy - size.height / 2,
      );

  /// Returns the top-right corner of the node's bounding box.
  Offset get topRight => Offset(
        position.dx + size.width / 2,
        position.dy - size.height / 2,
      );

  /// Returns the bottom-left corner of the node's bounding box.
  Offset get bottomLeft => Offset(
        position.dx - size.width / 2,
        position.dy + size.height / 2,
      );

  /// Returns the bottom-right corner of the node's bounding box.
  Offset get bottomRight => Offset(
        position.dx + size.width / 2,
        position.dy + size.height / 2,
      );

  /// Returns the rectangular bounds of the node.
  Rect get rect => Rect.fromCenter(
        center: position,
        width: size.width,
        height: size.height,
      );

  /// Returns expanded bounds for hit testing (includes hitTestPadding).
  Rect get interactionRect {
    final maxHandleSize =
        handles.values.map((h) => h.size).fold<double>(0, (max, size) {
      final larger = math.max(size.width, size.height);
      return math.max(larger, max);
    });
    return Rect.fromCenter(
      center: center,
      width: size.width + maxHandleSize,
      height: size.height + maxHandleSize,
    );
  }

  // --- Coordinate Conversions ---

  /// Converts a canvas position to a node-relative position.
  Offset toNodeSpace(Offset canvasPosition) => canvasPosition - topLeft;

  /// Converts a node-relative position to canvas coordinates.
  Offset toCanvasSpace(Offset nodePosition) => topLeft + nodePosition;
}


/*

  // ==========================================================================
  // Hit Testing
  // ==========================================================================

  /// Returns true if the given point is within this node's bounds.
  bool containsPoint(Offset point) => rect.contains(point);

  /// Returns true if the given point is within the interaction area (with padding).
  bool containsPointExpanded(Offset point) => interactionRect.contains(point);

  /// Returns true if this node intersects with another node.
  bool intersects(FlowNode other) => rect.overlaps(other.rect);

  /// Returns true if this node completely contains another node.
  bool contains(FlowNode other) =>
      rect.contains(other.topLeft) && rect.contains(other.bottomRight);

  /// Returns the distance from this node's center to another node's center.
  double distanceTo(FlowNode other) => (position - other.position).distance;

  // ==========================================================================
  // Parent/Child Relationships
  // ==========================================================================

  /// Returns true if this node has a parent.
  bool get hasParent => parentId != null;

  /// Returns true if this node is the parent of another node.
  bool isParentOf(FlowNode other) => other.parentId == id;

  /// Returns true if this node is a child of another node.
  bool isChildOf(FlowNode other) => parentId == other.id;

   // ==========================================================================
  // Handle Management
  // ==========================================================================

  /// Returns true if this node has any handles.
  bool get hasHandles => handles.isNotEmpty;

  /// Returns the number of handles on this node.
  int get handleCount => handles.length;

  /// Gets a handle by its ID. Returns null if not found.
  FlowHandle? getHandle(String handleId) {
    return handles[handleId];
  }

  /// Returns all handles of the specified type.
  Iterable<FlowHandle> getHandlesByType(HandleType type) =>
      handles.where((h) => h.type == type);

  /// Returns all source (output) handles.
  Iterable<FlowHandle> get sourceHandles =>
      handles.where((h) => h.type == HandleType.source);

  /// Returns all target (input) handles.
  Iterable<FlowHandle> get targetHandles =>
      handles.where((h) => h.type == HandleType.target);

  // TODO: add this is handles connectable thing
  // /// Returns all connectable handles.
  // Iterable<FlowHandle> get connectableHandles =>
  //     handles.values.where((h) => h.connectable);

*/
import 'dart:ui';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/handle.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node.freezed.dart';

/// Represents a node in the flow canvas.
///
/// A node is a visual element that can be positioned, sized, connected to other
/// nodes via edges, and interacted with by users. Nodes can contain handles for
/// creating connections and can have custom data attached.
///
/// ## Usage
///
/// Create a basic node:
/// ```
/// final node = FlowNode(
///   id: 'node-1',
///   type: 'default',
///   position: Offset(100, 100),
///   size: Size(200, 100),
/// );
/// ```
///
/// Create a node with handles:
/// ```
/// final node = FlowNode(
///   id: 'node-1',
///   type: 'process',
///   position: Offset(100, 100),
///   size: Size(200, 100),
///   handles: {
///     'input': FlowHandle.leftInput(
///       id: 'input',
///       nodeHeight: 100,
///     ),
///     'output': FlowHandle.rightOutput(
///       id: 'output',
///       nodeWidth: 200,
///       nodeHeight: 100,
///     ),
///   },
/// );
/// ```
///
/// Query node state:
/// ```
/// if (node.containsPoint(pointerPosition)) {
///   print('Pointer is over node');
/// }
///
/// final handle = node.getHandleAt(localPosition);
/// if (handle != null) {
///   print('Found handle: ${handle.id}');
/// }
/// ```
///
/// See also:
///
///  * [FlowHandle], for connection points on nodes
///  * [FlowEdge], for connections between nodes
@freezed
abstract class FlowNode with _$FlowNode {
  const FlowNode._();

  /// Creates a flow node.
  ///
  /// The [id] must be unique within the canvas.
  ///
  /// The [position] represents the center of the node in canvas coordinates.
  ///
  /// The [size] defines the node's dimensions.
  const factory FlowNode({
    /// Unique identifier for this node.
    required String id,

    /// Type identifier for this node (e.g., 'default', 'input', 'output').
    ///
    /// Used for applying type-specific styling or behavior.
    required String type,

    /// Position of the node's center in canvas coordinates.
    ///
    /// This is the reference point for the node. The visual representation
    /// is rendered centered on this position.
    required Offset position,

    /// Size of the node in logical pixels.
    ///
    /// Defines the width and height of the node's bounding box.
    required Size size,

    /// Optional ID of the parent node (for nested/grouped nodes).
    ///
    /// When set, this node is a child of another node, creating a
    /// parent-child hierarchy for grouping or nesting.
    String? parentId,

    /// Map of handles attached to this node, keyed by handle ID.
    ///
    /// Handles define connection points where edges can attach.
    /// Handle positions are relative to the node's top-left corner.
    ///
    /// Example:
    /// ```
    /// handles: {
    ///   'input': FlowHandle(/* ... */),
    ///   'output-1': FlowHandle(/* ... */),
    ///   'output-2': FlowHandle(/* ... */),
    /// }
    /// ```
    @Default({}) Map<String, FlowHandle> handles,

    /// Custom data that can be attached to this node.
    ///
    /// Store application-specific information like labels, values,
    /// configuration, etc.
    @Default({}) Map<String, dynamic> data,

    /// Z-index for rendering order (higher values render on top).
    ///
    /// Used for layering nodes. Selected nodes are often elevated
    /// temporarily by increasing their z-index.
    @Default(0) int zIndex,

    /// Padding around the node for easier hit testing in pixels.
    ///
    /// Expands the interactive area beyond the visual bounds, making
    /// the node easier to click/select.
    @Default(10.0) double hitTestPadding,

    /// Whether this node should be hidden from view.
    ///
    /// Hidden nodes are not rendered but remain in the data structure.
    /// If null, uses the global canvas setting.
    bool? hidden,

    /// Whether this node can be dragged by the user.
    ///
    /// If null, uses the global canvas setting.
    bool? draggable,

    /// Whether this node can be selected by the user.
    ///
    /// If null, uses the global canvas setting.
    bool? selectable,

    /// Whether edges can be connected to/from this node.
    ///
    /// If null, uses the global canvas setting.
    bool? connectable,

    /// Whether this node can be deleted by the user.
    ///
    /// If null, uses the global canvas setting.
    bool? deletable,

    /// Whether this node can receive keyboard focus.
    ///
    /// If null, uses the global canvas setting.
    bool? focusable,

    /// Whether this node should be elevated when selected.
    ///
    /// If null, uses the global canvas setting.
    bool? elevateNodeOnSelected,
  }) = _FlowNode;

  // ==========================================================================
  // Position & Bounds Calculations
  // ==========================================================================

  /// Returns the center point of the node.
  ///
  /// This is the same as [position] - the reference point for the node.
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
  ///
  /// Example:
  /// ```
  /// canvas.drawRect(node.rect, paint);
  /// ```
  Rect get rect => Rect.fromCenter(
        center: position,
        width: size.width,
        height: size.height,
      );

  /// Returns expanded bounds for hit testing.
  ///
  /// Includes the [hitTestPadding] to make the node easier to interact with.
  ///
  /// Example:
  /// ```
  /// if (node.interactionRect.contains(pointerPosition)) {
  ///   // User clicked near the node
  /// }
  /// ```
  Rect get interactionRect => Rect.fromCenter(
        center: position,
        width: size.width + hitTestPadding * 2,
        height: size.height + hitTestPadding * 2,
      );

  // ==========================================================================
  // Hit Testing
  // ==========================================================================

  /// Returns true if the given point (in canvas coordinates) is within this node.
  ///
  /// Uses the standard [rect] for testing.
  ///
  /// Example:
  /// ```
  /// void onPointerDown(PointerDownEvent event) {
  ///   final clickedNode = nodes.firstWhere(
  ///     (node) => node.containsPoint(event.localPosition),
  ///     orElse: () => null,
  ///   );
  /// }
  /// ```
  bool containsPoint(Offset point) => rect.contains(point);

  /// Returns true if the given point is within the interaction area.
  ///
  /// Uses the expanded [interactionRect] for easier selection.
  bool containsPointExpanded(Offset point) => interactionRect.contains(point);

  /// Returns true if this node intersects with another node.
  ///
  /// Useful for collision detection or spatial queries.
  ///
  /// Example:
  /// ```
  /// final overlapping = nodes.where(
  ///   (other) => node.intersects(other)
  /// );
  /// ```
  bool intersects(FlowNode other) => rect.overlaps(other.rect);

  /// Returns true if this node's bounds completely contain another node.
  ///
  /// Useful for group/container logic.
  bool contains(FlowNode other) =>
      rect.contains(other.topLeft) && rect.contains(other.bottomRight);

  /// Returns the distance from this node's center to another node's center.
  ///
  /// Example:
  /// ```
  /// final closest = nodes.reduce((a, b) =>
  ///   node.distanceTo(a) < node.distanceTo(b) ? a : b
  /// );
  /// ```
  double distanceTo(FlowNode other) => (position - other.position).distance;

  // ==========================================================================
  // Handle Queries
  // ==========================================================================

  /// Returns true if this node has any handles.
  bool get hasHandles => handles.isNotEmpty;

  /// Returns the number of handles on this node.
  int get handleCount => handles.length;

  /// Gets a handle by its ID.
  ///
  /// Returns null if no handle with the given ID exists.
  ///
  /// Example:
  /// ```
  /// final handle = node.getHandle('output-1');
  /// if (handle != null && handle.isConnectable) {
  ///   // Can create connection
  /// }
  /// ```
  FlowHandle? getHandle(String handleId) => handles[handleId];

  /// Gets the handle at the given position (relative to node's top-left).
  ///
  /// Returns the first handle that contains the point, or null if none found.
  ///
  /// Example:
  /// ```
  /// // Convert canvas position to node-relative position
  /// final nodeRelative = canvasPosition - node.topLeft;
  /// final handle = node.getHandleAt(nodeRelative);
  /// ```
  FlowHandle? getHandleAt(Offset localPosition, {double expansion = 0}) {
    for (final handle in handles.values) {
      if (expansion > 0) {
        if (handle.containsPointExpanded(localPosition, expansion)) {
          return handle;
        }
      } else {
        if (handle.containsPoint(localPosition)) {
          return handle;
        }
      }
    }
    return null;
  }

  /// Returns all handles of the specified type.
  ///
  /// Example:
  /// ```
  /// final inputs = node.getHandlesByType(HandleType.target);
  /// final outputs = node.getHandlesByType(HandleType.source);
  /// ```
  Iterable<FlowHandle> getHandlesByType(HandleType type) =>
      handles.values.where((h) => h.type == type);

  /// Returns all source (output) handles.
  Iterable<FlowHandle> get sourceHandles =>
      handles.values.where((h) => h.isSource);

  /// Returns all target (input) handles.
  Iterable<FlowHandle> get targetHandles =>
      handles.values.where((h) => h.isTarget);

  /// Returns all connectable handles.
  Iterable<FlowHandle> get connectableHandles =>
      handles.values.where((h) => h.isConnectable);

  /// Converts a canvas position to a node-relative position.
  ///
  /// Useful for handle hit testing and relative positioning.
  ///
  /// Example:
  /// ```
  /// final nodeRelative = node.toNodeSpace(canvasPosition);
  /// final handle = node.getHandleAt(nodeRelative);
  /// ```
  Offset toNodeSpace(Offset canvasPosition) => canvasPosition - topLeft;

  /// Converts a node-relative position to canvas coordinates.
  ///
  /// Example:
  /// ```
  /// final handleCanvasPos = node.toCanvasSpace(handle.position);
  /// ```
  Offset toCanvasSpace(Offset nodePosition) => topLeft + nodePosition;

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
  // Data Access Helpers
  // ==========================================================================

  /// Returns true if this node has custom data attached.
  bool get hasData => data.isNotEmpty;

  /// Gets a data value by key, with type safety.
  ///
  /// Returns null if the key doesn't exist or the type doesn't match.
  ///
  /// Example:
  /// ```
  /// final label = node.getData<String>('label');
  /// final value = node.getData<double>('value');
  /// ```
  T? getData<T>(String key) {
    final value = data[key];
    return value is T ? value : null;
  }

  /// Gets a data value by key, with a fallback default.
  ///
  /// Example:
  /// ```
  /// final label = node.getDataOrDefault('label', 'Unnamed Node');
  /// ```
  T getDataOrDefault<T>(String key, T defaultValue) {
    final value = getData<T>(key);
    return value ?? defaultValue;
  }
}

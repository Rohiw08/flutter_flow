import 'dart:math';
import 'package:flutter/painting.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node_handle.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node.freezed.dart';

/// Generates a unique node ID. This can remain a utility function.
String _generateUniqueNodeId() {
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  final random = Random().nextInt(999999);
  return 'node_${timestamp}_$random';
}

/// Represents a single node in the flow canvas.
@freezed
abstract class FlowNode with _$FlowNode {
  const factory FlowNode({
    required String id,
    required Offset position,
    required Size size,
    required String type,
    @Default([]) List<NodeHandle> handles,
    @Default({}) Map<String, dynamic> data,
    @Default(false) bool isSelected,

    // Interaction configuration
    @Default(true) bool isDraggable,
    @Default(true) bool isSelectable,

    // Note: UI-specific state like 'cachedImage' and 'needsRepaint'
    // will be removed. The new architecture handles this differently.
  }) = _FlowNode;

  const FlowNode._(); // Private constructor for custom methods

  /// Creates a new node with a unique ID.
  factory FlowNode.create({
    required Offset position,
    required Size size,
    required String type,
    List<NodeHandle> handles = const [],
    Map<String, dynamic> data = const {},
    bool isSelected = false,
    bool isDraggable = true,
    bool isSelectable = true,
  }) {
    return FlowNode(
      id: _generateUniqueNodeId(),
      position: position,
      size: size,
      type: type,
      handles: handles,
      data: data,
      isSelected: isSelected,
      isDraggable: isDraggable,
      isSelectable: isSelectable,
    );
  }

  // A getter for the node's rectangle, derived from its properties.
  Rect get rect =>
      Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
}

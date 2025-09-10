import 'package:built_collection/built_collection.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/handle.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/utility/random_id_generator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node.freezed.dart';

/// Represents a single node in the flow canvas.
@freezed
abstract class FlowNode with _$FlowNode {
  const FlowNode._();
  factory FlowNode({
    required String type,
    required String id,
    required Offset position,
    required Size size,
    required BuiltMap<String, NodeHandle> internalHandles,
    required BuiltMap<String, dynamic> internalData,
    @Default(false) bool isSelected,
    @Default(true) bool isDraggable,
    @Default(true) bool isSelectable,
    @Default(false) bool isHidden,
    @Default(false) bool isDragging,
    @Default(false) bool isResizing,
    @Default(0) int zIndex,
  }) = _FlowNode;

  // Getters
  Map<String, NodeHandle> get handles =>
      Map.unmodifiable(internalHandles.asMap());
  Map<String, dynamic> get data => Map.unmodifiable(internalData.asMap());

  // A getter for the node's rectangle, derived from its properties.
  Rect get rect =>
      Rect.fromLTWH(position.dx, position.dy, size.width, size.height);

  /// Creates a new node with a unique ID.
  factory FlowNode.create({
    required Offset position,
    required Size size,
    required String type,
    Map<String, NodeHandle>? handles,
    Map<String, dynamic>? data,
    bool isSelected = false,
    bool isDraggable = true,
    bool isSelectable = true,
    bool isHidden = false,
    bool isDragging = false,
    bool isResizing = false,
    int zIndex = 0,
  }) {
    return FlowNode(
      id: generateUniqueId(),
      position: position,
      size: size,
      type: type,
      internalHandles: BuiltMap<String, NodeHandle>(handles ?? {}),
      internalData: BuiltMap<String, dynamic>(data ?? {}),
      isSelected: isSelected,
      isDraggable: isDraggable,
      isSelectable: isSelectable,
      zIndex: zIndex,
      isHidden: isHidden,
      isDragging: isDraggable,
      isResizing: isResizing,
    );
  }
}

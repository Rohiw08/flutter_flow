import 'package:flutter/painting.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/handle.dart';
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
    @Default({}) Map<String, NodeHandle> handles,
    @Default({}) Map<String, dynamic> data,
    @Default(0) int zIndex,
    bool? hidden,
    bool? draggable,
    bool? selectable,
    bool? connectable,
    bool? deletable,
    bool? focusable,
    bool? elevateNodeOnSelected,
  }) = _FlowNode;

  Offset get center =>
      Offset(position.dx + size.width / 2, position.dy + size.height / 2);

  // A getter for the node's rectangle, derived from its properties.
  Rect get rect =>
      Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
}

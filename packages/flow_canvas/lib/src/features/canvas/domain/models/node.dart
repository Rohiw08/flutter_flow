import 'dart:ui';
import 'package:flow_canvas/src/features/canvas/domain/models/handle.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node.freezed.dart';

@freezed
abstract class FlowNode with _$FlowNode {
  const FlowNode._();

  // The primary, generated constructor
  const factory FlowNode({
    required String type,
    required String id,
    required Offset position,
    required Size size,
    String? parentId,
    @Default({}) Map<String, NodeHandle> handles,
    @Default({}) Map<String, dynamic> data,
    @Default(0) int zIndex,
    @Default(10) double hitTestPadding,
    bool? hidden,
    bool? draggable,
    bool? selectable,
    bool? connectable,
    bool? deletable,
    bool? focusable,
    bool? elevateNodeOnSelected,
  }) = _FlowNode;

  /// Custom factory method to create a FlowNode with common defaults,
  /// especially for converting a list of handles to a map.
  factory FlowNode.create({
    required String id,
    required String type,
    required Offset position,
    required Size size,
    int zIndex = 0,
    double hitTestPadding = 10,
    String? parentId,
    @Default([]) List<NodeHandle>? handles,
    @Default({}) Map<String, dynamic>? data,
    bool? hidden,
    bool? draggable,
    bool? selectable,
    bool? connectable,
    bool? deletable,
    bool? focusable,
    bool? elevateNodeOnSelected,
  }) {
    final handlesMap = handles != null
        ? {for (var handle in handles) handle.id: handle}
        : <String, NodeHandle>{};
    // Call the primary constructor with the correctly formatted map
    return FlowNode(
      id: id,
      type: type,
      position: position,
      size: size,
      parentId: parentId,
      data: data ?? <String, dynamic>{},
      handles: handlesMap,
      zIndex: zIndex,
      hitTestPadding: hitTestPadding, // Add this line
      hidden: hidden,
      draggable: draggable,
      selectable: selectable,
      connectable: connectable,
      deletable: deletable,
      focusable: focusable,
      elevateNodeOnSelected: elevateNodeOnSelected,
    );
  }

  // Getters remain the same
  Offset get center => position;

  Offset get topLeft =>
      Offset(position.dx - size.width / 2, position.dy - size.height / 2);

  Rect get rect =>
      Rect.fromLTWH(topLeft.dx, topLeft.dy, size.width, size.height);
}

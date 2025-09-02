import 'dart:ui';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_handle.freezed.dart';

/// Describes a handle on a node for making connections.
@freezed
abstract class NodeHandle with _$NodeHandle {
  const factory NodeHandle({
    required String id,
    required HandleType type,
    required Offset
        position, // Position relative to the node's origin (top-left)
    @Default(true) bool isConnectable,
  }) = _NodeHandle;
}

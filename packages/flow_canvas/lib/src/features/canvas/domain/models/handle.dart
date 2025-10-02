import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'handle.freezed.dart';

/// Describes a handle on a node for making connections.
@freezed
abstract class NodeHandle with _$NodeHandle {
  const NodeHandle._();

  const factory NodeHandle({
    required String id,
    required HandleType type,
    required Offset position,
    @Default(true) bool isConnectable,
    @Default(10) double size,
  }) = _NodeHandle;

  Offset get center => position;
}

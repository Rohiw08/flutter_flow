import 'dart:ui';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'handle.freezed.dart';

/// Describes a handle on a node for making connections.
@freezed
abstract class NodeHandle with _$NodeHandle {
  const factory NodeHandle({
    required String id,
    required HandleType type,
    required Offset position,
    @Default(true) bool isConnectable,
    @Default(Size(10, 10)) Size size,
  }) = _NodeHandle;
}

import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_state.freezed.dart';

@freezed
abstract class NodeRuntimeState with _$NodeRuntimeState {
  const factory NodeRuntimeState({
    @Default(false) bool selected,
    @Default(false) bool dragging,
    @Default(false) bool resizing,
    @Default(false) bool expandParent,
    Rect? extent,
  }) = _NodeRuntimeState;
}

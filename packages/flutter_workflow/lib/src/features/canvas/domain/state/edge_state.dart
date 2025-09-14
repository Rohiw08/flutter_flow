import 'package:freezed_annotation/freezed_annotation.dart';

part 'edge_state.freezed.dart';

@freezed
abstract class EdgeRuntimeState with _$EdgeRuntimeState {
  const factory EdgeRuntimeState({
    @Default(true) bool isValid,
    @Default(false) bool selected,
    @Default(false) bool hovered,
    @Default(false) bool isAnimating,
    @Default(false) bool isReconnecting,
  }) = _EdgeRuntimeState;
}

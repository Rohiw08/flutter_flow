import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state.freezed.dart';

@freezed
abstract class FlowConnectionState with _$FlowConnectionState {
  const factory FlowConnectionState({
    @Default(false) bool isAnimating,
    @Default(false) bool isValid,
  }) = _FlowConnectionState;
}

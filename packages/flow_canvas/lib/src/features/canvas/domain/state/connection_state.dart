import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state.freezed.dart';

@freezed
abstract class FlowConnectionRuntimeState with _$FlowConnectionRuntimeState {
  const factory FlowConnectionRuntimeState({
    @Default(false) bool isAnimating,
    @Default(false) bool isValid,
    String? potentialTargetHandleKey,
  }) = _FlowConnectionRuntimeState;
}

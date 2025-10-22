import 'package:flow_canvas/src/shared/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state.freezed.dart';

@freezed
abstract class FlowConnectionRuntimeState with _$FlowConnectionRuntimeState {
  const factory FlowConnectionRuntimeState({
    @Default(ConnectionValidity.none) ConnectionValidity validity,
    String? potentialTargetHandleKey,
  }) = _FlowConnectionRuntimeState;
}

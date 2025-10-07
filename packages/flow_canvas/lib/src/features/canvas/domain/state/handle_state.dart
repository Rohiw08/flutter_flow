import 'package:freezed_annotation/freezed_annotation.dart';
part 'handle_state.freezed.dart';

@freezed
abstract class HandleRuntimeState with _$HandleRuntimeState {
  const factory HandleRuntimeState({
    // Visual states
    @Default(false) bool isHovered,
    @Default(false) bool isActive, // Currently being used for connection
    @Default(false) bool isValidTarget, // Valid target for current connection
    // Connection state
    @Default(0) int currentConnections, // Number of current connections
    @Default([]) List<String> connectedEdgeIds, // IDs of connected edges
    // Animation state
    @Default(false) bool isAnimating,
  }) = _HandleRuntimeState;
}

import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state.freezed.dart';

/// Represents a connection in progress, from the start handle to the cursor.
@freezed
abstract class FlowConnectionState with _$FlowConnectionState {
  const factory FlowConnectionState({
    required String fromNodeId,
    required String fromHandleId,
    required Offset startPosition,
    required Offset endPosition,
    String? targetNodeId,
    String? targetHandleId,
    @Default(false) bool isValid,
  }) = _FlowConnectionState;
}

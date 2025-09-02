import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection.freezed.dart';

@freezed
abstract class Connection with _$Connection {
  const factory Connection({
    required String sourceNodeId,
    required String sourceHandleId,
    required String targetNodeId,
    required String targetHandleId,
  }) = _Connection;
}

import 'package:flutter/material.dart';
import '../state/connection_state.dart';
import '../streams/connection_change_stream.dart';

typedef OnConnect = void Function(FlowConnectionState connection);
typedef OnConnectStart = void Function(FlowConnectionState connection);
typedef OnConnectEnd = void Function(FlowConnectionState? connection);
typedef OnClickConnectStart = void Function(FlowConnectionState connection);
typedef OnClickConnectEnd = void Function(FlowConnectionState? connection);
typedef IsValidConnection = bool Function(FlowConnectionState connection);

@immutable
class ConnectionCallbacks {
  final OnConnect onConnect;
  final OnConnectStart onConnectStart;
  final OnConnectEnd onConnectEnd;
  final OnClickConnectStart onClickConnectStart;
  final OnClickConnectEnd onClickConnectEnd;
  final IsValidConnection isValidConnection;
  final ConnectionStreams? streams;

  const ConnectionCallbacks({
    this.onConnect = _defaultOnConnect,
    this.onConnectStart = _defaultOnConnectStart,
    this.onConnectEnd = _defaultOnConnectEnd,
    this.onClickConnectStart = _defaultOnClickConnectStart,
    this.onClickConnectEnd = _defaultOnClickConnectEnd,
    this.isValidConnection = _defaultIsValidConnection,
    this.streams,
  });

  // Default implementations
  static void _defaultOnConnect(FlowConnectionState connection) {}
  static void _defaultOnConnectStart(FlowConnectionState connection) {}
  static void _defaultOnConnectEnd(FlowConnectionState? connection) {}
  static void _defaultOnClickConnectStart(FlowConnectionState connection) {}
  static void _defaultOnClickConnectEnd(FlowConnectionState? connection) {}
  static bool _defaultIsValidConnection(FlowConnectionState connection) => true;

  ConnectionCallbacks copyWith({
    OnConnect? onConnect,
    OnConnectStart? onConnectStart,
    OnConnectEnd? onConnectEnd,
    OnClickConnectStart? onClickConnectStart,
    OnClickConnectEnd? onClickConnectEnd,
    IsValidConnection? isValidConnection,
    ConnectionStreams? streams,
  }) {
    return ConnectionCallbacks(
      onConnect: onConnect ?? this.onConnect,
      onConnectStart: onConnectStart ?? this.onConnectStart,
      onConnectEnd: onConnectEnd ?? this.onConnectEnd,
      onClickConnectStart: onClickConnectStart ?? this.onClickConnectStart,
      onClickConnectEnd: onClickConnectEnd ?? this.onClickConnectEnd,
      isValidConnection: isValidConnection ?? this.isValidConnection,
      streams: streams ?? this.streams,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConnectionCallbacks &&
        other.onConnect == onConnect &&
        other.onConnectStart == onConnectStart &&
        other.onConnectEnd == onConnectEnd &&
        other.onClickConnectStart == onClickConnectStart &&
        other.onClickConnectEnd == onClickConnectEnd &&
        other.isValidConnection == isValidConnection &&
        other.streams == streams;
  }

  @override
  int get hashCode {
    return Object.hash(
      onConnect,
      onConnectStart,
      onConnectEnd,
      onClickConnectStart,
      onClickConnectEnd,
      isValidConnection,
      streams,
    );
  }
}

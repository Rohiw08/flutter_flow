import 'package:flutter/material.dart';
import '../../domain/models/connection.dart';
import '../../domain/models/handle.dart';
import '../../domain/models/node.dart';
import '../streams/connection_change_stream.dart';

typedef ConnectCallback = void Function(FlowConnection connection);
typedef ConnectStartCallback = void Function(FlowConnection pendingConnection);
typedef ConnectEndCallback = void Function(FlowConnection pendingConnection);
typedef ConnectionValidator = bool Function({
  required FlowNode sourceNode,
  required FlowHandle sourceHandle,
  required FlowNode targetNode,
  required FlowHandle targetHandle,
});

@immutable
class ConnectionCallbacks {
  final ConnectCallback onConnect;
  final ConnectStartCallback onConnectStart;
  final ConnectEndCallback onConnectEnd;
  final ConnectionValidator isValidConnection;
  final ConnectionStreams? streams;

  const ConnectionCallbacks({
    this.onConnect = _defaultOnConnect,
    this.onConnectStart = _defaultOnConnectStart,
    this.onConnectEnd = _defaultOnConnectEnd,
    this.isValidConnection = _defaultIsValidConnection,
    this.streams,
  });

  // ---- Default no-op implementations ----
  static void _defaultOnConnect(FlowConnection connection) {}
  static void _defaultOnConnectStart(FlowConnection pendingConnection) {}
  static void _defaultOnConnectEnd(FlowConnection pendingConnection) {}
  static bool _defaultIsValidConnection({
    required FlowNode sourceNode,
    required FlowHandle sourceHandle,
    required FlowNode targetNode,
    required FlowHandle targetHandle,
  }) =>
      true;

  ConnectionCallbacks copyWith({
    ConnectCallback? onConnect,
    ConnectStartCallback? onConnectStart,
    ConnectEndCallback? onConnectEnd,
    ConnectionValidator? isValidConnection,
    ConnectionStreams? streams,
  }) {
    return ConnectionCallbacks(
      onConnect: onConnect ?? this.onConnect,
      onConnectStart: onConnectStart ?? this.onConnectStart,
      onConnectEnd: onConnectEnd ?? this.onConnectEnd,
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
        other.isValidConnection == isValidConnection &&
        other.streams == streams;
  }

  @override
  int get hashCode => Object.hash(
        onConnect,
        onConnectStart,
        onConnectEnd,
        isValidConnection,
        streams,
      );
}

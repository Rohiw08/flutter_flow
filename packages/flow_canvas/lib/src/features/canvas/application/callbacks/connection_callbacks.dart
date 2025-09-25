import 'package:flutter/material.dart';

import '../../domain/models/connection.dart';
import '../../domain/models/handle.dart';
import '../../domain/models/node.dart';
import '../streams/connection_change_stream.dart';

/// Called when a valid connection is successfully created.
typedef ConnectCallback = void Function(FlowConnection connection);

/// Called when a connection gesture starts (drag from a handle begins).
typedef ConnectStartCallback = void Function(FlowConnection pendingConnection);

/// Called when a connection gesture ends, whether successful or cancelled.
typedef ConnectEndCallback = void Function(FlowConnection? connection);

/// Validation function to decide if a proposed connection is allowed.
typedef ConnectionValidator = bool Function({
  required FlowNode sourceNode,
  required NodeHandle sourceHandle,
  required FlowNode targetNode,
  required NodeHandle targetHandle,
});

@immutable
class ConnectionCallbacks {
  /// Fires when a valid connection is successfully created.
  final ConnectCallback onConnect;

  /// Fires when a connection gesture starts.
  final ConnectStartCallback onConnectStart;

  /// Fires when a connection gesture ends (successfully or not).
  final ConnectEndCallback onConnectEnd;

  /// Custom validation for proposed connections.
  final ConnectionValidator isValidConnection;

  /// Optional event stream for external listeners.
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
  static void _defaultOnConnectEnd(FlowConnection? connection) {}
  static bool _defaultIsValidConnection({
    required FlowNode sourceNode,
    required NodeHandle sourceHandle,
    required FlowNode targetNode,
    required NodeHandle targetHandle,
  }) =>
      true; // Default allows all connections.

  /// Creates a copy with any subset of callbacks replaced.
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

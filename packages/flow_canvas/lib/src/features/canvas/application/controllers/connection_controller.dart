import 'package:flow_canvas/src/features/canvas/application/callbacks/connection_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/events/connection_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/connection_service.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/connection_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/widgets.dart';

class ConnectionController {
  final FlowCanvasController _controller;
  final ConnectionService _connectionService;
  final CanvasCoordinateConverter _coordinateConverter;
  final ConnectionStreams _connectionStreams;
  final ConnectionCallbacks _connectionCallbacks;

  ConnectionController({
    required FlowCanvasController controller,
    required ConnectionService connectionService,
    required CanvasCoordinateConverter coordinateConverter,
    required ConnectionStreams connectionStreams,
    required ConnectionCallbacks connectionCallbacks,
  })  : _controller = controller,
        _connectionService = connectionService,
        _coordinateConverter = coordinateConverter,
        _connectionStreams = connectionStreams,
        _connectionCallbacks = connectionCallbacks;

  /// Initiates a connection drag from a node's handle.
  void startConnection(String nodeId, String handleId) {
    final state = _controller.currentState;
    final sourceNode = state.nodes[nodeId];
    final sourceHandle = sourceNode?.handles[handleId];
    if (sourceNode == null || sourceHandle == null) return;

    final handleCenter = sourceNode.position + sourceHandle.position;

    // Start connection and update drag mode.
    final nextState = _connectionService.startConnection(
      state.copyWith(dragMode: DragMode.connection),
      fromNodeId: nodeId,
      fromHandleId: handleId,
      startPosition: handleCenter,
    );
    _controller.updateStateOnly(nextState);

    final activeConnection = nextState.activeConnection;
    if (activeConnection != null) {
      final event = ConnectionEvent(
        type: ConnectionEventType.start,
        connection: activeConnection,
      );
      _connectionStreams.emitEvent(event);
      _connectionCallbacks.onConnectStart(activeConnection);
    }
  }

  /// Updates the connection drag (real-time pointer movement).
  void updateConnection(Offset cursorScreenPosition) {
    final state = _controller.currentState;
    final activeConnection = state.activeConnection;

    if (state.dragMode != DragMode.connection || activeConnection == null)
      return;
    final cartesianPosition =
        _coordinateConverter.toCartesianPosition(cursorScreenPosition);

    // Only update if pointer actually moved.
    if (activeConnection.endPoint != cartesianPosition) {
      final nextState =
          _connectionService.updateConnection(state, cartesianPosition);
      _controller.updateStateOnly(nextState);
    }
  }

  /// Finalizes the edge if possible; propagates connect/end events.
  void endConnection() {
    final oldState = _controller.currentState;
    final pendingConnection = oldState.activeConnection;
    if (pendingConnection == null) return;

    _controller.mutate((s) => _connectionService.endConnection(s));
    final newState = _controller.currentState;

    // If an edge was created, emit connection event.
    final newEdgeCreated = newState.edges.length > oldState.edges.length;
    if (newEdgeCreated) {
      final newEdge = newState.edges.values
          .firstWhere((e) => !oldState.edges.containsKey(e.id));
      final completedConnection = pendingConnection.copyWith(
        id: newEdge.id,
        toNodeId: newEdge.targetNodeId,
        toHandleId: newEdge.targetHandleId,
      );
      final connectEvent = ConnectionEvent(
        type: ConnectionEventType.connect,
        connection: completedConnection,
      );
      _connectionStreams.emitEvent(connectEvent);
      _connectionCallbacks.onConnect(completedConnection);
    }

    // Always emit end event, even if connection was cancelled.
    final endEvent = ConnectionEvent(
      type: ConnectionEventType.end,
      connection: pendingConnection,
    );
    _connectionStreams.emitEvent(endEvent);
    _connectionCallbacks.onConnectEnd(pendingConnection);
  }

  /// Cancels the current connection drag operation.
  void cancelConnection() {
    final state = _controller.currentState;
    if (state.activeConnection == null) return;
    final nextState = _connectionService.cancelConnection(state);
    _controller.updateStateOnly(nextState);

    // Optionally, you can emit a cancel-specific event if needed.
    // This is up to your app-level logic.
  }
}

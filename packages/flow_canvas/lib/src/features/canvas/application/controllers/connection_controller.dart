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

  void startConnection(String nodeId, String handleId) {
    final sourceNode = _controller.currentState.nodes[nodeId];
    final sourceHandle = sourceNode?.handles[handleId];
    if (sourceNode == null || sourceHandle == null) return;

    final handleCenterPosition = sourceNode.position + sourceHandle.position;
    _controller.updateStateOnly(_connectionService.startConnection(
      _controller.currentState.copyWith(dragMode: DragMode.connection),
      fromNodeId: nodeId,
      fromHandleId: handleId,
      startPosition: handleCenterPosition,
    ));

    final pendingConnection = _controller.currentState.connection;
    if (pendingConnection != null) {
      final event = ConnectionEvent(
        type: ConnectionEventType.start,
        connection: pendingConnection,
      );
      _connectionStreams.emitEvent(event);
      _connectionCallbacks.onConnectStart(pendingConnection);
    }
  }

  void updateConnection(
      Offset cursorScreenPosition, String nodeId, String handleId) {
    final currentState = _controller.currentState;
    if (currentState.dragMode != DragMode.connection ||
        currentState.connection == null) {
      return;
    }
    final cartesianPosition =
        _coordinateConverter.toCartesianPosition(cursorScreenPosition);

    if (currentState.connection!.endPoint != cartesianPosition) {
      _controller.updateStateOnly(
          _connectionService.updateConnection(currentState, cartesianPosition));
    }
  }

  void endConnection() {
    final oldState = _controller.currentState;
    final pendingConnection = oldState.connection;
    if (pendingConnection == null) return;

    // Save final connection result to history (if an edge was created)
    _controller.mutate((s) => _connectionService.endConnection(s));

    final newState = _controller.currentState;
    final wasSuccessful = newState.edges.length > oldState.edges.length;

    if (wasSuccessful) {
      final newEdge = newState.edges.values
          .firstWhere((e) => !oldState.edges.containsKey(e.id));
      final finalConnection = pendingConnection.copyWith(
        id: newEdge.id,
        toNodeId: newEdge.targetNodeId,
        toHandleId: newEdge.targetHandleId,
      );
      final connectEvent = ConnectionEvent(
          type: ConnectionEventType.connect, connection: finalConnection);
      _connectionStreams.emitEvent(connectEvent);
      _connectionCallbacks.onConnect(finalConnection);
    }

    final endEvent = ConnectionEvent(
        type: ConnectionEventType.end, connection: pendingConnection);
    _connectionStreams.emitEvent(endEvent);
    _connectionCallbacks.onConnectEnd(pendingConnection);
  }

  /// Cancels an in-progress connection.
  void cancelConnection() {
    if (_controller.currentState.connection == null) return;
    _controller.updateStateOnly(
        _connectionService.cancelConnection(_controller.currentState));
  }
}

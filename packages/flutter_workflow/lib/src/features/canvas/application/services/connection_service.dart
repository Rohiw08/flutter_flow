import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node_handle.dart';

import '../../domain/flow_canvas_state.dart';
import '../../domain/models/connection_state.dart';
import '../../domain/models/edge.dart';
import '../../domain/models/node.dart';
import '../../../../shared/enums.dart';

/// Provider for the stateless ConnectionService.
final connectionServiceProvider = Provider<ConnectionService>((ref) {
  // We can pass the ref if we need to read other services,
  // but for now, it's not needed.
  return ConnectionService();
});

/// A utility function to generate a unique edge ID.
String _generateUniqueEdgeId() {
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  final random = Random().nextInt(999999);
  return 'edge_${timestamp}_$random';
}

/// A stateless service for handling all logic related to creating connections.
class ConnectionService {
  /// Starts a new connection process.
  FlowCanvasState startConnection(
    FlowCanvasState state, {
    required String fromNodeId,
    required String fromHandleId,
    required Offset startPosition,
  }) {
    return state.copyWith(
      connection: FlowConnectionState(
        fromNodeId: fromNodeId,
        fromHandleId: fromHandleId,
        startPosition: startPosition,
        endPosition: startPosition,
      ),
      dragMode: DragMode.handle,
    );
  }

  /// Updates the position and validity of the connection in progress.
  FlowCanvasState updateConnection(
    FlowCanvasState state,
    Offset cursorPosition, {
    double snapRadius = 20.0,
  }) {
    if (state.connection == null) return state;

    String? hoveredKey;
    bool isValid = false;

    // Use the pre-calculated spatial hash for efficient collision detection
    final nearbyHandles = _getHandlesNear(state.spatialHash, cursorPosition);

    for (final handleKey in nearbyHandles) {
      if ('${state.connection!.fromNodeId}/${state.connection!.fromHandleId}' ==
          handleKey) {
        continue;
      }

      final keyParts = handleKey.split('/');
      final targetNodeId = keyParts[0];
      final targetHandleId = keyParts[1];

      final targetNode =
          state.nodes.firstWhere((n) => n.id == targetNodeId, orElse: () {
        // This should ideally not happen if the hash is in sync
        debugPrint('Error: Node not found for handle key: $handleKey');
        return const FlowNode(
            id: '', position: Offset.zero, size: Size.zero, type: '');
      });

      if (targetNode.id.isEmpty) continue;

      final targetHandle = targetNode.handles
          .firstWhere((h) => h.id == targetHandleId, orElse: () {
        debugPrint('Error: Handle not found for handle key: $handleKey');
        return const NodeHandle(
            id: '', type: HandleType.source, position: Offset.zero);
      });
      if (targetHandle.id.isEmpty) continue;

      // Calculate position mathematically, not from the UI
      final handleCenter = targetNode.position + targetHandle.position;
      final distance = (cursorPosition - handleCenter).distance;

      if (distance <= snapRadius) {
        if (targetHandle.type != HandleType.source &&
            targetHandle.isConnectable) {
          // TODO: Implement custom validation callback if needed in the future
          isValid = true;
          hoveredKey = handleKey;
          break; // Found a valid target, no need to check others
        }
      }
    }

    return state.copyWith(
      connection: state.connection!.copyWith(
        endPosition: cursorPosition,
        hoveredTargetKey: hoveredKey,
        isValid: isValid,
      ),
    );
  }

  /// Ends the connection process, creating an edge if the connection is valid.
  FlowCanvasState endConnection(FlowCanvasState state) {
    if (state.connection == null) return state;

    FlowCanvasState nextState = state;

    if (state.connection!.isValid &&
        state.connection!.hoveredTargetKey != null) {
      final targetKeyParts = state.connection!.hoveredTargetKey!.split('/');
      final newEdge = FlowEdge(
        id: _generateUniqueEdgeId(),
        sourceNodeId: state.connection!.fromNodeId,
        sourceHandleId: state.connection!.fromHandleId,
        targetNodeId: targetKeyParts[0],
        targetHandleId: targetKeyParts[1],
      );

      // Create new list of edges
      final newEdges = [...state.edges, newEdge];
      nextState = state.copyWith(edges: newEdges);
    }

    // Always clear the connection state and drag mode afterwards
    return nextState.copyWith(
      connection: null,
      dragMode: DragMode.none,
    );
  }

  /// Cancels the connection in progress.
  FlowCanvasState cancelConnection(FlowCanvasState state) {
    if (state.connection == null) return state;
    return state.copyWith(
      connection: null,
      dragMode: DragMode.none,
    );
  }

  /// A private utility to query the spatial hash.
  Iterable<String> _getHandlesNear(
    Map<String, Set<String>> spatialHash,
    Offset position, {
    double gridSize = 200.0,
  }) {
    final gridX = (position.dx / gridSize).floor();
    final gridY = (position.dy / gridSize).floor();
    final nearbyHandles = <String>{};

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        final key = '${gridX + x},${gridY + y}';
        if (spatialHash.containsKey(key)) {
          nearbyHandles.addAll(spatialHash[key]!);
        }
      }
    }
    return nearbyHandles;
  }
}

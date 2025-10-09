import 'package:flow_canvas/src/features/canvas/application/callbacks/node_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/selection_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/events/node_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/nodes_flow_state_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_service.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/node_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/nodes_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/material.dart';

// Forward declaration or import for SelectionController if it's in another file
// For now, we assume it exists and will be passed in.
// import 'selection_controller.dart';

class NodesController {
  final FlowCanvasController _controller;
  final NodeService _nodeService;
  final NodeStateCallbacks _nodeStateCallbacks;
  final NodeInteractionCallbacks _nodeInteractionCallbacks;
  final NodeInteractionStreams _nodeStreams;
  final NodesStateStreams _nodesStateStreams;
  final SelectionController _selectionController;

  // Assumes a SelectionController will be created and passed in

  Map<String, Offset>? _dragStartPositions;

  NodesController({
    required FlowCanvasController controller,
    required NodeService nodeService,
    required NodeStateCallbacks nodeStateCallbacks,
    required NodeInteractionCallbacks nodeInteractionCallbacks,
    required NodeInteractionStreams nodeStreams,
    required NodesStateStreams nodesStateStreams,
    required SelectionController selectionController,
  })  : _controller = controller,
        _nodeService = nodeService,
        _nodeStateCallbacks = nodeStateCallbacks,
        _nodeInteractionCallbacks = nodeInteractionCallbacks,
        _nodeStreams = nodeStreams,
        _nodesStateStreams = nodesStateStreams,
        _selectionController = selectionController;

  void addNode(FlowNode node) {
    if (_controller.currentState.nodes.containsKey(node.id)) {
      throw ArgumentError('Node with id ${node.id} already exists');
    }
    _controller.mutate((s) => _nodeService.addNode(s, node));
    final event = NodeLifecycleEvent(
      type: NodeLifecycleType.add,
      state: _controller.currentState,
      nodeId: node.id,
      data: node,
    );
    _nodesStateStreams.emitEvent(event);
    _nodeStateCallbacks.onNodeAdd(event);
  }

  void addNodes(List<FlowNode> nodes) {
    for (var node in nodes) {
      if (_controller.currentState.nodes.containsKey(node.id)) {
        throw ArgumentError('Node with id ${node.id} already exists');
      }
    }
    _controller.mutate((s) => _nodeService.addNodes(s, nodes));
    final events = nodes
        .map((n) => NodeLifecycleEvent(
              type: NodeLifecycleType.add,
              state: _controller.currentState,
              nodeId: n.id,
              data: n,
            ))
        .toList();
    _nodesStateStreams.emitBulk(events);
    for (final event in events) {
      _nodeStateCallbacks.onNodeAdd(event);
    }
  }

  void removeSelectedNodes() {
    final oldState = _controller.currentState;
    if (oldState.selectedNodes.isEmpty) return;

    final removedNodeIds = Set<String>.from(oldState.selectedNodes);
    _controller.mutate((s) =>
        _nodeService.removeNodesAndConnections(s, removedNodeIds.toList()));

    final nodeEvents = removedNodeIds
        .map((id) => NodeLifecycleEvent(
              type: NodeLifecycleType.remove,
              state: _controller.currentState,
              nodeId: id,
            ))
        .toList();
    _nodesStateStreams.emitBulk(nodeEvents);
    for (final event in nodeEvents) {
      _nodeStateCallbacks.onNodeRemove(event);
    }
  }

  void updateNode(FlowNode node) {
    final oldNode = _controller.currentState.nodes[node.id];
    if (oldNode == null) return;

    _controller.mutate((s) => _nodeService.updateNode(s, node));

    final newNode = _controller.currentState.nodes[node.id]!;
    final event = NodeLifecycleEvent(
      type: NodeLifecycleType.update,
      state: _controller.currentState,
      nodeId: node.id,
      data: {'old': oldNode, 'new': newNode},
    );
    _nodesStateStreams.emitEvent(event);
    _nodeStateCallbacks.onNodeUpdate(event);
  }

  void onNodeTap(String nodeId, TapDownDetails details, bool isSelectable,
      FocusNode focusNode, bool isFocusable) {
    if (isSelectable) {
      // Assuming SelectionController will have this method
      _selectionController.selectNode(nodeId, addToSelection: false);
    }
    if (isFocusable) {
      focusNode.requestFocus();
    }
    _nodeInteractionCallbacks.onClick(nodeId, details);
    _nodeStreams.emitEvent(NodeClickEvent(nodeId: nodeId, details: details));
  }

  void onNodeDoubleClick(String nodeId) {
    _nodeInteractionCallbacks.onDoubleClick(nodeId);
    _nodeStreams.emitEvent(NodeDoubleClickEvent(nodeId: nodeId));
  }

  void onNodeContextMenu(String nodeId, LongPressStartDetails details) {
    _nodeInteractionCallbacks.onContextMenu(nodeId, details);
    _nodeStreams
        .emitEvent(NodeContextMenuEvent(nodeId: nodeId, details: details));
  }

  void onNodeDragStart(String nodeId, DragStartDetails details) {
    _dragStartPositions = {};
    for (final selectedId in _controller.currentState.selectedNodes) {
      final node = _controller.currentState.nodes[selectedId];
      if (node != null) {
        _dragStartPositions![selectedId] = node.position;
      }
    }

    if (_controller.currentState.dragMode != DragMode.node) {
      _controller.updateStateOnly(
          _controller.currentState.copyWith(dragMode: DragMode.node));
    }

    _nodeInteractionCallbacks.onDragStart(nodeId, details);
    _nodeStreams
        .emitEvent(NodeDragStartEvent(nodeId: nodeId, details: details));
  }

  void onNodeDragUpdate(
      String nodeId, DragUpdateDetails details, bool isSelectable) {
    if (isSelectable &&
        !_controller.currentState.selectedNodes.contains(nodeId)) {
      _selectionController.selectNode(nodeId, addToSelection: false);
    }
    moveSelectedNodesBy(details.delta, details);
    _nodeInteractionCallbacks.onDrag(nodeId, details);
  }

  void onNodeDragEnd(String nodeId, DragEndDetails details) {
    if (_dragStartPositions != null) {
      final startPositions = _dragStartPositions!;
      bool hasChanged = false;
      for (final id in startPositions.keys) {
        if (_controller.currentState.nodes[id]?.position !=
            startPositions[id]) {
          hasChanged = true;
          break;
        }
      }
      if (hasChanged) {
        _controller.history.record(_controller.currentState);
      }
      _dragStartPositions = null;
    }

    _controller.mutate((s) => s.copyWith(dragMode: DragMode.none));

    _nodeInteractionCallbacks.onDragStop(nodeId, details);
    _nodeStreams.emitEvent(NodeDragStopEvent(nodeId: nodeId, details: details));
  }

  void onNodeMouseEnter(String nodeId, PointerEvent details) {
    _nodeInteractionCallbacks.onMouseEnter(nodeId, details);
    _nodeStreams
        .emitEvent(NodeMouseEnterEvent(nodeId: nodeId, details: details));
  }

  void onNodeMouseLeave(String nodeId, PointerEvent details) {
    _nodeInteractionCallbacks.onMouseLeave(nodeId, details);
    _nodeStreams
        .emitEvent(NodeMouseLeaveEvent(nodeId: nodeId, details: details));
  }

  void onNodeMouseMove(String nodeId, PointerEvent details) {
    _nodeInteractionCallbacks.onMouseMove(nodeId, details);
    _nodeStreams
        .emitEvent(NodeMouseMoveEvent(nodeId: nodeId, details: details));
  }

  void moveSelectedNodesBy(Offset screenDelta, DragUpdateDetails details) {
    if (_controller.currentState.dragMode != DragMode.node) return;
    final cartesianDelta =
        _controller.coordinateConverter.toCartesianDelta(screenDelta);

    _controller.updateStateOnly(_nodeService.dragSelectedNodes(
        _controller.currentState, cartesianDelta));

    _controller.edgeGeometryService.updateEdgesForNodes(
        _controller.currentState, _controller.currentState.selectedNodes);

    final movedNodePositions = <String, Offset>{};
    for (final nodeId in _controller.currentState.selectedNodes) {
      final node = _controller.currentState.nodes[nodeId];
      if (node != null) {
        movedNodePositions[nodeId] = node.position;
      }
    }

    if (movedNodePositions.isNotEmpty) {
      _nodeStreams.emitEvent(NodesDragEvent(
        positions: movedNodePositions,
        delta: cartesianDelta,
        details: details,
      ));
    }
  }
}

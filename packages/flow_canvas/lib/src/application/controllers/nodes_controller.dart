import 'package:flow_canvas/src/features/canvas/application/controllers/selection_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/events/node_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/nodes_flow_state_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_service.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/node_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/nodes_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/node_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/material.dart';

class NodesController {
  NodesController({
    required FlowCanvasInternalController controller,
    required NodeService nodeService,
    required EdgeService edgeService,
    required NodeInteractionStreams nodeStreams,
    required NodesStateStreams nodesStateStreams,
    required SelectionController selectionController,
  })  : _controller = controller,
        _nodeService = nodeService,
        _edgeService = edgeService,
        _nodeStreams = nodeStreams,
        _nodesStateStreams = nodesStateStreams,
        _selectionController = selectionController;

  final FlowCanvasInternalController _controller;
  final NodeService _nodeService;
  final EdgeService _edgeService;
  final NodeInteractionStreams _nodeStreams;
  final NodesStateStreams _nodesStateStreams;
  final SelectionController _selectionController;

  Map<String, Offset>? _dragStartPositions;
  Set<String> _nodesBeingDragged = {};

  FlowNode? getNode(nodeId) {
    return _nodeService.getNode(
      _controller.currentState,
      nodeId,
    );
  }

  NodeRuntimeState? getNodeRuntimeState(nodeId) {
    return _nodeService.getNodeRuntimeState(
      _controller.currentState,
      nodeId,
    );
  }

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
  }

  void removeNode(String nodeId) {
    removeNodes({nodeId});
  }

  void removeSelectedNodes() {
    final state = _controller.currentState;
    if (state.selectedNodes.isEmpty) return;

    final removedNodeIds = Set<String>.from(state.selectedNodes);
    removeNodes(removedNodeIds);
  }

  void removeNodes(Iterable<String> nodeIds) {
    final oldState = _controller.currentState;
    if (nodeIds.isEmpty) return;
    final removedNodeIds = nodeIds.toSet();

    final edgeIds = _edgeService.getEdgesFromNodes(oldState, nodeIds);
    final stateAfterEdges = _edgeService.removeEdges(oldState, edgeIds);
    _controller.updateStateOnly(stateAfterEdges);

    final newState =
        _nodeService.removeNodes(stateAfterEdges, removedNodeIds.toList());
    _controller.mutate((_) => newState);

    final nodeEvents = removedNodeIds
        .map((id) => NodeLifecycleEvent(
              type: NodeLifecycleType.remove,
              state: _controller.currentState,
              nodeId: id,
            ))
        .toList();

    _nodesStateStreams.emitBulk(nodeEvents);
  }

  void updateNode(FlowNode node) {
    final oldNode = _nodeService.getNode(_controller.currentState, node.id);
    if (oldNode == null || oldNode == node) return;

    _controller.mutate((s) => _nodeService.updateNode(s, node));

    final newNode = _nodeService.getNode(
      _controller.currentState,
      node.id,
    )!;

    final event = NodeLifecycleEvent(
      type: NodeLifecycleType.update,
      state: _controller.currentState,
      nodeId: node.id,
      data: {'old': oldNode, 'new': newNode},
    );
    _nodesStateStreams.emitEvent(event);
  }

  void updateNodeRuntimeState(String nodeId, NodeRuntimeState node) {
    final oldState = _controller.currentState;
    final oldNodeState = _nodeService.getNodeRuntimeState(oldState, nodeId);
    if (oldNodeState == null || oldNodeState == node) return;
    _controller.updateStateOnly(
        _nodeService.updateNodeRuntimeState(oldState, nodeId, node));

    // TODO: node runtime state even should not be send from same point
    // it should have its own runtimestate even emmitor
    // final newState = _controller.currentState;
    // final newNodeState = _nodeService.getNodeRuntimeState(newState, nodeId)!;
    // final event = NodeLifecycleEvent(
    //   type: NodeLifecycleType.update,
    //   state: _controller.currentState,
    //   nodeId: nodeId,
    //   data: {'old': oldNodeState, 'new': newNodeState},
    // );
    // _nodesStateStreams.emitEvent(event);
    // _nodeStateCallbacks.onNodeUpdate(event);
  }

  void onNodeTap(String nodeId, TapDownDetails details, bool isSelectable) {
    final state = _controller.currentState;
    if (isSelectable && !state.selectedNodes.contains(nodeId)) {
      _selectionController.selectNode(nodeId, addToSelection: false);
    }
    _nodeStreams.emitEvent(NodeClickEvent(nodeId: nodeId, details: details));
  }

  void onNodeDragStart(
      String nodeId, DragStartDetails details, bool isSelectable) {
    final node = getNode(nodeId);
    if (node == null) return;

    final bool isDraggable = node.draggable ?? true;
    if (!isDraggable) return;

    final initialState = _controller.currentState;
    final isAlreadySelected = initialState.selectedNodes.contains(nodeId);

    FlowCanvasState stateAfterSelection = initialState;

    if (isSelectable && !isAlreadySelected) {
      _selectionController.selectNode(nodeId, addToSelection: false);
      stateAfterSelection = _controller.currentState;
    }

    if (isAlreadySelected) {
      _nodesBeingDragged = Set.from(stateAfterSelection.selectedNodes);
    } else {
      _nodesBeingDragged = {nodeId};
    }

    _dragStartPositions = {};
    for (final id in _nodesBeingDragged) {
      final n = stateAfterSelection.nodes[id];
      if (n != null && (n.draggable ?? true)) {
        _dragStartPositions![id] = n.position;
      }
    }

    _nodesBeingDragged
        .retainWhere((id) => _dragStartPositions!.containsKey(id));

    _controller
        .updateStateOnly(stateAfterSelection.copyWith(dragMode: DragMode.node));

    _nodeStreams
        .emitEvent(NodeDragStartEvent(nodeId: nodeId, details: details));
  }

  void onNodeDragUpdate(DragUpdateDetails details) {
    if (_controller.currentState.dragMode != DragMode.node) return;

    _moveNodesBy(details.delta, details, _nodesBeingDragged);
  }

  void onNodeDragEnd(DragEndDetails details) {
    if (_dragStartPositions == null) return;
    final currentState = _controller.currentState;
    for (final id in _nodesBeingDragged) {
      final startPos = _dragStartPositions![id];
      if (startPos != null && currentState.nodes[id]?.position != startPos) {
        break;
      }
    }

    _controller.mutate((s) {
      return s.copyWith(dragMode: DragMode.none);
    });

    _dragStartPositions = null;
    _nodesBeingDragged.clear();

    _nodeStreams
        .emitEvent(NodeDragStopEvent(nodeId: "group", details: details));
  }

  void _moveNodesBy(
    Offset screenDelta,
    DragUpdateDetails details,
    Set<String> nodesToMove,
  ) {
    if (_controller.currentState.dragMode != DragMode.node) return;
    if (nodesToMove.isEmpty) return; // Nothing to move

    final cartesianDelta =
        _controller.coordinateConverter.toCartesianDelta(screenDelta);

    if (cartesianDelta == Offset.zero) return;

    // Use the generic `moveNodes` service, not `moveSelectedNodes`
    _controller.updateStateOnly(_nodeService.moveNodes(
        _controller.currentState, nodesToMove, cartesianDelta));

    _controller.edgeGeometryService
        .updateEdgesForNodes(_controller.currentState, nodesToMove);

    final movedNodePositions = <String, Offset>{};
    for (final nodeId in nodesToMove) {
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

  void onNodeMouseEnter(String nodeId, PointerEvent details) {
    final nodeState =
        _nodeService.getNodeRuntimeState(_controller.currentState, nodeId);
    if (nodeState == null) return;
    _controller.updateStateOnly(_nodeService.updateNodeRuntimeState(
        _controller.currentState, nodeId, nodeState.copyWith(hovered: true)));
    _nodeStreams
        .emitEvent(NodeMouseEnterEvent(nodeId: nodeId, details: details));
  }

  void onNodeMouseMove(String nodeId, PointerEvent details) {
    _nodeStreams
        .emitEvent(NodeMouseMoveEvent(nodeId: nodeId, details: details));
  }

  void onNodeMouseLeave(String nodeId, PointerEvent details) {
    final nodeState =
        _nodeService.getNodeRuntimeState(_controller.currentState, nodeId);
    if (nodeState == null) return;
    _controller.updateStateOnly(_nodeService.updateNodeRuntimeState(
        _controller.currentState, nodeId, nodeState.copyWith(hovered: false)));
    _nodeStreams
        .emitEvent(NodeMouseLeaveEvent(nodeId: nodeId, details: details));
  }
}

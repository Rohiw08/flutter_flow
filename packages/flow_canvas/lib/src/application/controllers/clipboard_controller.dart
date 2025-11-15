import 'package:flow_canvas/src/features/canvas/application/events/edges_flow_state_chnage_event.dart';
import 'package:flow_canvas/src/features/canvas/application/events/nodes_flow_state_change_event.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/clipboard_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_service.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/edges_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/nodes_flow_state_change_stream.dart';
import 'package:flutter/widgets.dart';

class ClipboardController {
  final FlowCanvasInternalController _controller;
  final ClipboardService _clipboardService;
  final NodeService _nodeService;
  final EdgeService _edgeService;
  final NodesStateStreams _nodesStateStreams;
  final EdgesStateStreams _edgesStateStreams;

  /// Internal storage for the copied payload.
  Map<String, dynamic>? _clipboardPayload;

  ClipboardController({
    required FlowCanvasInternalController controller,
    required ClipboardService clipboardService,
    required NodeService nodeService,
    required EdgeService edgeService,
    required NodesStateStreams nodesStateStreams,
    required EdgesStateStreams edgesStateStreams,
  })  : _controller = controller,
        _clipboardService = clipboardService,
        _nodeService = nodeService,
        _edgeService = edgeService,
        _nodesStateStreams = nodesStateStreams,
        _edgesStateStreams = edgesStateStreams;

  /// Copies the currently selected nodes and edges to the internal clipboard.
  void copySelection() {
    // The copy service returns a payload that we store internally in this controller.
    _clipboardPayload = _clipboardService.copy(_controller.currentState);
  }

  /// Pastes the content from the internal clipboard onto the canvas.
  void paste({Offset? positionOffset}) {
    // Do nothing if the clipboard is empty.
    if (_clipboardPayload == null) return;

    final oldState = _controller.currentState;

    // Delegate the state mutation to the main controller.
    _controller.mutate((s) {
      // Use the stored payload.
      return _clipboardService.paste(
        s,
        _clipboardPayload!,
        positionOffset: positionOffset ?? const Offset(20, 20),
        nodeService: _nodeService,
        edgeService: _edgeService,
      );
    });

    final newState = _controller.currentState;

    // Find the newly added elements by comparing the state before and after.
    final newNodes =
        newState.nodes.values.where((n) => !oldState.nodes.containsKey(n.id));
    final newEdges =
        newState.edges.values.where((e) => !oldState.edges.containsKey(e.id));

    // Emit bulk lifecycle events for the newly pasted nodes and edges.
    if (newNodes.isNotEmpty) {
      final nodeEvents = newNodes
          .map((n) => NodeLifecycleEvent(
                type: NodeLifecycleType.add,
                state: newState,
                nodeId: n.id,
                data: n,
              ))
          .toList();
      _nodesStateStreams.emitBulk(nodeEvents);
    }
    if (newEdges.isNotEmpty) {
      final edgeEvents = newEdges
          .map((e) => EdgeLifecycleEvent(
                type: EdgeLifecycleType.add,
                state: newState,
                edgeId: e.id,
                data: e,
              ))
          .toList();
      _edgesStateStreams.emitBulk(edgeEvents);
    }
  }
}

import 'package:flow_canvas/src/features/canvas/application/controllers/viewport_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';

// Import all sub-controllers and streams
import 'package:flow_canvas/src/features/canvas/application/controllers/clipboard_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/connection_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/edge_geometry_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/edges_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/handles_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/history_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/keyboard_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/nodes_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/selection_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/controllers/z_index_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/connection_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/edge_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/edges_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/node_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/nodes_flow_state_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/pane_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/selection_change_stream.dart';
import 'package:flow_canvas/src/features/canvas/application/streams/viewport_change_stream.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// A public-facing controller (facade) for interacting with a FlowCanvas widget.
///
/// Create an instance of this controller and pass it to the [FlowCanvas]
/// widget's constructor to gain imperative control over the canvas.
///
/// This pattern hides the internal Riverpod state management from the widget's
/// user, providing a more traditional Flutter "controller-widget" API.
///
/// ### Example:
///
/// ```dart
/// class MyEditor extends StatefulWidget {
///   @override
///   _MyEditorState createState() => _MyEditorState();
/// }
///
/// class _MyEditorState extends State<MyEditor> {
///   // 1. Create the controller
///   late final FlowCanvasController _controller;
///
///   @override
///   void initState() {
///     super.initState();
///     _controller = FlowCanvasController();
///   }
///
///   void _addNode() {
///     // 3. Use the controller's API
///     _controller.nodes.addNode(
///       FlowNode.create(id: 'new-node', type: 'default', position: Offset.zero, data: {}),
///     );
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         ElevatedButton(onPressed: _addNode, child: Text('Add Node')),
///         Expanded(
///           child: FlowCanvas(
///             // 2. Pass the controller to the widget
///             controller: _controller,
///             nodeRegistry: myNodeRegistry,
///             edgeRegistry: myEdgeRegistry,
///           ),
///         ),
///       ],
///     );
///   }
/// }
/// ```
class FlowCanvasController {
  FlowCanvasInternalController? _internalController;

  /// A check to ensure the controller is attached to a canvas.
  void _assertAttached() {
    if (_internalController == null) {
      throw StateError(
          'FlowCanvasController is not attached to a FlowCanvas widget. '
          'Ensure you have passed this controller to the FlowCanvas widget '
          'and it has been initialized.');
    }
  }

  /// Internal method for the FlowCanvas widget to link the controllers.
  /// Not for public use.
  @internal
  void attach(FlowCanvasInternalController internalController) {
    if (_internalController != null) {
      debugPrint('FlowCanvasController is being re-attached. '
          'This is usually fine during hot reload.');
    }
    _internalController = internalController;
  }

  /// Internal method for the FlowCanvas widget to unlink the controllers.
  /// Not for public use.
  @internal
  void detach() {
    _internalController = null;
  }

  /// Access the current, immutable state of the canvas.
  FlowCanvasState get currentState {
    _assertAttached();
    return _internalController!.currentState;
  }

  // --- Delegated Sub-Controllers ---

  /// Controller for all node-related actions (add, remove, update, drag).
  NodesController get nodes {
    _assertAttached();
    return _internalController!.nodes;
  }

  /// Controller for all edge-related actions (add, remove, update, reconnect).
  EdgesController get edges {
    _assertAttached();
    return _internalController!.edges;
  }

  /// Controller for managing selection (nodes, edges, box selection).
  SelectionController get selection {
    _assertAttached();
    return _internalController!.selection;
  }

  /// Controller for managing the viewport (pan, zoom, fitView).
  ViewportController get viewport {
    _assertAttached();
    return _internalController!.viewport;
  }

  /// Controller for managing active connection-dragging state.
  ConnectionController get connection {
    _assertAttached();
    return _internalController!.connection;
  }

  /// Controller for clipboard actions (copy, paste).
  ClipboardController get clipboard {
    _assertAttached();
    return _internalController!.clipboard;
  }

  /// Controller for undo/redo history.
  HistoryController get history {
    _assertAttached();
    return _internalController!.history;
  }

  /// Controller for managing handle hover/active states.
  HandleController get handle {
    _assertAttached();
    return _internalController!.handle;
  }

  /// Controller for managing edge geometry and hit-testing.
  EdgeGeometryController get edgeGeometry {
    _assertAttached();
    return _internalController!.edgeGeometry;
  }

  /// Controller for managing node z-index (bring to front, send to back).
  ZIndexController get zIndex {
    _assertAttached();
    return _internalController!.zIndex;
  }

  /// Controller for handling keyboard actions.
  KeyboardController get keyboard {
    _assertAttached();
    return _internalController!.keyboard;
  }

  // --- Delegated Streams ---

  /// Streams for user-driven node interactions (click, drag, hover).
  NodeInteractionStreams get nodeStreams {
    _assertAttached();
    return _internalController!.nodeStreams;
  }

  /// Streams for node lifecycle events (add, remove, update).
  NodesStateStreams get nodesStateStreams {
    _assertAttached();
    return _internalController!.nodesStateStreams;
  }

  /// Streams for user-driven edge interactions (click, hover).
  EdgeInteractionStreams get edgeStreams {
    _assertAttached();
    return _internalController!.edgeStreams;
  }

  /// Streams for edge lifecycle events (add, remove, update).
  EdgesStateStreams get edgesStateStream {
    _assertAttached();
    return _internalController!.edgesStateStream;
  }

  /// Streams for connection drag events (start, connect, end).
  ConnectionStreams get connectionStreams {
    _assertAttached();
    return _internalController!.connectionStreams;
  }

  /// Streams for pane (canvas background) interactions.
  PaneStreams get paneStreams {
    _assertAttached();
    return _internalController!.paneStreams;
  }

  /// Streams for selection change events.
  SelectionStreams get selectionStreams {
    _assertAttached();
    return _internalController!.selectionStreams;
  }

  /// Streams for viewport change events (pan, zoom, resize).
  ViewportStreams get viewportStreams {
    _assertAttached();
    return _internalController!.viewportStreams;
  }
}

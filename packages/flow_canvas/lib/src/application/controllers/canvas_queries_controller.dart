// import 'dart:ui';

// import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
// import 'package:flow_canvas/src/features/canvas/application/services/connection_service.dart';
// import 'package:flow_canvas/src/features/canvas/application/services/edge_query_service.dart';
// import 'package:flow_canvas/src/features/canvas/application/services/node_query_service.dart';
// import 'package:flow_canvas/src/features/canvas/application/services/viewport_service.dart';
// import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
// import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';

// /// Provides a read-only API for querying the state of the canvas.
// class CanvasQuerier {
//   final FlowCanvasInternalController _controller;
//   final NodeQueryService _nodeQueryService;
//   final EdgeQueryService _edgeQueryService;
//   final ConnectionService _connectionService;
//   final ViewportService _viewportService;

//   CanvasQuerier({
//     required FlowCanvasInternalController controller,
//     required NodeQueryService nodeQueryService,
//     required EdgeQueryService edgeQueryService,
//     required ConnectionService connectionService,
//     required ViewportService viewportService,
//   })  : _controller = controller,
//         _nodeQueryService = nodeQueryService,
//         _edgeQueryService = edgeQueryService,
//         _connectionService = connectionService,
//         _viewportService = viewportService;

//   // =================================================================================
//   // --- Node Queries ---
//   // =================================================================================

//   /// Finds all nodes whose bounding boxes intersect with a given rectangle.
//   Set<String> findNodesInRect(Rect rect) =>
//       _nodeQueryService.queryInRect(_controller.currentState, rect);

//   /// Finds all nodes near a given point within a specified radius.
//   Set<String> findNodesNearPoint(Offset point, double radius) =>
//       _nodeQueryService.queryNearPoint(_controller.currentState, point, radius);

//   /// Returns a list of all nodes that have no connected edges.
//   List<FlowNode> getIsolatedNodes() =>
//       _nodeQueryService.getIsolatedNodes(_controller.currentState);

//   /// Returns a set of node IDs that are directly connected to the given node.
//   Set<String> getNodesConnectedTo(String nodeId) =>
//       _nodeQueryService.getConnectedNodes(_controller.currentState, nodeId);

//   /// Calculates the total bounding box that encloses a given set of nodes.
//   NodeBounds getNodeBounds({bool includeHidden = false}) =>
//       _viewportService.getNodeBounds(
//         nodes: _controller.currentState.nodes.values.toList(),
//         includeHidden: includeHidden,
//       );

//   // =================================================================================
//   // --- Edge Queries ---
//   // =================================================================================

//   /// Returns a set of all edge IDs connected to a specific node.
//   Set<String> getEdgesForNode(String nodeId) =>
//       _edgeQueryService.getEdgesForNode(_controller.currentState, nodeId);

//   /// Returns a set of all edge IDs connected to a specific handle on a node.
//   Set<String> getEdgesForHandle(String nodeId, String handleId) =>
//       _edgeQueryService.getEdgesForHandle(
//           _controller.currentState, nodeId, handleId);

//   /// Checks if a node has any connections.
//   bool isNodeConnected(String nodeId) =>
//       _edgeQueryService.isNodeConnected(_controller.currentState, nodeId);

//   /// Checks if a specific handle has any connections.
//   bool isHandleConnected(String nodeId, String handleId) => _edgeQueryService
//       .isHandleConnected(_controller.currentState, nodeId, handleId);

//   /// Returns a list of all `FlowEdge` objects connected to a specific handle.
//   List<FlowEdge> getConnectedEdges(String nodeId, String handleId) =>
//       _connectionService.getConnectedEdges(
//           _controller.currentState, nodeId, handleId);
// }

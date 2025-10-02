import 'dart:ui';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/handle.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/viewport_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';

class SerializationService {
  static const String version = '1.0.0';

  Map<String, dynamic> toJson(FlowCanvasState state) {
    return {
      'version': version,
      'nodes': state.nodes.values.map(_nodeToJson).toList(),
      'edges': state.edges.values.map(_edgeToJson).toList(),
      'viewport': _viewportToJson(state.viewport),
    };
  }

  FlowCanvasState fromJson(FlowCanvasState state, Map<String, dynamic> json) {
    final nodesJson = (json['nodes'] as List? ?? const []);
    final edgesJson = (json['edges'] as List? ?? const []);

    final nodes = {
      for (final n in nodesJson)
        n['id'] as String: _nodeFromJson(n as Map<String, dynamic>)
    };
    final edges = {
      for (final e in edgesJson)
        e['id'] as String: _edgeFromJson(e as Map<String, dynamic>)
    };

    final viewport = json['viewport'] != null
        ? _viewportFromJson(json['viewport'] as Map<String, dynamic>)
        : state.viewport;

    return state.copyWith(nodes: nodes, edges: edges, viewport: viewport);
  }

  // --- Node Serialization ---

  Map<String, dynamic> _nodeToJson(FlowNode node) => {
        'id': node.id,
        'type': node.type,
        'x': node.position.dx,
        'y': node.position.dy,
        'w': node.size.width,
        'h': node.size.height,
        'handles': node.handles.values.map(_handleToJson).toList(),
        'parentId': node.parentId,
        'data': node.data,
        'z': node.zIndex,
        'hitTestPadding': node.hitTestPadding,
        'hidden': node.hidden,
        'draggable': node.draggable,
        'selectable': node.selectable,
        'connectable': node.connectable,
        'deletable': node.deletable,
        'focusable': node.focusable,
        'elevateNodeOnSelected': node.elevateNodeOnSelected,
      };

  FlowNode _nodeFromJson(Map<String, dynamic> json) {
    final handlesJson = (json['handles'] as List? ?? const []);
    final handles = {
      for (final h in handlesJson)
        (h as Map<String, dynamic>)['id'] as String: _handleFromJson(h)
    };

    return FlowNode(
      id: json['id'] as String,
      type: json['type'] as String,
      position:
          Offset((json['x'] as num).toDouble(), (json['y'] as num).toDouble()),
      size: Size((json['w'] as num).toDouble(), (json['h'] as num).toDouble()),
      handles: handles,
      parentId: json['parentId'] as String?,
      data: (json['data'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{},
      zIndex: (json['z'] as num?)?.toInt() ?? 0,
      hitTestPadding: (json['hitTestPadding'] as num?)?.toDouble() ?? 10.0,
      hidden: json['hidden'] as bool?,
      draggable: json['draggable'] as bool?,
      selectable: json['selectable'] as bool?,
      connectable: json['connectable'] as bool?,
      deletable: json['deletable'] as bool?,
      focusable: json['focusable'] as bool?,
      elevateNodeOnSelected: json['elevateNodeOnSelected'] as bool?,
    );
  }

  // --- Handle Serialization (Updated for new NodeHandle model) ---

  Map<String, dynamic> _handleToJson(NodeHandle handle) => {
        'id': handle.id,
        'x': handle.position.dx,
        'y': handle.position.dy,
        's': handle.size,
        'type': handle.type.name,
        'isConnectable': handle.isConnectable,
      };

  NodeHandle _handleFromJson(Map<String, dynamic> json) => NodeHandle(
        id: json['id'] as String,
        position: Offset(
            (json['x'] as num).toDouble(), (json['y'] as num).toDouble()),
        // accept either compact 's' or verbose 'size'
        size: (json['s'] as num?)?.toDouble() ??
            (json['size'] as num?)?.toDouble() ??
            10.0,
        type: HandleType.values.firstWhere(
          (e) => e.name == (json['type'] as String? ?? 'both'),
          orElse: () => HandleType.both,
        ),
        isConnectable: json['isConnectable'] as bool? ?? true,
      );

  // --- Edge and Viewport Serialization (Unchanged) ---

  Map<String, dynamic> _edgeToJson(FlowEdge edge) => {
        'id': edge.id,
        'source': edge.sourceNodeId,
        'target': edge.targetNodeId,
        'sourceHandle': edge.sourceHandleId,
        'targetHandle': edge.targetHandleId,
        'z': edge.zIndex,
        'pathType': edge.pathType.name,
        'interactionWidth': edge.interactionWidth,
        'data': edge.data,
        'animated': edge.animated,
        'hidden': edge.hidden,
        'deletable': edge.deletable,
        'selectable': edge.selectable,
        'focusable': edge.focusable,
        'reconnectable': edge.reconnectable,
        'elevateEdgeOnSelected': edge.elevateEdgeOnSelected,
      };

  FlowEdge _edgeFromJson(Map<String, dynamic> json) => FlowEdge(
        id: json['id'] as String,
        sourceNodeId: json['source'] as String,
        targetNodeId: json['target'] as String,
        sourceHandleId: json['sourceHandle'] as String?,
        targetHandleId: json['targetHandle'] as String?,
        zIndex: (json['z'] as num?)?.toInt() ?? 0,
        pathType: EdgePathType.values.firstWhere(
          (e) => e.name == (json['pathType'] as String? ?? 'bezier'),
          orElse: () => EdgePathType.bezier,
        ),
        interactionWidth:
            (json['interactionWidth'] as num?)?.toDouble() ?? 10.0,
        data: (json['data'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
        animated: json['animated'] as bool?,
        hidden: json['hidden'] as bool?,
        deletable: json['deletable'] as bool?,
        selectable: json['selectable'] as bool?,
        focusable: json['focusable'] as bool?,
        reconnectable: json['reconnectable'] as bool?,
        elevateEdgeOnSelected: json['elevateEdgeOnSelected'] as bool?,
      );

  Map<String, dynamic> _viewportToJson(FlowViewport vp) => {
        'x': vp.offset.dx,
        'y': vp.offset.dy,
        'zoom': vp.zoom,
      };

  FlowViewport _viewportFromJson(Map<String, dynamic> json) => FlowViewport(
        offset: Offset(
            (json['x'] as num).toDouble(), (json['y'] as num).toDouble()),
        zoom: (json['zoom'] as num).toDouble(),
      );
}

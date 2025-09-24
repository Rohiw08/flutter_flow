import 'package:flutter/widgets.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/connection.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/connection_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/edge_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/node_state.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_export.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/utility/edge_path_creator.dart';

/// A painter for drawing the edges, active connection,
/// and selection rectangle on the canvas.
class FlowPainter extends CustomPainter {
  final Map<String, FlowNode> nodes;
  final Map<String, FlowEdge> edges;
  final FlowConnection? connection;
  final Map<String, NodeRuntimeState> nodeStates;
  final Map<String, EdgeRuntimeState> edgeStates;
  final FlowConnectionRuntimeState? connectionState;
  final Rect? selectionRect;
  final FlowCanvasTheme style;
  final double zoom;

  // Pre-built Paint objects for performance.
  final Paint _defaultEdgePaint;
  final Paint _selectedEdgePaint;
  final Paint _connectionPaint;
  final Paint _connectionEndpointPaint;
  final Paint _selectionFillPaint;
  final Paint _selectionStrokePaint;

  FlowPainter({
    required this.nodes,
    required this.edges,
    required this.connection,
    required this.selectionRect,
    required this.style,
    required this.zoom,
    this.nodeStates = const {},
    this.edgeStates = const {},
    this.connectionState,
  })  : _defaultEdgePaint = Paint()
          ..color = style.edge.defaultColor!
          ..strokeWidth = style.edge.defaultStrokeWidth!
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _selectedEdgePaint = Paint()
          ..color = style.edge.selectedColor!
          ..strokeWidth = style.edge.selectedStrokeWidth!
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _connectionPaint = Paint()
          ..strokeWidth = style.connection.strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _connectionEndpointPaint = Paint()..style = PaintingStyle.fill,
        _selectionFillPaint = Paint()..color = style.selection.fillColor!,
        _selectionStrokePaint = Paint()
          ..color = style.selection.borderColor!
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    _drawEdges(canvas);
    _drawConnection(canvas);
    _drawSelectionRect(canvas);
  }

  void _drawEdges(Canvas canvas) {
    if (edges.isEmpty) return;

    for (final entry in edges.entries) {
      final edgeId = entry.key;
      final edge = entry.value;

      final sourceNode = nodes[edge.sourceNodeId];
      final targetNode = nodes[edge.targetNodeId];

      if (sourceNode == null ||
          targetNode == null ||
          edge.sourceHandleId == null ||
          edge.targetHandleId == null) continue;

      final sourceHandle = sourceNode.handles[edge.sourceHandleId!];
      final targetHandle = targetNode.handles[edge.targetHandleId!];

      if (sourceHandle == null || targetHandle == null) continue;

      final start = sourceNode.position + sourceHandle.position;
      final end = targetNode.position + targetHandle.position;

      // Get the selection state directly from the EdgeRuntimeState
      final state = edgeStates[edgeId];
      final isSelected = state?.selected ?? false;

      final paint = isSelected ? _selectedEdgePaint : _defaultEdgePaint;

      final path = EdgePathCreator.createPath(edge.pathType, start, end);
      canvas.drawPath(path, paint);
    }
  }

  void _drawConnection(Canvas canvas) {
    if (connection == null) return;

    // This part is already correct! It properly uses connectionState.
    final isValid = connectionState?.isValid ?? false;
    final color = isValid
        ? style.connection.validTargetColor
        : style.connection.activeColor;

    _connectionPaint.color = color;
    _connectionEndpointPaint.color = color;

    final path = EdgePathCreator.createPath(
      style.connection.pathType,
      connection!.startPoint,
      connection!.endPoint,
    );
    canvas.drawPath(path, _connectionPaint);
    canvas.drawCircle(
        connection!.endPoint,
        (style.handle.size ?? 10.0) / 2, // Use handle size for consistency
        _connectionEndpointPaint);
  }

  void _drawSelectionRect(Canvas canvas) {
    if (selectionRect == null) return;
    canvas.drawRect(selectionRect!, _selectionFillPaint);

    // Scale the border width to remain visually consistent when zoomed out
    _selectionStrokePaint.strokeWidth =
        (style.selection.borderWidth! / zoom).clamp(0.5, 3.0);
    canvas.drawRect(selectionRect!, _selectionStrokePaint);
  }

  @override
  bool shouldRepaint(covariant FlowPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.edges != edges ||
        oldDelegate.nodeStates != nodeStates ||
        oldDelegate.edgeStates != edgeStates ||
        oldDelegate.connectionState != connectionState ||
        oldDelegate.connection != connection ||
        oldDelegate.selectionRect != selectionRect ||
        oldDelegate.style != style ||
        oldDelegate.zoom != zoom;
  }
}

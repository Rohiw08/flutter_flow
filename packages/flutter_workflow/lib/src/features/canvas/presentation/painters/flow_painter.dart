import 'dart:math';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/connection_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/utility/edge_path_creator.dart';
import 'package:flutter_workflow/src/theme/theme.dart';

/// A highly optimized painter for drawing edges, connections, and selection rectangles.
///
/// This painter is stateless and decoupled from the controller. It receives all
/// necessary data to draw and uses pre-built Paint objects for maximum performance.
class FlowPainter extends CustomPainter {
  final List<FlowNode> nodes;
  final List<FlowEdge> edges;
  final FlowConnectionState? connection;
  final Rect? selectionRect;
  final FlowCanvasTheme theme;
  final double zoom;

  // Pre-built Paint objects for performance.
  final Paint _defaultEdgePaint;
  final Paint _selectedEdgePaint;
  final Paint _connectionPaint;
  final Paint _connectionEndpointPaint;
  final Paint _selectionFillPaint;
  final Paint _selectionStrokePaint;
  final Paint _arrowPaint;

  FlowPainter({
    required this.nodes,
    required this.edges,
    required this.connection,
    required this.selectionRect,
    required this.theme,
    required this.zoom,
  })  : _defaultEdgePaint = Paint()
          ..color = theme.edge.defaultColor
          ..strokeWidth = theme.edge.defaultStrokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _selectedEdgePaint = Paint()
          ..color = theme.edge.selectedColor
          ..strokeWidth = theme.edge.selectedStrokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _connectionPaint = Paint()
          ..strokeWidth = theme.connection.strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _connectionEndpointPaint = Paint()..style = PaintingStyle.fill,
        _selectionFillPaint = Paint()..color = theme.selection.fillColor,
        _selectionStrokePaint = Paint()
          ..color = theme.selection.borderColor
          ..style = PaintingStyle.stroke,
        _arrowPaint = Paint()..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    _drawEdges(canvas);
    _drawConnection(canvas);
    _drawSelectionRect(canvas);
  }

  void _drawEdges(Canvas canvas) {
    if (edges.isEmpty) return;

    // Create a quick lookup map for node positions.
    final nodeMap = {for (var node in nodes) node.id: node};

    for (final edge in edges) {
      final sourceNode = nodeMap[edge.sourceNodeId];
      final targetNode = nodeMap[edge.targetNodeId];

      if (sourceNode == null || targetNode == null) continue;

      final sourceHandle = sourceNode.handles
          .firstWhereOrNull((h) => h.id == edge.sourceHandleId);
      final targetHandle = targetNode.handles
          .firstWhereOrNull((h) => h.id == edge.targetHandleId);

      if (sourceHandle == null || targetHandle == null) continue;

      final start = sourceNode.position + sourceHandle.position;
      final end = targetNode.position + targetHandle.position;

      final isSelected = sourceNode.isSelected || targetNode.isSelected;
      final paint = isSelected ? _selectedEdgePaint : _defaultEdgePaint;

      final path = EdgePathCreator.createPath(edge.pathType, start, end);
      canvas.drawPath(path, paint);

      _arrowPaint.color = paint.color;
      _drawArrowHead(canvas, start, end, _arrowPaint);
    }
  }

  void _drawArrowHead(Canvas canvas, Offset start, Offset end, Paint paint) {
    final double arrowSize = theme.edge.arrowHeadSize;
    if (arrowSize <= 0) return;

    final direction = (end - start).direction;
    if (direction.isNaN) return;

    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(end.dx - arrowSize * (cos(direction) - sin(direction) * 0.5),
          end.dy - arrowSize * (sin(direction) + cos(direction) * 0.5))
      ..lineTo(end.dx - arrowSize * (cos(direction) + sin(direction) * 0.5),
          end.dy - arrowSize * (sin(direction) - cos(direction) * 0.5))
      ..close();

    canvas.drawPath(arrowPath, paint);
  }

  void _drawConnection(Canvas canvas) {
    if (connection == null) return;

    final color = connection!.isValid
        ? theme.connection.validTargetColor
        : theme.connection.activeColor;

    _connectionPaint.color = color;
    _connectionEndpointPaint.color = color;

    final path = EdgePathCreator.createPath(
      theme.connection.pathType,
      connection!.startPosition,
      connection!.endPosition,
    );
    canvas.drawPath(path, _connectionPaint);
    canvas.drawCircle(connection!.endPosition, theme.connection.endPointRadius,
        _connectionEndpointPaint);
  }

  void _drawSelectionRect(Canvas canvas) {
    if (selectionRect == null) return;
    canvas.drawRect(selectionRect!, _selectionFillPaint);

    _selectionStrokePaint.strokeWidth =
        (theme.selection.borderWidth / zoom).clamp(0.5, 3.0);
    canvas.drawRect(selectionRect!, _selectionStrokePaint);
  }

  @override
  bool shouldRepaint(covariant FlowPainter oldDelegate) {
    // Highly efficient repaint check.
    return oldDelegate.nodes != nodes ||
        oldDelegate.edges != edges ||
        oldDelegate.connection != connection ||
        oldDelegate.selectionRect != selectionRect ||
        oldDelegate.theme != theme ||
        oldDelegate.zoom != zoom;
  }
}

// Helper extension to get angle from an Offset
extension on Offset {
  // ignore: unused_element
  double get direction => dx == 0 && dy == 0 ? 0 : atan2(dy, dx);
}

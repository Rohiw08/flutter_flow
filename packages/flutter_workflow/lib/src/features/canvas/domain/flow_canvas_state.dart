import 'dart:ui' show Rect, Size, Offset;

import 'package:flutter_workflow/src/features/canvas/application/utils/coordination_helper.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math_64.dart';

import 'models/connection_state.dart';
import 'models/edge.dart';
import 'models/node.dart';

part 'flow_canvas_state.freezed.dart';

@freezed
abstract class FlowCanvasState with _$FlowCanvasState {
  const factory FlowCanvasState({
    // Core data
    @Default([]) List<FlowNode> nodes,
    @Default([]) List<FlowEdge> edges,
    @Default({}) Set<String> selectedNodes,
    @Default({}) Map<String, Set<String>> spatialHash,

    // Interaction state
    FlowConnectionState? connection,
    Rect? selectionRect,
    @Default(DragMode.none) DragMode dragMode,

    // Viewport State
    @Default(1.0) double zoom,
    @Default(false) bool isPanZoomLocked,
    Size? viewportSize,
    Rect? viewport,

    // Configuration
    @Default(true) bool enableMultiSelection,
    @Default(true) bool enableKeyboardShortcuts,
    @Default(true) bool enableBoxSelection,
    @Default(50000) double canvasWidth,
    @Default(50000) double canvasHeight,

    // Controller
    Matrix4? matrix,
  }) = _FlowCanvasState;

  factory FlowCanvasState.initial() =>
      FlowCanvasState(matrix: Matrix4.identity());
}

// Extension to add coordinate transformation methods
extension FlowCanvasStateCoordinates on FlowCanvasState {
  /// Get the coordinate transformer for this canvas
  CoordinateTransform get coordinateTransform =>
      CoordinateTransform(canvasWidth, canvasHeight);

  /// Get the canvas size as a Size object
  Size get canvasSize => Size(canvasWidth, canvasHeight);

  /// Get the center of the canvas in canvas coordinates
  Offset get canvasCenter => coordinateTransform.canvasCenter;

  /// Get the current viewport in logical coordinates (if available)
  Rect? get logicalViewport {
    if (viewport == null) return null;
    return coordinateTransform.canvasToLogicalRect(viewport!);
  }

  /// Get the selection rectangle in logical coordinates (if available)
  Rect? get logicalSelectionRect {
    if (selectionRect == null) return null;
    return coordinateTransform.canvasToLogicalRect(selectionRect!);
  }

  /// Check if a logical position is within the canvas bounds
  bool isLogicalPositionValid(Offset logicalPosition) {
    final canvasPosition = coordinateTransform.logicalToCanvas(logicalPosition);
    return canvasPosition.dx >= 0 &&
        canvasPosition.dx <= canvasWidth &&
        canvasPosition.dy >= 0 &&
        canvasPosition.dy <= canvasHeight;
  }

  /// Get all nodes with their logical positions
  List<({FlowNode node, Offset logicalPosition})>
      get nodesWithLogicalPositions {
    return nodes
        .map((node) => (
              node: node,
              logicalPosition:
                  coordinateTransform.canvasToLogical(node.position),
            ))
        .toList();
  }

  /// Find the logical bounds of all nodes
  Rect? get nodesLogicalBounds {
    if (nodes.isEmpty) return null;

    final logicalPositions = nodes
        .map((node) => coordinateTransform.canvasToLogical(node.position))
        .toList();

    double minX = logicalPositions.first.dx;
    double maxX = logicalPositions.first.dx;
    double minY = logicalPositions.first.dy;
    double maxY = logicalPositions.first.dy;

    for (final pos in logicalPositions) {
      if (pos.dx < minX) minX = pos.dx;
      if (pos.dx > maxX) maxX = pos.dx;
      if (pos.dy < minY) minY = pos.dy;
      if (pos.dy > maxY) maxY = pos.dy;
    }

    // Add node sizes to get actual bounds
    for (final node in nodes) {
      final logicalPos = coordinateTransform.canvasToLogical(node.position);
      final right = logicalPos.dx + node.size.width;
      final bottom = logicalPos.dy + node.size.height;
      if (right > maxX) maxX = right;
      if (bottom > maxY) maxY = bottom;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}

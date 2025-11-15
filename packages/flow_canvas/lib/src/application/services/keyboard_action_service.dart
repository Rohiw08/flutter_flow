import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flow_canvas/src/features/canvas/application/services/clipboard_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/edge_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/selection_service.dart';
import 'package:flow_canvas/src/features/canvas/application/services/viewport_service.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/shared/enums.dart';

class KeyboardActionService {
  final NodeService nodeService;
  final SelectionService selectionService;
  final ViewportService viewportService;
  final ClipboardService clipboardService;
  final EdgeService edgeService;

  KeyboardActionService({
    required this.nodeService,
    required this.selectionService,
    required this.viewportService,
    required this.clipboardService,
    required this.edgeService,
  });

  /// Processes a keyboard action and returns the new state.
  /// Note: This service no longer interacts with HistoryService directly.
  FlowCanvasState handleAction(
    FlowCanvasState state,
    KeyboardAction action, {
    Offset arrowMoveDelta = const Offset(10, 10),
    double zoomStep = 0.1,
    required double minZoom,
    required double maxZoom,
    Offset focalPoint = Offset.zero,
  }) {
    switch (action) {
      // --- MUTATION ACTIONS (will be wrapped in history by the controller) ---
      case KeyboardAction.selectAll:
        return selectionService.selectAll(state);
      case KeyboardAction.deselectAll:
        return selectionService.deselectAll(state);
      case KeyboardAction.deleteSelection:
        final selectedNodeIds = state.selectedNodes.toList();
        if (selectedNodeIds.isEmpty) return state;
        final connectedEdgeIds =
            edgeService.getEdgesFromNodes(state, selectedNodeIds);
        final stateAfterEdges =
            edgeService.removeEdges(state, connectedEdgeIds);
        final newState =
            nodeService.removeNodes(stateAfterEdges, selectedNodeIds);
        return newState;
      case KeyboardAction.moveUp:
        return nodeService.moveSelectedNodes(
            state, Offset(0, arrowMoveDelta.dy));
      case KeyboardAction.moveDown:
        return nodeService.moveSelectedNodes(
            state, Offset(0, -arrowMoveDelta.dy));
      case KeyboardAction.moveLeft:
        return nodeService.moveSelectedNodes(
            state, Offset(-arrowMoveDelta.dx, 0));
      case KeyboardAction.moveRight:
        return nodeService.moveSelectedNodes(
            state, Offset(arrowMoveDelta.dx, 0));
      case KeyboardAction.duplicateSelection:
        final payload = clipboardService.copy(state);
        if (payload.isEmpty) return state;
        return clipboardService.paste(state, payload,
            positionOffset: const Offset(30, 30),
            nodeService: nodeService,
            edgeService: edgeService);

      // --- VIEWPORT (NAVIGATION) ACTIONS (will NOT be wrapped in history) ---
      case KeyboardAction.zoomIn:
        return viewportService.zoom(
          state,
          zoomFactor: 1 + zoomStep,
          focalPoint: focalPoint,
          minZoom: minZoom,
          maxZoom: maxZoom,
        );
      case KeyboardAction.zoomOut:
        return viewportService.zoom(
          state,
          zoomFactor: 1 - zoomStep,
          focalPoint: focalPoint,
          minZoom: minZoom,
          maxZoom: maxZoom,
        );
      case KeyboardAction.resetZoom:
        return state.copyWith(viewport: state.viewport.copyWith(zoom: 1.0));

      // --- HISTORY ACTIONS (handled directly by the controller) ---
      case KeyboardAction.undo:
      case KeyboardAction.redo:
        // These actions are now handled in the controller, so we just return the current state.
        return state;
    }
  }
}

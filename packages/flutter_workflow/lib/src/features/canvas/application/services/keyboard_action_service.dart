import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/clipboard_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/edge_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/history_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/node_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/selection_service.dart';
import 'package:flutter_workflow/src/features/canvas/application/services/viewport_service.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

/// Centralizes keyboard handling using KeyboardOptions mapping and services.
class KeyboardActionService {
  final HistoryService history;
  final NodeService nodeService;
  final EdgeService edgeService;
  final SelectionService selectionService;
  final ViewportService viewportService;
  final ClipboardService clipboardService;

  Map<String, dynamic>? _clipboardPayload;

  KeyboardActionService({
    required this.history,
    required this.nodeService,
    required this.edgeService,
    required this.selectionService,
    required this.viewportService,
    required this.clipboardService,
  });

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
      case KeyboardAction.selectAll:
        return history.apply(state, (s) => selectionService.selectAllNodes(s));
      case KeyboardAction.deselectAll:
        return history.apply(
            state, (s) => s.copyWith(selectedNodes: {}, selectedEdges: {}));
      case KeyboardAction.deleteSelection:
        return history.apply(state, (s) {
          final removedEdges =
              edgeService.removeEdges(s, s.selectedEdges.toList());
          FlowCanvasState cur = removedEdges;
          for (final nodeId in s.selectedNodes) {
            cur = nodeService.removeNodeAndConnections(cur, nodeId);
          }
          return cur.copyWith(selectedNodes: {}, selectedEdges: {});
        });
      case KeyboardAction.moveUp:
        return history.apply(
            state,
            (s) => nodeService.dragSelectedNodes(
                s, Offset(0, -arrowMoveDelta.dy)));
      case KeyboardAction.moveDown:
        return history.apply(
            state,
            (s) =>
                nodeService.dragSelectedNodes(s, Offset(0, arrowMoveDelta.dy)));
      case KeyboardAction.moveLeft:
        return history.apply(
            state,
            (s) => nodeService.dragSelectedNodes(
                s, Offset(-arrowMoveDelta.dx, 0)));
      case KeyboardAction.moveRight:
        return history.apply(
            state,
            (s) =>
                nodeService.dragSelectedNodes(s, Offset(arrowMoveDelta.dx, 0)));
      case KeyboardAction.zoomIn:
        return history.apply(
            state,
            (s) => viewportService.zoom(
                  s,
                  zoomFactor: 1 + zoomStep,
                  focalPoint: focalPoint,
                  minZoom: minZoom,
                  maxZoom: maxZoom,
                ));
      case KeyboardAction.zoomOut:
        return history.apply(
            state,
            (s) => viewportService.zoom(
                  s,
                  zoomFactor: 1 - zoomStep,
                  focalPoint: focalPoint,
                  minZoom: minZoom,
                  maxZoom: maxZoom,
                ));
      case KeyboardAction.resetZoom:
        return history.apply(
            state, (s) => s.copyWith(viewport: s.viewport.copyWith(zoom: 1.0)));
      case KeyboardAction.duplicateSelection:
        return history.apply(state, (s) {
          _clipboardPayload = clipboardService.copy(s);
          if (_clipboardPayload == null) return s;
          return clipboardService.paste(s, _clipboardPayload!,
              positionOffset: const Offset(30, 30));
        });
      case KeyboardAction.undo:
        return history.undo() ?? state;
      case KeyboardAction.redo:
        return history.redo() ?? state;
    }
  }
}

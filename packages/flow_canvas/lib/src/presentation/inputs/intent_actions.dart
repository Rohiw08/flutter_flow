import 'package:flutter/widgets.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/flow_options.dart';

class ZoomInIntent extends Intent {
  const ZoomInIntent();
}

class ZoomOutIntent extends Intent {
  const ZoomOutIntent();
}

class FitViewIntent extends Intent {
  const FitViewIntent();
}

class SelectAllIntent extends Intent {
  final bool selectNodes;
  final bool selectEdges;
  const SelectAllIntent({
    this.selectNodes = true,
    this.selectEdges = true,
  });
}

class DeleteIntent extends Intent {
  const DeleteIntent();
}

class UndoIntent extends Intent {
  const UndoIntent();
}

class RedoIntent extends Intent {
  const RedoIntent();
}

class CopyIntent extends Intent {
  const CopyIntent();
}

class PasteIntent extends Intent {
  const PasteIntent();
}

Map<Type, Action<Intent>> buildActions(
  FlowCanvasInternalController controller,
  FlowCanvasOptions options,
) {
  return <Type, Action<Intent>>{
    ZoomInIntent: CallbackAction<ZoomInIntent>(
      onInvoke: (intent) {
        controller.viewport.zoom(
          zoomFactor: 0.2,
          minZoom: options.viewportOptions.minZoom,
          maxZoom: options.viewportOptions.minZoom,
          focalPoint: controller.currentState.viewport.offset,
        );
        return null;
      },
    ),
    ZoomOutIntent: CallbackAction<ZoomOutIntent>(
      onInvoke: (intent) {
        controller.viewport.zoom(
          zoomFactor: -0.2,
          minZoom: options.viewportOptions.minZoom,
          maxZoom: options.viewportOptions.minZoom,
          focalPoint: controller.currentState.viewport.offset,
        );
        return null;
      },
    ),
    FitViewIntent: CallbackAction<FitViewIntent>(
      onInvoke: (intent) {
        controller.viewport.fitView();
        return null;
      },
    ),
    SelectAllIntent: CallbackAction<SelectAllIntent>(
      onInvoke: (intent) {
        controller.selection.selectAll();
        return null;
      },
    ),
    DeleteIntent: CallbackAction<DeleteIntent>(
      onInvoke: (intent) {
        final state = controller.currentState;

        // Nodes
        final defaultNodeDeletable = options.nodeOptions.deletable;

        final deletableNodeIds = state.selectedNodes.where((id) {
          final n = state.nodes[id];
          if (n == null) return false;
          return n.deletable ?? defaultNodeDeletable;
        }).toList();

        if (deletableNodeIds.isNotEmpty) {
          controller.selection.deselectAll();
          for (final id in deletableNodeIds) {
            controller.selection.selectNode(id, addToSelection: true);
          }
          controller.nodes.removeSelectedNodes();
        }

        // Edges (remaining selection might have changed; recompute)

        final refreshed = controller.currentState;
        final defaultEdgeDeletable = options.edgeOptions.deletable;
        final deletableEdgeIds = refreshed.selectedEdges.where((id) {
          final e = refreshed.edges[id];
          if (e == null) return false;
          return e.deletable ?? defaultEdgeDeletable;
        }).toList();

        if (deletableEdgeIds.isNotEmpty) {
          controller.selection.deselectAll();
          for (final id in deletableEdgeIds) {
            controller.selection.selectEdge(id, addToSelection: true);
          }
          controller.edges.removeSelectedEdges();
        }

        return null;
      },
    ),
    UndoIntent: CallbackAction<UndoIntent>(
      onInvoke: (intent) {
        controller.history.undo();
        return null;
      },
    ),
    RedoIntent: CallbackAction<RedoIntent>(
      onInvoke: (intent) {
        controller.history.redo();
        return null;
      },
    ),
    CopyIntent: CallbackAction<CopyIntent>(
      onInvoke: (intent) {
        controller.clipboard.copySelection();
        return null;
      },
    ),
    PasteIntent: CallbackAction<PasteIntent>(
      onInvoke: (intent) {
        controller.clipboard.paste();
        return null;
      },
    ),
  };
}

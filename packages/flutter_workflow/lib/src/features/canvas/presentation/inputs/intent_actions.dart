import 'package:flutter/widgets.dart';
import 'package:flutter_workflow/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/flow_options.dart';

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
  FlowCanvasController controller,
  FlowOptions options,
) {
  return <Type, Action<Intent>>{
    ZoomInIntent: CallbackAction<ZoomInIntent>(
      onInvoke: (intent) {
        controller.zoom(0.2,
            focalPoint: Offset.zero, minZoom: 0.1, maxZoom: 2.0);
        return null;
      },
    ),
    ZoomOutIntent: CallbackAction<ZoomOutIntent>(
      onInvoke: (intent) {
        controller.zoom(-0.2,
            focalPoint: Offset.zero, minZoom: 0.1, maxZoom: 2.0);
        return null;
      },
    ),
    FitViewIntent: CallbackAction<FitViewIntent>(
      onInvoke: (intent) {
        controller.fitView();
        return null;
      },
    ),
    SelectAllIntent: CallbackAction<SelectAllIntent>(
      onInvoke: (intent) {
        controller.selectAll(
          nodes: intent.selectNodes,
          edges: intent.selectEdges,
        );
        return null;
      },
    ),
    DeleteIntent: CallbackAction<DeleteIntent>(
      onInvoke: (intent) {
        // Guard deletions by deletable flags (model override -> global options)
        final state = controller.currentState;

        // Nodes
        final defaultNodeDeletable = options.nodeOptions.deletable;
        final deletableNodeIds = state.selectedNodes.where((id) {
          final n = state.nodes[id];
          if (n == null) return false;
          return n.deletable ?? defaultNodeDeletable;
        }).toList();

        if (deletableNodeIds.isNotEmpty) {
          controller.deselectAll();
          for (final id in deletableNodeIds) {
            controller.selectNode(id, addToSelection: true);
          }
          controller.removeSelectedNodes();
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
          controller.deselectAll();
          for (final id in deletableEdgeIds) {
            controller.selectEdge(id, addToSelection: true);
          }
          controller.removeSelectedEdges();
        }

        return null;
      },
    ),
    UndoIntent: CallbackAction<UndoIntent>(
      onInvoke: (intent) {
        controller.undo();
        return null;
      },
    ),
    RedoIntent: CallbackAction<RedoIntent>(
      onInvoke: (intent) {
        controller.redo();
        return null;
      },
    ),
    CopyIntent: CallbackAction<CopyIntent>(
      onInvoke: (intent) {
        controller.copySelection();
        return null;
      },
    ),
    PasteIntent: CallbackAction<PasteIntent>(
      onInvoke: (intent) {
        controller.paste();
        return null;
      },
    ),
  };
}

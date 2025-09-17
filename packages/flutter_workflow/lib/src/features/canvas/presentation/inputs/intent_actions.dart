import 'package:flutter/widgets.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
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
  const SelectAllIntent();
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
  FlowCanvasFacade facade,
  FlowOptions options,
) {
  return <Type, Action<Intent>>{
    ZoomInIntent: CallbackAction<ZoomInIntent>(
      onInvoke: (intent) {
        facade.zoom(0.2);
        return null;
      },
    ),
    ZoomOutIntent: CallbackAction<ZoomOutIntent>(
      onInvoke: (intent) {
        facade.zoom(-0.2);
        return null;
      },
    ),
    FitViewIntent: CallbackAction<FitViewIntent>(
      onInvoke: (intent) {
        facade.fitView();
        return null;
      },
    ),
    SelectAllIntent: CallbackAction<SelectAllIntent>(
      onInvoke: (intent) {
        // Not exposed on facade; using controller methods via facade
        // Consider adding selectAllNodes on facade if needed
        return null;
      },
    ),
    DeleteIntent: CallbackAction<DeleteIntent>(
      onInvoke: (intent) {
        facade.removeSelectedNodes();
        return null;
      },
    ),
  };
}

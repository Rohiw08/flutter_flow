import 'package:equatable/equatable.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_provider.dart';
import '../../painters/selection_painter.dart';

class SelectionState extends Equatable {
  final Rect? selectionRect;
  final double zoom;

  const SelectionState({this.selectionRect, required this.zoom});

  @override
  List<Object?> get props => [selectionRect, zoom];
}

class SelectionLayer extends ConsumerWidget {
  const SelectionLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(internalControllerProvider.select(
      (s) =>
          SelectionState(selectionRect: s.selectionRect, zoom: s.viewport.zoom),
    ));
    final dragMode = ref.watch(
      internalControllerProvider.select((state) => state.dragMode),
    );
    // final options = ref.read(flowOptionsProvider);
    final controller = ref.watch(internalControllerProvider.notifier);
    final isSelecting =
        ref.watch(internalControllerProvider.select((state) => state.dragMode));

    final theme = FlowCanvasThemeProvider.of(context).selection;

    return IgnorePointer(
      ignoring: isSelecting != DragMode.selection,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          controller.selection.startSelection(event.localPosition);
        },
        onPointerMove: (event) {
          if (dragMode == DragMode.selection) {
            controller.selection.updateSelection(event.localPosition);
          }
        },
        onPointerUp: (event) {
          if (dragMode == DragMode.selection) {
            controller.selection.endSelection();
          }
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: SelectionRectanglePainter(
            selectionRect: selectionState.selectionRect,
            style: theme,
            zoom: selectionState.zoom,
          ),
        ),
      ),
    );
  }
}

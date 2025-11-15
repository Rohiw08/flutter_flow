import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/history_service.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';

class HistoryController {
  final FlowCanvasInternalController _controller;
  final HistoryService _history;

  HistoryController({
    required FlowCanvasInternalController controller,
    required HistoryService history,
  })  : _controller = controller,
        _history = history;

  /// Initializes the history with a given state.
  void init(FlowCanvasState state) {
    _history.init(state);
  }

  /// Clears the entire undo/redo history.
  void clear() {
    _history.clear();
    // Also re-initialize with the current state to start a fresh history stack.
    _history.init(_controller.currentState);
  }

  /// Reverts to the previous state in the history stack, preserving the current viewport.
  void undo() {
    final currentState = _controller.currentState;
    final prevState = _history.undo();
    if (prevState != null) {
      // Apply the previous state but carry over the current transient UI state
      // (like viewport and drag mode) because they are not part of the undo history.
      final newState = prevState.copyWith(
        dragMode: currentState.dragMode,
        viewport: currentState.viewport,
        viewportSize: currentState.viewportSize,
        isPanZoomLocked: currentState.isPanZoomLocked,
      );

      // Update state directly without re-recording to history.
      _controller.updateStateOnly(newState);
    }
  }

  /// Moves to the next state in the history stack, preserving the current viewport.
  void redo() {
    final currentState = _controller.currentState;
    final nextState = _history.redo();
    if (nextState != null) {
      // Apply the next state, also carrying over the transient UI state.
      final newState = nextState.copyWith(
        dragMode: currentState.dragMode,
        viewport: currentState.viewport,
        viewportSize: currentState.viewportSize,
        isPanZoomLocked: currentState.isPanZoomLocked,
      );

      _controller.updateStateOnly(newState);
    }
  }

  void record(FlowCanvasState state) {
    _history.record(state);
  }
}

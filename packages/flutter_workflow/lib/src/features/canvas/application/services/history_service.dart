import 'package:flutter/foundation.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';

/// A lightweight history manager for undo/redo of immutable FlowCanvasState.
///
/// Usage pattern:
///   final history = HistoryService();
///   state = history.init(state);
///   state = history.apply(state, (s) => edgeService.addEdge(s, edge));
///   state = history.undo() ?? state;
class HistoryService {
  final List<FlowCanvasState> _undoStack = <FlowCanvasState>[];
  final List<FlowCanvasState> _redoStack = <FlowCanvasState>[];

  /// Initialize history with a starting state (pushes onto undo stack once).
  FlowCanvasState init(FlowCanvasState initial) {
    if (_undoStack.isEmpty || !identical(_undoStack.last, initial)) {
      _undoStack.add(initial);
    }
    _redoStack.clear();
    return initial;
  }

  /// Applies a mutation function and records the new state if it changed.
  FlowCanvasState apply(
    FlowCanvasState current,
    FlowCanvasState Function(FlowCanvasState) mutate,
  ) {
    final next = mutate(current);
    if (!identical(next, current) && next != current) {
      _undoStack.add(next);
      _redoStack.clear();
      return next;
    }
    return current;
  }

  /// Undo to the previous state; returns null if not possible.
  FlowCanvasState? undo() {
    if (_undoStack.length <= 1) return null;
    final current = _undoStack.removeLast();
    _redoStack.add(current);
    return _undoStack.last;
  }

  /// Redo to the next state; returns null if not possible.
  FlowCanvasState? redo() {
    if (_redoStack.isEmpty) return null;
    final next = _redoStack.removeLast();
    _undoStack.add(next);
    return next;
  }

  /// Clears all history.
  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }

  @visibleForTesting
  (int undo, int redo) get lengths => (_undoStack.length, _redoStack.length);
}

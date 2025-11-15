import 'dart:async';
import '../events/pane_change.dart';

class PaneStreams {
  final StreamController<PaneEvent> _paneEventController =
      StreamController<PaneEvent>.broadcast();

  /// A stream of all pane interaction events.
  Stream<PaneEvent> get events => _paneEventController.stream;

  // --- Type-Safe Filtered Streams ---

  /// A stream that emits events when a pane move gesture starts.
  Stream<PaneMoveStartEvent> get moveStartEvents =>
      events.where((e) => e is PaneMoveStartEvent).cast<PaneMoveStartEvent>();

  /// A stream that emits events as the pane is being moved (panned).
  Stream<PaneMoveEvent> get moveEvents =>
      events.where((e) => e is PaneMoveEvent).cast<PaneMoveEvent>();

  /// A stream that emits events when a pane move gesture ends.
  Stream<PaneMoveEndEvent> get moveEndEvents =>
      events.where((e) => e is PaneMoveEndEvent).cast<PaneMoveEndEvent>();

  /// A stream that emits events when the pane is tapped.
  Stream<PaneTapEvent> get tapEvents =>
      events.where((e) => e is PaneTapEvent).cast<PaneTapEvent>();

  /// A stream that emits events for pane context menu interactions.
  Stream<PaneContextMenuEvent> get contextMenuEvents => events
      .where((e) => e is PaneContextMenuEvent)
      .cast<PaneContextMenuEvent>();

  /// A stream that emits events when the user scrolls on the pane.
  Stream<PaneScrollEvent> get scrollEvents =>
      events.where((e) => e is PaneScrollEvent).cast<PaneScrollEvent>();

  /// Emits a new pane interaction event.
  void emitEvent(PaneEvent event) {
    if (!_paneEventController.isClosed) {
      _paneEventController.add(event);
    }
  }

  /// Closes the stream controller.
  void dispose() {
    _paneEventController.close();
  }
}

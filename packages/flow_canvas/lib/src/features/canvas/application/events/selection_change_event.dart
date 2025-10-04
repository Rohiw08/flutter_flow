import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';

class SelectionChangeEvent {
  final Set<String> selectedNodeIds;
  final Set<String> selectedEdgeIds;
  final FlowCanvasState state;
  final DateTime timestamp;

  SelectionChangeEvent({
    required this.selectedNodeIds,
    required this.selectedEdgeIds,
    required this.state,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

import 'package:flutter/painting.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';

/// A stateless service for performing high-performance queries on handles.
/// It uses the unified NodeIndex from the FlowCanvasState.
class HandleQueryService {
  /// Finds all handle IDs within a 3x3 grid area around the given position.
  Set<String> getHandlesNear(FlowCanvasState state, Offset position) {
    return state.nodeIndex.queryHandlesNear(position);
  }
}

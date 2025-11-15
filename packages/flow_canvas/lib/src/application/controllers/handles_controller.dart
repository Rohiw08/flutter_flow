import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/handle_state.dart';

class HandleController {
  final FlowCanvasInternalController _controller;

  HandleController({
    required FlowCanvasInternalController controller,
  }) : _controller = controller;

  /// Updates the hover state for a specific handle.
  /// This is a transient UI change and is not recorded in history.
  void setHandleHover(String handleKey, bool isHovered) {
    final currentStates = Map<String, HandleRuntimeState>.from(
        _controller.currentState.handleStates);
    final currentState = currentStates[handleKey] ?? const HandleRuntimeState();

    // Avoid unnecessary state updates if the hover state is already correct.
    if (currentState.hovered == isHovered) return;

    currentStates[handleKey] = currentState.copyWith(hovered: isHovered);

    _controller.updateStateOnly(
      _controller.currentState.copyWith(handleStates: currentStates),
    );
  }

  // Future methods for managing other handle states will go here.
  // For example:
  // void setHandleActive(String handleKey, bool isActive) { ... }
  // void setHandleValidTarget(String handleKey, bool isValid) { ... }
}

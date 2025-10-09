import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/serialization_service.dart';

class SerializationController {
  final FlowCanvasController _controller;
  final SerializationService _serializationService;

  SerializationController({
    required FlowCanvasController controller,
    required SerializationService serializationService,
  })  : _controller = controller,
        _serializationService = serializationService;

  /// Serializes the entire current canvas state to a JSON-compatible map.
  Map<String, dynamic> toJson() =>
      _serializationService.toJson(_controller.currentState);

  /// Deserializes a JSON map to replace the entire canvas state.
  /// This action also resets the history.
  void fromJson(Map<String, dynamic> json) {
    // This is a special mutation because it also needs to reset the history.
    _controller.mutate((s) => _serializationService.fromJson(s, json));
    _controller.history.clear();
    _controller.history.init(_controller.currentState);
  }
}

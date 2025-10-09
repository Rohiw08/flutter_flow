import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/application/services/z_index_service.dart';

class ZIndexController {
  final FlowCanvasController _controller;
  final ZIndexService _zIndexService;

  ZIndexController({
    required FlowCanvasController controller,
    required ZIndexService zIndexService,
  })  : _controller = controller,
        _zIndexService = zIndexService;

  /// Brings all currently selected nodes to the front.
  void bringSelectionToFront() =>
      _controller.mutate((s) => _zIndexService.bringSelectedToFront(s));

  /// Sends all currently selected nodes to the back.
  void sendSelectionToBack() =>
      _controller.mutate((s) => _zIndexService.sendSelectedToBack(s));

  /// Brings a specific node to the front.
  void bringNodeToFront(String nodeId) =>
      _controller.mutate((s) => _zIndexService.bringToFront(s, nodeId));

  /// Sends a specific node to the back.
  void sendNodeToBack(String nodeId) =>
      _controller.mutate((s) => _zIndexService.sendToBack(s, nodeId));
}

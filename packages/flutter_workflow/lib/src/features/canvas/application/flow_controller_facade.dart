import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/node_registry.dart';

/// A simple facade to use the library without depending on Riverpod in app code.
///
/// This facade owns an internal ProviderContainer and a FlowCanvasController.
/// Use this for controlled mode without importing Riverpod or managing providers.
class FlowController {
  final ProviderContainer _container;
  late final FlowCanvasController _controller;
  final NodeRegistry _nodeRegistry;
  final EdgeRegistry _edgeRegistry;

  FlowController({
    required NodeRegistry nodeRegistry,
    required EdgeRegistry edgeRegistry,
    FlowCanvasState? initialState,
  })  : _container = ProviderContainer(),
        _nodeRegistry = nodeRegistry,
        _edgeRegistry = edgeRegistry {
    final provider =
        StateNotifierProvider<FlowCanvasController, FlowCanvasState>(
      (ref) => FlowCanvasController(
        ref,
        nodeRegistry: nodeRegistry,
        edgeRegistry: edgeRegistry,
        initialState: initialState,
      ),
    );
    _controller = _container.read(provider.notifier);
  }

  /// Access to the underlying controller for internal wiring.
  FlowCanvasController get controller => _controller;

  /// Registries used by this controller.
  NodeRegistry get nodeRegistry => _nodeRegistry;
  EdgeRegistry get edgeRegistry => _edgeRegistry;

  /// Current immutable state snapshot.
  FlowCanvasState get state => _controller.currentState;

  /// Dispose resources.
  void dispose() {
    _controller.dispose();
    _container.dispose();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/connection_callbacks.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/edge_callbacks.dart';
import '../features/canvas/application/flow_canvas_controller.dart';
import '../features/canvas/application/callbacks/node_callbacks.dart';
import '../features/canvas/domain/state/flow_canvas_state.dart';
import '../features/canvas/domain/registries/edge_registry.dart';
import '../features/canvas/domain/registries/node_registry.dart';

/// The central provider for the FlowCanvas state and controller.
///
/// This is a `StateNotifierProvider.family` which allows us to pass in the
/// user-defined registries when the controller is first created. This is the
/// primary way the UI will interact with the canvas's state.
final flowControllerProvider = StateNotifierProvider.family<
    FlowCanvasController,
    FlowCanvasState,
    ({NodeRegistry nodeRegistry, EdgeRegistry edgeRegistry})>(
  (ref, registries) {
    // This creates the single instance of our controller, providing it with
    // a ref to read other providers and the necessary registries.
    return FlowCanvasController(
      ref,
      nodeRegistry: registries.nodeRegistry,
      edgeRegistry: registries.edgeRegistry,
    );
  },
);

// Global node callbacks that apply to all nodes unless overridden
final globalNodeCallbacksProvider = Provider<NodeCallbacks>((ref) {
  return const NodeCallbacks();
});

// Global edges callbacks that apply to all nodes unless overridden
final globalEdgeCallbacksProvider = Provider<EdgeCallbacks>((ref) {
  return const EdgeCallbacks();
});

// Global edges callbacks that apply to all nodes unless overridden
final globalConnectionCallbacksProvider = Provider<ConnectionCallbacks>((ref) {
  return const ConnectionCallbacks();
});

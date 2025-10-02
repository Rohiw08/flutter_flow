import 'package:flow_canvas/flow_canvas.dart' show FlowOptions;
import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/canvas/application/flow_canvas_controller.dart';
import '../features/canvas/application/services/clipboard_service.dart';
import '../features/canvas/application/services/connection_service.dart';
import '../features/canvas/application/services/edge_query_service.dart';
import '../features/canvas/application/services/edge_service.dart';
import '../features/canvas/application/services/history_service.dart';
import '../features/canvas/application/services/keyboard_action_service.dart';
import '../features/canvas/application/services/node_query_service.dart';
import '../features/canvas/application/services/node_service.dart';
import '../features/canvas/application/services/selection_service.dart';
import '../features/canvas/application/services/serialization_service.dart';
import '../features/canvas/application/services/viewport_service.dart';
import '../features/canvas/application/services/z_index_service.dart';
import '../features/canvas/domain/flow_canvas_state.dart';
import '../features/canvas/domain/registries/edge_registry.dart';
import '../features/canvas/domain/registries/node_registry.dart';

/// The central provider for the FlowCanvas state and controller.
///
/// This is a `StateNotifierProvider.family` which allows us to pass in the
/// user-defined registries when the controller is first created. This is the
/// primary way the UI will interact with the canvas's state.
final flowControllerProvider =
    StateNotifierProvider<FlowCanvasController, FlowCanvasState>(
  (ref) {
    // Create the controller
    return FlowCanvasController(
      ref,
    );
  },
);

/// This provider is the key to our internal state management.
///
/// It is not intended for public use by the library's users. It is
/// overridden within the FlowCanvas widget to provide the correct controller
/// instance to all descendant widgets.
final internalControllerProvider =
    StateNotifierProvider<FlowCanvasController, FlowCanvasState>((ref) {
  // This should never be called directly.
  throw UnimplementedError(
      'This provider is for internal use and must be overridden.');
});

/// Provider for the NodeRegistry.
/// This should be overridden in the FlowCanvas widget.
final nodeRegistryProvider = Provider<NodeRegistry>((ref) {
  throw UnimplementedError('NodeRegistryProvider must be overridden');
});

/// Provider for the EdgeRegistry.
/// This should be overridden in the FlowCanvas widget.
final edgeRegistryProvider = Provider<EdgeRegistry>((ref) {
  throw UnimplementedError('EdgeRegistryProvider must be overridden');
});

final flowOptionsProvider = Provider<FlowOptions>((ref) {
  throw UnimplementedError('FlowOptionsProvider must be overridden');
});

final coordinateConverterProvider = Provider<CanvasCoordinateConverter>((ref) {
  final options = ref.watch(flowOptionsProvider);
  return CanvasCoordinateConverter(
    canvasWidth: options.canvasWidth,
    canvasHeight: options.canvasHeight,
  );
});

// --- SERVICE PROVIDERS ---

final nodeServiceProvider = Provider<NodeService>((ref) => NodeService());
final edgeServiceProvider = Provider<EdgeService>((ref) => EdgeService());
final selectionServiceProvider =
    Provider<SelectionService>((ref) => SelectionService());
final viewportServiceProvider =
    Provider<ViewportService>((ref) => ViewportService());
final connectionServiceProvider =
    Provider<ConnectionService>((ref) => ConnectionService());
final zIndexServiceProvider = Provider<ZIndexService>((ref) => ZIndexService());
final clipboardServiceProvider =
    Provider<ClipboardService>((ref) => ClipboardService());
final historyServiceProvider =
    Provider<HistoryService>((ref) => HistoryService());
final serializationServiceProvider =
    Provider<SerializationService>((ref) => SerializationService());
final edgeQueryServiceProvider =
    Provider<EdgeQueryService>((ref) => EdgeQueryService());
final nodeQueryServiceProvider =
    Provider<NodeQueryService>((ref) => NodeQueryService());

// This one is special as it depends on other services
final keyboardActionServiceProvider = Provider<KeyboardActionService>((ref) {
  return KeyboardActionService(
    history: ref.watch(historyServiceProvider),
    nodeService: ref.watch(nodeServiceProvider),
    edgeService: ref.watch(edgeServiceProvider),
    selectionService: ref.watch(selectionServiceProvider),
    viewportService: ref.watch(viewportServiceProvider),
    clipboardService: ref.watch(clipboardServiceProvider),
  );
});

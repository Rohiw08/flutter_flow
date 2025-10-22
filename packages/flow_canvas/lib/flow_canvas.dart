/// The main entry point for the Flutter Workflow library.
///
/// This file exports all the public-facing APIs, including the core canvas,
/// controllers, data models, theming, and options.
library flow_canvas;

// --- Core ---
export 'src/features/canvas/presentation/flow_canvas.dart';

// --- Domain Models ---
export 'src/features/canvas/domain/models/node.dart';
export 'src/features/canvas/domain/models/edge.dart';
export 'src/features/canvas/domain/models/handle.dart';
export 'src/features/canvas/domain/models/connection.dart';
export 'src/features/canvas/domain/models/coordinate_extent.dart';

// --- Domain Registries ---
export 'src/features/canvas/domain/registries/node_registry.dart';
export 'src/features/canvas/domain/registries/edge_registry.dart';

// --- Theming ---
export 'src/features/canvas/presentation/theme/theme_export.dart';

// --- Options ---
export 'src/features/canvas/presentation/options/flow_options.dart';
export 'src/features/canvas/presentation/options/components/edge_options.dart';
export 'src/features/canvas/presentation/options/components/fitview_options.dart';
export 'src/features/canvas/presentation/options/components/keyboard_options.dart';
export 'src/features/canvas/presentation/options/components/node_options.dart';
export 'src/features/canvas/presentation/options/components/viewport_options.dart';

// --- Callbacks & Events ---
export 'src/features/canvas/application/callbacks/connection_callbacks.dart';
export 'src/features/canvas/application/callbacks/edge_callbacks.dart';
export 'src/features/canvas/application/callbacks/node_callbacks.dart';
export 'src/features/canvas/application/callbacks/pane_callbacks.dart';
export 'src/features/canvas/application/events/connection_change_event.dart';
export 'src/features/canvas/application/events/edge_change_event.dart';
export 'src/features/canvas/application/events/node_change_event.dart';
export 'src/features/canvas/application/events/pane_change.dart';
export 'src/features/canvas/application/events/selection_change_event.dart';
export 'src/features/canvas/application/events/viewport_change_event.dart';
export 'src/features/canvas/application/flow_canvas_controller.dart';

// --- Streams ---
export 'src/features/canvas/application/streams/connection_change_stream.dart';
export 'src/features/canvas/application/streams/edge_change_stream.dart';
export 'src/features/canvas/application/streams/node_change_stream.dart';
export 'src/features/canvas/application/streams/pane_change_stream.dart';
export 'src/features/canvas/application/streams/selection_change_stream.dart';
export 'src/features/canvas/application/streams/viewport_change_stream.dart';

// --- Shared ---
export 'src/shared/enums.dart';

// --- Widgets ---
export 'src/features/canvas/presentation/widgets/flow_canvas_controls.dart';
export 'src/features/canvas/presentation/widgets/control_button.dart';
export 'src/features/canvas/presentation/widgets/flow_minimap.dart';
export 'src/features/canvas/presentation/widgets/flow_handle.dart';
export 'src/features/canvas/presentation/widgets/layers/flow_background.dart';
export 'src/features/canvas/presentation/widgets/flow_node.dart';

// --- Utility ---
export 'src/features/canvas/presentation/utility/flow_positioned.dart';
export 'src/features/canvas/presentation/utility/typedefs.dart';

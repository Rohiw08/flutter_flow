// --- PUBLIC API FACADE ---
// The main entry point for all library interactions.
export 'src/features/canvas/presentation/flow_canvas_facade.dart';

// --- PRESENTATION (UI WIDGETS) ---
// The widgets the user will add to their application.
export 'src/features/canvas/presentation/flow_canvas.dart';
export 'src/features/canvas/presentation/widgets/flow_minimap.dart';
export 'src/features/canvas/presentation/widgets/flow_background.dart';
export 'src/features/canvas/presentation/widgets/flow_canvas_controls.dart';
export 'src/features/canvas/presentation/widgets/handle.dart';

// --- DOMAIN (DATA MODELS & REGISTRIES) ---
// The data models the user will need to create nodes and edges.
export 'src/features/canvas/domain/models/node.dart';
export 'src/features/canvas/domain/models/edge.dart';
export 'src/features/canvas/domain/models/handle.dart';
export 'src/features/canvas/domain/registries/node_registry.dart';
export 'src/features/canvas/domain/registries/edge_registry.dart';

// --- SHARED ENUMS ---
export 'src/shared/enums.dart';

// --- THEMING ---
// The public theme data, providers, and builders.
export 'src/features/canvas/presentation/theme/theme_export.dart';

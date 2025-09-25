import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/connection_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/edge_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/node_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/application/callbacks/pane_callbacks.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/edge.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flow_canvas/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/flow_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/options_provider.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_provider.dart';

import '../../../shared/providers.dart';
import '../application/flow_canvas_controller.dart';
import 'widgets/layers/edges_layer.dart';
import 'widgets/layers/nodes_layer.dart';
import 'adapters/controller_adapter.dart';
import 'inputs/keymap.dart';
import 'widgets/flow_background.dart';

typedef FlowCanvasCreatedCallback = void Function(
    FlowCanvasController controller);

/// The main entry point widget for the Flow Canvas library.
class FlowCanvas extends StatefulWidget {
  // --- CORE MEMBERS ---
  final List<FlowNode>? initialNodes;
  final List<FlowEdge>? initialEdges;
  final NodeRegistry nodeRegistry;
  final EdgeRegistry edgeRegistry;
  final FlowOptions options;
  final FlowCanvasTheme? theme;

  // --- CALLBACKS ---
  final FlowCanvasCreatedCallback? onCanvasCreated;
  final NodeCallbacks nodeCallbacks;
  final EdgeCallbacks edgeCallbacks;
  final ConnectionCallbacks connectionCallbacks;
  final PaneCallbacks paneCallbacks;

  // --- UI ---
  final List<Widget> overlays;

  const FlowCanvas({
    super.key,
    required this.nodeRegistry,
    required this.edgeRegistry,
    this.onCanvasCreated,
    this.initialNodes,
    this.initialEdges,
    this.theme,
    this.options = const FlowOptions(),
    this.nodeCallbacks = const NodeCallbacks(),
    this.edgeCallbacks = const EdgeCallbacks(),
    this.connectionCallbacks = const ConnectionCallbacks(),
    this.paneCallbacks = const PaneCallbacks(),
    this.overlays = const [],
  });

  @override
  State<FlowCanvas> createState() => _FlowCanvasState();
}

class _FlowCanvasState extends State<FlowCanvas> {
  late final ProviderContainer _providerContainer;
  late final FlowCanvasController _controller;

  @override
  void initState() {
    super.initState();

    final initialState = FlowCanvasState.initial().copyWith(
      nodes: {for (var n in widget.initialNodes ?? []) n.id: n},
      edges: {for (var e in widget.initialEdges ?? []) e.id: e},
    );

    _providerContainer = ProviderContainer(
      overrides: [
        nodeRegistryProvider.overrideWithValue(widget.nodeRegistry),
        edgeRegistryProvider.overrideWithValue(widget.edgeRegistry),
        flowControllerProvider.overrideWith(
          (ref) => FlowCanvasController(ref, initialState: initialState),
        ),
        // Expose the created controller via the internalControllerProvider so
        // descendant widgets can read/watch it. This prevents the
        // UnimplementedError when internalControllerProvider is accessed.
        internalControllerProvider.overrideWith(
          (ref) => ref.watch(flowControllerProvider.notifier),
        ),
      ],
    );

    _controller = _providerContainer.read(flowControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onCanvasCreated?.call(_controller);
    });
  }

  @override
  void dispose() {
    _providerContainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: _providerContainer,
      child: FlowCanvasThemeProvider(
        theme: widget.theme,
        child: FlowCanvasOptionsProvider(
          options: widget.options,
          child: _FlowCanvasCore(
            overlays: widget.overlays,
            nodeCallbacks: widget.nodeCallbacks,
            edgeCallbacks: widget.edgeCallbacks,
            paneCallbacks: widget.paneCallbacks,
          ),
        ),
      ),
    );
  }
}

class _FlowCanvasCore extends ConsumerWidget {
  final List<Widget> overlays;
  final NodeCallbacks nodeCallbacks;
  final PaneCallbacks paneCallbacks;
  final EdgeCallbacks edgeCallbacks;

  const _FlowCanvasCore({
    required this.overlays,
    required this.nodeCallbacks,
    required this.paneCallbacks,
    required this.edgeCallbacks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the globally defined internalControllerProvider
    final controller = ref.watch(internalControllerProvider.notifier);
    final options = FlowCanvasOptionsProvider.of(context);
    final isLocked = ref.watch(
      internalControllerProvider.select((state) => state.isPanZoomLocked),
    );

    final backgroundOverlays = overlays.whereType<FlowBackground>().toList();
    final foregroundOverlays =
        overlays.where((w) => w is! FlowBackground).toList();

    return KeyboardAdapter(
      controller: controller,
      options: options,
      keymap: Keymap.standard(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              controller.setViewportSize(
                  Size(constraints.maxWidth, constraints.maxHeight));
            }
          });

          return Stack(
            clipBehavior: Clip.none,
            children: [
              InteractiveViewer(
                transformationController: controller.transformationController,
                constrained: false,
                minScale: options.viewportOptions.minZoom,
                maxScale: options.viewportOptions.maxZoom,
                panEnabled: !isLocked,
                scaleEnabled: !isLocked,
                child: SizedBox(
                  width: options.canvasWidth,
                  height: options.canvasHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ...backgroundOverlays,
                      FlowEdgeLayer(
                        edgeCallbacks: edgeCallbacks,
                        paneCallbacks: paneCallbacks,
                      ),
                      FlowNodesLayer(
                        nodeCallbacks: nodeCallbacks,
                        paneCallbacks: paneCallbacks,
                      ),
                    ],
                  ),
                ),
              ),
              ...foregroundOverlays,
            ],
          );
        },
      ),
    );
  }
}

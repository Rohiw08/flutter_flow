import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/connection_callbacks.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/edge_callbacks.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/node_callbacks.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/pane_callbacks.dart';
import 'package:flutter_workflow/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flutter_workflow/src/features/canvas/application/flow_controller_facade.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/flow_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/options_provider.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/flow_theme.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_provider.dart';

import '../../../shared/providers.dart';
import 'widgets/layers/edges_layer.dart';
import 'widgets/layers/nodes_layer.dart';
import 'adapters/controller_adapter.dart';
import 'inputs/keymap.dart';

/// The main entry point widget for the Flow Canvas library.
class FlowCanvas extends StatefulWidget {
  // --- CORE MEMBERS ---
  final FlowController? controller;
  final List<FlowNode>? initialNodes;
  final List<FlowEdge>? initialEdges;
  final NodeRegistry? nodeRegistry;
  final EdgeRegistry? edgeRegistry;
  final FlowOptions options;
  final FlowCanvasTheme? theme;

  // --- CALLBACKS ---
  final NodeCallbacks nodeCallbacks;
  final EdgeCallbacks edgeCallbacks;
  final ConnectionCallbacks connectionCallbacks;
  final PaneCallbacks paneCallbacks;

  // --- UI ---
  final List<Widget> overlays;

  //
  const FlowCanvas({
    super.key,
    this.controller,
    this.nodeRegistry,
    this.edgeRegistry,
    this.initialNodes,
    this.initialEdges,
    this.theme,
    this.options = const FlowOptions(),
    this.nodeCallbacks = const NodeCallbacks(),
    this.edgeCallbacks = const EdgeCallbacks(),
    this.connectionCallbacks = const ConnectionCallbacks(),
    this.paneCallbacks = const PaneCallbacks(),
    this.overlays = const [],
  }) : assert(
          (controller != null) ^ (nodeRegistry != null && edgeRegistry != null),
          'Provide either a FlowController (controlled) OR nodeRegistry+edgeRegistry (uncontrolled).',
        );

  @override
  State<FlowCanvas> createState() => _FlowCanvasState();
}

class _FlowCanvasState extends State<FlowCanvas> {
  late final FlowCanvasController _controller;
  late final ProviderContainer _internalProviderContainer;
  bool _ownsController = false;
  late final NodeRegistry _nodeRegistryInUse;
  late final EdgeRegistry _edgeRegistryInUse;

  @override
  void initState() {
    super.initState();
    _internalProviderContainer = ProviderContainer();

    if (widget.controller != null) {
      // Controlled: use provided controller, and take registries from it to avoid duplication
      _controller = widget.controller!.controller;
      _nodeRegistryInUse = widget.controller!.nodeRegistry;
      _edgeRegistryInUse = widget.controller!.edgeRegistry;
      _ownsController = false;
    } else {
      // Uncontrolled by default: manage internal state ourselves
      _ownsController = true;
      _nodeRegistryInUse = widget.nodeRegistry!;
      _edgeRegistryInUse = widget.edgeRegistry!;
      _controller = _internalProviderContainer.read(
        StateNotifierProvider<FlowCanvasController, FlowCanvasState>(
          (ref) => FlowCanvasController(
            ref,
            nodeRegistry: _nodeRegistryInUse,
            edgeRegistry: _edgeRegistryInUse,
            initialState: FlowCanvasState.initial().copyWith(
              nodes: {for (var n in widget.initialNodes ?? []) n.id: n},
              edges: {for (var e in widget.initialEdges ?? []) e.id: e},
            ),
          ),
        ).notifier,
      );
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    _internalProviderContainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This ProviderScope creates the isolated "internal world" for Riverpod.
    // It's completely hidden from the user of the library.
    return ProviderScope(
      overrides: [
        internalControllerProvider.overrideWith((ref) => _controller),
      ],
      child: FlowCanvasThemeProvider(
        theme: widget.theme,
        child: FlowCanvasOptionsProvider(
          options: widget.options,
          child: _FlowCanvasCore(
            overlays: widget.overlays,
            nodeRegistry: _nodeRegistryInUse,
            edgeRegistry: _edgeRegistryInUse,
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
  final NodeRegistry nodeRegistry;
  final EdgeRegistry edgeRegistry;
  final NodeCallbacks nodeCallbacks;
  final PaneCallbacks paneCallbacks;
  final EdgeCallbacks edgeCallbacks;

  const _FlowCanvasCore({
    required this.overlays,
    required this.nodeRegistry,
    required this.edgeRegistry,
    required this.nodeCallbacks,
    required this.paneCallbacks,
    required this.edgeCallbacks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(internalControllerProvider.notifier);
    final options = FlowCanvasOptionsProvider.of(context);
    final isLocked = ref.watch(
      internalControllerProvider.select((state) => state.isPanZoomLocked),
    );

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
                      FlowEdgeLayer(
                        edgeRegistry: edgeRegistry,
                        edgeCallbacks: edgeCallbacks,
                        paneCallbacks: paneCallbacks,
                      ),
                      FlowNodesLayer(
                        nodeRegistry: nodeRegistry,
                        nodeCallbacks: nodeCallbacks,
                        paneCallbacks: paneCallbacks,
                      ),
                    ],
                  ),
                ),
              ),
              ...overlays,
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/connection_callbacks.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/edge_callbacks.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/node_callbacks.dart';
import 'package:flutter_workflow/src/features/canvas/application/callbacks/pane_callbacks.dart';
import 'package:flutter_workflow/src/features/canvas/application/flow_canvas_controller.dart';
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
  final FlowCanvasController? controller;
  final List<FlowNode>? initialNodes;
  final List<FlowEdge>? initialEdges;
  final NodeRegistry nodeRegistry;
  final EdgeRegistry edgeRegistry;
  final FlowOptions options;
  final FlowCanvasTheme? theme;

  // --- CALLBACKS ---
  final NodeCallbacks nodeCallbacks;
  final EdgeCallbacks edgeCallbacks;
  final ConnectionCallbacks connectionCallbacks;
  final PaneCallbacks paneCallbacks;

  // --- UI ---
  final List<Widget> overlays;

  /// Controlled Constructor
  ///
  /// Use this when you want to manage the state and interactions externally by
  /// creating and providing your own [FlowCanvasController].
  const FlowCanvas({
    super.key,
    required this.controller,
    required this.nodeRegistry,
    required this.edgeRegistry,
    this.options = const FlowOptions(),
    this.theme,
    this.nodeCallbacks = const NodeCallbacks(),
    this.edgeCallbacks = const EdgeCallbacks(),
    this.connectionCallbacks = const ConnectionCallbacks(),
    this.paneCallbacks = const PaneCallbacks(),
    this.overlays = const [],
  })  : initialNodes = null,
        initialEdges = null;

  /// Uncontrolled Constructor
  ///
  /// Use this for a quick and simple setup. The canvas will create and manage
  /// its own internal state. You can provide initial nodes and edges.
  const FlowCanvas.uncontrolled({
    super.key,
    required this.nodeRegistry,
    required this.edgeRegistry,
    this.initialNodes,
    this.initialEdges,
    this.theme,
    this.options = const FlowOptions(),
    this.nodeCallbacks = const NodeCallbacks(),
    this.edgeCallbacks = const EdgeCallbacks(),
    this.connectionCallbacks = const ConnectionCallbacks(),
    this.paneCallbacks = const PaneCallbacks(),
    this.overlays = const [],
  }) : controller = null;

  @override
  State<FlowCanvas> createState() => _FlowCanvasState();
}

class _FlowCanvasState extends State<FlowCanvas> {
  late final FlowCanvasController _controller;
  late final ProviderContainer _internalProviderContainer;
  bool _isUncontrolled = false;

  @override
  void initState() {
    super.initState();
    _internalProviderContainer = ProviderContainer();

    if (widget.controller != null) {
      _controller = widget.controller!;
      _isUncontrolled = false;
    } else {
      _isUncontrolled = true;
      _controller = _internalProviderContainer.read(
        StateNotifierProvider<FlowCanvasController, FlowCanvasState>(
          (ref) => FlowCanvasController(
            ref,
            nodeRegistry: widget.nodeRegistry,
            edgeRegistry: widget.edgeRegistry,
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
    if (_isUncontrolled) {
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
            nodeRegistry: widget.nodeRegistry,
            edgeRegistry: widget.edgeRegistry,
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

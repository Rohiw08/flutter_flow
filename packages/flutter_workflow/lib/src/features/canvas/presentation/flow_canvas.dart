import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/widgets/flow_background.dart';
import 'package:flutter_workflow/src/theme/theme_export.dart';
import 'painters/flow_painter.dart';

class FlowCanvas extends StatefulWidget {
  final NodeRegistry nodeRegistry;
  final EdgeRegistry edgeRegistry;
  final double minScale;
  final double maxScale;
  final bool fitView;
  final List<Widget> overlays;
  final FlowCanvasFacade facade;
  // final List<FlowNode> nodes;

  const FlowCanvas(
      {super.key,
      required this.nodeRegistry,
      required this.edgeRegistry,
      required this.facade,
      this.minScale = 0.1,
      this.maxScale = 2.0,
      this.overlays = const [],
      // this.nodes = const [],
      this.fitView = false});

  @override
  State<FlowCanvas> createState() => _FlowCanvasState();
}

class _FlowCanvasState extends State<FlowCanvas> {
  late final FlowCanvasFacade facade;
  bool _shouldDisposeLocalFacade = false;

  @override
  void initState() {
    super.initState();

    facade = widget.facade;
    _shouldDisposeLocalFacade = false;

    if (widget.fitView) {
      facade.fitView();
    } else {
      facade.centerView();
    }
  }

  @override
  void dispose() {
    if (_shouldDisposeLocalFacade) {
      facade.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlowCanvasThemeProvider.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Report viewport size to the facade
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              constraints.hasBoundedWidth &&
              constraints.hasBoundedHeight) {
            final viewportSize =
                Size(constraints.maxWidth, constraints.maxHeight);
            // Use a private method to set viewport size in your controller
            facade.setViewportSize(viewportSize);
          }
        });

        return Stack(
          children: [
            Listener(
              onPointerMove: (details) {
                facade.updateConnection(details.localPosition);
              },
              child: GestureDetector(
                onPanStart: (details) =>
                    facade.startSelection(details.localPosition),
                onPanUpdate: (details) =>
                    facade.updateSelection(details.localPosition),
                onPanEnd: (details) => facade.endSelection(),
                child: InteractiveViewer(
                  transformationController: facade.transformationController,
                  constrained: false,
                  boundaryMargin: EdgeInsets.zero,
                  minScale: widget.minScale,
                  maxScale: widget.maxScale,
                  clipBehavior: Clip.none,
                  child: StreamBuilder<FlowCanvasState>(
                    stream: facade.fullCanvasStream,
                    initialData: facade.state,
                    builder: (context, snapshot) {
                      final canvasState = snapshot.data;

                      if (canvasState == null) {
                        return SizedBox(
                          width: 50000,
                          height: 50000,
                          child: Container(
                            color:
                                theme.background.backgroundColor.withAlpha(25),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                        );
                      }

                      return SizedBox(
                          width: facade.state.canvasWidth,
                          height: facade.state.canvasHeight,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Background overlays (move with canvas)
                              ...widget.overlays.whereType<FlowBackground>(),

                              // Main canvas painting
                              CustomPaint(
                                size: Size.infinite,
                                painter: FlowPainter(
                                  nodes: facade.state.nodes,
                                  edges: facade.state.edges,
                                  connection: facade.state.connection,
                                  selectionRect: facade.state.selectionRect,
                                  theme: theme,
                                  zoom: facade.state.zoom,
                                ),
                              ),

                              // Render nodes\

                              ...facade.state.nodes.map((node) =>
                                  _buildNode(node, facade.canvasCentre)),
                            ],
                          ));
                    },
                  ),
                ),
              ),
            ),

            // UI overlays (don't move with canvas)
            ...widget.overlays.where((overlay) => overlay is! FlowBackground),
          ],
        );
      },
    );
  }

  Widget _buildNode(FlowNode node, Offset centre) {
    final nodeWidget = widget.nodeRegistry.buildWidget(node);
    return Positioned(
      left: node.position.dx + centre.dx,
      top: node.position.dy + centre.dy,
      width: node.size.width,
      height: node.size.height,
      child: nodeWidget,
    );
  }
}

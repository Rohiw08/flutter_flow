import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/theme/theme_export.dart';

import 'painters/flow_painter.dart';

/// The main widget that displays the interactive canvas.
///
/// This widget is responsible for creating and managing the `FlowCanvasFacade`
/// and building the UI based on the state streams from the facade.
class FlowCanvas extends StatefulWidget {
  final NodeRegistry nodeRegistry;
  final EdgeRegistry edgeRegistry;
  final double minScale;
  final double maxScale;

  const FlowCanvas({
    super.key,
    required this.nodeRegistry,
    required this.edgeRegistry,
    this.minScale = 0.1,
    this.maxScale = 2.0,
  });

  @override
  State<FlowCanvas> createState() => _FlowCanvasState();
}

class _FlowCanvasState extends State<FlowCanvas> {
  late final FlowCanvasFacade facade;

  @override
  void initState() {
    super.initState();
    facade = FlowCanvasFacade(
      nodeRegistry: widget.nodeRegistry,
      edgeRegistry: widget.edgeRegistry,
    );
  }

  @override
  void dispose() {
    facade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlowCanvasThemeProvider.of(context);

    return Listener(
      onPointerMove: (details) {
        // Pass pointer move events to the facade for connection line updates
        facade.updateConnection(details.localPosition);
      },
      child: GestureDetector(
        onPanStart: (details) {
          // Start box selection when panning on the canvas background
          facade.startSelection(details.localPosition);
        },
        onPanUpdate: (details) {
          facade.updateSelection(details.localPosition);
        },
        onPanEnd: (details) {
          facade.endSelection();
        },
        child: InteractiveViewer(
          transformationController: facade.transformationController,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          clipBehavior: Clip.none,
          child: StreamBuilder<FlowCanvasState>(
            stream: facade.fullCanvasStream,
            builder: (context, snapshot) {
              final canvasState = snapshot.data;
              if (canvasState == null) {
                return SizedBox(
                  width: facade.state.canvasWidth,
                  height: facade.state.canvasHeight,
                );
              }

              return SizedBox(
                width: facade.state.canvasWidth,
                height: facade.state.canvasHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: FlowPainter(
                        nodes: canvasState.nodes,
                        edges: canvasState.edges,
                        connection: canvasState.connection,
                        selectionRect: canvasState.selectionRect,
                        theme: theme,
                        zoom: canvasState.zoom,
                      ),
                    ),
                    ...canvasState.nodes.map((node) => _buildNode(node)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNode(FlowNode node) {
    final nodeWidget = widget.nodeRegistry.buildWidget(node);
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      width: node.size.width,
      height: node.size.height,
      child: nodeWidget,
    );
  }
}

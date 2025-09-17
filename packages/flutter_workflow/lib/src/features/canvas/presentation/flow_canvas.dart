import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show PointerScrollEvent;
import 'package:flutter_workflow/src/features/canvas/domain/state/flow_canvas_state.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/edge_registry.dart';
import 'package:flutter_workflow/src/features/canvas/domain/registries/node_registry.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/widgets/flow_background.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_export.dart';
import 'painters/flow_painter.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/options_extensions.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/viewport_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/flow_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/node_options.dart';

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

  // Cache overlays split once to avoid recomputation during builds
  late final List<Widget> _backgroundOverlays;
  late final List<Widget> _uiOverlays;

  @override
  void initState() {
    super.initState();

    facade = widget.facade;
    _shouldDisposeLocalFacade = false;

    // Split overlays once
    _backgroundOverlays = widget.overlays.whereType<FlowBackground>().toList();
    _uiOverlays = widget.overlays.where((o) => o is! FlowBackground).toList();

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
    final flowOptions = context.flowCanvasOptions;
    final viewportOptions = ViewportOptions.resolve(context, null);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Only schedule when constraints are stable and mounted
        if (constraints.hasBoundedWidth && constraints.hasBoundedHeight) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            final viewportSize =
                Size(constraints.maxWidth, constraints.maxHeight);
            facade.setViewportSize(viewportSize);
          });
        }

        final enableBoxSelection =
            flowOptions.enableBoxSelection && viewportOptions.selectionOnDrag;

        return Stack(
          children: [
            Listener(
              onPointerSignal: (signal) {
                if (signal is PointerScrollEvent) {
                  if (viewportOptions.zoomOnScroll) {
                    final delta = -signal.scrollDelta.dy.sign * 0.08;
                    facade.zoom(delta,
                        focalPoint: signal.localPosition,
                        minZoom: viewportOptions.minZoom,
                        maxZoom: viewportOptions.maxZoom);
                  } else if (viewportOptions.panOnScroll) {
                    final pan =
                        signal.scrollDelta * viewportOptions.panOnScrollSpeed;
                    facade.pan(pan);
                  }
                }
              },
              onPointerMove: (details) {
                facade.updateConnection(details.localPosition);
                // Auto-pan while connecting
                final isConnecting = facade.state.connection != null;
                if ((isConnecting && viewportOptions.autoPanOnConnect)) {
                  _maybeAutoPan(details.localPosition, viewportOptions);
                }
              },
              child: GestureDetector(
                onDoubleTapDown: viewportOptions.zoomOnDoubleClick
                    ? (d) => facade.zoom(0.2,
                        focalPoint: d.localPosition,
                        minZoom: viewportOptions.minZoom,
                        maxZoom: viewportOptions.maxZoom)
                    : null,
                onPanStart: enableBoxSelection
                    ? (details) => facade.startSelection(details.localPosition)
                    : null,
                onPanUpdate: enableBoxSelection
                    ? (details) => facade.updateSelection(details.localPosition,
                        selectionMode: viewportOptions.selectionMode)
                    : null,
                onPanEnd: enableBoxSelection
                    ? (details) => facade.endSelection()
                    : null,
                child: InteractiveViewer(
                  transformationController: facade.transformationController,
                  constrained: false,
                  boundaryMargin: EdgeInsets.zero,
                  minScale: viewportOptions.minZoom,
                  maxScale: viewportOptions.maxZoom,
                  panEnabled: viewportOptions.panOnDrag,
                  scaleEnabled: viewportOptions.zoomOnPinch ||
                      viewportOptions.zoomOnDoubleClick,
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
                                theme.background.backgroundColor!.withAlpha(25),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                        );
                      }

                      final nodesToRender = _resolveVisibleNodes(canvasState,
                          viewportOptions.onlyRenderVisibleElements);

                      return SizedBox(
                          width: flowOptions.canvasWidth,
                          height: flowOptions.canvasHeight,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Background overlays (move with canvas)
                              ..._backgroundOverlays,

                              // Main canvas painting isolated from node subtree
                              RepaintBoundary(
                                child: _FlowCanvasPaint(facade: facade),
                              ),

                              // Render nodes (each wrapped in its own RepaintBoundary)
                              ...nodesToRender.map((node) => RepaintBoundary(
                                  child: _buildNodeWidget(
                                      context,
                                      node,
                                      Offset(flowOptions.canvasWidth / 2,
                                          flowOptions.canvasHeight / 2),
                                      flowOptions,
                                      viewportOptions))),
                            ],
                          ));
                    },
                  ),
                ),
              ),
            ),

            // UI overlays (don't move with canvas)
            ..._uiOverlays,
          ],
        );
      },
    );
  }

  List<FlowNode> _resolveVisibleNodes(FlowCanvasState state, bool onlyVisible) {
    if (!onlyVisible || state.viewportSize == null) {
      return state.nodes.values.toList();
    }
    final zoom = state.viewport.zoom;
    final offset = state.viewport.offset;
    final size = state.viewportSize!;
    final topLeftCanvas = (-offset) / zoom;
    final rect = Rect.fromLTWH(topLeftCanvas.dx, topLeftCanvas.dy,
        size.width / zoom, size.height / zoom);
    return state.nodeIndex.queryInRect(rect);
  }

  Widget _buildNodeWidget(BuildContext context, FlowNode node, Offset centre,
      FlowOptions flowOptions, ViewportOptions viewportOptions) {
    final nodeWidget = widget.nodeRegistry.buildWidget(node);
    return Positioned(
      left: node.position.dx + centre.dx,
      top: node.position.dy + centre.dy,
      width: node.size.width,
      height: node.size.height,
      child: Listener(
        onPointerMove: (e) {
          if (viewportOptions.autoPanOnNodeDrag) {
            _maybeAutoPan(e.localPosition, viewportOptions);
          }
        },
        child: GestureDetector(
          onTap: () {
            if (!flowOptions.enableBoxSelection) return;
            if (!(node.isSelectable(context))) return;
            facade.selectNode(node.id);
          },
          onPanStart: (details) {
            if (!(node.isDraggable(context))) return;
            // Ensure node is selected before dragging
            if (!facade.state.selectedNodes.contains(node.id)) {
              facade.selectNode(node.id);
            }
          },
          onPanUpdate: (details) {
            if (!(node.isDraggable(context))) return;
            final snap = viewportOptions.snapToGrid;
            facade.dragSelectedBy(details.delta,
                snapToGrid: snap, grid: viewportOptions.snapGrid);
          },
          child: nodeWidget,
        ),
      ),
    );
  }

  void _maybeAutoPan(Offset localPosition, ViewportOptions options) {
    final size = facade.state.viewportSize;
    if (size == null) return;
    const edge = 24.0;
    Offset pan = Offset.zero;
    if (localPosition.dx < edge) pan += const Offset(-1, 0);
    if (localPosition.dx > size.width - edge) pan += const Offset(1, 0);
    if (localPosition.dy < edge) pan += const Offset(0, -1);
    if (localPosition.dy > size.height - edge) pan += const Offset(0, 1);
    if (pan == Offset.zero) return;
    facade.pan(pan * options.autoPanSpeed);
  }
}

/// Isolated paint subtree that rebuilds with stream but does not force node widgets to repaint
class _FlowCanvasPaint extends StatelessWidget {
  const _FlowCanvasPaint({required this.facade});

  final FlowCanvasFacade facade;

  @override
  Widget build(BuildContext context) {
    final theme = FlowCanvasThemeProvider.of(context);
    return StreamBuilder<FlowCanvasState>(
      stream: facade.fullCanvasStream,
      initialData: facade.state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? facade.state;
        return CustomPaint(
          size: Size.infinite,
          painter: FlowPainter(
            nodes: state.nodes,
            edges: state.edges,
            connection: state.connection,
            selectionRect: state.selectionRect,
            theme: theme,
            zoom: state.viewport.zoom,
          ),
        );
      },
    );
  }
}

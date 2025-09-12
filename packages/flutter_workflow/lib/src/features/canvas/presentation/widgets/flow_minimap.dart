import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/painters/minimap_painter.dart';
import 'package:flutter_workflow/src/theme/components/minimap_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/theme/theme_resolver/minimap_theme_resolver.dart';

/// A function that returns a color for a given node in the minimap.
typedef MiniMapNodeColorFunc = Color? Function(FlowNode node);

/// A highly customizable and performant minimap widget for the FlowCanvas.
class FlowMiniMap extends ConsumerWidget {
  final FlowCanvasFacade facade;

  // --- Sizing and Positioning ---
  final double width;
  final double height;
  final Alignment position;
  final EdgeInsetsGeometry margin;

  // --- Theming & Overrides ---
  final FlowCanvasMiniMapTheme? miniMapTheme;

  // --- Interactivity ---
  final bool pannable;
  final bool zoomable;

  const FlowMiniMap({
    super.key,
    required this.facade,
    this.width = 200,
    this.height = 150,
    this.position = Alignment.bottomRight,
    this.margin = const EdgeInsetsGeometry.all(20),
    this.miniMapTheme,
    this.pannable = true,
    this.zoomable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = resolveMiniMapTheme(context, miniMapTheme);

    return Align(
      alignment: position,
      child: Container(
        margin: margin,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.circular(theme.borderRadius!),
            border: Border.all(
              color: theme.maskStrokeColor!.withAlpha(125),
              width: 1,
            ),
            boxShadow: theme.shadows,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.borderRadius!),
            child: StreamBuilder<List<Object>>(
              stream: facade.nodesAndViewportStream.cast<List<Object>>(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                final nodes = snapshot.data![0] as Map<String, FlowNode>;
                final viewport = snapshot.data![1] as Rect;

                return Listener(
                  onPointerSignal:
                      zoomable ? (event) => _onPointerSignal(event) : null,
                  child: GestureDetector(
                    onTapUp: pannable
                        ? (details) => _onTapUp(details, nodes, theme)
                        : null,
                    onPanUpdate: pannable
                        ? (details) => _onPanUpdate(details, nodes, theme)
                        : null,
                    child: CustomPaint(
                      painter: MiniMapPainter(
                        nodes: nodes,
                        viewport: viewport,
                        theme: theme,
                      ),
                      size: Size(width, height),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUp(
    TapUpDetails details,
    List<FlowNode> nodes,
    FlowCanvasMiniMapTheme theme,
  ) {
    final transform = MiniMapPainter.calculateTransform(
      _getBounds(nodes),
      Size(width, height),
      theme,
    );
    if (transform.scale <= 0) return;

    final canvasPosition =
        MiniMapPainter.fromMiniMapToCanvas(details.localPosition, transform);
    facade.centerOnPosition(canvasPosition);
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    List<FlowNode> nodes,
    FlowCanvasMiniMapTheme theme,
  ) {
    final transform = MiniMapPainter.calculateTransform(
      _getBounds(nodes),
      Size(width, height),
      theme,
    );
    if (transform.scale <= 0) return;

    final canvasDelta = details.delta / transform.scale;
    facade.pan(canvasDelta);
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final zoomDelta = -event.scrollDelta.dy * 0.001;
      facade.zoom(zoomDelta);
    }
  }

  Rect _getBounds(List<FlowNode> nodes) {
    if (nodes.isEmpty) return Rect.zero;
    return nodes
        .map((n) => n.rect)
        .reduce((value, element) => value.expandToInclude(element));
  }
}

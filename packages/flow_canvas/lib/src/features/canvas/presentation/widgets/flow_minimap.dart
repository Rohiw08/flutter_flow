import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/painters/minimap_painter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/minimap_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import '../../../../shared/providers.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';

typedef MiniMapNodeProperty<T> = T Function(FlowNode node);
typedef MiniMapNodeColorFunc = Color? Function(FlowNode node);
typedef MiniMapNodeBuilder = Path Function(FlowNode node);
typedef MiniMapNodeOnClick = void Function(FlowNode node);

class FlowMiniMap extends ConsumerWidget {
  final double width;
  final double height;
  final Alignment alignment;
  final EdgeInsetsGeometry margin;
  final FlowMinimapStyle? minimapStyle;
  final bool pannable;
  final bool zoomable;
  final bool inversePan;
  final MiniMapNodeColorFunc? nodeColor;
  final MiniMapNodeColorFunc? nodeStrokeColor;
  final MiniMapNodeProperty<double>? nodeStrokeWidth;
  final MiniMapNodeProperty<double>? nodeBorderRadius;
  final MiniMapNodeBuilder? nodeBuilder;
  final MiniMapNodeOnClick? onClickNode;

  const FlowMiniMap({
    super.key,
    this.width = 200,
    this.height = 150,
    this.alignment = Alignment.bottomRight,
    this.margin = const EdgeInsets.all(20),
    this.minimapStyle,
    this.pannable = true,
    this.zoomable = true,
    this.inversePan = false,
    this.nodeColor,
    this.nodeStrokeColor,
    this.nodeStrokeWidth,
    this.nodeBorderRadius,
    this.nodeBuilder,
    this.onClickNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(internalControllerProvider.notifier);
    final state = ref.watch(internalControllerProvider);
    final baseTheme = context.flowCanvasTheme.minimap;
    final style = baseTheme.merge(minimapStyle);

    final nodes = state.nodes.values.toList();
    final viewportSize = state.viewportSize ?? Size.zero;
    final topLeft = controller.screenToCanvasPosition(Offset.zero);
    final bottomRight = controller.screenToCanvasPosition(
        Offset(viewportSize.width, viewportSize.height));
    final cartesianViewportRect = Rect.fromPoints(topLeft, bottomRight);

    return Align(
      alignment: alignment,
      child: Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(style.borderRadius),
          border:
              Border.all(color: style.maskStrokeColor.withAlpha(125), width: 1),
          boxShadow: style.shadows,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(style.borderRadius),
          child: Listener(
            onPointerSignal: zoomable
                ? (event) => _onPointerSignal(event, ref, controller)
                : null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: pannable
                  ? (details) => _onTapUp(details, nodes, style, controller)
                  : null,
              onPanUpdate: pannable
                  ? (details) => _onPanUpdate(
                      details, nodes, style, controller, state.viewport.zoom)
                  : null,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: MiniMapPainter(
                    nodes: nodes,
                    viewport: cartesianViewportRect,
                    theme: style,
                    nodeColor: nodeColor,
                    nodeStrokeColor: nodeStrokeColor,
                    nodeStrokeWidth: nodeStrokeWidth,
                    nodeBorderRadius: nodeBorderRadius,
                    nodeBuilder: nodeBuilder,
                  ),
                  size: Size(width, height),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUp(
    TapUpDetails details,
    List<FlowNode> nodes,
    FlowMinimapStyle style,
    FlowCanvasController controller,
  ) {
    final minimapSize = Size(width, height);
    final bounds =
        MiniMapPainter(nodes: nodes, viewport: Rect.zero, theme: style)
            .getCombinedBounds(nodes, Rect.zero);
    final transform =
        MiniMapPainter.calculateTransform(bounds, minimapSize, style);
    if (transform.scale <= 0) return;

    final cartesianPosition = MiniMapPainter.fromMiniMapToCanvas(
        details.localPosition, transform, minimapSize);

    FlowNode? clickedNode;
    for (final node in nodes.reversed) {
      if (node.rect.contains(cartesianPosition)) {
        clickedNode = node;
        break;
      }
    }

    if (clickedNode != null && onClickNode != null) {
      onClickNode!(clickedNode);
    } else {
      controller.centerOnPosition(cartesianPosition);
    }
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    List<FlowNode> nodes,
    FlowMinimapStyle style,
    FlowCanvasController controller,
    double mainCanvasZoom,
  ) {
    final minimapSize = Size(width, height);
    final bounds =
        MiniMapPainter(nodes: nodes, viewport: Rect.zero, theme: style)
            .getCombinedBounds(nodes, Rect.zero);
    final transform =
        MiniMapPainter.calculateTransform(bounds, minimapSize, style);
    if (transform.scale <= 0) return;

    final screenDelta = details.delta * (mainCanvasZoom / transform.scale);
    controller.panBy(inversePan ? screenDelta : -screenDelta);
  }

  void _onPointerSignal(PointerSignalEvent event, WidgetRef ref,
      FlowCanvasController controller) {
    if (event is PointerScrollEvent) {
      final options = ref.read(flowOptionsProvider);
      final zoomDelta = -event.scrollDelta.dy * 0.001;
      controller.zoom(
        zoomFactor: zoomDelta,
        focalPoint: event.position,
        minZoom: options.viewportOptions.minZoom,
        maxZoom: options.viewportOptions.maxZoom,
      );
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/painters/minimap_painter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/minimap_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import 'package:flow_canvas/src/shared/providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _MinimapViewModel extends Equatable {
  final List<FlowNode> nodes;
  final Rect viewportRect;
  final double mainCanvasZoom;

  const _MinimapViewModel({
    required this.nodes,
    required this.viewportRect,
    required this.mainCanvasZoom,
  });

  @override
  List<Object?> get props => [nodes, viewportRect, mainCanvasZoom];
}

typedef MiniMapNodeProperty<T> = T Function(FlowNode node);
typedef MiniMapNodeColorFunc = Color? Function(FlowNode node);
typedef MiniMapNodeBuilder = Path Function(FlowNode node);
typedef MiniMapNodeOnClick = void Function(FlowNode node);

class FlowMiniMap extends ConsumerWidget {
  final bool pannable;
  final bool zoomable;
  final bool inversePan;
  final Size size;
  final Alignment alignment;
  final EdgeInsetsGeometry margin;
  final FlowMinimapStyle? minimapStyle;

  final MiniMapNodeColorFunc? nodeColor;
  final MiniMapNodeColorFunc? nodeStrokeColor;
  final MiniMapNodeProperty<double>? nodeStrokeWidth;
  final MiniMapNodeProperty<double>? nodeBorderRadius;
  final MiniMapNodeBuilder? nodeBuilder;
  final MiniMapNodeOnClick? onClickNode;

  const FlowMiniMap({
    super.key,
    this.size = const Size(200, 150),
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
    final viewModel = ref.watch(internalControllerProvider.select((s) {
      final viewportSize = s.viewportSize ?? Size.zero;
      final controller = ref.read(internalControllerProvider.notifier);
      final topLeft = controller.viewport.screenToCanvasPosition(Offset.zero);
      final bottomRight = controller.viewport.screenToCanvasPosition(
          Offset(viewportSize.width, viewportSize.height));

      return _MinimapViewModel(
        nodes: s.nodes.values.toList(),
        viewportRect: Rect.fromPoints(topLeft, bottomRight),
        mainCanvasZoom: s.viewport.zoom,
      );
    }));

    final controller = ref.read(internalControllerProvider.notifier);
    final theme = minimapStyle ?? context.flowCanvasTheme.minimap;

    final bounds = MiniMapPainter.getCombinedBounds(
        viewModel.nodes, viewModel.viewportRect);
    final transform = MiniMapPainter.calculateTransform(bounds, size, theme);

    return Align(
      alignment: alignment,
      child: Container(
        margin: margin,
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: theme.borderRadius,
          border:
              Border.all(color: theme.maskStrokeColor.withAlpha(125), width: 1),
          boxShadow: theme.shadows,
        ),
        child: ClipRRect(
          borderRadius: theme.borderRadius,
          child: Listener(
            onPointerSignal: zoomable
                ? (event) => _onPointerSignal(event, ref, controller)
                : null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: pannable
                  ? (details) =>
                      _onTapUp(details, viewModel.nodes, transform, controller)
                  : null,
              onPanUpdate: pannable
                  ? (details) => _onPanUpdate(
                      details, transform, controller, viewModel.mainCanvasZoom)
                  : null,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: MiniMapPainter(
                    nodes: viewModel.nodes,
                    viewport: viewModel.viewportRect,
                    theme: theme,
                    nodeColor: nodeColor,
                    nodeStrokeColor: nodeStrokeColor,
                    nodeStrokeWidth: nodeStrokeWidth,
                    nodeBorderRadius: nodeBorderRadius,
                    nodeBuilder: nodeBuilder,
                  ),
                  size: size,
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
    MiniMapTransform transform,
    FlowCanvasController controller,
  ) {
    if (transform.scale <= 0) return;

    final cartesianPosition = MiniMapPainter.fromMiniMapToCanvas(
        details.localPosition, transform, size);

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
      controller.viewport.centerOnPosition(cartesianPosition);
    }
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    MiniMapTransform transform,
    FlowCanvasController controller,
    double mainCanvasZoom,
  ) {
    if (transform.scale <= 0) return;
    final screenDelta = details.delta * (mainCanvasZoom / transform.scale);
    controller.viewport.panBy(inversePan ? screenDelta : -screenDelta);
  }

  void _onPointerSignal(PointerSignalEvent event, WidgetRef ref,
      FlowCanvasController controller) {
    if (event is PointerScrollEvent) {
      final options = ref.read(flowOptionsProvider);
      final zoomDelta = -event.scrollDelta.dy * 0.001;
      controller.viewport.zoom(
        zoomFactor: zoomDelta,
        focalPoint: event.position,
        minZoom: options.viewportOptions.minZoom,
        maxZoom: options.viewportOptions.maxZoom,
      );
    }
  }
}

import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/painters/minimap_painter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/minimap_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_resolver/minimap_theme_resolver.dart';

import '../../../../shared/providers.dart';

/// A function that returns a color for a given node in the minimap.
typedef MiniMapNodeColorFunc = Color? Function(FlowNode node);

/// A highly customizable and performant minimap widget for the FlowCanvas.
class FlowMiniMap extends ConsumerStatefulWidget {
  final double width;
  final double height;
  final Alignment alignment;
  final EdgeInsetsGeometry margin;
  final FlowMinimapStyle? minimapStyle;
  final bool pannable;
  final bool zoomable;

  const FlowMiniMap({
    super.key,
    this.width = 200,
    this.height = 150,
    this.alignment = Alignment.bottomRight,
    this.margin = const EdgeInsets.all(20),
    this.minimapStyle,
    this.pannable = true,
    this.zoomable = true,
  });

  @override
  ConsumerState<FlowMiniMap> createState() => _FlowMiniMapState();
}

class _FlowMiniMapState extends ConsumerState<FlowMiniMap> {
  late FlowMinimapStyle _resolvedStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolvedStyle = resolveMiniMapTheme(context, widget.minimapStyle);
  }

  @override
  void didUpdateWidget(covariant FlowMiniMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minimapStyle != widget.minimapStyle) {
      _resolvedStyle = resolveMiniMapTheme(context, widget.minimapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(internalControllerProvider.notifier);
    final state = ref.watch(internalControllerProvider);
    final style = _resolvedStyle;

    // The nodes in the state are already in the correct Cartesian coordinate system.
    // We can pass them directly to the painter.
    final nodes = state.nodes.values.toList();

    // CORRECTLY calculate the viewport rectangle in Cartesian coordinates.
    final viewportSize = state.viewportSize ?? Size.zero;
    final topLeft = controller.screenToCanvasPosition(Offset.zero);
    final bottomRight = controller.screenToCanvasPosition(
        Offset(viewportSize.width, viewportSize.height));
    final cartesianViewportRect = Rect.fromPoints(topLeft, bottomRight);

    return Align(
      alignment: widget.alignment,
      child: Container(
        margin: widget.margin,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(style.borderRadius ?? 8.0),
          border: Border.all(
            color: (style.maskStrokeColor ?? Colors.grey).withAlpha(125),
            width: 1,
          ),
          boxShadow: style.shadows,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(style.borderRadius ?? 8.0),
          child: Listener(
            onPointerSignal: widget.zoomable
                ? (event) => _onPointerSignal(event, controller)
                : null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: widget.pannable
                  ? (details) => _onTapUp(details, nodes, style, controller)
                  : null,
              onPanUpdate: widget.pannable
                  ? (details) => _onPanUpdate(
                      details, nodes, style, controller, state.viewport.zoom)
                  : null,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: MiniMapPainter(
                    nodes: nodes, // Use original nodes
                    viewport: cartesianViewportRect, // Use corrected viewport
                    theme: style,
                  ),
                  size: Size(widget.width, widget.height),
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
    final transform = MiniMapPainter.calculateTransform(
      _getBounds(nodes),
      Size(widget.width, widget.height),
      style,
    );
    if (transform.scale <= 0) return;

    final cartesianPosition =
        MiniMapPainter.fromMiniMapToCanvas(details.localPosition, transform);

    controller.centerOnPosition(cartesianPosition);
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    List<FlowNode> nodes,
    FlowMinimapStyle style,
    FlowCanvasController controller,
    double mainCanvasZoom,
  ) {
    final transform = MiniMapPainter.calculateTransform(
      _getBounds(nodes),
      Size(widget.width, widget.height),
      style,
    );
    if (transform.scale <= 0) return;

    // Convert the drag delta from minimap pixels to canvas pixels
    final canvasDelta = details.delta / transform.scale;
    // Convert canvas pixels to screen pixels for the main view
    final screenDelta = canvasDelta * mainCanvasZoom;

    // Call the new panBy method with the inverted delta
    controller.panBy(-screenDelta);
  }

  Rect _getBounds(List<FlowNode> nodes) {
    if (nodes.isEmpty) return Rect.zero;
    return nodes
        .map((n) => n.rect)
        .reduce((value, element) => value.expandToInclude(element));
  }

  void _onPointerSignal(
      PointerSignalEvent event, FlowCanvasController controller) {
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

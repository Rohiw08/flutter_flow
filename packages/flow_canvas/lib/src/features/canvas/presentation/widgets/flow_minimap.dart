import 'package:flow_canvas/src/features/canvas/presentation/utility/canvas_coordinate_converter.dart';
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
    final options = ref.read(flowOptionsProvider);
    final style = _resolvedStyle;

    // Create coordinate converter
    final coordinateConverter = CanvasCoordinateConverter(
      canvasWidth: options.canvasWidth,
      canvasHeight: options.canvasHeight,
    );

    final viewportSize = state.viewportSize ?? Size.zero;
    final viewportRect = Rect.fromLTWH(
      -state.viewport.offset.dx / state.viewport.zoom,
      -state.viewport.offset.dy / state.viewport.zoom,
      viewportSize.width / state.viewport.zoom,
      viewportSize.height / state.viewport.zoom,
    );

    // Convert viewport from render coordinates to cartesian coordinates
    final cartesianViewportRect =
        coordinateConverter.renderRectToCartesianRect(viewportRect);

    // Convert nodes from render coordinates to cartesian coordinates
    final nodes = state.nodes.values.toList();
    final cartesianNodes = nodes.map((node) {
      final cartesianRect =
          coordinateConverter.renderRectToCartesianRect(node.rect);
      return FlowNode(
        id: node.id,
        position: cartesianRect.topLeft,
        size: cartesianRect.size,
        hitTestPadding: node.hitTestPadding,
        data: node.data,
        type: node.type,
        draggable: node.draggable,
        selectable: node.selectable,
        deletable: node.deletable,
      );
    }).toList();

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
                  ? (details) => _onTapUp(details, cartesianNodes, style,
                      controller, coordinateConverter)
                  : null,
              onPanUpdate: widget.pannable
                  ? (details) => _onPanUpdate(details, cartesianNodes, style,
                      controller, coordinateConverter)
                  : null,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: MiniMapPainter(
                    nodes: cartesianNodes, // Use converted nodes
                    viewport: cartesianViewportRect, // Use converted viewport
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
    List<FlowNode> cartesianNodes,
    FlowMinimapStyle style,
    dynamic controller,
    CanvasCoordinateConverter coordinateConverter,
  ) {
    final transform = MiniMapPainter.calculateTransform(
      _getBounds(cartesianNodes),
      Size(widget.width, widget.height),
      style,
    );
    if (transform.scale <= 0) return;

    // Get position in cartesian space from minimap click
    final cartesianPosition =
        MiniMapPainter.fromMiniMapToCanvas(details.localPosition, transform);

    // Pass the cartesian position directly to the controller
    // The controller should handle coordinate conversion internally if needed
    controller.centerOnPosition(cartesianPosition);
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    List<FlowNode> cartesianNodes,
    FlowMinimapStyle style,
    dynamic controller,
    CanvasCoordinateConverter coordinateConverter,
  ) {
    final transform = MiniMapPainter.calculateTransform(
      _getBounds(cartesianNodes),
      Size(widget.width, widget.height),
      style,
    );
    if (transform.scale <= 0) return;

    // Convert the pan delta to cartesian space
    final cartesianDelta = details.delta / transform.scale;

    // Convert to render delta for the controller
    final renderDelta = coordinateConverter.toRenderDelta(cartesianDelta);

    // Apply the pan with correct delta
    controller.pan(-renderDelta);
  }

  Rect _getBounds(List<FlowNode> nodes) {
    if (nodes.isEmpty) return Rect.zero;
    return nodes
        .map((n) => n.rect)
        .reduce((value, element) => value.expandToInclude(element));
  }

  void _onPointerSignal(PointerSignalEvent event, dynamic controller) {
    if (event is PointerScrollEvent) {
      final zoomDelta = -event.scrollDelta.dy * 0.001;
      controller.zoom(zoomDelta,
          focalPoint: Offset.zero, minZoom: 0.1, maxZoom: 2.0);
    }
  }
}

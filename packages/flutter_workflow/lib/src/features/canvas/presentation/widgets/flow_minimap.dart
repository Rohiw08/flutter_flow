// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
// import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
// import 'package:flutter_workflow/src/features/canvas/presentation/painters/minimap_painter.dart';
// import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/minimap_theme.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_resolver/minimap_theme_resolver.dart';

// /// A function that returns a color for a given node in the minimap.
// typedef MiniMapNodeColorFunc = Color? Function(FlowNode node);

// /// A highly customizable and performant minimap widget for the FlowCanvas.
// class FlowMiniMap extends ConsumerStatefulWidget {
//   final FlowCanvasFacade facade;
//   final double width;
//   final double height;
//   final Alignment position;
//   final EdgeInsetsGeometry margin;
//   final FlowMinimapStyle? miniMapTheme;
//   final bool pannable;
//   final bool zoomable;

//   const FlowMiniMap({
//     super.key,
//     required this.facade,
//     this.width = 200,
//     this.height = 150,
//     this.position = Alignment.bottomRight,
//     this.margin = const EdgeInsets.all(20),
//     this.miniMapTheme,
//     this.pannable = true,
//     this.zoomable = true,
//   });

//   @override
//   ConsumerState<FlowMiniMap> createState() => _FlowMiniMapState();
// }

// class _FlowMiniMapState extends ConsumerState<FlowMiniMap> {
//   late FlowMinimapStyle _resolvedTheme;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _resolvedTheme = resolveMiniMapTheme(context, widget.miniMapTheme);
//   }

//   @override
//   void didUpdateWidget(covariant FlowMiniMap oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.miniMapTheme != widget.miniMapTheme) {
//       _resolvedTheme = resolveMiniMapTheme(context, widget.miniMapTheme);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = _resolvedTheme;

//     return Align(
//       alignment: widget.position,
//       child: Container(
//         margin: widget.margin,
//         child: Container(
//           width: widget.width,
//           height: widget.height,
//           decoration: BoxDecoration(
//             color: theme.backgroundColor,
//             borderRadius: BorderRadius.circular(theme.borderRadius!),
//             border: Border.all(
//               color: theme.maskStrokeColor!.withAlpha(125),
//               width: 1,
//             ),
//             boxShadow: theme.shadows,
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(theme.borderRadius!),
//             child: StreamBuilder<({List<FlowNode> nodes, Rect? viewport})>(
//               stream: Stream.value((
//                 nodes: widget.facade.state.nodes.values.toList(),
//                 viewport: widget.facade.state.viewport.asRect(widget.facade.state.viewportSize),
//               )),
//               builder: (context, snapshot) {
//                 final data = snapshot.data;
//                 if (data == null) {
//                   return const SizedBox.shrink();
//                 }
//                 final nodes = data.nodes;
//                 final viewport = data.viewport ?? Rect.zero;

//                 return Listener(
//                   onPointerSignal: widget.zoomable
//                       ? (event) => _onPointerSignal(event)
//                       : null,
//                   child: GestureDetector(
//                     onTapUp: widget.pannable
//                         ? (details) => _onTapUp(details, nodes, theme)
//                         : null,
//                     onPanUpdate: widget.pannable
//                         ? (details) => _onPanUpdate(details, nodes, theme)
//                         : null,
//                     child: CustomPaint(
//                       painter: MiniMapPainter(
//                         nodes: nodes,
//                         viewport: viewport,
//                         theme: theme,
//                       ),
//                       size: Size(widget.width, widget.height),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _onTapUp(
//     TapUpDetails details,
//     List<FlowNode> nodes,
//     FlowMinimapStyle theme,
//   ) {
//     final transform = MiniMapPainter.calculateTransform(
//       _getBounds(nodes),
//       Size(widget.width, widget.height),
//       theme,
//     );
//     if (transform.scale <= 0) return;

//     final canvasPosition =
//         MiniMapPainter.fromMiniMapToCanvas(details.localPosition, transform);
//     widget.facade.centerOnPosition(canvasPosition);
//   }

//   void _onPanUpdate(
//     DragUpdateDetails details,
//     List<FlowNode> nodes,
//     FlowMinimapStyle theme,
//   ) {
//     final transform = MiniMapPainter.calculateTransform(
//       _getBounds(nodes),
//       Size(widget.width, widget.height),
//       theme,
//     );
//     if (transform.scale <= 0) return;

//     final canvasDelta = details.delta / transform.scale;
//     widget.facade.pan(canvasDelta);
//   }

//   void _onPointerSignal(PointerSignalEvent event) {
//     if (event is PointerScrollEvent) {
//       final zoomDelta = -event.scrollDelta.dy * 0.001;
//       widget.facade.zoom(zoomDelta);
//     }
//   }

//   Rect _getBounds(List<FlowNode> nodes) {
//     if (nodes.isEmpty) return Rect.zero;
//     return nodes
//         .map((n) => n.rect)
//         .reduce((value, element) => value.expandToInclude(element));
//   }
// }

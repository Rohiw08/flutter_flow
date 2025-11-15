// import 'package:flow_canvas/src/features/canvas/presentation/widgets/flow_handle.dart';
// import 'package:flow_canvas/src/shared/providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// typedef ShouldResizeCallback = bool Function(
//   DragUpdateDetails details,
//   ResizeDirection direction,
// );

// typedef ResizeCallback = void Function(
//   Size newSize,
//   ResizeDirection direction,
// );

// enum ResizeDirection {
//   topLeft,
//   topRight,
//   bottomLeft,
//   bottomRight,
// }

// class FlowNodeResizer extends ConsumerWidget {
//   final String nodeId;
//   final bool isVisible;

//   final double minWidth;
//   final double minHeight;
//   final double maxWidth;
//   final double maxHeight;

//   final bool keepAspectRatio;
//   final bool autoScale;

//   final List<Handle> handles;
//   final BoxDecoration? lineDecoration;

//   const FlowNodeResizer({
//     super.key,
//     required this.nodeId,
//     this.isVisible = true,
//     this.minWidth = 10,
//     this.minHeight = 10,
//     this.maxWidth = double.infinity,
//     this.maxHeight = double.infinity,
//     this.keepAspectRatio = false,
//     this.autoScale = true,
//     this.lineDecoration,
//     this.handles = const [],
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     if (!isVisible) return const SizedBox.shrink();

//     ref.read(internalControllerProvider.select((s) => s.nodes[nodeId]!));
//     ref.read(internalControllerProvider.select((s) => s.nodeStates[nodeId]!));

//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           width: _currentSize.width,
//           height: _currentSize.height,
//           decoration: lineDecoration ??
//               BoxDecoration(
//                 color: Colors.transparent,
//                 border: Border.all(
//                   color: Colors.blueAccent.withAlpha(100),
//                   width: 1,
//                 ),
//               ),
//         ),
//         ...handles,
//       ],
//     );
//   }
// }


// // /*
// //   final ShouldResizeCallback? shouldResize;
// //   final ResizeCallback? onResizeStart;
// //   final ResizeCallback? onResize;
// //   final ResizeCallback? onResizeEnd;

// //   this.shouldResize,
// //   this.onResizeStart,
// //   this.onResize,
// //   this.onResizeEnd,
// // */
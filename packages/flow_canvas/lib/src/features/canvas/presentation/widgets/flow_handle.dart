import 'package:flow_canvas/flow_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/options_extensions.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/handle_state.dart';
import '../../../../shared/providers.dart';

/// A builder function for creating a custom handle widget.
///
/// It receives the handle's current runtime state and the resolved `FlowHandleStyle`.
/// Passing the full style object allows the builder to use theme properties
/// (e.g., `style.hovered?.color`) to create completely custom widgets that
/// still respect the canvas theme.
typedef HandleBuilder = Widget Function(
  BuildContext context,
  HandleRuntimeState state,
  FlowHandleStyle style,
);

/// A connection point on a node widget.
///
/// This widget is self-contained and communicates directly with the
/// FlowCanvasController via Riverpod to manage its state (hovered, active, etc.)
/// and initiate connections. It relies on its parent widget for positioning.
class Handle extends ConsumerWidget {
  final String nodeId;
  final String handleId;
  final HandleType type;
  final Offset position;
  final Size size;
  final bool? enableAnimations;
  final Curve? animationCurve;
  final Duration? animationDuration;
  final double? animationScale;
  // Theming override
  final FlowHandleStyle? handleStyle;

  /// An optional builder to render a completely custom widget for the handle.
  final HandleBuilder? handleBuilder;

  const Handle({
    super.key,
    required this.nodeId,
    required this.handleId,
    this.position = Offset.zero,
    this.size = const Size(10.0, 10.0),
    this.type = HandleType.both,
    this.animationScale = 1.5, // Adjusted default for a more subtle effect
    this.enableAnimations = true,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 200),
    this.handleBuilder,
    this.handleStyle,
  });

  String get handleKey => '$nodeId/$handleId';

  Set<FlowHandleState> _states(HandleRuntimeState handleState) {
    final states = <FlowHandleState>{FlowHandleState.idle};

    if (handleState.isValidTarget) {
      states.add(FlowHandleState.validTarget);
    }
    if (handleState.isHovered) {
      states.add(FlowHandleState.hovered);
    }
    if (handleState.isActive) {
      states.add(FlowHandleState.active);
    }
    return states;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handleState = ref.watch(
      internalControllerProvider.select(
        (s) => s.handleStates[handleKey] ?? const HandleRuntimeState(),
      ),
    );

    final controller = ref.read(internalControllerProvider.notifier);

    final baseTheme = context.flowCanvasTheme.handle;
    final theme =
        handleStyle != null ? baseTheme.merge(handleStyle) : baseTheme;

    final decoration = theme.resolveDecoration(_states(handleState));

    final handleCore = handleBuilder != null
        ? handleBuilder!(context, handleState, theme)
        : _DefaultHandle(
            decoration: decoration,
          );

    final bool isAnimated = handleState.isHovered || handleState.isActive;
    final double targetScale = isAnimated ? (animationScale ?? 1.5) : 1.0;

    return FlowPositioned(
      dx: position.dx,
      dy: position.dy,
      child: MouseRegion(
        onEnter: (_) => controller.handle.setHandleHover(handleKey, true),
        onExit: (_) => controller.handle.setHandleHover(handleKey, false),
        cursor: SystemMouseCursors.precise,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            if (type == HandleType.target) return;
            final flowOptions = context.flowCanvasOptions;
            if (!flowOptions.enableConnectivity) return;

            controller.connection.startConnection(nodeId, handleId);
          },
          onPanUpdate: (details) {
            if (type == HandleType.target) return;

            final canvasKey = controller.canvasKey;
            final canvasRenderBox =
                canvasKey.currentContext?.findRenderObject() as RenderBox?;
            if (canvasRenderBox == null) return;

            final localPosition =
                canvasRenderBox.globalToLocal(details.globalPosition);

            controller.connection
                .updateConnection(localPosition, nodeId, handleId);
          },
          onPanEnd: (details) {
            if (type == HandleType.target) return;
            controller.connection.endConnection();
          },
          child: enableAnimations!
              ? AnimatedContainer(
                  transformAlignment: Alignment.center,
                  duration: animationDuration!,
                  transform: Matrix4.identity()..scale(targetScale),
                  curve: animationCurve!,
                  width: size.width,
                  height: size.height,
                  child: Center(child: handleCore),
                )
              : SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Center(child: handleCore),
                ),
        ),
      ),
    );
  }
}

/// The default widget for a handle, built purely from the theme.
class _DefaultHandle extends StatelessWidget {
  final Decoration decoration;

  const _DefaultHandle({required this.decoration});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
    );
  }
}

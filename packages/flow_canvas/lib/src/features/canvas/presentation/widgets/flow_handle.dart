import 'package:flow_canvas/flow_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/handle_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/options_extensions.dart';
import 'package:flow_canvas/src/features/canvas/domain/state/handle_state.dart';

import '../../../../shared/providers.dart';
import '../theme/theme_resolver/handle_theme_resolver.dart';

/// A builder function for creating a custom handle widget.
/// It receives the handle's current runtime state from the canvas controller
/// and the resolved theme style for convenience.
typedef HandleBuilder = Widget Function(
  BuildContext context,
  HandleRuntimeState state,
  FlowHandleStyle theme,
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

  /// An optional builder to render a completely custom widget for the handle.
  final HandleBuilder? builder;

  // Theming override
  final FlowHandleStyle? handleStyle;

  // REMOVED: `position` property is gone.
  const Handle({
    super.key,
    required this.nodeId,
    required this.handleId,
    this.position = Offset.zero,
    this.type = HandleType.both,
    this.builder,
    this.handleStyle,
  });

  String get handleKey => '$nodeId/$handleId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handleState = ref.watch(
      internalControllerProvider.select(
        (s) => s.handleStates[handleKey] ?? const HandleRuntimeState(),
      ),
    );

    final controller = ref.read(internalControllerProvider.notifier);
    final theme = resolveHandleTheme(context, handleStyle);

    final finalColor = _getHandleColor(theme, handleState);
    final scale = (handleState.isHovered ||
            handleState.isActive ||
            handleState.isValidTarget)
        ? 1.4
        : 1.0;

    final handleCore = builder != null
        ? builder!(context, handleState, theme)
        : _DefaultHandle(
            color: finalColor,
            theme: theme,
          );

    return FlowPositioned(
      dx: position.dx,
      dy: position.dy,
      child: MouseRegion(
        onEnter: (_) => controller.setHandleHover(handleKey, true),
        onExit: (_) => controller.setHandleHover(handleKey, false),
        cursor: SystemMouseCursors.precise,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            if (type == HandleType.target) return;
            final flowOptions = context.flowCanvasOptions;
            if (!flowOptions.enableConnectivity) return;
            controller.startConnection(
              nodeId,
              handleId,
              details.globalPosition,
            );
          },
          onPanUpdate: (details) {
            if (type == HandleType.target) return;
            controller.updateConnection(details.globalPosition);
          },
          onPanEnd: (details) {
            if (type == HandleType.target) return;
            controller.endConnection();
          },
          child: AnimatedContainer(
            duration: theme.enableAnimations!
                ? const Duration(milliseconds: 150)
                : Duration.zero,
            transformAlignment: Alignment.center,
            transform: Matrix4.identity()..scale(scale),
            width: theme.size!,
            height: theme.size!,
            color: Colors.transparent,
            child: Center(child: handleCore),
          ),
        ),
      ),
    );
  }

  Color _getHandleColor(FlowHandleStyle theme, HandleRuntimeState state) {
    if (state.isActive) {
      return theme.activeColor!;
    }
    if (state.isInvalidTarget) {
      return theme.invalidTargetColor!;
    }
    if (state.isValidTarget) {
      return theme.validTargetColor!;
    }
    if (state.isHovered) {
      return theme.hoverColor!;
    }
    return theme.idleColor!;
  }
}

/// The default widget for a handle, built purely from the theme.
class _DefaultHandle extends StatelessWidget {
  final Color color;
  final FlowHandleStyle theme;

  const _DefaultHandle({required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: theme.size,
      height: theme.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: theme.borderColor!,
          width: theme.borderWidth!,
        ),
        boxShadow: theme.shadows!,
      ),
    );
  }
}

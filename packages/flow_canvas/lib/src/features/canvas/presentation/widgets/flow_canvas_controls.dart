import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/flow_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/controls_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/presentation/widgets/control_button.dart';
import '../../../../shared/providers.dart';

class FlowCanvasControls extends ConsumerWidget {
  final Size? size;
  final bool showZoom;
  final bool showFitView;
  final bool showLock;
  final bool showUndoRedo;
  final Axis orientation;
  final Alignment alignment;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final List<Widget> children;

  // THEME OVERRIDES
  final FlowControlsStyle? controlsStyle;

  const FlowCanvasControls({
    super.key,
    this.showZoom = true,
    this.showFitView = true,
    this.showLock = true,
    this.showUndoRedo = true,
    this.orientation = Axis.vertical,
    this.alignment = Alignment.bottomLeft,
    this.margin = const EdgeInsets.all(20),
    this.padding = const EdgeInsets.all(20),
    this.children = const [],
    this.spacing = 6.0,
    this.controlsStyle,
    this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theme
    final contextTheme = context.flowCanvasTheme.controls;
    final theme = contextTheme.merge(controlsStyle);

    // logic
    final controller = ref.read(internalControllerProvider.notifier);
    final options = ref.read(flowOptionsProvider);
    final viewportSize =
        ref.watch(internalControllerProvider.select((s) => s.viewportSize));
    final isLocked = ref.watch(
      internalControllerProvider.select((s) => s.isPanZoomLocked),
    );

    return Align(
      alignment: alignment,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: theme.decoration,
        height: size?.height,
        width: size?.width,
        child: Wrap(
          direction: orientation,
          spacing: spacing,
          runSpacing: spacing,
          children: _buildButtons(
            context,
            controller,
            isLocked,
            options,
            viewportSize,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons(
    BuildContext context,
    FlowCanvasController controller,
    bool isLocked,
    FlowOptions options,
    Size? viewportSize,
  ) {
    final screenCenter = viewportSize != null
        ? Offset(viewportSize.width / 2, viewportSize.height / 2)
        : Offset.zero;

    return [
      if (showZoom) ...[
        ControlButton(
          icon: Icons.add,
          tooltip: 'Zoom In',
          onPressed: () => controller.viewport.zoom(
            zoomFactor: 0.2,
            minZoom: options.viewportOptions.minZoom,
            maxZoom: options.viewportOptions.maxZoom,
            focalPoint: screenCenter,
          ),
        ),
        ControlButton(
          icon: Icons.remove,
          tooltip: 'Zoom Out',
          onPressed: () => controller.viewport.zoom(
            zoomFactor: -0.2,
            minZoom: options.viewportOptions.minZoom,
            maxZoom: options.viewportOptions.maxZoom,
            focalPoint: screenCenter,
          ),
        ),
      ],
      if (showFitView) ...[
        ControlButton(
          icon: Icons.fit_screen,
          tooltip: 'Fit View',
          onPressed: () => controller.viewport.fitView(),
        ),
        ControlButton(
          icon: Icons.center_focus_strong,
          tooltip: 'Center View',
          onPressed: () => controller.viewport.centerOnPosition(Offset.zero),
        ),
      ],
      if (showLock)
        ControlButton(
          icon: isLocked ? Icons.lock : Icons.lock_open,
          tooltip: isLocked ? 'Unlock' : 'Lock',
          selected: isLocked, // Visually show the lock button as selected
          onPressed: controller.viewport.toggleLock,
        ),
      if (showUndoRedo) ...[
        ControlButton(
          icon: Icons.undo,
          tooltip: 'Undo',
          onPressed: controller.history.undo,
        ),
        ControlButton(
          icon: Icons.redo,
          tooltip: 'Redo',
          onPressed: controller.history.redo,
        ),
      ],
      ...children,
    ];
  }
}

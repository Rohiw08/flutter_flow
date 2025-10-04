import 'package:flow_canvas/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/flow_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/controller_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/presentation/widgets/control_button.dart';

import '../../../../shared/providers.dart';
import '../theme/components/controller_button_theme.dart';
import '../theme/theme_resolver/controller_theme_resolver.dart';

class FlowCanvasControls extends ConsumerWidget {
  final bool showZoom;
  final bool showFitView;
  final bool showLock;
  final List<Widget> children;
  final Axis orientation;
  final Alignment alignment;
  final EdgeInsetsGeometry margin;
  final double? spacing; // Added spacing parameter

  // THEME OVERRIDES
  final FlowCanvasControlsStyle? controlsTheme;

  const FlowCanvasControls({
    super.key,
    this.showZoom = true,
    this.showFitView = true,
    this.showLock = true,
    this.orientation = Axis.vertical,
    this.alignment = Alignment.bottomLeft,
    this.margin = const EdgeInsets.all(20),
    this.children = const [],
    this.spacing = 6.0,
    this.controlsTheme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Resolve the final theme
    final theme = resolveControlTheme(context, controlsTheme);
    final controller = ref.read(internalControllerProvider.notifier);
    final options = ref.read(flowOptionsProvider);
    final viewportSize =
        ref.watch(internalControllerProvider.select((s) => s.viewportSize));
    final isLocked = ref.watch(
      internalControllerProvider.select((s) => s.isPanZoomLocked),
    );

    return ControlThemeProvider(
      theme: theme,
      child: Align(
        alignment: alignment,
        child: Container(
          margin: margin,
          padding: theme.effectivePadding, // Use container padding from theme
          decoration: theme.effectiveContainerDecoration,
          child: Flex(
            direction: orientation,
            spacing: spacing ?? 0.0,
            mainAxisSize: MainAxisSize.min,
            children: _buildButtons(
              context,
              theme,
              controller,
              isLocked,
              options,
              viewportSize,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons(
    BuildContext context,
    FlowCanvasControlsStyle theme,
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
          onPressed: () => controller.zoom(
            zoomFactor: 0.2,
            minZoom: options.viewportOptions.minZoom,
            maxZoom: options.viewportOptions.maxZoom,
            focalPoint: screenCenter,
          ),
        ),
        ControlButton(
          icon: Icons.remove,
          tooltip: 'Zoom Out',
          onPressed: () => controller.zoom(
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
          onPressed: () => controller.fitView(),
        ),
        ControlButton(
          icon: Icons.center_focus_strong,
          tooltip: 'Center View',
          onPressed: () => controller.centerOnOrigin(),
        ),
      ],
      if (showLock)
        ControlButton(
            icon: isLocked ? Icons.lock : Icons.lock_open,
            tooltip: isLocked ? 'Unlock' : 'Lock',
            onPressed: controller.toggleLock),
      ...children,
    ];
  }
}

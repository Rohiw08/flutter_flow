import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/widgets/control_button.dart';
import 'package:flutter_workflow/src/theme/components/controller_theme.dart';
import 'package:flutter_workflow/src/theme/theme_resolver/controller_button_inherited_theme.dart';
import 'package:flutter_workflow/src/theme/theme_resolver/controller_theme_resolver.dart';

class FlowCanvasControls extends StatelessWidget {
  final FlowCanvasFacade facade;
  final bool showZoom;
  final bool showFitView;
  final bool showLock;
  final List<Widget> children;
  final Axis orientation;
  final double? spacing; // Added spacing parameter

  // THEME OVERRIDES
  final FlowCanvasControlsStyle? controlsTheme;

  const FlowCanvasControls({
    super.key,
    required this.facade,
    this.showZoom = true,
    this.showFitView = true,
    this.showLock = true,
    this.orientation = Axis.vertical,
    this.children = const [],
    this.spacing = 6.0,
    this.controlsTheme,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve the final theme
    final FlowCanvasControlsStyle theme = resolveControlTheme(
      context,
      controlsTheme,
    );

    return ControlThemeProvider(
      theme: theme,
      child: Container(
        padding: theme.effectivePadding, // Use container padding from theme
        decoration: theme.effectiveContainerDecoration,
        child: Flex(
          direction: orientation,
          spacing: spacing ?? 0.0,
          mainAxisSize: MainAxisSize.min,
          children: _buildButtons(context, theme),
        ),
      ),
    );
  }

  List<Widget> _buildButtons(
      BuildContext context, FlowCanvasControlsStyle theme) {
    return [
      if (showZoom) ...[
        ControlButton(
          icon: Icons.add,
          tooltip: 'Zoom In',
          onPressed: () => facade.zoom(0.2),
        ),
        ControlButton(
          icon: Icons.remove,
          tooltip: 'Zoom Out',
          onPressed: () => facade.zoom(-0.2),
        ),
      ],
      if (showFitView) ...[
        ControlButton(
          icon: Icons.fit_screen,
          tooltip: 'Fit View',
          onPressed: () => facade.fitView(),
        ),
        ControlButton(
          icon: Icons.center_focus_strong,
          tooltip: 'Center View',
          onPressed: () => facade.centerView(),
        ),
      ],
      if (showLock)
        StreamBuilder<bool>(
          stream: facade.isPanZoomLockedStream,
          builder: (context, snapshot) {
            final isLocked = snapshot.data ?? false;
            return ControlButton(
              icon: isLocked ? Icons.lock : Icons.lock_open,
              tooltip: isLocked ? 'Unlock' : 'Lock',
              onPressed: facade.togglePanZoomLock,
            );
          },
        ),
      ...children,
    ];
  }
}

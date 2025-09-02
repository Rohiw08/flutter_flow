import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/widgets/control_button.dart';
import 'package:flutter_workflow/src/theme/theme_extensions.dart';

/// A customizable control panel for the FlowCanvas.
class FlowCanvasControls extends StatelessWidget {
  final FlowCanvasFacade facade;
  final bool showZoom;
  final bool showFitView;
  final bool showLock;

  const FlowCanvasControls({
    super.key,
    required this.facade,
    this.showZoom = true,
    this.showFitView = true,
    this.showLock = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.flowCanvasTheme.controls;
    return Container(
      padding: theme.padding,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: theme.borderRadius,
        boxShadow: theme.shadows,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showZoom) ...[
            ControlButton(
              icon: Icons.add,
              tooltip: 'Zoom In',
              onPressed: () => facade.zoom(0.2),
              theme: theme,
            ),
            ControlButton(
              icon: Icons.remove,
              tooltip: 'Zoom Out',
              onPressed: () => facade.zoom(-0.2),
              theme: theme,
            ),
          ],
          if (showFitView)
            ControlButton(
              icon: Icons.fit_screen,
              tooltip: 'Fit View',
              onPressed: () {
                // We need the viewport size to fit the view correctly.
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  facade.fitView(box.size);
                }
              },
              theme: theme,
            ),
          if (showLock)
            StreamBuilder<bool>(
              stream: facade.isPanZoomLockedStream,
              builder: (context, snapshot) {
                final isLocked = snapshot.data ?? false;
                return ControlButton(
                  icon: isLocked ? Icons.lock : Icons.lock_open,
                  tooltip: isLocked ? 'Unlock' : 'Lock',
                  onPressed: facade.togglePanZoomLock,
                  theme: theme,
                );
              },
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/widgets/control_button.dart';
import 'package:flutter_workflow/src/theme/components/control_theme.dart';
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
  final FlowCanvasControlTheme? controlsTheme;
  final Color? containerColor;
  final Color? buttonColor;
  final Color? buttonHoverColor;
  final Color? iconColor;
  final Color? iconHoverColor;
  final double? buttonSize;
  final double? buttonCornerRadius;
  final double? containerCornerRadius;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? shadows;
  final BoxDecoration? containerDecoration;
  final BoxDecoration? buttonDecoration;
  final BoxDecoration? buttonHoverDecoration;
  final TextStyle? iconStyle;
  final TextStyle? iconHoverStyle;

  const FlowCanvasControls({
    super.key,
    required this.facade,
    this.showZoom = true,
    this.showFitView = true,
    this.showLock = true,
    this.orientation = Axis.vertical,
    this.children = const [],
    this.spacing = 6.0,
    this.padding = const EdgeInsets.all(5.0),
    this.controlsTheme,
    this.containerColor,
    this.buttonColor,
    this.buttonHoverColor,
    this.iconColor,
    this.iconHoverColor,
    this.buttonSize,
    this.buttonCornerRadius,
    this.containerCornerRadius,
    this.shadows,
    this.containerDecoration,
    this.buttonDecoration,
    this.buttonHoverDecoration,
    this.iconStyle,
    this.iconHoverStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve the final theme
    final FlowCanvasControlTheme theme = resolveControlTheme(
      context,
      controlsTheme,
      containerColor: containerColor,
      buttonColor: buttonColor,
      buttonHoverColor: buttonHoverColor,
      iconColor: iconColor,
      iconHoverColor: iconHoverColor,
      buttonSize: buttonSize,
      buttonCornerRadius: buttonCornerRadius,
      containerCornerRadius: containerCornerRadius,
      padding: padding,
      shadows: shadows,
      containerDecoration: containerDecoration,
      buttonDecoration: buttonDecoration,
      buttonHoverDecoration: buttonHoverDecoration,
      iconStyle: iconStyle,
      iconHoverStyle: iconHoverStyle,
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
      BuildContext context, FlowCanvasControlTheme theme) {
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
      if (showFitView)
        ControlButton(
          icon: Icons.fit_screen,
          tooltip: 'Fit View',
          onPressed: () {
            facade.centerView();
            // final box = context.findRenderObject() as RenderBox?;
            // if (box != null) {
            //   facade.fitView(box.size);
            // }
          },
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
            );
          },
        ),
      ...children,
    ];
  }
}

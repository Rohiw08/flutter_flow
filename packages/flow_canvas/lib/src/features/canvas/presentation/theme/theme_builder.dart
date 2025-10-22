import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_manager.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_provider.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';

class FlowCanvasThemeBuilder extends StatelessWidget {
  final FlowCanvasThemeManager themeManager;
  final Widget Function(BuildContext context, FlowCanvasTheme theme) builder;

  const FlowCanvasThemeBuilder({
    super.key,
    required this.themeManager,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        return FlowCanvasThemeProvider(
          theme: themeManager.currentTheme,
          child: builder(context, themeManager.currentTheme),
        );
      },
    );
  }
}

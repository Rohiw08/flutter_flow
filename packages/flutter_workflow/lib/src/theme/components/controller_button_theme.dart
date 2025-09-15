import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/theme/components/controller_theme.dart';

class ControlThemeProvider extends InheritedWidget {
  final FlowCanvasControlsStyle theme;

  const ControlThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  static FlowCanvasControlsStyle? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ControlThemeProvider>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(ControlThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}

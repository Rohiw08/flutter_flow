import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/theme/components/control_theme.dart';

class ControlThemeProvider extends InheritedWidget {
  final FlowCanvasControlTheme theme;

  const ControlThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  static FlowCanvasControlTheme? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ControlThemeProvider>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(ControlThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}

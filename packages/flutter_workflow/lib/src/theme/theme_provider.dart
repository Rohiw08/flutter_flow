import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/theme/flow_theme.dart'
    show FlowCanvasTheme;

class FlowCanvasThemeProvider extends StatelessWidget {
  final FlowCanvasTheme? theme;
  final Widget child;

  const FlowCanvasThemeProvider({
    super.key,
    this.theme,
    required this.child,
  });

  /// Convenience constructor for light theme
  FlowCanvasThemeProvider.light({
    super.key,
    required this.child,
  }) : theme = FlowCanvasTheme.light();

  /// Convenience constructor for dark theme
  FlowCanvasThemeProvider.dark({
    super.key,
    required this.child,
  }) : theme = FlowCanvasTheme.dark();

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? _getDefaultTheme(context);

    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          ...Theme.of(context)
              .extensions
              .values
              .where((e) => e is! FlowCanvasTheme),
          effectiveTheme,
        ],
      ),
      child: child,
    );
  }

  static FlowCanvasTheme _getDefaultTheme(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowCanvasTheme.dark()
        : FlowCanvasTheme.light();
  }

  /// Get the FlowCanvas theme from the context
  static FlowCanvasTheme of(BuildContext context) {
    return Theme.of(context).extension<FlowCanvasTheme>() ??
        _getDefaultTheme(context);
  }
}

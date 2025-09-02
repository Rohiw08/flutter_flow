import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/theme/theme.dart';

/// Extension to easily access FlowCanvasTheme from the BuildContext.
extension FlowCanvasThemeExtension on BuildContext {
  /// Retrieves the FlowCanvasTheme from the nearest Theme ancestor.
  ///
  /// If no theme is found, it falls back to the default light theme.
  FlowCanvasTheme get flowCanvasTheme {
    return Theme.of(this).extension<FlowCanvasTheme>() ??
        FlowCanvasTheme.light();
  }
}

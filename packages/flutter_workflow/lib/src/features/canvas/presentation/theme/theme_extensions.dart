import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/flow_theme.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_provider.dart';

extension FlowCanvasThemeExtension on BuildContext {
  FlowCanvasTheme get flowCanvasTheme {
    return FlowCanvasThemeProvider.of(this);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/options/flow_options.dart';

/// Provides FlowOptions to the widget tree.
class FlowCanvasOptionsProvider extends InheritedWidget {
  final FlowOptions options;

  const FlowCanvasOptionsProvider({
    super.key,
    required this.options,
    required super.child,
  });

  static FlowOptions of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<FlowCanvasOptionsProvider>();
    // Provide a default if no provider is found in the tree.
    return provider?.options ?? const FlowOptions();
  }

  @override
  bool updateShouldNotify(FlowCanvasOptionsProvider oldWidget) {
    return options != oldWidget.options;
  }
}

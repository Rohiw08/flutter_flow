import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/flow_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/options_provider.dart';

/// Extension on BuildContext to easily access FlowCanvasOptions.
extension FlowCanvasOptionsExtension on BuildContext {
  FlowOptions get flowCanvasOptions {
    return FlowCanvasOptionsProvider.of(this);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/options/flow_options.dart';
import 'package:flutter_workflow/src/options/options_provider.dart';

/// Extension on BuildContext to easily access FlowCanvasOptions.
extension FlowCanvasOptionsExtension on BuildContext {
  FlowOptions get flowCanvasOptions {
    return FlowCanvasOptionsProvider.of(this);
  }
}

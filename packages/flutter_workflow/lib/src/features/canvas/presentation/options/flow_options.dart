import 'package:flutter_workflow/src/features/canvas/presentation/options/components/edge_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/node_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/viewport_options.dart';

class FlowOptions {
  final bool enableMultiSelection;
  final bool enableBoxSelection;
  final bool enableKeyboardInteraction;
  final bool enableConnectivity;
  final double canvasWidth;
  final double canvasHeight;
  final EdgeOptions edgeOptions;
  final NodeOptions defaultNodeOptions;
  final ViewportOptions viewportOptions;

  const FlowOptions({
    this.enableMultiSelection = true,
    this.enableBoxSelection = true,
    this.enableKeyboardInteraction = true,
    this.enableConnectivity = true,
    this.canvasWidth = 500000,
    this.canvasHeight = 500000,
    this.edgeOptions = const EdgeOptions(),
    this.defaultNodeOptions = const NodeOptions(),
    this.viewportOptions = const ViewportOptions(),
  });

  FlowOptions copyWith({
    bool? enableMultiSelection,
    bool? enableBoxSelection,
    bool? enableKeyboardInteraction,
    bool? enableConnectivity,
    double? canvasWidth,
    double? canvasHeight,
    EdgeOptions? edgeOptions,
    NodeOptions? defaultNodeOptions,
    ViewportOptions? viewportOptions,
  }) {
    return FlowOptions(
      enableMultiSelection: enableMultiSelection ?? this.enableMultiSelection,
      enableBoxSelection: enableBoxSelection ?? this.enableBoxSelection,
      enableKeyboardInteraction:
          enableKeyboardInteraction ?? this.enableKeyboardInteraction,
      enableConnectivity: enableConnectivity ?? this.enableConnectivity,
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      edgeOptions: edgeOptions ?? this.edgeOptions,
      defaultNodeOptions: defaultNodeOptions ?? this.defaultNodeOptions,
      viewportOptions: viewportOptions ?? this.viewportOptions,
    );
  }

  @override
  bool operator ==(covariant FlowOptions other) {
    if (identical(this, other)) return true;

    return other.enableMultiSelection == enableMultiSelection &&
        other.enableBoxSelection == enableBoxSelection &&
        other.enableKeyboardInteraction == enableKeyboardInteraction &&
        other.enableConnectivity == enableConnectivity &&
        other.canvasWidth == canvasWidth &&
        other.canvasHeight == canvasHeight &&
        other.edgeOptions == edgeOptions &&
        other.defaultNodeOptions == defaultNodeOptions &&
        other.viewportOptions == viewportOptions;
  }

  @override
  int get hashCode {
    return enableMultiSelection.hashCode ^
        enableBoxSelection.hashCode ^
        enableKeyboardInteraction.hashCode ^
        enableConnectivity.hashCode ^
        canvasWidth.hashCode ^
        canvasHeight.hashCode ^
        edgeOptions.hashCode ^
        defaultNodeOptions.hashCode ^
        viewportOptions.hashCode;
  }
}

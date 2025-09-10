import 'package:flutter_workflow/src/features/canvas/domain/options/edge_options.dart';
import 'package:flutter_workflow/src/features/canvas/domain/options/node_options.dart';

class FlowOptions {
  final bool enableNodeDrag;
  final bool enableEdgeDrag;
  final bool enableMultiSelection;
  final bool enableBoxSelection;
  final bool enableKeyboardInteraction;
  final bool enableConnectivity;
  final double canvasWidth;
  final double canvasHeight;
  final EdgeOptions edgeOptions;
  final NodeOptions defaultNodeOptions;

  const FlowOptions({
    this.enableNodeDrag = true,
    this.enableEdgeDrag = true,
    this.enableMultiSelection = true,
    this.enableBoxSelection = true,
    this.enableKeyboardInteraction = true,
    this.enableConnectivity = true,
    this.canvasWidth = 500000,
    this.canvasHeight = 500000,
    this.edgeOptions = const EdgeOptions(),
    this.defaultNodeOptions = const NodeOptions(),
  });

  FlowOptions copyWith({
    bool? enableNodeDrag,
    bool? enableEdgeDrag,
    bool? enableMultiSelection,
    bool? enableBoxSelection,
    bool? enableKeyboardInteraction,
    bool? enableConnectivity,
    double? canvasWidth,
    double? canvasHeight,
    EdgeOptions? edgeOptions,
    NodeOptions? defaultNodeOptions,
  }) {
    return FlowOptions(
      enableNodeDrag: enableNodeDrag ?? this.enableNodeDrag,
      enableEdgeDrag: enableEdgeDrag ?? this.enableEdgeDrag,
      enableMultiSelection: enableMultiSelection ?? this.enableMultiSelection,
      enableBoxSelection: enableBoxSelection ?? this.enableBoxSelection,
      enableKeyboardInteraction:
          enableKeyboardInteraction ?? this.enableKeyboardInteraction,
      enableConnectivity: enableConnectivity ?? this.enableConnectivity,
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      edgeOptions: edgeOptions ?? this.edgeOptions,
      defaultNodeOptions: defaultNodeOptions ?? this.defaultNodeOptions,
    );
  }

  @override
  bool operator ==(covariant FlowOptions other) {
    if (identical(this, other)) return true;

    return other.enableNodeDrag == enableNodeDrag &&
        other.enableEdgeDrag == enableEdgeDrag &&
        other.enableMultiSelection == enableMultiSelection &&
        other.enableBoxSelection == enableBoxSelection &&
        other.enableKeyboardInteraction == enableKeyboardInteraction &&
        other.enableConnectivity == enableConnectivity &&
        other.canvasWidth == canvasWidth &&
        other.canvasHeight == canvasHeight &&
        other.edgeOptions == edgeOptions &&
        other.defaultNodeOptions == defaultNodeOptions;
  }

  @override
  int get hashCode {
    return enableNodeDrag.hashCode ^
        enableEdgeDrag.hashCode ^
        enableMultiSelection.hashCode ^
        enableBoxSelection.hashCode ^
        enableKeyboardInteraction.hashCode ^
        enableConnectivity.hashCode ^
        canvasWidth.hashCode ^
        canvasHeight.hashCode ^
        edgeOptions.hashCode ^
        defaultNodeOptions.hashCode;
  }
}

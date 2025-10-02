import 'package:flow_canvas/src/features/canvas/presentation/options/components/edge_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/keyboard_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/node_options.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/components/viewport_options.dart';

class FlowOptions {
  final bool enableMultiSelection;
  final bool enableBoxSelection;
  final bool enableKeyboardInteraction;
  final bool enableConnectivity;
  final double canvasWidth;
  final double canvasHeight;
  final EdgeOptions edgeOptions;
  final NodeOptions nodeOptions;
  final ViewportOptions viewportOptions;
  final KeyboardOptions keyboardOptions;

  const FlowOptions({
    this.enableMultiSelection = true,
    this.enableBoxSelection = true,
    this.enableKeyboardInteraction = true,
    this.enableConnectivity = true,
    this.canvasWidth = 50000.0,
    this.canvasHeight = 50000.0,
    this.edgeOptions = const EdgeOptions(),
    this.nodeOptions = const NodeOptions(),
    this.viewportOptions = const ViewportOptions(),
    this.keyboardOptions = const KeyboardOptions(),
  });

  FlowOptions copyWith({
    bool? enableMultiSelection,
    bool? enableBoxSelection,
    bool? enableKeyboardInteraction,
    bool? enableConnectivity,
    double? canvasWidth,
    double? canvasHeight,
    EdgeOptions? edgeOptions,
    NodeOptions? nodeOptions,
    ViewportOptions? viewportOptions,
    KeyboardOptions? keyboardOptions,
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
      nodeOptions: nodeOptions ?? this.nodeOptions,
      viewportOptions: viewportOptions ?? this.viewportOptions,
      keyboardOptions: keyboardOptions ?? this.keyboardOptions,
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
        other.nodeOptions == nodeOptions &&
        other.viewportOptions == viewportOptions &&
        other.keyboardOptions == keyboardOptions;
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
        nodeOptions.hashCode ^
        viewportOptions.hashCode ^
        keyboardOptions.hashCode;
  }
}

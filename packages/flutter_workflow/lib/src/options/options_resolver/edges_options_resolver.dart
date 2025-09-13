import 'package:flutter/widgets.dart';
import 'package:flutter_workflow/src/options/options_extensions.dart';
import '../../features/canvas/domain/models/edge.dart';

extension ResolvedEdgeOptions on FlowEdge {
  bool isSelectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return selectable ?? globalOptions.selectable;
  }

  bool isDeletable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return deletable ?? globalOptions.deletable;
  }

  bool isAnimated(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return animated ?? globalOptions.animated;
  }

  bool isHidden(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return hidden ?? globalOptions.hidden;
  }

  bool isReconnectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return reconnectable ?? globalOptions.reconnectable;
  }

  bool elevateEdgesOnSelect(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return elevateEdgeOnSelected ?? globalOptions.elevateEdgesOnSelect;
  }
}

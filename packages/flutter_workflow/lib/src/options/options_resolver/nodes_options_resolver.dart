import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_workflow/src/features/canvas/domain/models/node.dart';
import 'package:flutter_workflow/src/options/options_extensions.dart';

extension ResolvedNodeOptions on FlowNode {
  bool isDraggable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.defaultNodeOptions;
    return draggable ?? globalOptions.draggable;
  }

  bool isSelectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.defaultNodeOptions;
    return selectable ?? globalOptions.selectable;
  }

  bool isFocusable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.defaultNodeOptions;
    return focusable ?? globalOptions.focusable;
  }

  bool isDeletable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.defaultNodeOptions;
    return deletable ?? globalOptions.deletable;
  }

  bool isConnectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.defaultNodeOptions;
    return connectable ?? globalOptions.connectable;
  }

  bool elevateNodeOnSelect(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.defaultNodeOptions;
    return elevateNodeOnSelected ?? globalOptions.elevateNodesOnSelected;
  }
}

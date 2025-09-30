import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/options_extensions.dart';
import 'package:flutter/foundation.dart';

@immutable
class NodeOptions {
  final String? type;
  final bool hidden;
  final bool draggable;
  final bool selectable;
  final bool connectable;
  final bool deletable;
  final bool focusable;
  final bool elevateNodesOnSelected;

  const NodeOptions({
    this.type,
    this.hidden = false,
    this.draggable = true,
    this.selectable = true,
    this.connectable = true,
    this.deletable = true,
    this.focusable = false,
    this.elevateNodesOnSelected = false,
  });

  NodeOptions copyWith({
    String? type,
    bool? hidden,
    bool? draggable,
    bool? selectable,
    bool? connectable,
    bool? deletable,
    bool? focusable,
    bool? elevateNodesOnSelected,
  }) {
    return NodeOptions(
      type: type ?? this.type,
      hidden: hidden ?? this.hidden,
      draggable: draggable ?? this.draggable,
      selectable: selectable ?? this.selectable,
      connectable: connectable ?? this.connectable,
      deletable: deletable ?? this.deletable,
      focusable: focusable ?? this.focusable,
      elevateNodesOnSelected:
          elevateNodesOnSelected ?? this.elevateNodesOnSelected,
    );
  }

  /// Resolves node options from the global FlowCanvasOptions in the context.
  static NodeOptions resolve(BuildContext context) {
    return context.flowCanvasOptions.nodeOptions;
  }

  @override
  bool operator ==(covariant NodeOptions other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.hidden == hidden &&
        other.draggable == draggable &&
        other.selectable == selectable &&
        other.connectable == connectable &&
        other.deletable == deletable &&
        other.focusable == focusable &&
        other.elevateNodesOnSelected == elevateNodesOnSelected;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        hidden.hashCode ^
        draggable.hashCode ^
        selectable.hashCode ^
        connectable.hashCode ^
        deletable.hashCode ^
        focusable.hashCode ^
        elevateNodesOnSelected.hashCode;
  }
}

extension ResolvedNodeOptions on FlowNode {
  bool isDraggable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return draggable ?? globalOptions.draggable;
  }

  bool isSelectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return selectable ?? globalOptions.selectable;
  }

  bool isDeletable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return deletable ?? globalOptions.deletable;
  }

  bool isHidden(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return hidden ?? globalOptions.hidden;
  }

  bool isConnectable(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return connectable ?? globalOptions.connectable;
  }

  bool elevateOnSelect(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.nodeOptions;
    return elevateNodeOnSelected ?? globalOptions.elevateNodesOnSelected;
  }
}

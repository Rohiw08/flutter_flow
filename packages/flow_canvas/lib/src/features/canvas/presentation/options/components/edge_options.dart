import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flow_canvas/flow_canvas.dart';
import 'package:flow_canvas/src/features/canvas/presentation/options/options_extensions.dart';
import 'package:flutter/foundation.dart';

@immutable
class EdgeOptions {
  final String? type;
  final bool animated;
  final bool hidden;
  final bool deletable;
  final bool selectable;
  final bool reconnectable;
  final bool focusable;
  final bool elevateEdgesOnSelect;

  const EdgeOptions({
    this.type,
    this.animated = false,
    this.hidden = false,
    this.deletable = true,
    this.selectable = true,
    this.reconnectable = true,
    this.focusable = true,
    this.elevateEdgesOnSelect = true,
  });

  EdgeOptions copyWith({
    String? type,
    bool? animated,
    bool? hidden,
    bool? deletable,
    bool? selectable,
    bool? reconnectable,
    bool? focusable,
    bool? elevateEdgesOnSelect,
  }) {
    return EdgeOptions(
      type: type ?? this.type,
      animated: animated ?? this.animated,
      hidden: hidden ?? this.hidden,
      deletable: deletable ?? this.deletable,
      selectable: selectable ?? this.selectable,
      reconnectable: reconnectable ?? this.reconnectable,
      focusable: focusable ?? this.focusable,
      elevateEdgesOnSelect: elevateEdgesOnSelect ?? this.elevateEdgesOnSelect,
    );
  }

  static EdgeOptions resolve(BuildContext context) {
    return context.flowCanvasOptions.edgeOptions;
  }

  @override
  bool operator ==(covariant EdgeOptions other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.animated == animated &&
        other.hidden == hidden &&
        other.deletable == deletable &&
        other.selectable == selectable &&
        other.reconnectable == reconnectable &&
        other.focusable == focusable &&
        other.elevateEdgesOnSelect == elevateEdgesOnSelect;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        animated.hashCode ^
        hidden.hashCode ^
        deletable.hashCode ^
        selectable.hashCode ^
        reconnectable.hashCode ^
        focusable.hashCode ^
        elevateEdgesOnSelect.hashCode;
  }
}

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

  bool elevateOnSelect(BuildContext context) {
    final globalOptions = context.flowCanvasOptions.edgeOptions;
    return elevateEdgeOnSelected ?? globalOptions.elevateEdgesOnSelect;
  }
}

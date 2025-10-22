import 'package:flutter/widgets.dart' show BuildContext;
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
  final bool elevateEdgeOnSelect;

  const EdgeOptions({
    this.type,
    this.animated = false,
    this.hidden = false,
    this.deletable = true,
    this.selectable = true,
    this.reconnectable = true,
    this.focusable = true,
    this.elevateEdgeOnSelect = true,
  });

  EdgeOptions copyWith({
    String? type,
    bool? animated,
    bool? hidden,
    bool? deletable,
    bool? selectable,
    bool? reconnectable,
    bool? focusable,
    bool? elevateEdgeOnSelect,
  }) {
    return EdgeOptions(
      type: type ?? this.type,
      animated: animated ?? this.animated,
      hidden: hidden ?? this.hidden,
      deletable: deletable ?? this.deletable,
      selectable: selectable ?? this.selectable,
      reconnectable: reconnectable ?? this.reconnectable,
      focusable: focusable ?? this.focusable,
      elevateEdgeOnSelect: elevateEdgeOnSelect ?? this.elevateEdgeOnSelect,
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
        other.elevateEdgeOnSelect == elevateEdgeOnSelect;
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
        elevateEdgeOnSelect.hashCode;
  }
}

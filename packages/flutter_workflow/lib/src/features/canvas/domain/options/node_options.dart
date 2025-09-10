import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show BoxDecoration;

class NodeOptions {
  final String? type;
  final bool hidden;
  final bool draggable;
  final bool selectable;
  final bool connectable;
  final bool deletable;
  final bool focusable;

  final int zIndex;
  final BoxDecoration? style;
  final Map<String, dynamic> data;

  const NodeOptions({
    this.type,
    this.hidden = false,
    this.draggable = true,
    this.selectable = true,
    this.connectable = true,
    this.deletable = true,
    this.focusable = true,
    this.zIndex = 0,
    this.style,
    this.data = const {},
  });

  NodeOptions copyWith({
    String? type,
    bool? hidden,
    bool? draggable,
    bool? selectable,
    bool? connectable,
    bool? deletable,
    bool? focusable,
    int? zIndex,
    BoxDecoration? style,
    Map<String, dynamic>? data,
  }) {
    return NodeOptions(
      type: type ?? this.type,
      hidden: hidden ?? this.hidden,
      draggable: draggable ?? this.draggable,
      selectable: selectable ?? this.selectable,
      connectable: connectable ?? this.connectable,
      deletable: deletable ?? this.deletable,
      focusable: focusable ?? this.focusable,
      zIndex: zIndex ?? this.zIndex,
      style: style ?? this.style,
      data: data ?? this.data,
    );
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
        other.zIndex == zIndex &&
        other.style == style &&
        mapEquals(other.data, data);
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
        zIndex.hashCode ^
        style.hashCode ^
        data.hashCode;
  }
}

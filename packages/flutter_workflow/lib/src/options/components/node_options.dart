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
    this.focusable = true,
    this.elevateNodesOnSelected = true,
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

  @override
  bool operator ==(covariant NodeOptions other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.hidden == hidden &&
        other.draggable == draggable &&
        other.selectable == selectable &&
        other.connectable == connectable &&
        other.deletable == deletable &&
        other.focusable == focusable;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        hidden.hashCode ^
        draggable.hashCode ^
        selectable.hashCode ^
        connectable.hashCode ^
        deletable.hashCode ^
        focusable.hashCode;
  }
}

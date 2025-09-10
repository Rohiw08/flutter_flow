import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_workflow/src/theme/components/edge_marker_theme.dart';
import 'package:flutter_workflow/src/theme/components/edge_theme.dart';

class EdgeOptions {
  final String? type;
  final bool animated;
  final bool hidden;
  final bool deletable;
  final bool selectable;
  final bool reconnectable;
  final bool focusable;
  final bool elevateEdgesOnSelect;

  final int zIndex;
  final double interactionWidth;

  final Widget? label;
  final TextStyle? labelStyle;
  final bool labelShowBg;
  final BoxDecoration? labelBgStyle;
  final EdgeInsets labelBgPadding;
  final double labelBgBorderRadius;

  final EdgeMarkerStyle? markerStart;
  final EdgeMarkerStyle? markerEnd;

  final EdgeStyle? style;
  final Map<String, dynamic> data;

  const EdgeOptions({
    this.type,
    this.animated = false,
    this.hidden = false,
    this.deletable = true,
    this.selectable = true,
    this.reconnectable = true,
    this.focusable = true,
    this.elevateEdgesOnSelect = true,
    this.zIndex = 0,
    this.interactionWidth = 10.0,
    this.label,
    this.labelStyle,
    this.labelShowBg = false,
    this.labelBgStyle,
    this.labelBgPadding = const EdgeInsets.all(2.0),
    this.labelBgBorderRadius = 4.0,
    this.markerStart,
    this.markerEnd,
    this.style,
    this.data = const {},
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
    int? zIndex,
    double? interactionWidth,
    Widget? label,
    TextStyle? labelStyle,
    bool? labelShowBg,
    BoxDecoration? labelBgStyle,
    EdgeInsets? labelBgPadding,
    double? labelBgBorderRadius,
    EdgeMarkerStyle? markerStart,
    EdgeMarkerStyle? markerEnd,
    EdgeStyle? style,
    Map<String, dynamic>? data,
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
      zIndex: zIndex ?? this.zIndex,
      interactionWidth: interactionWidth ?? this.interactionWidth,
      label: label ?? this.label,
      labelStyle: labelStyle ?? this.labelStyle,
      labelShowBg: labelShowBg ?? this.labelShowBg,
      labelBgStyle: labelBgStyle ?? this.labelBgStyle,
      labelBgPadding: labelBgPadding ?? this.labelBgPadding,
      labelBgBorderRadius: labelBgBorderRadius ?? this.labelBgBorderRadius,
      markerStart: markerStart ?? this.markerStart,
      markerEnd: markerEnd ?? this.markerEnd,
      style: style ?? this.style,
      data: data ?? this.data,
    );
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
        other.elevateEdgesOnSelect == elevateEdgesOnSelect &&
        other.zIndex == zIndex &&
        other.interactionWidth == interactionWidth &&
        other.label == label &&
        other.labelStyle == labelStyle &&
        other.labelShowBg == labelShowBg &&
        other.labelBgStyle == labelBgStyle &&
        other.labelBgPadding == labelBgPadding &&
        other.labelBgBorderRadius == labelBgBorderRadius &&
        other.markerStart == markerStart &&
        other.markerEnd == markerEnd &&
        other.style == style &&
        mapEquals(other.data, data);
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
        elevateEdgesOnSelect.hashCode ^
        zIndex.hashCode ^
        interactionWidth.hashCode ^
        label.hashCode ^
        labelStyle.hashCode ^
        labelShowBg.hashCode ^
        labelBgStyle.hashCode ^
        labelBgPadding.hashCode ^
        labelBgBorderRadius.hashCode ^
        markerStart.hashCode ^
        markerEnd.hashCode ^
        style.hashCode ^
        data.hashCode;
  }
}

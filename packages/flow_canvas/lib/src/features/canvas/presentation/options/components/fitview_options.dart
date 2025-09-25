import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flow_canvas/src/shared/enums.dart';

@immutable
class FitViewOptions {
  final EdgeInsets padding;
  final bool includeHiddenNodes;
  final double minZoom;
  final double maxZoom;
  final Duration duration;
  final Curve ease;
  final FitViewInterpolation interpolate;
  final List<String> nodes;

  const FitViewOptions({
    this.padding = const EdgeInsets.all(0),
    this.includeHiddenNodes = false,
    this.minZoom = 0.1,
    this.maxZoom = 2.0,
    this.duration = const Duration(milliseconds: 300),
    this.ease = Curves.easeInOut,
    this.interpolate = FitViewInterpolation.smooth,
    this.nodes = const [],
  });

  FitViewOptions copyWith({
    EdgeInsets? padding,
    bool? includeHiddenNodes,
    double? minZoom,
    double? maxZoom,
    Duration? duration,
    Curve? ease,
    FitViewInterpolation? interpolate,
    List<String>? nodes,
  }) {
    return FitViewOptions(
      padding: padding ?? this.padding,
      includeHiddenNodes: includeHiddenNodes ?? this.includeHiddenNodes,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      duration: duration ?? this.duration,
      ease: ease ?? this.ease,
      interpolate: interpolate ?? this.interpolate,
      nodes: nodes ?? this.nodes,
    );
  }

  @override
  bool operator ==(covariant FitViewOptions other) {
    if (identical(this, other)) return true;

    return other.padding == padding &&
        other.includeHiddenNodes == includeHiddenNodes &&
        other.minZoom == minZoom &&
        other.maxZoom == maxZoom &&
        other.duration == duration &&
        other.ease == ease &&
        other.interpolate == interpolate &&
        listEquals(other.nodes, nodes);
  }

  @override
  int get hashCode {
    return padding.hashCode ^
        includeHiddenNodes.hashCode ^
        minZoom.hashCode ^
        maxZoom.hashCode ^
        duration.hashCode ^
        ease.hashCode ^
        interpolate.hashCode ^
        nodes.hashCode;
  }
}

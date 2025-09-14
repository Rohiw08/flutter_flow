import 'dart:ui';

class FlowViewport {
  final Offset offset;
  final double zoom;
  FlowViewport({
    required this.offset,
    required this.zoom,
  });

  FlowViewport copyWith({
    Offset? offset,
    double? zoom,
  }) {
    return FlowViewport(
      offset: offset ?? this.offset,
      zoom: zoom ?? this.zoom,
    );
  }

  @override
  String toString() => 'FlowViewport(offset: $offset, zoom: $zoom)';

  @override
  bool operator ==(covariant FlowViewport other) {
    if (identical(this, other)) return true;

    return other.offset == offset && other.zoom == zoom;
  }

  @override
  int get hashCode => offset.hashCode ^ zoom.hashCode;
}

/// Defines the grid for snapping
class SnapGrid {
  final double width;
  final double height;

  const SnapGrid({this.width = 10, this.height = 10});

  SnapGrid copyWith({double? width, double? height}) {
    return SnapGrid(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SnapGrid &&
            runtimeType == other.runtimeType &&
            width == other.width &&
            height == other.height;
  }

  @override
  int get hashCode => width.hashCode ^ height.hashCode;
}

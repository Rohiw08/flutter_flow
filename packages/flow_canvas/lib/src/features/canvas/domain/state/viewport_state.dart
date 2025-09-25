import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'viewport_state.freezed.dart';

@freezed
abstract class FlowViewport with _$FlowViewport {
  const factory FlowViewport({
    @Default(Offset.zero) Offset offset,
    @Default(1.0) double zoom,
  }) = _FlowViewport;
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

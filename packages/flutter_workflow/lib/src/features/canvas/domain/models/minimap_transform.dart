import 'dart:ui' show Rect;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimap_transform.freezed.dart';

/// Holds the calculated transformation values for rendering the minimap.
@freezed
abstract class MiniMapTransform with _$MiniMapTransform {
  const factory MiniMapTransform({
    required double scale,
    required double offsetX,
    required double offsetY,
    required Rect contentBounds,
  }) = _MiniMapTransform;
}

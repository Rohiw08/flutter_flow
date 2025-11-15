import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'viewport_state.freezed.dart';

/// Defines the current camera transform of the canvas.
///
/// Controls how the user views the flowchart:
/// - [offset] → Canvas translation (panning)
/// - [zoom] → Canvas scale factor (pinching/scrolling)
///
/// Equivalent to React Flow’s `Viewport` (x, y, zoom).
///
/// Typical usage scenarios:
/// * Panning with drag gestures → modify [offset].
/// * Zooming with pinch or scroll → modify [zoom].
/// * Reset or fit-to-view → set both offset and zoom programmatically.
@freezed
abstract class FlowViewport with _$FlowViewport {
  const FlowViewport._();
  const factory FlowViewport({
    /// Canvas translation offset in Cartesian space.
    @Default(Offset.zero) Offset offset,

    /// Current zoom level (1.0 = 100%) — affects all scale-related rendering.
    ///
    /// Lower values zoom out, higher zoom in.
    @Default(1.0) double zoom,
  }) = _FlowViewport;

  /// Returns a convenient default untransformed viewport.
  static const FlowViewport initial = FlowViewport();

  /// Returns a copy with clamped zoom value.
  FlowViewport clampZoom({
    double minZoom = 0.25,
    double maxZoom = 2.5,
  }) {
    return copyWith(
      zoom: zoom.clamp(minZoom, maxZoom),
    );
  }

  // /// Whether the viewport is at its default state (no transformation).
  // bool get isIdentity => offset == Offset.zero && zoom == 1.0;
}

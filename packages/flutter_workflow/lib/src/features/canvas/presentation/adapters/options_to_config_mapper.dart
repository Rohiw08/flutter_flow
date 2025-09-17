import 'package:flutter_workflow/src/features/canvas/presentation/options/flow_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/components/viewport_options.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/viewport_state.dart';

class ViewConfig {
  final double minZoom;
  final double maxZoom;
  final bool snapToGrid;
  final SnapGrid snapGrid;
  final bool onlyRenderVisibleElements;
  final double canvasWidth;
  final double canvasHeight;

  const ViewConfig({
    required this.minZoom,
    required this.maxZoom,
    required this.snapToGrid,
    required this.snapGrid,
    required this.onlyRenderVisibleElements,
    required this.canvasWidth,
    required this.canvasHeight,
  });
}

class OptionsToConfigMapper {
  static ViewConfig mapToViewConfig(FlowOptions options) {
    final ViewportOptions v = options.viewportOptions;
    return ViewConfig(
      minZoom: v.minZoom,
      maxZoom: v.maxZoom,
      snapToGrid: v.snapToGrid,
      snapGrid: v.snapGrid,
      onlyRenderVisibleElements: v.onlyRenderVisibleElements,
      canvasWidth: options.canvasWidth,
      canvasHeight: options.canvasHeight,
    );
  }
}

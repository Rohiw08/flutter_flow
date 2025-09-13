import 'package:flutter/widgets.dart';
import 'package:flutter_workflow/src/options/components/fitview_options.dart';
import 'package:flutter_workflow/src/options/options_extensions.dart'; // Import the new extension
import 'package:flutter_workflow/src/shared/enums.dart';

FitViewOptions resolveFitViewOptions(
  BuildContext context,
  FitViewOptions? localOptions, {
  EdgeInsets? padding,
  bool? includeHiddenNodes,
  double? minZoom,
  double? maxZoom,
  Duration? duration,
  Curve? ease,
  FitViewInterpolation? interpolate,
  List<String>? nodes,
}) {
  final base =
      localOptions ?? context.flowCanvasOptions.viewportOptions.fitViewOptions;

  return base.copyWith(
    padding: padding,
    includeHiddenNodes: includeHiddenNodes,
    minZoom: minZoom,
    maxZoom: maxZoom,
    duration: duration,
    ease: ease,
    interpolate: interpolate,
    nodes: nodes,
  );
}

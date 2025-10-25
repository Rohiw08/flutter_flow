import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_label_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';
import 'package:flow_canvas/src/features/canvas/presentation/utility/flow_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowEdgeLabel extends ConsumerWidget {
  final String id;
  final Offset position;
  final String? parentId;
  final bool selected;
  final bool hovered;

  // Styling
  final FlowEdgeLabelStyle? style;
  final EdgeInsetsGeometry? padding;

  // Animation
  final bool enableAnimations;
  final Curve animationCurve;
  final Duration animationDuration;

  // Content (mutually exclusive - either text OR child)
  final String? text;
  final Widget? child;

  const FlowEdgeLabel({
    super.key,
    required this.id,
    required this.position,
    this.parentId,
    this.selected = false,
    this.hovered = false,
    this.style,
    this.padding,
    this.enableAnimations = true,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 200),
    this.text,
    this.child,
  }) : assert(
          (text == null) != (child == null),
          'Either text or child must be provided, but not both',
        );

  Set<FlowEdgeState> _computeStates() {
    final states = <FlowEdgeState>{};
    if (selected) {
      states.add(FlowEdgeState.selected);
    } else if (hovered) {
      states.add(FlowEdgeState.hovered);
    } else {
      states.add(FlowEdgeState.normal);
    }
    return states;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseTheme = context.flowCanvasTheme.edgeLabel;
    final effectiveTheme = baseTheme.merge(style);

    // Compute current visual states
    final states = _computeStates();

    final textStyle = effectiveTheme.resolveTextStyle(states);
    final decoration = effectiveTheme.resolveDecoration(states);

    // Use resolved padding from theme if not provided
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);

    return FlowPositioned(
      dx: position.dx,
      dy: position.dy,
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: enableAnimations ? animationDuration : Duration.zero,
          curve: animationCurve,
          padding: effectivePadding,
          decoration: decoration,
          child: DefaultTextStyle(
            style: textStyle,
            child: child ?? Text(text!),
          ),
        ),
      ),
    );
  }
}

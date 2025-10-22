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
  final bool? enableAnimations;
  final Curve? animationCurve;
  final Duration? animationDuration;
  final EdgeInsetsGeometry? padding;
  final FlowEdgeLabelStyle? style;
  final bool selected;
  final bool hovered;
  final String? text;
  final Widget? child;

  const FlowEdgeLabel({
    super.key,
    required this.id,
    required this.position,
    this.parentId,
    this.selected = false,
    this.hovered = false,
    this.enableAnimations = true,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 200),
    this.padding = const EdgeInsets.all(12.0),
    this.style,
    this.child,
    this.text,
  });

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

    return FlowPositioned(
      dx: position.dx,
      dy: position.dy,
      child: Material(
        color: Colors.transparent, // Material needs a color, even transparent
        textStyle: textStyle,
        child: AnimatedContainer(
          // Determine the duration once
          duration:
              enableAnimations == true ? animationDuration! : Duration.zero,
          curve: animationCurve!,
          padding: padding,
          decoration: decoration,
          child: child ?? Text(text ?? ''),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/background_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/connection_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/controller_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_label_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/handle_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/minimap_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/node_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/selection_theme.dart';

import 'components/edge_marker_theme.dart';

/// The core theme for the Flow Canvas.
@immutable
class FlowCanvasTheme extends ThemeExtension<FlowCanvasTheme> {
  final FlowBackgroundStyle background;
  final FlowNodeStyle node;
  final FlowEdgeStyle edge;
  final FlowHandleStyle handle;
  final FlowSelectionStyle selection;
  final FlowCanvasControlsStyle controls;
  final FlowMinimapStyle minimap;
  final FlowConnectionStyle connection;
  final FlowEdgeLabelStyle edgeLabel;
  final FlowEdgeMarkerStyle edgeMarker;

  const FlowCanvasTheme({
    required this.background,
    required this.node,
    required this.edge,
    required this.handle,
    required this.selection,
    required this.controls,
    required this.minimap,
    required this.connection,
    required this.edgeLabel,
    required this.edgeMarker,
  });

  /// Creates a light theme.
  factory FlowCanvasTheme.light() {
    return FlowCanvasTheme(
      background: FlowBackgroundStyle.light(),
      node: FlowNodeStyle.light(),
      edge: FlowEdgeStyle.light(),
      handle: FlowHandleStyle.light(),
      selection: FlowSelectionStyle.light(),
      controls: FlowCanvasControlsStyle.light(),
      minimap: FlowMinimapStyle.light(),
      connection: FlowConnectionStyle.light(),
      edgeLabel: FlowEdgeLabelStyle.light(),
      edgeMarker: FlowEdgeMarkerStyle.light(),
    );
  }

  /// Creates a dark theme.
  factory FlowCanvasTheme.dark() {
    return FlowCanvasTheme(
      background: FlowBackgroundStyle.dark(),
      node: FlowNodeStyle.dark(),
      edge: FlowEdgeStyle.dark(),
      handle: FlowHandleStyle.dark(),
      selection: FlowSelectionStyle.dark(),
      controls: FlowCanvasControlsStyle.dark(),
      minimap: FlowMinimapStyle.dark(),
      connection: FlowConnectionStyle.dark(),
      edgeLabel: FlowEdgeLabelStyle.dark(),
      edgeMarker: FlowEdgeMarkerStyle.dark(),
    );
  }

  /// Creates a copy of this theme with the given fields replaced by the new values.
  @override
  FlowCanvasTheme copyWith({
    FlowBackgroundStyle? background,
    FlowNodeStyle? node,
    FlowEdgeStyle? edge,
    FlowHandleStyle? handle,
    FlowSelectionStyle? selection,
    FlowCanvasControlsStyle? controls,
    FlowMinimapStyle? minimap,
    FlowConnectionStyle? connection,
    FlowEdgeLabelStyle? edgeLabel,
    FlowEdgeMarkerStyle? edgeMarker,
  }) {
    return FlowCanvasTheme(
      background: background ?? this.background,
      node: node ?? this.node,
      edge: edge ?? this.edge,
      handle: handle ?? this.handle,
      selection: selection ?? this.selection,
      controls: controls ?? this.controls,
      minimap: minimap ?? this.minimap,
      connection: connection ?? this.connection,
      edgeLabel: edgeLabel ?? this.edgeLabel,
      edgeMarker: edgeMarker ?? this.edgeMarker,
    );
  }

  factory FlowCanvasTheme.fromColorScheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return FlowCanvasTheme(
      background: FlowBackgroundStyle(
        backgroundColor: colorScheme.surface,
        variant: BackgroundVariant.dots,
        patternColor: colorScheme.outline.withAlpha(isDark ? 60 : 40),
        gap: 25.0,
        lineWidth: 1.0,
        dotRadius: 0.75,
        crossSize: 8.0,
        fadeOnZoom: true,
        gradient: null,
        patternOffset: Offset.zero,
        blendMode: BlendMode.srcOver,
        alternateColors: null,
      ),
      node: FlowNodeStyle(
        defaultBackgroundColor: colorScheme.surfaceContainer,
        defaultBorderColor: colorScheme.outlineVariant,
        selectedBackgroundColor: colorScheme.primaryContainer,
        selectedBorderColor: colorScheme.primary,
        errorBackgroundColor: colorScheme.errorContainer,
        errorBorderColor: colorScheme.error,
        hoverBackgroundColor: colorScheme.surfaceContainerHigh,
        hoverBorderColor: colorScheme.outline,
        disabledBackgroundColor: colorScheme.surfaceContainerLow,
        disabledBorderColor: colorScheme.outlineVariant.withAlpha(120),
        defaultBorderWidth: 1.0,
        selectedBorderWidth: 2.0,
        hoverBorderWidth: 1.5,
        borderRadius: 8.0,
        defaultTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
        shadows: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(isDark ? 51 : 26),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        animationDuration: const Duration(milliseconds: 200),
        animationCurve: Curves.easeInOut,
        defaultPadding: const EdgeInsets.all(12.0),
      ),
      edge: FlowEdgeStyle(
        defaultColor: colorScheme.outline,
        selectedColor: colorScheme.primary,
        hoverColor: colorScheme.primary,
        animatedColor: colorScheme.tertiary,
        defaultStrokeWidth: 2.0,
        selectedStrokeWidth: 3.0,
        arrowHeadSize: 8.0,
        labelStyle: FlowEdgeLabelStyle(
          textStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 12,
          ),
          backgroundColor: colorScheme.surfaceContainerLow,
          borderColor: colorScheme.outlineVariant,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        markerStyle: FlowEdgeMarkerStyle(
          type: EdgeMarkerType.arrowClosed,
          color: colorScheme.outline,
          width: 12.0,
          height: 12.0,
          strokeWidth: 1.0,
        ),
      ),
      edgeMarker: FlowEdgeMarkerStyle(
        type: EdgeMarkerType.arrowClosed,
        color: colorScheme.outline,
        width: 12.0,
        height: 12.0,
        strokeWidth: 1.0,
      ),
      edgeLabel: FlowEdgeLabelStyle(
        textStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 12,
        ),
        backgroundColor: colorScheme.surfaceContainerLow,
        borderColor: colorScheme.outlineVariant,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      handle: FlowHandleStyle(
        idleColor: colorScheme.outline,
        hoverColor: colorScheme.primary,
        activeColor: colorScheme.primary,
        validTargetColor: colorScheme.tertiary,
        invalidTargetColor: colorScheme.error,
        borderColor: colorScheme.surface,
        size: 10.0,
        borderWidth: 1.5,
        shadows: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(isDark ? 60 : 40),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        enableAnimations: true,
      ),
      selection: FlowSelectionStyle(
        fillColor: colorScheme.primary.withAlpha(39),
        borderColor: colorScheme.primary,
        borderWidth: 1.0,
        dashLength: 5.0,
        gapLength: 5.0,
      ),
      controls: FlowCanvasControlsStyle(
        containerColor: colorScheme.surfaceContainer,
        buttonColor: colorScheme.surfaceContainerHigh,
        buttonHoverColor: colorScheme.surfaceContainerHighest,
        iconColor: colorScheme.onSurfaceVariant,
        iconHoverColor: colorScheme.onSurface,
        containerCornerRadius: 12.0,
        buttonCornerRadius: 8.0,
        buttonSize: 32.0,
        padding: const EdgeInsets.all(5.0),
        shadows: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(isDark ? 40 : 25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      minimap: FlowMinimapStyle(
        backgroundColor: colorScheme.surfaceContainerLow,
        nodeColor: colorScheme.primary,
        nodeStrokeColor: colorScheme.primaryContainer,
        selectedNodeColor: colorScheme.tertiary,
        maskColor: colorScheme.scrim.withAlpha(153),
        maskStrokeColor: colorScheme.outline,
        nodeStrokeWidth: 1.0,
        maskStrokeWidth: 1.0,
        borderRadius: 8.0,
        nodeBorderRadius: 2.0,
        padding: 10.0,
        viewportBorderRadius: 2.0,
        selectedGlowColor: colorScheme.tertiary.withAlpha(100),
        selectedGlowBlur: 4.0,
        selectedGlowWidthMultiplier: 1.5,
        viewportInnerGlowColor: colorScheme.primary.withAlpha(100),
        viewportInnerGlowWidthMultiplier: 1.0,
        viewportInnerGlowBlur: 2.0,
        viewportInnerColor: Colors.transparent,
        shadows: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(isDark ? 50 : 30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      connection: FlowConnectionStyle(
        activeColor: colorScheme.primary,
        validTargetColor: colorScheme.tertiary,
        invalidTargetColor: colorScheme.error,
        strokeWidth: 2.0,
        pathType: EdgePathType.bezier,
      ),
    );
  }

  @override
  ThemeExtension<FlowCanvasTheme> lerp(
      covariant ThemeExtension<FlowCanvasTheme>? other, double t) {
    if (other is! FlowCanvasTheme) return this;
    return FlowCanvasTheme(
      background: background.lerp(other.background, t),
      node: node.lerp(other.node, t),
      edge: edge.lerp(other.edge, t),
      handle: handle.lerp(other.handle, t),
      selection: selection.lerp(other.selection, t),
      controls: controls.lerp(other.controls, t),
      minimap: minimap.lerp(other.minimap, t),
      connection: connection.lerp(other.connection, t),
      edgeLabel: edgeLabel.lerp(other.edgeLabel, t),
      edgeMarker: edgeMarker.lerp(other.edgeMarker, t),
    );
  }
}

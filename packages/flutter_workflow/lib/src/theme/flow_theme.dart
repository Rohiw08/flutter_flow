import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/theme/components/background_theme.dart';
import 'package:flutter_workflow/src/theme/components/connection_theme.dart';
import 'package:flutter_workflow/src/theme/components/controller_theme.dart';
import 'package:flutter_workflow/src/theme/components/edge_label_theme.dart';
import 'package:flutter_workflow/src/theme/components/edge_theme.dart';
import 'package:flutter_workflow/src/theme/components/handle_theme.dart';
import 'package:flutter_workflow/src/theme/components/minimap_theme.dart';
import 'package:flutter_workflow/src/theme/components/node_theme.dart';
import 'package:flutter_workflow/src/theme/components/selection_theme.dart';

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

  const FlowCanvasTheme({
    required this.background,
    required this.node,
    required this.edge,
    required this.handle,
    required this.selection,
    required this.controls,
    required this.minimap,
    required this.connection,
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
    );
  }

  factory FlowCanvasTheme.fromColorScheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return FlowCanvasTheme(
      background: FlowBackgroundStyle(
        backgroundColor: colorScheme.surface,
        variant: BackgroundVariant.dots,
        patternColor: colorScheme.outline.withAlpha(isDark ? 60 : 40),
        fadeOnZoom: true,
      ),
      node: FlowNodeStyle(
        defaultBackgroundColor: colorScheme.surfaceContainer,
        defaultBorderColor: colorScheme.outlineVariant,
        selectedBackgroundColor: colorScheme.primaryContainer,
        selectedBorderColor: colorScheme.primary,
        errorBackgroundColor: colorScheme.errorContainer,
        errorBorderColor: colorScheme.error,
        hoverBackgroundColor: colorScheme.surfaceContainerHigh,
        defaultTextStyle: TextStyle(color: colorScheme.onSurface),
        shadows: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(isDark ? 51 : 26),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      edge: FlowEdgeStyle(
        defaultColor: colorScheme.outline,
        selectedColor: colorScheme.primary,
        animatedColor: colorScheme.tertiary,
        labelStyle: FlowEdgeLabelStyle(
          textStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 12,
          ),
          backgroundColor: colorScheme.surfaceContainerLow,
          borderColor: colorScheme.outlineVariant,
        ),
      ),
      handle: FlowHandleStyle(
        idleColor: colorScheme.outline,
        hoverColor: colorScheme.primary,
        activeColor: colorScheme.primary,
        validTargetColor: colorScheme.tertiary,
        invalidTargetColor: colorScheme.error,
        borderColor: colorScheme.surface,
      ),
      selection: FlowSelectionStyle(
        fillColor: colorScheme.primary.withAlpha(39),
        borderColor: colorScheme.primary,
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
            color: colorScheme.shadow.withAlpha(25),
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
      ),
      connection: FlowConnectionStyle(
        activeColor: colorScheme.primary,
        validTargetColor: colorScheme.tertiary,
        invalidTargetColor: colorScheme.error,
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
    );
  }
}

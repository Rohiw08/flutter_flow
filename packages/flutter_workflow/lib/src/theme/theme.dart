import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/theme/components/background_theme.dart';
import 'package:flutter_workflow/src/theme/components/connection_theme.dart';
import 'package:flutter_workflow/src/theme/components/control_theme.dart';
import 'package:flutter_workflow/src/theme/components/edge_label_theme.dart';
import 'package:flutter_workflow/src/theme/components/edge_theme.dart';
import 'package:flutter_workflow/src/theme/components/handle_theme.dart';
import 'package:flutter_workflow/src/theme/components/minimap_theme.dart';
import 'package:flutter_workflow/src/theme/components/node_theme.dart';
import 'package:flutter_workflow/src/theme/components/selection_theme.dart';

/// The core theme for the Flow Canvas.
@immutable
class FlowCanvasTheme extends ThemeExtension<FlowCanvasTheme> {
  final FlowCanvasBackgroundTheme background;
  final FlowCanvasNodeTheme node;
  final FlowCanvasEdgeTheme edge;
  final FlowCanvasHandleTheme handle;
  final FlowCanvasSelectionTheme selection;
  final FlowCanvasControlTheme controls;
  final FlowCanvasMiniMapTheme miniMap;
  final FlowCanvasConnectionTheme connection;

  const FlowCanvasTheme({
    required this.background,
    required this.node,
    required this.edge,
    required this.handle,
    required this.selection,
    required this.controls,
    required this.miniMap,
    required this.connection,
  });

  /// Creates a light theme.
  factory FlowCanvasTheme.light() {
    return FlowCanvasTheme(
      background: FlowCanvasBackgroundTheme.light(),
      node: FlowCanvasNodeTheme.light(),
      edge: FlowCanvasEdgeTheme.light(),
      handle: FlowCanvasHandleTheme.light(),
      selection: FlowCanvasSelectionTheme.light(),
      controls: FlowCanvasControlTheme.light(),
      miniMap: FlowCanvasMiniMapTheme.light(),
      connection: FlowCanvasConnectionTheme.light(),
    );
  }

  /// Creates a dark theme.
  factory FlowCanvasTheme.dark() {
    return FlowCanvasTheme(
      background: FlowCanvasBackgroundTheme.dark(),
      node: FlowCanvasNodeTheme.dark(),
      edge: FlowCanvasEdgeTheme.dark(),
      handle: FlowCanvasHandleTheme.dark(),
      selection: FlowCanvasSelectionTheme.dark(),
      controls: FlowCanvasControlTheme.dark(),
      miniMap: FlowCanvasMiniMapTheme.dark(),
      connection: FlowCanvasConnectionTheme.dark(),
    );
  }

  /// Creates a copy of this theme with the given fields replaced by the new values.
  @override
  FlowCanvasTheme copyWith({
    FlowCanvasBackgroundTheme? background,
    FlowCanvasNodeTheme? node,
    FlowCanvasEdgeTheme? edge,
    FlowCanvasHandleTheme? handle,
    FlowCanvasSelectionTheme? selection,
    FlowCanvasControlTheme? controls,
    FlowCanvasMiniMapTheme? miniMap,
    FlowCanvasConnectionTheme? connection,
  }) {
    return FlowCanvasTheme(
      background: background ?? this.background,
      node: node ?? this.node,
      edge: edge ?? this.edge,
      handle: handle ?? this.handle,
      selection: selection ?? this.selection,
      controls: controls ?? this.controls,
      miniMap: miniMap ?? this.miniMap,
      connection: connection ?? this.connection,
    );
  }

  factory FlowCanvasTheme.fromColorScheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return FlowCanvasTheme(
      background: FlowCanvasBackgroundTheme(
        backgroundColor: colorScheme.surface,
        variant: BackgroundVariant.dots,
        patternColor: colorScheme.outline.withAlpha(isDark ? 60 : 40),
        fadeOnZoom: true,
      ),
      node: FlowCanvasNodeTheme(
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
      edge: FlowCanvasEdgeTheme(
        defaultColor: colorScheme.outline,
        selectedColor: colorScheme.primary,
        animatedColor: colorScheme.tertiary,
        label: EdgeLabelTheme(
          textStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 12,
          ),
          backgroundColor: colorScheme.surfaceContainerLow,
          borderColor: colorScheme.outlineVariant,
        ),
      ),
      handle: FlowCanvasHandleTheme(
        idleColor: colorScheme.outline,
        hoverColor: colorScheme.primary,
        activeColor: colorScheme.primary,
        validTargetColor: colorScheme.tertiary,
        invalidTargetColor: colorScheme.error,
        borderColor: colorScheme.surface,
      ),
      selection: FlowCanvasSelectionTheme(
        fillColor: colorScheme.primary.withAlpha(39),
        borderColor: colorScheme.primary,
      ),
      controls: FlowCanvasControlTheme(
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
      miniMap: FlowCanvasMiniMapTheme(
        backgroundColor: colorScheme.surfaceContainerLow,
        nodeColor: colorScheme.primary,
        nodeStrokeColor: colorScheme.primaryContainer,
        selectedNodeColor: colorScheme.tertiary,
        maskColor: colorScheme.scrim.withAlpha(153),
        maskStrokeColor: colorScheme.outline,
      ),
      connection: FlowCanvasConnectionTheme(
        activeColor: colorScheme.primary,
        validTargetColor: colorScheme.tertiary,
        invalidTargetColor: colorScheme.error,
      ),
    );
  }

  @override
  ThemeExtension<FlowCanvasTheme> lerp(
      covariant ThemeExtension<FlowCanvasTheme>? other, double t) {
    // TODO: implement lerp
    if (other is! FlowCanvasTheme) return this;
    // For now, just do a simple switch at t=0.5
    // You can implement proper lerping later if needed
    return t < 0.5 ? this : other;
  }
}

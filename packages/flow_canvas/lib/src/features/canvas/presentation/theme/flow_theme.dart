import 'package:flow_canvas/src/features/canvas/presentation/theme/components/controls_button_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/controls_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_label_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_marker_theme.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/background_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/connection_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/edge_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/handle_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/minimap_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/node_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/selection_theme.dart';

@immutable
class FlowCanvasTheme extends ThemeExtension<FlowCanvasTheme> {
  final FlowBackgroundStyle background;
  final FlowNodeStyle node;
  final FlowEdgeStyle edge;
  final FlowHandleStyle handle;
  final FlowSelectionStyle selection;
  final FlowControlsStyle controls;
  final FlowControlsButtonStyle button;
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
    required this.button,
    required this.minimap,
    required this.connection,
    required this.edgeLabel,
    required this.edgeMarker,
  });

  factory FlowCanvasTheme.light() {
    return FlowCanvasTheme(
      background: FlowBackgroundStyle.light(),
      node: FlowNodeStyle.light(),
      edge: FlowEdgeStyle.light(),
      handle: FlowHandleStyle.light(),
      selection: FlowSelectionStyle.light(),
      controls: FlowControlsStyle.light(),
      button: FlowControlsButtonStyle.light(),
      minimap: FlowMinimapStyle.light(),
      connection: FlowConnectionStyle.light(),
      edgeLabel: FlowEdgeLabelStyle.light(),
      edgeMarker: FlowEdgeMarkerStyle.light(),
    );
  }

  factory FlowCanvasTheme.dark() {
    return FlowCanvasTheme(
      background: FlowBackgroundStyle.dark(),
      node: FlowNodeStyle.dark(),
      edge: FlowEdgeStyle.dark(),
      handle: FlowHandleStyle.dark(),
      selection: FlowSelectionStyle.dark(),
      controls: FlowControlsStyle.dark(),
      button: FlowControlsButtonStyle.dark(),
      minimap: FlowMinimapStyle.dark(),
      connection: FlowConnectionStyle.dark(),
      edgeLabel: FlowEdgeLabelStyle.dark(),
      edgeMarker: FlowEdgeMarkerStyle.dark(),
    );
  }

  factory FlowCanvasTheme.system(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlowCanvasTheme.dark()
        : FlowCanvasTheme.light();
  }

  factory FlowCanvasTheme.fromColorScheme(ColorScheme colorScheme) {
    return FlowCanvasTheme(
      background: FlowBackgroundStyle.fromColorScheme(colorScheme),
      node: FlowNodeStyle.fromColorScheme(colorScheme),
      edge: FlowEdgeStyle.fromColorScheme(colorScheme),
      handle: FlowHandleStyle.fromColorScheme(colorScheme),
      selection: FlowSelectionStyle.fromColorScheme(colorScheme),
      controls: FlowControlsStyle.fromColorScheme(colorScheme),
      button: FlowControlsButtonStyle.fromColorScheme(colorScheme),
      minimap: FlowMinimapStyle.fromColorScheme(colorScheme),
      connection: FlowConnectionStyle.fromColorScheme(colorScheme),
      edgeLabel: FlowEdgeLabelStyle.fromColorScheme(colorScheme),
      edgeMarker: FlowEdgeMarkerStyle.fromColorScheme(colorScheme),
    );
  }

  FlowCanvasTheme merge(FlowCanvasTheme? other) {
    if (other == null) return this;
    return copyWith(
      background: other.background,
      node: other.node,
      edge: other.edge,
      handle: other.handle,
      selection: other.selection,
      controls: other.controls,
      button: other.button,
      minimap: other.minimap,
      connection: other.connection,
      edgeLabel: other.edgeLabel,
      edgeMarker: other.edgeMarker,
    );
  }

  @override
  FlowCanvasTheme copyWith({
    FlowBackgroundStyle? background,
    FlowNodeStyle? node,
    FlowEdgeStyle? edge,
    FlowHandleStyle? handle,
    FlowSelectionStyle? selection,
    FlowControlsStyle? controls,
    FlowControlsButtonStyle? button,
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
      button: button ?? this.button,
      minimap: minimap ?? this.minimap,
      connection: connection ?? this.connection,
      edgeLabel: edgeLabel ?? this.edgeLabel,
      edgeMarker: edgeMarker ?? this.edgeMarker,
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
      button: button.lerp(other.button, t),
      minimap: minimap.lerp(other.minimap, t),
      connection: connection.lerp(other.connection, t),
      edgeLabel: edgeLabel.lerp(other.edgeLabel, t),
      edgeMarker: edgeMarker.lerp(other.edgeMarker, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowCanvasTheme &&
        other.background == background &&
        other.node == node &&
        other.edge == edge &&
        other.handle == handle &&
        other.selection == selection &&
        other.controls == controls &&
        other.button == button &&
        other.minimap == minimap &&
        other.edgeLabel == edgeLabel &&
        other.edgeMarker == edgeMarker &&
        other.connection == connection;
  }

  @override
  int get hashCode => Object.hash(
        background,
        node,
        edge,
        handle,
        selection,
        controls,
        minimap,
        connection,
        edgeLabel,
        edgeMarker,
        button,
      );
}

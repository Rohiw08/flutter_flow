import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';

/// Abstract base class for all custom edge painters.
/// Extend this class to create your own custom edge rendering logic.
/// This remains an abstract class and does not need to be immutable.
abstract class EdgePainter {
  /// The main paint method for the edge.
  ///
  /// [canvas] The canvas to paint on.
  /// [path] The pre-calculated Path object for the edge's shape.
  /// [edge] The FlowEdge data model containing all properties.
  /// [paint] The default paint object for the edge, configured by the theme.
  void paint(
    Canvas canvas,
    Path path,
    FlowEdge edge,
    Paint paint,
  );
}

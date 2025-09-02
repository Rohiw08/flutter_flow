import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/painters/background_painter.dart';
import 'package:flutter_workflow/src/theme/components/background_theme.dart';

/// A widget that renders the canvas background using a high-performance shader.
class FlowBackground extends StatelessWidget {
  final ui.FragmentProgram shader;
  final Matrix4 matrix;
  final FlowCanvasBackgroundTheme theme;

  const FlowBackground({
    super.key,
    required this.shader,
    required this.matrix,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: BackgroundPainter(
            program: shader,
            matrix: matrix,
            theme: theme,
          ),
        ),
      ),
    );
  }
}

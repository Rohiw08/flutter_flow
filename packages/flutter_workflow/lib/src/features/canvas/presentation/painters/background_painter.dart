import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/theme/components/background_theme.dart';

/// A highly performant painter for the canvas background that uses a fragment shader.
///
/// This painter is responsible for drawing the solid background color/gradient
/// and the tiled pattern (dots, grid, etc.) by setting the appropriate uniforms
/// for the compiled shader program.
class BackgroundPainter extends CustomPainter {
  /// The compiled shader program from the asset file.
  final ui.FragmentProgram program;

  /// The transformation matrix from the InteractiveViewer, containing pan and zoom.
  final Matrix4 matrix;

  /// The theme data containing colors, gap size, pattern type, etc.
  final FlowCanvasBackgroundTheme theme;

  const BackgroundPainter({
    required this.program,
    required this.matrix,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // First, draw the solid background color or gradient.
    // This is done on the CPU and is very fast.
    final bgPaint = Paint();
    if (theme.gradient != null) {
      bgPaint.shader = theme.gradient!
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    } else {
      bgPaint.color = theme.backgroundColor;
    }
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // If no pattern is selected, we're done.
    if (theme.variant == BackgroundVariant.none) {
      return;
    }

    // 1. Create the shader instance from the compiled program.
    final shader = program.fragmentShader();

    // 2. Set each uniform individually by its index.
    // The order MUST match the declaration order in the GLSL file.
    shader
      ..setFloat(0, -matrix.storage[12]) // uOffset.x
      ..setFloat(1, -matrix.storage[13]) // uOffset.y
      ..setFloat(2, matrix.getMaxScaleOnAxis()) // uScale
      ..setFloat(3, theme.patternColor.r / 255.0) // uColor.r
      ..setFloat(4, theme.patternColor.g / 255.0) // uColor.g
      ..setFloat(5, theme.patternColor.b / 255.0) // uColor.b
      ..setFloat(6, theme.patternColor.a) // uColor.a
      ..setFloat(7, theme.gap) // uGap
      ..setFloat(
          8,
          BackgroundVariant.values
              .indexOf(theme.variant)
              .toDouble()) // uPatternType
      ..setFloat(9, theme.dotRadius ?? 1.0) // uDotRadius
      ..setFloat(10, theme.crossSize ?? 5.0); // uCrossSize

    // 3. Create a Paint object and assign the configured shader.
    final paint = Paint()..shader = shader;

    // 4. Draw a single rectangle covering the whole canvas. The GPU does the rest.
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    // This is a highly efficient repaint condition. The painter will only
    // re-execute its paint method if the viewport (matrix) or the theme
    // has actually changed.
    return oldDelegate.matrix != matrix || oldDelegate.theme != theme;
  }
}

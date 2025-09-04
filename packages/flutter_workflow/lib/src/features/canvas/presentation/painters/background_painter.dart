import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/theme/components/background_theme.dart';

class BackgroundPainter extends CustomPainter {
  final ui.FragmentProgram program;
  final Matrix4 matrix;
  final FlowCanvasBackgroundTheme theme;
  late final ui.FragmentShader shader;

  // Cache for expensive calculations
  BackgroundPainter({
    required this.program,
    required this.matrix,
    required this.theme,
  }) {
    shader = program.fragmentShader();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = _setupShader(size);

    // Direct draw - no unnecessary save/restore/clip
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  ui.FragmentShader _setupShader(Size size) {
    // Pack uniforms more efficiently
    int index = 0;

    // Resolution
    shader.setFloat(index++, size.width);
    shader.setFloat(index++, size.height);

    // Matrix (unavoidable - Flutter API limitation)
    final values = matrix.storage;
    for (int i = 0; i < 16; i++) {
      shader.setFloat(index++, values[i]);
    }

    // Pack colors as single operations (if possible with your shader)
    // Background color
    shader.setFloat(index++, theme.backgroundColor.r);
    shader.setFloat(index++, theme.backgroundColor.g);
    shader.setFloat(index++, theme.backgroundColor.b);
    shader.setFloat(index++, theme.backgroundColor.a);

    // Pattern color
    shader.setFloat(index++, theme.patternColor.r);
    shader.setFloat(index++, theme.patternColor.g);
    shader.setFloat(index++, theme.patternColor.b);
    shader.setFloat(index++, theme.patternColor.a);

    // Packed pattern parameters
    shader.setFloat(index++, theme.gap);
    shader.setFloat(index++, theme.lineWidth);
    shader.setFloat(index++, theme.dotRadius ?? 2.0);
    shader.setFloat(index++, theme.crossSize ?? 6.0);
    shader.setFloat(index++, theme.variant.index.toDouble());

    return shader;
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    // More efficient comparison
    return !identical(oldDelegate.theme, theme) ||
        !identical(oldDelegate.matrix, matrix);
  }
}

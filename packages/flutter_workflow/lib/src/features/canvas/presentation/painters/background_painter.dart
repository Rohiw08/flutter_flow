import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/background_theme.dart';

class BackgroundPainter extends CustomPainter {
  final ui.FragmentProgram program;
  final FlowBackgroundStyle theme;
  late final ui.FragmentShader shader;

  BackgroundPainter({
    required this.program,
    required this.theme,
  }) {
    shader = program.fragmentShader();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || size.width <= 0 || size.height <= 0) return;

    final paint = Paint()..shader = _setupShader(size);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  ui.FragmentShader _setupShader(Size size) {
    int index = 0;

    // Resolution
    shader.setFloat(index++, size.width);
    shader.setFloat(index++, size.height);

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

    // Pattern parameters
    shader.setFloat(index++, theme.gap);
    shader.setFloat(index++, theme.lineWidth);
    shader.setFloat(index++, theme.dotRadius ?? 2.0);
    shader.setFloat(index++, theme.crossSize ?? 6.0);
    shader.setFloat(index++, theme.variant.index.toDouble());

    return shader;
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return !identical(oldDelegate.theme, theme);
  }
}

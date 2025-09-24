import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/components/background_theme.dart';

class BackgroundPainter extends CustomPainter {
  final ui.FragmentProgram program;
  final FlowBackgroundStyle style;
  late final ui.FragmentShader shader;

  BackgroundPainter({
    required this.program,
    required this.style,
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
    shader.setFloat(index++, style.backgroundColor!.r);
    shader.setFloat(index++, style.backgroundColor!.g);
    shader.setFloat(index++, style.backgroundColor!.b);
    shader.setFloat(index++, style.backgroundColor!.a);

    // Pattern color
    shader.setFloat(index++, style.patternColor!.r);
    shader.setFloat(index++, style.patternColor!.g);
    shader.setFloat(index++, style.patternColor!.b);
    shader.setFloat(index++, style.patternColor!.a);

    // Pattern parameters
    shader.setFloat(index++, style.gap!);
    shader.setFloat(index++, style.lineWidth!);
    shader.setFloat(index++, style.dotRadius ?? 2.0);
    shader.setFloat(index++, style.crossSize ?? 6.0);
    shader.setFloat(index++, style.variant!.index.toDouble());

    return shader;
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return !identical(oldDelegate.style, style);
  }
}

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

    // Resolution (0, 1)
    shader.setFloat(index++, size.width);
    shader.setFloat(index++, size.height);

    // Background color (2..5)
    shader.setFloat(index++, style.backgroundColor.r);
    shader.setFloat(index++, style.backgroundColor.g);
    shader.setFloat(index++, style.backgroundColor.b);
    shader.setFloat(index++, style.backgroundColor.a);

    // Pattern color (6..9)
    shader.setFloat(index++, style.patternColor.r);
    shader.setFloat(index++, style.patternColor.g);
    shader.setFloat(index++, style.patternColor.b);
    shader.setFloat(index++, style.patternColor.a);

    // Pattern parameters (10..13)
    shader.setFloat(index++, style.gap);
    shader.setFloat(index++, style.lineWidth);
    shader.setFloat(index++, style.dotRadius);
    shader.setFloat(index++, style.crossSize);

    // Variant (14)
    shader.setFloat(index++, style.variant.index.toDouble());

    // Pattern offset (15, 16)
    shader.setFloat(index++, style.patternOffset.dx);
    shader.setFloat(index++, style.patternOffset.dy);

    // Blend mode (17)
    shader.setFloat(index++, _getBlendModeIndex(style.blendMode));

    // Gradient setup (18)
    final hasGradient = style.gradient != null;
    shader.setFloat(index++, hasGradient ? 1.0 : 0.0);

    // Gradient colors (19..34) - support up to 4 colors
    List<Color> gradientColors = [];
    if (hasGradient && style.gradient is LinearGradient) {
      final gradient = style.gradient as LinearGradient;
      gradientColors = gradient.colors;
    }

    // Set up to 4 gradient colors
    for (int i = 0; i < 4; i++) {
      if (i < gradientColors.length) {
        final color = gradientColors[i];
        shader.setFloat(index++, color.r);
        shader.setFloat(index++, color.g);
        shader.setFloat(index++, color.b);
        shader.setFloat(index++, color.a);
      } else {
        // Fill with black transparent for unused slots
        shader.setFloat(index++, 0.0);
        shader.setFloat(index++, 0.0);
        shader.setFloat(index++, 0.0);
        shader.setFloat(index++, 0.0);
      }
    }

    // Gradient color count (35)
    shader.setFloat(index++, gradientColors.length.toDouble());

    return shader;
  }

  double _getBlendModeIndex(BlendMode mode) {
    // Map common blend modes to indices
    switch (mode) {
      case BlendMode.srcOver:
        return 0.0;
      case BlendMode.multiply:
        return 3.0;
      case BlendMode.screen:
        return 4.0;
      case BlendMode.overlay:
        return 5.0;
      default:
        return 0.0; // Default to srcOver
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.style != style;
  }
}

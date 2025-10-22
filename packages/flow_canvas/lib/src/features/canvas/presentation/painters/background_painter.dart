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
    if (size.isEmpty) return;
    final paint = Paint()..shader = _setupShader(size);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  ui.FragmentShader _setupShader(Size size) {
    int index = 0;

    // --- Uniforms 0-17 are unchanged ---
    shader.setFloat(index++, size.width);
    shader.setFloat(index++, size.height);
    shader.setFloat(index++, style.backgroundColor.r);
    shader.setFloat(index++, style.backgroundColor.g);
    shader.setFloat(index++, style.backgroundColor.b);
    shader.setFloat(index++, style.backgroundColor.a);
    shader.setFloat(index++, style.patternColor.r);
    shader.setFloat(index++, style.patternColor.g);
    shader.setFloat(index++, style.patternColor.b);
    shader.setFloat(index++, style.patternColor.a);
    shader.setFloat(index++, style.gap);
    shader.setFloat(index++, style.lineWidth);
    shader.setFloat(index++, style.dotRadius);
    shader.setFloat(index++, style.crossSize);
    shader.setFloat(index++, style.variant.index.toDouble());
    shader.setFloat(index++, style.patternOffset.dx);
    shader.setFloat(index++, style.patternOffset.dy);
    shader.setFloat(index++, _getBlendModeIndex(style.blendMode));

    final hasGradient =
        style.gradient != null && style.gradient is LinearGradient;
    shader.setFloat(index++, hasGradient ? 1.0 : 0.0); // Uniform 18

    // Default values
    List<Color> gradientColors = [];
    List<double> gradientStops = [];
    Offset begin = Offset.zero, end = Offset.zero;
    Matrix4 transformMatrix = Matrix4.identity();
    int tileMode = 0;

    if (hasGradient) {
      final gradient = style.gradient as LinearGradient;
      gradientColors = gradient.colors;
      gradientStops = gradient.stops ?? _defaultStops(gradient.colors.length);
      begin = (gradient.begin as Alignment).alongSize(size);
      end = (gradient.end as Alignment).alongSize(size);
      tileMode = gradient.tileMode.index;

      if (gradient.transform != null) {
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        transformMatrix = gradient.transform!.transform(rect)!;
      }
    }

    // Gradient Begin/End Coords (19..22)
    shader.setFloat(index++, begin.dx);
    shader.setFloat(index++, begin.dy);
    shader.setFloat(index++, end.dx);
    shader.setFloat(index++, end.dy);

    // Gradient Colors (23..38)
    for (int i = 0; i < 4; i++) {
      final color =
          i < gradientColors.length ? gradientColors[i] : Colors.transparent;
      shader.setFloat(index++, color.r);
      shader.setFloat(index++, color.g);
      shader.setFloat(index++, color.b);
      shader.setFloat(index++, color.a);
    }

    // Gradient Stops (39..42)
    for (int i = 0; i < 4; i++) {
      shader.setFloat(
          index++, i < gradientStops.length ? gradientStops[i] : -1.0);
    }

    // Gradient color count (43)
    shader.setFloat(index++, gradientColors.length.toDouble());

    // Tile Mode (44)
    shader.setFloat(index++, tileMode.toDouble());

    // Transformation Matrix (45..60)
    final matrixFloats = transformMatrix.storage;
    for (int i = 0; i < 16; i++) {
      shader.setFloat(index++, matrixFloats[i]);
    }

    return shader;
  }

  // ... (helper methods _defaultStops, _getBlendModeIndex are unchanged)
  List<double> _defaultStops(int colorCount) {
    if (colorCount <= 1) return [0.0];
    final step = 1.0 / (colorCount - 1);
    return List.generate(colorCount, (i) => i * step);
  }

  double _getBlendModeIndex(BlendMode mode) {
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
        return 0.0;
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter old) => old.style != style;
}

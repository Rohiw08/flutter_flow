import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import '../theme/components/background_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/widgets/layers/flow_background.dart';

class BackgroundPainter extends CustomPainter {
  /// Manages the specialized shader variants.
  final BackgroundShaderManager shaderManager;

  /// Visual styling configuration for the background.
  final FlowBackgroundStyle style;

  const BackgroundPainter({
    required this.shaderManager,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    // Special case: solid background (no pattern).
    if (style.variant == BackgroundVariant.none) {
      _paintSolidBackground(canvas, size);
      return;
    }

    // Get the specialized shader *program* for this pattern.
    final program = shaderManager.getShader(style.variant);
    if (program == null) {
      _paintSolidBackground(canvas, size);
      return;
    }

    // Every paint must create a fresh ui.FragmentShader from the program.
    final shader = program.fragmentShader();

    // Configure shader uniforms based on pattern type.
    switch (style.variant) {
      case BackgroundVariant.dots:
        _setupDotShader(shader, size);
        break;
      case BackgroundVariant.grid:
        _setupGridShader(shader, size);
        break;
      case BackgroundVariant.cross:
        _setupCrossShader(shader, size);
        break;
      case BackgroundVariant.none:
        return; // Already handled above.
    }

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  void _paintSolidBackground(Canvas canvas, Size size) {
    final paint = Paint()..color = style.backgroundColor;
    if (style.gradient != null) {
      final gradient = style.gradient!;
      final rect = Offset.zero & size;
      paint.shader = gradient.createShader(rect);
    }
    canvas.drawRect(Offset.zero & size, paint);
  }

  void _setupDotShader(ui.FragmentShader shader, Size size) {
    int idx = 0;
    shader.setFloat(idx++, size.width);
    shader.setFloat(idx++, size.height);
    shader.setFloat(idx++, style.backgroundColor.r);
    shader.setFloat(idx++, style.backgroundColor.g);
    shader.setFloat(idx++, style.backgroundColor.b);
    shader.setFloat(idx++, style.backgroundColor.a);
    shader.setFloat(idx++, style.patternColor.r);
    shader.setFloat(idx++, style.patternColor.g);
    shader.setFloat(idx++, style.patternColor.b);
    shader.setFloat(idx++, style.patternColor.a);
    shader.setFloat(idx++, style.gap);
    shader.setFloat(idx++, style.dotRadius);
    shader.setFloat(idx++, style.patternOffset.dx);
    shader.setFloat(idx++, style.patternOffset.dy);
    shader.setFloat(idx++, _getBlendModeIndex(style.blendMode));
    _setupGradientUniforms(shader, size, idx);
  }

  void _setupGridShader(ui.FragmentShader shader, Size size) {
    int idx = 0;
    shader.setFloat(idx++, size.width);
    shader.setFloat(idx++, size.height);
    shader.setFloat(idx++, style.backgroundColor.r);
    shader.setFloat(idx++, style.backgroundColor.g);
    shader.setFloat(idx++, style.backgroundColor.b);
    shader.setFloat(idx++, style.backgroundColor.a);
    shader.setFloat(idx++, style.patternColor.r);
    shader.setFloat(idx++, style.patternColor.g);
    shader.setFloat(idx++, style.patternColor.b);
    shader.setFloat(idx++, style.patternColor.a);
    shader.setFloat(idx++, style.gap);
    shader.setFloat(idx++, style.lineWidth);
    shader.setFloat(idx++, style.patternOffset.dx);
    shader.setFloat(idx++, style.patternOffset.dy);
    shader.setFloat(idx++, _getBlendModeIndex(style.blendMode));
    _setupGradientUniforms(shader, size, idx);
  }

  void _setupCrossShader(ui.FragmentShader shader, Size size) {
    int idx = 0;
    shader.setFloat(idx++, size.width);
    shader.setFloat(idx++, size.height);
    shader.setFloat(idx++, style.backgroundColor.r);
    shader.setFloat(idx++, style.backgroundColor.g);
    shader.setFloat(idx++, style.backgroundColor.b);
    shader.setFloat(idx++, style.backgroundColor.a);
    shader.setFloat(idx++, style.patternColor.r);
    shader.setFloat(idx++, style.patternColor.g);
    shader.setFloat(idx++, style.patternColor.b);
    shader.setFloat(idx++, style.patternColor.a);
    shader.setFloat(idx++, style.gap);
    shader.setFloat(idx++, style.lineWidth);
    shader.setFloat(idx++, style.crossSize);
    shader.setFloat(idx++, style.patternOffset.dx);
    shader.setFloat(idx++, style.patternOffset.dy);
    shader.setFloat(idx++, _getBlendModeIndex(style.blendMode));
    _setupGradientUniforms(shader, size, idx);
  }

  void _setupGradientUniforms(
    ui.FragmentShader shader,
    Size size,
    int startIndex,
  ) {
    int idx = startIndex;

    final hasGradient =
        style.gradient != null && style.gradient is LinearGradient;
    shader.setFloat(idx++, hasGradient ? 1.0 : 0.0);

    if (!hasGradient) {
      // Fill remaining uniforms (see your original code for details)
      for (int i = 0; i < 4 + 16 + 4 + 2 + 16; i++) {
        shader.setFloat(idx++, 0.0);
      }
      return;
    }

    final gradient = style.gradient as LinearGradient;
    final colors = gradient.colors;
    final stops = gradient.stops ?? _defaultStops(colors.length);
    final begin = (gradient.begin as Alignment).alongSize(size);
    final end = (gradient.end as Alignment).alongSize(size);

    final tileMode = gradient.tileMode.index;

    Matrix4 transformMatrix = Matrix4.identity();
    if (gradient.transform != null) {
      final rect = Offset.zero & size;
      transformMatrix = gradient.transform!.transform(rect)!;
    }
    final inverseTransform = Matrix4.inverted(transformMatrix);

    shader.setFloat(idx++, begin.dx);
    shader.setFloat(idx++, begin.dy);
    shader.setFloat(idx++, end.dx);
    shader.setFloat(idx++, end.dy);

    for (int i = 0; i < 4; i++) {
      final color = i < colors.length ? colors[i] : Colors.transparent;
      shader.setFloat(idx++, color.r);
      shader.setFloat(idx++, color.g);
      shader.setFloat(idx++, color.b);
      shader.setFloat(idx++, color.a);
    }

    for (int i = 0; i < 4; i++) {
      shader.setFloat(idx++, i < stops.length ? stops[i] : 0.0);
    }

    shader.setFloat(idx++, colors.length.toDouble());
    shader.setFloat(idx++, tileMode.toDouble());

    final storage = inverseTransform.storage;
    for (int i = 0; i < 16; i++) {
      shader.setFloat(idx++, storage[i]);
    }
  }

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
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.style != style ||
        oldDelegate.shaderManager != shaderManager;
  }

  @override
  bool shouldRebuildSemantics(BackgroundPainter oldDelegate) => false;
}

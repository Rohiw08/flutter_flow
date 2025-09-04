import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/painters/background_painter.dart';
import 'package:flutter_workflow/src/theme/components/background_theme.dart';
import 'package:flutter_workflow/src/theme/theme_resolver/background_theme_resolver.dart';

class FlowBackground extends StatelessWidget {
  final FlowCanvasFacade facade;
  final FlowCanvasBackgroundTheme? backgroundTheme;

  const FlowBackground({
    super.key,
    required this.facade,
    this.backgroundTheme,
  });

  Future<ui.FragmentProgram> _loadShader() {
    return ui.FragmentProgram.fromAsset(
      'packages/flutter_workflow/lib/src/features/canvas/presentation/shaders/background.frag',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveBackgroundTheme(context, backgroundTheme);
    final matrix = facade.transformationController.value;

    return Positioned.fill(
      child: FutureBuilder<ui.FragmentProgram>(
        future: _loadShader(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Debug: Show error if shader loading fails
            debugPrint('Shader loading error: ${snapshot.error}');
            return Container(color: theme.backgroundColor);
          }

          if (!snapshot.hasData) {
            // Show fallback background until the shader is ready
            return Container(color: theme.backgroundColor);
          }

          return RepaintBoundary(
            child: CustomPaint(
              painter: BackgroundPainter(
                program: snapshot.data!,
                matrix: matrix,
                theme: theme,
              ),
            ),
          );
        },
      ),
    );
  }
}

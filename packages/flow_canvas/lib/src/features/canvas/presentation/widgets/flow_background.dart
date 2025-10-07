import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/presentation/painters/background_painter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/background_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extensions.dart';

// Provider to asynchronously load the shader once and cache it.
final _shaderProvider = FutureProvider<ui.FragmentProgram>((ref) {
  return ui.FragmentProgram.fromAsset(
    'packages/flow_canvas/lib/src/features/canvas/presentation/shaders/background.frag',
  );
});

class FlowBackground extends ConsumerWidget {
  final FlowBackgroundStyle? backgroundStyle;

  const FlowBackground({
    super.key,
    this.backgroundStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseTheme = context.flowCanvasTheme.background;
    final style = baseTheme.merge(backgroundStyle);

    final shaderAsyncValue = ref.watch(_shaderProvider);

    return Positioned.fill(
      child: shaderAsyncValue.when(
        loading: () => Container(color: style.backgroundColor),
        error: (err, stack) {
          debugPrint('Shader loading error: $err');
          return Container(color: style.backgroundColor);
        },
        data: (program) {
          return RepaintBoundary(
            child: CustomPaint(
              painter: BackgroundPainter(
                program: program,
                style: style,
              ),
              size: Size.infinite,
            ),
          );
        },
      ),
    );
  }
}

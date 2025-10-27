import 'dart:ui' as ui;
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_extension.dart';
import 'package:flow_canvas/src/shared/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/src/features/canvas/presentation/painters/background_painter.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/components/background_theme.dart';

/// Manages specialized fragment shader programs keyed by background variant.
class BackgroundShaderManager {
  final Map<BackgroundVariant, ui.FragmentProgram> _shaders;

  BackgroundShaderManager(this._shaders);

  /// Returns the `FragmentProgram` for the given background variant, or null.
  ui.FragmentProgram? getShader(BackgroundVariant variant) {
    return _shaders[variant];
  }
}

final _shaderManagerProvider =
    FutureProvider<BackgroundShaderManager>((ref) async {
  final dotProgram = await ui.FragmentProgram.fromAsset(
    'packages/flow_canvas/lib/src/features/canvas/presentation/shaders/dot_pattern.frag',
  );
  final crossProgram = await ui.FragmentProgram.fromAsset(
    'packages/flow_canvas/lib/src/features/canvas/presentation/shaders/cross_pattern.frag',
  );
  final gridProgram = await ui.FragmentProgram.fromAsset(
    'packages/flow_canvas/lib/src/features/canvas/presentation/shaders/grid_pattern.frag',
  );

  return BackgroundShaderManager({
    BackgroundVariant.dots: dotProgram,
    BackgroundVariant.cross: crossProgram,
    BackgroundVariant.grid: gridProgram,
  });
});

class FlowBackground extends ConsumerWidget {
  final FlowBackgroundStyle? style;

  const FlowBackground({super.key, this.style});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: check if setting theme in FlowCanvas Widget set default theme in context
    final baseTheme = context.flowCanvasTheme.background ??
        FlowBackgroundStyle.system(context);
    final mergedStyle = baseTheme.merge(style);

    final shaderManagerAsync = ref.watch(_shaderManagerProvider);

    return Positioned.fill(
      child: shaderManagerAsync.when(
        loading: () => Container(color: mergedStyle.backgroundColor),
        error: (err, stack) {
          debugPrint('Failed to load shaders: $err');
          return Container(color: mergedStyle.backgroundColor);
        },
        data: (shaderManager) {
          return RepaintBoundary(
            child: CustomPaint(
              painter: BackgroundPainter(
                shaderManager: shaderManager,
                style: mergedStyle,
              ),
              size: Size.infinite,
            ),
          );
        },
      ),
    );
  }
}

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/painters/background_painter.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/background_theme.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/theme_resolver/background_theme_resolver.dart';

class FlowBackground extends StatefulWidget {
  final FlowBackgroundStyle? backgroundTheme;

  const FlowBackground({
    super.key,
    this.backgroundTheme,
  });

  @override
  State<FlowBackground> createState() => _FlowBackgroundState();
}

class _FlowBackgroundState extends State<FlowBackground> {
  ui.FragmentProgram? _program;
  bool _isShaderLoaded = false;
  late FlowBackgroundStyle _resolvedTheme;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolvedTheme = resolveBackgroundTheme(context, widget.backgroundTheme);
  }

  @override
  void didUpdateWidget(covariant FlowBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backgroundTheme != widget.backgroundTheme) {
      _resolvedTheme = resolveBackgroundTheme(context, widget.backgroundTheme);
    }
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(
        'packages/flutter_workflow/lib/src/features/canvas/presentation/shaders/background.frag',
      );

      if (mounted) {
        setState(() {
          _program = program;
          _isShaderLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Shader loading error: $e');
      if (mounted) {
        setState(() {
          _isShaderLoaded = true; // Show fallback
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _resolvedTheme;

    // Show fallback during shader loading
    if (!_isShaderLoaded) {
      return Positioned.fill(
        child: Container(color: theme.backgroundColor),
      );
    }

    // Show fallback if shader failed to load
    if (_program == null) {
      return Positioned.fill(
        child: Container(color: theme.backgroundColor),
      );
    }

    return Positioned.fill(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: BackgroundPainter(
            program: _program!,
            style: theme, // No matrix needed!
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

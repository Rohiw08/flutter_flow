import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/painters/background_painter.dart';
import 'package:flutter_workflow/src/theme/components/background_theme.dart';
import 'package:flutter_workflow/src/theme/theme_resolver/background_theme_resolver.dart';

class FlowBackground extends StatefulWidget {
  final FlowCanvasFacade facade;
  final FlowCanvasBackgroundTheme? backgroundTheme;

  const FlowBackground({
    super.key,
    required this.facade,
    this.backgroundTheme,
  });

  @override
  State<FlowBackground> createState() => _FlowBackgroundState();
}

class _FlowBackgroundState extends State<FlowBackground> {
  ui.FragmentProgram? _program;
  bool _isLoadingShader = false;
  bool _isShaderLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadShader();
    widget.facade.transformationController
        .addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    widget.facade.transformationController
        .removeListener(_onTransformationChanged);
    super.dispose();
  }

  void _onTransformationChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadShader() async {
    if (_isLoadingShader) return;

    _isLoadingShader = true;
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
      // Even if shader fails to load, mark as "loaded" to show fallback
      if (mounted) {
        setState(() {
          _isShaderLoaded = true;
        });
      }
    } finally {
      _isLoadingShader = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveBackgroundTheme(context, widget.backgroundTheme);

    // Get the transformation matrix, with a fallback to identity matrix
    final matrix = widget.facade.state.matrix ?? Matrix4.identity();

    // Show loading state while shader is loading
    if (!_isShaderLoaded) {
      return Positioned.fill(
        child: Container(color: theme.backgroundColor),
      );
    }

    // If shader failed to load, show fallback background
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
            matrix: matrix,
            theme: theme,
          ),
          // Force the painter to cover the entire area
          size: Size.infinite,
        ),
      ),
    );
  }
}

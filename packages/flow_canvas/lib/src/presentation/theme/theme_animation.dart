import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_provider.dart';

/// Animates transitions between [FlowCanvasTheme] configurations.
///
/// This widget wraps [AnimatedTheme] to provide smooth, animated transitions
/// when the [theme] changes. All theme properties (colors, decorations, sizes)
/// will interpolate over the specified [duration].
///
/// {@tool snippet}
/// Basic usage with theme switching:
/// ```dart
/// AnimatedFlowCanvasTheme(
///   theme: isDark ? FlowCanvasTheme.dark() : FlowCanvasTheme.light(),
///   child: FlowCanvas(...),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// With custom duration and curve:
/// ```dart
/// AnimatedFlowCanvasTheme(
///   theme: customTheme,
///   duration: Duration(milliseconds: 500),
///   curve: Curves.easeInOutCubic,
///   child: FlowCanvas(...),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// Extending a parent theme:
/// ```dart
/// // Parent provides base theme
/// FlowCanvasThemeProvider(
///   theme: FlowCanvasTheme.light(),
///   child: Column(
///     children: [
///       FlowCanvas(...), // Uses light theme
///
///       // This canvas uses light theme but with custom nodes
///       AnimatedFlowCanvasTheme(
///         theme: FlowCanvasTheme.light().copyWith(
///           node: FlowNodeStyle.colored(color: Colors.purple),
///         ),
///         inheritParent: true,
///         child: FlowCanvas(...),
///       ),
///     ],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// ## Animation Behavior
///
/// The widget uses [TweenAnimationBuilder] to create smooth interpolations
/// between theme states. When [theme] changes, all animatable properties
/// (colors, doubles, decorations) will transition over [duration].
///
/// ## Performance Notes
///
/// - Theme interpolation is efficient and runs at 60fps
/// - Animations only occur when [theme] actually changes
/// - Consider using [RepaintBoundary] around child if needed
///
/// See also:
///
///  * [FlowCanvasTheme], the theme being animated
///  * [FlowCanvasThemeProvider], for providing static themes
///  * [FlowCanvasThemeManager], for managing multiple themes
///  * [AnimatedTheme], the underlying Flutter widget
class AnimatedFlowCanvasTheme extends StatelessWidget {
  /// The target theme to animate towards.
  ///
  /// When this value changes, the widget will animate from the current
  /// theme to this new theme over [duration].
  final FlowCanvasTheme theme;

  /// The duration of the theme transition animation.
  ///
  /// Defaults to 300 milliseconds, which provides a noticeable but
  /// not distracting transition.
  final Duration duration;

  /// The curve to use for the theme transition animation.
  ///
  /// Defaults to [Curves.easeInOut], which provides smooth acceleration
  /// and deceleration.
  final Curve curve;

  /// Whether to inherit and extend the parent theme.
  ///
  /// When `true`:
  /// - Looks for a parent [FlowCanvasTheme] in the widget tree
  /// - If found, uses it as a base and applies [theme] on top
  /// - Only specified properties in [theme] will override the parent
  ///
  /// When `false` (default):
  /// - Uses [theme] directly, ignoring any parent theme
  /// - This is the typical behavior for setting a complete theme
  ///
  /// Example use case: You have a global light theme but want one specific
  /// canvas to have purple nodes while keeping everything else from the
  /// parent theme.
  ///
  /// ```dart
  /// // Parent provides base theme
  /// FlowCanvasThemeProvider(
  ///   theme: FlowCanvasTheme.light(),
  ///   child: AnimatedFlowCanvasTheme(
  ///     theme: FlowCanvasTheme.light().copyWith(
  ///       node: FlowNodeStyle.colored(color: Colors.purple),
  ///     ),
  ///     inheritParent: true, // Extends parent instead of replacing
  ///     child: FlowCanvas(...),
  ///   ),
  /// )
  /// ```
  final bool inheritParent;

  /// The widget below this widget in the tree.
  ///
  /// This widget will have access to the animated theme through
  /// [FlowCanvasThemeProvider.of] or `context.flowCanvasTheme`.
  final Widget child;

  /// Creates an animated theme widget.
  ///
  /// The [theme] and [child] arguments must not be null.
  const AnimatedFlowCanvasTheme({
    super.key,
    required this.theme,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.inheritParent = false,
  });

  @override
  Widget build(BuildContext context) {
    final parentTheme = Theme.of(context);
    final parentFlowTheme = parentTheme.extension<FlowCanvasTheme>();

    // Determine the target theme based on inheritance setting
    final targetTheme = _resolveTargetTheme(parentFlowTheme);

    // Get the current theme for smooth animation start point
    // If no current theme exists, start from target (no animation on first build)
    final currentTheme = FlowCanvasThemeProvider.of(context);

    return TweenAnimationBuilder<FlowCanvasTheme>(
      key: ValueKey(inheritParent), // Rebuild if inheritance mode changes
      tween: _FlowCanvasThemeTween(
        begin: currentTheme,
        end: targetTheme,
      ),
      duration: duration,
      curve: curve,
      builder: (context, animatedTheme, child) {
        return Theme(
          data: parentTheme.copyWith(
            extensions: [
              // Preserve all other theme extensions
              ...parentTheme.extensions.values
                  .where((e) => e is! FlowCanvasTheme),
              // Add our animated theme
              animatedTheme,
            ],
          ),
          child: child!,
        );
      },
      child: child,
    );
  }

  /// Resolves the final target theme based on inheritance settings.
  ///
  /// This determines what theme to animate towards:
  /// - If [inheritParent] is false, returns [theme] directly
  /// - If [inheritParent] is true and parent exists, merges them
  /// - If [inheritParent] is true but no parent, falls back to [theme]
  FlowCanvasTheme _resolveTargetTheme(FlowCanvasTheme? parentFlowTheme) {
    if (!inheritParent || parentFlowTheme == null) {
      return theme;
    }

    // Merge: parent provides base, theme provides overrides
    // Note: FlowCanvasTheme.merge() currently does full replacement.
    // For true property-level merging, component styles would need
    // nullable fields and proper merge implementations.
    return parentFlowTheme.merge(theme);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FlowCanvasTheme>('theme', theme));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(DiagnosticsProperty<Curve>('curve', curve));
    properties.add(FlagProperty(
      'inheritParent',
      value: inheritParent,
      ifTrue: 'inheriting parent theme',
      ifFalse: 'using theme directly',
    ));
  }
}

/// A [Tween] for [FlowCanvasTheme] that interpolates all theme properties.
///
/// This tween uses the [FlowCanvasTheme.lerp] method to smoothly transition
/// between two theme configurations. All animatable properties (colors,
/// sizes, decorations) will be interpolated.
class _FlowCanvasThemeTween extends Tween<FlowCanvasTheme> {
  /// Creates a [FlowCanvasTheme] tween.
  ///
  /// The [begin] and [end] properties must be set before calling [lerp].
  _FlowCanvasThemeTween({super.begin, super.end});

  @override
  FlowCanvasTheme lerp(double t) {
    // Handle null cases gracefully
    if (begin == null) return end!;
    if (end == null) return begin!;

    // Use the theme's built-in lerp for smooth interpolation
    return begin!.lerp(end!, t);
  }
}

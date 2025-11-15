import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_manager.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_provider.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/theme_animation.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';

/// Rebuilds its child whenever the [FlowCanvasThemeManager]'s theme changes.
///
/// This widget listens to a [FlowCanvasThemeManager] and rebuilds whenever
/// the current theme changes, providing the updated theme to the builder function.
///
/// {@tool snippet}
/// Basic usage with a theme manager:
/// ```dart
/// final themeManager = FlowCanvasThemeManager();
///
/// FlowCanvasThemeBuilder(
///   themeManager: themeManager,
///   builder: (context, theme) {
///     return FlowCanvas(
///       // Canvas automatically uses theme from context
///     );
///   },
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// With theme switching controls:
/// ```dart
/// FlowCanvasThemeBuilder(
///   themeManager: themeManager,
///   builder: (context, theme) {
///     return Column(
///       children: [
///         // Theme switcher
///         Row(
///           children: [
///             ElevatedButton(
///               onPressed: () => themeManager.setThemeByName('light'),
///               child: Text('Light'),
///             ),
///             ElevatedButton(
///               onPressed: () => themeManager.setThemeByName('dark'),
///               child: Text('Dark'),
///             ),
///           ],
///         ),
///         // Canvas
///         Expanded(
///           child: FlowCanvas(...),
///         ),
///       ],
///     );
///   },
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// With animated theme transitions:
/// ```dart
/// FlowCanvasThemeBuilder(
///   themeManager: themeManager,
///   animated: true,
///   duration: Duration(milliseconds: 500),
///   builder: (context, theme) {
///     return FlowCanvas(...);
///   },
/// )
/// ```
/// {@end-tool}
///
/// ## Animation Support
///
/// When [animated] is true, theme changes will smoothly interpolate over
/// [duration]. This creates a polished user experience when switching themes.
///
/// ## Theme Resolution
///
/// If [resolveTheme] is true (default), the theme from the manager will be
/// resolved to ensure all component styles are defined. This prevents null
/// pointer exceptions if the theme manager provides a partial theme.
///
/// ## Performance Notes
///
/// - Only rebuilds when the theme manager notifies listeners
/// - Uses [AnimatedBuilder] for efficient rebuilds
/// - Consider using [RepaintBoundary] around expensive canvas content
///
/// See also:
///
///  * [FlowCanvasThemeManager], for managing multiple themes
///  * [FlowCanvasThemeProvider], for providing static themes
///  * [AnimatedFlowCanvasTheme], for animated theme transitions
///  * [AnimatedBuilder], the underlying widget used for rebuilding
class FlowCanvasThemeBuilder extends StatelessWidget {
  /// The theme manager to listen to for theme changes.
  ///
  /// The builder will rebuild whenever [FlowCanvasThemeManager.currentTheme]
  /// changes and will pass the new theme to the [builder] function.
  final FlowCanvasThemeManager themeManager;

  /// Builds the widget tree using the current theme.
  ///
  /// This function is called whenever the theme changes. The [theme] parameter
  /// contains the current theme from [themeManager], potentially resolved and
  /// animated depending on configuration.
  ///
  /// The [context] parameter provides access to the theme through
  /// `FlowCanvasThemeProvider.of(context)` or `context.flowCanvasTheme`.
  final Widget Function(BuildContext context, FlowCanvasTheme theme) builder;

  /// Whether to animate theme transitions.
  ///
  /// When true, uses [AnimatedFlowCanvasTheme] to smoothly interpolate
  /// between theme changes over [duration].
  ///
  /// When false (default), theme changes apply immediately.
  final bool animated;

  /// The duration of theme transition animations.
  ///
  /// Only applies when [animated] is true. Defaults to 300 milliseconds.
  final Duration duration;

  /// The curve to use for theme transition animations.
  ///
  /// Only applies when [animated] is true. Defaults to [Curves.easeInOut].
  final Curve curve;

  /// Whether to resolve the theme to ensure all components are defined.
  ///
  /// When true (default), calls [FlowCanvasTheme.resolve] on the theme from
  /// the manager before providing it to descendants. This ensures all component
  /// styles have values, preventing null pointer exceptions.
  ///
  /// When false, uses the theme from the manager as-is. Only disable this if
  /// you're certain the theme manager always provides complete themes.
  final bool resolveTheme;

  /// Creates a theme builder that rebuilds when the manager's theme changes.
  ///
  /// The [themeManager] and [builder] parameters must not be null.
  const FlowCanvasThemeBuilder({
    super.key,
    required this.themeManager,
    required this.builder,
    this.animated = false,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.resolveTheme = true,
  });

  /// Creates an animated theme builder.
  ///
  /// This is a convenience constructor equivalent to setting [animated] to true.
  const FlowCanvasThemeBuilder.animated({
    super.key,
    required this.themeManager,
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.resolveTheme = true,
  }) : animated = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        // Get current theme from manager
        final currentTheme = themeManager.currentTheme;

        // Resolve theme if requested to ensure all components are defined
        final effectiveTheme =
            resolveTheme ? currentTheme.resolve() : currentTheme;

        // Wrap in animated theme if requested
        if (animated) {
          return AnimatedFlowCanvasTheme(
            theme: effectiveTheme,
            duration: duration,
            curve: curve,
            child: Builder(
              builder: (context) => builder(context, effectiveTheme),
            ),
          );
        }

        // Otherwise provide theme directly
        return FlowCanvasThemeProvider(
          theme: effectiveTheme,
          child: builder(context, effectiveTheme),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FlowCanvasThemeManager>(
      'themeManager',
      themeManager,
    ));
    properties.add(
        ObjectFlagProperty<Widget Function(BuildContext, FlowCanvasTheme)>.has(
      'builder',
      builder,
    ));
    properties.add(FlagProperty(
      'animated',
      value: animated,
      ifTrue: 'animated transitions',
      ifFalse: 'immediate transitions',
    ));
    if (animated) {
      properties.add(DiagnosticsProperty<Duration>('duration', duration));
      properties.add(DiagnosticsProperty<Curve>('curve', curve));
    }
    properties.add(FlagProperty(
      'resolveTheme',
      value: resolveTheme,
      ifTrue: 'resolving theme',
      ifFalse: 'using theme as-is',
    ));
  }
}

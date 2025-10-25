import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';

/// Manages [FlowCanvasTheme] state and provides theme switching capabilities.
///
/// This class extends [ChangeNotifier] to notify listeners when the current
/// theme changes. It supports predefined themes (light/dark), custom themes,
/// and various theme management utilities.
///
/// {@tool snippet}
/// Basic usage with theme switching:
/// ```dart
/// final themeManager = FlowCanvasThemeManager();
///
/// // Switch themes
/// themeManager.setTheme(FlowCanvasTheme.dark());
///
/// // Or by name
/// themeManager.setThemeByName('dark');
///
/// // Toggle light/dark
/// themeManager.toggleBrightness();
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// Adding custom themes:
/// ```dart
/// final themeManager = FlowCanvasThemeManager();
///
/// // Add a custom purple theme
/// themeManager.addCustomTheme(
///   'purple',
///   FlowCanvasTheme.fromSeed(
///     seedColor: Colors.purple,
///     brightness: Brightness.light,
///   ),
/// );
///
/// // Use it
/// themeManager.setThemeByName('purple');
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// With FlowCanvasThemeBuilder for automatic rebuilds:
/// ```dart
/// class MyApp extends StatelessWidget {
///   final themeManager = FlowCanvasThemeManager();
///
///   @override
///   Widget build(BuildContext context) {
///     return FlowCanvasThemeBuilder(
///       themeManager: themeManager,
///       builder: (context, theme) {
///         return Column(
///           children: [
///             // Theme switcher
///             DropdownButton<String>(
///               value: themeManager.currentThemeName,
///               items: themeManager.themeNames.map((name) {
///                 return DropdownMenuItem(value: name, child: Text(name));
///               }).toList(),
///               onChanged: (name) => themeManager.setThemeByName(name!),
///             ),
///             // Canvas with current theme
///             Expanded(child: FlowCanvas(...)),
///           ],
///         );
///       },
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// ## Predefined Themes
///
/// The manager includes two predefined themes:
/// - `'light'` - [FlowCanvasTheme.light]
/// - `'dark'` - [FlowCanvasTheme.dark]
///
/// ## Custom Themes
///
/// Add custom themes using [addCustomTheme]. Custom themes can be accessed
/// by name alongside predefined themes. Use [removeCustomTheme] to remove them.
///
/// ## Theme Persistence
///
/// This class doesn't handle persistence directly. To save/load themes:
///
/// ```dart
/// // Save
/// await prefs.setString('theme', themeManager.currentThemeName ?? 'light');
///
/// // Load
/// final themeName = prefs.getString('theme') ?? 'light';
/// themeManager.setThemeByName(themeName);
/// ```
///
/// ## Performance Notes
///
/// - Only notifies listeners when the theme actually changes
/// - Theme comparisons use identity checks for performance
/// - Available themes list is cached and only rebuilt when custom themes change
///
/// See also:
///
///  * [FlowCanvasTheme], the theme being managed
///  * [FlowCanvasThemeBuilder], for automatic rebuilds when theme changes
///  * [FlowCanvasThemeProvider], for providing themes to the widget tree
///  * [ChangeNotifier], the base class for state management
class FlowCanvasThemeManager extends ChangeNotifier with DiagnosticableTreeMixin {
  /// The currently active theme.
  FlowCanvasTheme _currentTheme;

  /// The name of the current theme, if it's a named theme.
  String? _currentThemeName;

  /// Custom themes added by the user.
  final Map<String, FlowCanvasTheme> _customThemes = {};

  /// Cached list of available theme names.
  List<String>? _cachedThemeNames;

  /// Predefined theme instances (cached for performance).
  static final _lightTheme = FlowCanvasTheme.light();
  static final _darkTheme = FlowCanvasTheme.dark();

  /// Creates a theme manager with an optional initial theme.
  ///
  /// If [initialTheme] is not provided, defaults to [FlowCanvasTheme.light].
  /// If [initialThemeName] is provided, that theme will be set if it exists.
  ///
  /// Example:
  /// ```dart
  /// // Start with dark theme
  /// final manager = FlowCanvasThemeManager(FlowCanvasTheme.dark());
  ///
  /// // Start with named theme
  /// final manager = FlowCanvasThemeManager.named('dark');
  /// ```
  FlowCanvasThemeManager([FlowCanvasTheme? initialTheme])
      : _currentTheme = initialTheme ?? _lightTheme {
    // Set the initial theme name if it matches a predefined theme
    _currentThemeName = _determineThemeName(_currentTheme);
  }

  /// Creates a theme manager with a named initial theme.
  ///
  /// If the named theme doesn't exist, falls back to light theme.
  ///
  /// Example:
  /// ```dart
  /// final manager = FlowCanvasThemeManager.named('dark');
  /// ```
  factory FlowCanvasThemeManager.named(String themeName) {
    final manager = FlowCanvasThemeManager();
    manager.setThemeByName(themeName);
    return manager;
  }

  // =========================================================================
  // Getters
  // =========================================================================

  /// The currently active theme.
  ///
  /// Access this to get the current theme for manual theme application:
  /// ```dart
  /// final theme = themeManager.currentTheme;
  /// ```
  FlowCanvasTheme get currentTheme => _currentTheme;

  /// The name of the current theme, if it's a named theme.
  ///
  /// Returns null if the current theme was set directly via [setTheme]
  /// without a corresponding name.
  ///
  /// Useful for displaying the current theme in UI:
  /// ```dart
  /// Text('Current: ${themeManager.currentThemeName ?? "Custom"}');
  /// ```
  String? get currentThemeName => _currentThemeName;

  /// Returns true if the current theme is a light theme.
  ///
  /// Determined by checking if the current theme matches the predefined
  /// light theme or by analyzing the background color brightness.
  bool get isLightTheme {
    if (_currentTheme == _lightTheme) return true;
    if (_currentTheme == _darkTheme) return false;

    // Determine from background color
    final bgColor = _currentTheme.background?.backgroundColor;
    if (bgColor != null) {
      return ThemeData.estimateBrightnessForColor(bgColor) == Brightness.light;
    }

    return true; // Default to light
  }

  /// Returns true if the current theme is a dark theme.
  bool get isDarkTheme => !isLightTheme;

  /// A map of all available themes (predefined + custom).
  ///
  /// This includes:
  /// - 'light': Predefined light theme
  /// - 'dark': Predefined dark theme
  /// - Any custom themes added via [addCustomTheme]
  ///
  /// Note: This returns cached theme instances for performance.
  Map<String, FlowCanvasTheme> get availableThemes => {
        'light': _lightTheme,
        'dark': _darkTheme,
        ..._customThemes,
      };

  /// A list of all available theme names.
  ///
  /// This is cached for performance and only rebuilt when custom themes change.
  ///
  /// Useful for building theme selection UIs:
  /// ```dart
  /// DropdownButton<String>(
  ///   items: themeManager.themeNames.map((name) {
  ///     return DropdownMenuItem(value: name, child: Text(name));
  ///   }).toList(),
  ///   onChanged: (name) => themeManager.setThemeByName(name!),
  /// )
  /// ```
  List<String> get themeNames {
    return _cachedThemeNames ??= availableThemes.keys.toList()..sort();
  }

  /// A list of custom theme names only (excludes predefined themes).
  List<String> get customThemeNames => _customThemes.keys.toList()..sort();

  /// Returns true if a theme with the given [name] exists.
  bool hasTheme(String name) => availableThemes.containsKey(name);

  // =========================================================================
  // Theme Management Methods
  // =========================================================================

  /// Sets the current theme by name.
  ///
  /// Returns true if the theme was found and set, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (themeManager.setThemeByName('dark')) {
  ///   print('Theme changed to dark');
  /// } else {
  ///   print('Theme not found');
  /// }
  /// ```
  bool setThemeByName(String name) {
    final theme = availableThemes[name];
    if (theme != null) {
      _setThemeWithName(theme, name);
      return true;
    }
    return false;
  }

  /// Sets the current theme directly.
  ///
  /// This will update [currentTheme] and notify listeners if the theme changed.
  /// The [currentThemeName] will be set to null unless the theme matches
  /// a known named theme.
  ///
  /// Example:
  /// ```dart
  /// themeManager.setTheme(
  ///   FlowCanvasTheme.fromSeed(
  ///     seedColor: Colors.purple,
  ///     brightness: Brightness.dark,
  ///   ),
  /// );
  /// ```
  void setTheme(FlowCanvasTheme theme) {
    if (identical(_currentTheme, theme)) return;

    _currentTheme = theme;
    _currentThemeName = _determineThemeName(theme);
    notifyListeners();
  }

  /// Sets the theme and associates it with a name.
  void _setThemeWithName(FlowCanvasTheme theme, String name) {
    if (identical(_currentTheme, theme) && _currentThemeName == name) return;

    _currentTheme = theme;
    _currentThemeName = name;
    notifyListeners();
  }

  /// Resets to the default light theme.
  ///
  /// This is equivalent to calling `setThemeByName('light')`.
  void reset() {
    _setThemeWithName(_lightTheme, 'light');
  }

  /// Toggles between light and dark themes.
  ///
  /// If the current theme is light, switches to dark.
  /// If the current theme is dark (or any other theme), switches to light.
  ///
  /// Example:
  /// ```dart
  /// IconButton(
  ///   icon: Icon(
  ///     themeManager.isLightTheme ? Icons.dark_mode : Icons.light_mode,
  ///   ),
  ///   onPressed: () => themeManager.toggleBrightness(),
  /// )
  /// ```
  void toggleBrightness() {
    if (isLightTheme) {
      _setThemeWithName(_darkTheme, 'dark');
    } else {
      _setThemeWithName(_lightTheme, 'light');
    }
  }

  // =========================================================================
  // Custom Theme Management
  // =========================================================================

  /// Adds or updates a custom theme with the given [name].
  ///
  /// If a theme with this name already exists, it will be replaced.
  /// This will clear the theme names cache and notify listeners.
  ///
  /// Example:
  /// ```dart
  /// themeManager.addCustomTheme(
  ///   'purple',
  ///   FlowCanvasTheme.fromSeed(
  ///     seedColor: Colors.purple,
  ///     brightness: Brightness.light,
  ///   ),
  /// );
  /// ```
  void addCustomTheme(String name, FlowCanvasTheme theme) {
    assert(name != 'light' && name != 'dark',
        'Cannot override predefined theme names');

    _customThemes[name] = theme;
    _cachedThemeNames = null; // Clear cache
    notifyListeners();
  }

  /// Removes a custom theme by name.
  ///
  /// Returns true if the theme was found and removed, false otherwise.
  /// Predefined themes ('light' and 'dark') cannot be removed.
  ///
  /// If the removed theme is currently active, the manager will switch
  /// to the light theme.
  ///
  /// Example:
  /// ```dart
  /// if (themeManager.removeCustomTheme('purple')) {
  ///   print('Purple theme removed');
  /// }
  /// ```
  bool removeCustomTheme(String name) {
    assert(name != 'light' && name != 'dark',
        'Cannot remove predefined themes');

    final removed = _customThemes.remove(name) != null;
    if (removed) {
      _cachedThemeNames = null; // Clear cache

      // If we removed the current theme, switch to light
      if (_currentThemeName == name) {
        _setThemeWithName(_lightTheme, 'light');
      } else {
        notifyListeners();
      }
    }
    return removed;
  }

  /// Removes all custom themes.
  ///
  /// Predefined themes ('light' and 'dark') are not affected.
  /// If the current theme is a custom theme, switches to light theme.
  ///
  /// Returns the number of themes removed.
  int clearCustomThemes() {
    final count = _customThemes.length;
    if (count == 0) return 0;

    _customThemes.clear();
    _cachedThemeNames = null; // Clear cache

    // If current theme was custom, switch to light
    if (_currentThemeName != null && 
        _currentThemeName != 'light' && 
        _currentThemeName != 'dark') {
      _setThemeWithName(_lightTheme, 'light');
    } else {
      notifyListeners();
    }

    return count;
  }

  // =========================================================================
  // Helper Methods
  // =========================================================================

  /// Determines the name of a theme by comparing it to known themes.
  ///
  /// Returns the theme name if it matches a known theme, null otherwise.
  String? _determineThemeName(FlowCanvasTheme theme) {
    if (identical(theme, _lightTheme)) return 'light';
    if (identical(theme, _darkTheme)) return 'dark';

    // Check custom themes
    for (final entry in _customThemes.entries) {
      if (identical(theme, entry.value)) return entry.key;
    }

    return null;
  }

  // =========================================================================
  // Debug Support
  // =========================================================================

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FlowCanvasTheme>(
      'currentTheme',
      _currentTheme,
    ));
    properties.add(StringProperty('currentThemeName', _currentThemeName));
    properties.add(FlagProperty(
      'brightness',
      value: isLightTheme,
      ifTrue: 'light',
      ifFalse: 'dark',
    ));
    properties.add(IntProperty('customThemes', _customThemes.length));
    properties.add(IterableProperty<String>(
      'availableThemes',
      themeNames,
    ));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FlowCanvasThemeManager('
        'current: ${_currentThemeName ?? "custom"}, '
        'themes: ${themeNames.length})';
  }
}
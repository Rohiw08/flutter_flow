import 'package:flutter/material.dart';
import 'package:flow_canvas/src/features/canvas/presentation/theme/flow_theme.dart';

class FlowCanvasThemeManager extends ChangeNotifier {
  FlowCanvasTheme _currentTheme;
  final Map<String, FlowCanvasTheme> _customThemes = {};

  FlowCanvasThemeManager([FlowCanvasTheme? initialTheme])
      : _currentTheme = initialTheme ?? FlowCanvasTheme.light();

  FlowCanvasTheme get currentTheme => _currentTheme;

  /// Available predefined themes
  Map<String, FlowCanvasTheme> get availableThemes => {
        'light': FlowCanvasTheme.light(),
        'dark': FlowCanvasTheme.dark(),
        ..._customThemes,
      };

  /// Set theme by name
  bool setThemeByName(String name) {
    final theme = availableThemes[name];
    if (theme != null) {
      setTheme(theme);
      return true;
    }
    return false;
  }

  /// Set theme directly
  void setTheme(FlowCanvasTheme theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  /// Add custom theme
  void addCustomTheme(String name, FlowCanvasTheme theme) {
    _customThemes[name] = theme;
    notifyListeners();
  }

  /// Remove custom theme
  bool removeCustomTheme(String name) {
    final removed = _customThemes.remove(name) != null;
    if (removed) {
      notifyListeners();
    }
    return removed;
  }

  /// Toggle between light and dark themes
  void toggleBrightness() {
    if (_currentTheme == FlowCanvasTheme.light()) {
      setTheme(FlowCanvasTheme.dark());
    } else {
      setTheme(FlowCanvasTheme.light());
    }
  }
}

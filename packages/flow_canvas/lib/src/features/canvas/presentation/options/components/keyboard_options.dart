import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../../../../shared/enums.dart';

/// Configuration options for keyboard interactions in the flow canvas
class KeyboardOptions {
  final bool enabled;
  final double arrowKeyMoveSpeed;
  final double zoomStep;
  final Map<ShortcutActivator, KeyboardAction> shortcuts;

  /// A const constructor with a default empty map for shortcuts.
  const KeyboardOptions({
    this.enabled = true,
    this.arrowKeyMoveSpeed = 10.0,
    this.zoomStep = 0.1,
    this.shortcuts = const {},
  });

  /// A factory that creates KeyboardOptions with default, platform-aware shortcuts.
  factory KeyboardOptions.withDefaults({
    bool enabled = true,
    double arrowKeyMoveSpeed = 10.0,
    double zoomStep = 0.1,
  }) {
    return KeyboardOptions(
      enabled: enabled,
      arrowKeyMoveSpeed: arrowKeyMoveSpeed,
      zoomStep: zoomStep,
      shortcuts: _getDefaultShortcuts(),
    );
  }

  // Helper method to create default, platform-aware shortcuts
  static Map<ShortcutActivator, KeyboardAction> _getDefaultShortcuts() {
    final isMac = defaultTargetPlatform == TargetPlatform.macOS;

    return {
      // Selection
      SingleActivator(LogicalKeyboardKey.keyA, control: !isMac, meta: isMac):
          KeyboardAction.selectAll,
      const SingleActivator(LogicalKeyboardKey.escape):
          KeyboardAction.deselectAll,

      // Deletion
      const SingleActivator(LogicalKeyboardKey.delete):
          KeyboardAction.deleteSelection,
      const SingleActivator(LogicalKeyboardKey.backspace):
          KeyboardAction.deleteSelection,

      // Navigation
      const SingleActivator(LogicalKeyboardKey.arrowUp): KeyboardAction.moveUp,
      const SingleActivator(LogicalKeyboardKey.arrowDown):
          KeyboardAction.moveDown,
      const SingleActivator(LogicalKeyboardKey.arrowLeft):
          KeyboardAction.moveLeft,
      const SingleActivator(LogicalKeyboardKey.arrowRight):
          KeyboardAction.moveRight,

      // Zoom
      SingleActivator(LogicalKeyboardKey.equal, control: !isMac, meta: isMac):
          KeyboardAction.zoomIn,
      SingleActivator(LogicalKeyboardKey.minus, control: !isMac, meta: isMac):
          KeyboardAction.zoomOut,
      SingleActivator(LogicalKeyboardKey.digit0, control: !isMac, meta: isMac):
          KeyboardAction.resetZoom,

      // Duplication
      SingleActivator(LogicalKeyboardKey.keyD, control: !isMac, meta: isMac):
          KeyboardAction.duplicateSelection,

      // Undo/Redo
      SingleActivator(LogicalKeyboardKey.keyZ, control: !isMac, meta: isMac):
          KeyboardAction.undo,
      SingleActivator(LogicalKeyboardKey.keyZ,
          control: !isMac, meta: isMac, shift: true): KeyboardAction.redo,
      // Common alternative for redo
      SingleActivator(LogicalKeyboardKey.keyY, control: !isMac, meta: isMac):
          KeyboardAction.redo,
    };
  }

  KeyboardOptions copyWith({
    bool? enabled,
    double? arrowKeyMoveSpeed,
    double? zoomStep,
    Map<ShortcutActivator, KeyboardAction>? shortcuts,
  }) {
    return KeyboardOptions(
      enabled: enabled ?? this.enabled,
      arrowKeyMoveSpeed: arrowKeyMoveSpeed ?? this.arrowKeyMoveSpeed,
      zoomStep: zoomStep ?? this.zoomStep,
      shortcuts: shortcuts ?? this.shortcuts,
    );
  }

  @override
  bool operator ==(covariant KeyboardOptions other) {
    if (identical(this, other)) return true;

    return other.enabled == enabled &&
        other.arrowKeyMoveSpeed == arrowKeyMoveSpeed &&
        other.zoomStep == zoomStep &&
        mapEquals(other.shortcuts, shortcuts);
  }

  @override
  int get hashCode {
    return Object.hash(
      enabled,
      arrowKeyMoveSpeed,
      zoomStep,
      shortcuts,
    );
  }
}

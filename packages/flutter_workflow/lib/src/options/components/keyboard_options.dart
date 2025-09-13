import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// It's good practice to define enums for actions rather than using strings.
// Assuming you have an enum like this somewhere in your project:
enum KeyboardAction {
  selectAll,
  deselectAll,
  deleteSelection,
  moveUp,
  moveDown,
  moveLeft,
  moveRight,
  zoomIn,
  zoomOut,
  resetZoom,
  duplicateSelection,
  undo,
  redo,
}

/// Configuration options for keyboard interactions in the flow canvas
class KeyboardOptions {
  final bool enabled;
  final bool enableMultiSelection;
  final bool enableArrowKeyNavigation;
  final bool enableZoomShortcuts;
  final bool enableDuplication;
  final double arrowKeyMoveSpeed;
  final double zoomStep;
  final Map<LogicalKeyboardKey, KeyboardAction> shortcuts;

  const KeyboardOptions._({
    this.enabled = true,
    this.enableMultiSelection = true,
    this.enableArrowKeyNavigation = true,
    this.enableZoomShortcuts = true,
    this.enableDuplication = true,
    this.arrowKeyMoveSpeed = 10.0,
    this.zoomStep = 0.1,
    required this.shortcuts,
  });

  // Factory constructor that creates the default shortcuts
  factory KeyboardOptions({
    bool enabled = true,
    bool enableMultiSelection = true,
    bool enableArrowKeyNavigation = true,
    bool enableZoomShortcuts = true,
    bool enableDuplication = true,
    double arrowKeyMoveSpeed = 10.0,
    double zoomStep = 0.1,
    Map<LogicalKeyboardKey, KeyboardAction>? shortcuts,
  }) {
    return KeyboardOptions._(
      enabled: enabled,
      enableMultiSelection: enableMultiSelection,
      enableArrowKeyNavigation: enableArrowKeyNavigation,
      enableZoomShortcuts: enableZoomShortcuts,
      enableDuplication: enableDuplication,
      arrowKeyMoveSpeed: arrowKeyMoveSpeed,
      zoomStep: zoomStep,
      shortcuts: shortcuts ?? _getDefaultShortcuts(),
    );
  }

  // Helper method to create default shortcuts
  static Map<LogicalKeyboardKey, KeyboardAction> _getDefaultShortcuts() {
    return {
      // Selection
      LogicalKeyboardKey.keyA: KeyboardAction.selectAll,
      LogicalKeyboardKey.escape: KeyboardAction.deselectAll,

      // Deletion
      LogicalKeyboardKey.delete: KeyboardAction.deleteSelection,
      LogicalKeyboardKey.backspace: KeyboardAction.deleteSelection,

      // Navigation
      LogicalKeyboardKey.arrowUp: KeyboardAction.moveUp,
      LogicalKeyboardKey.arrowDown: KeyboardAction.moveDown,
      LogicalKeyboardKey.arrowLeft: KeyboardAction.moveLeft,
      LogicalKeyboardKey.arrowRight: KeyboardAction.moveRight,

      // Zoom
      LogicalKeyboardKey.equal: KeyboardAction.zoomIn,
      LogicalKeyboardKey.minus: KeyboardAction.zoomOut,
      LogicalKeyboardKey.digit0: KeyboardAction.resetZoom,

      // Duplication
      LogicalKeyboardKey.keyD: KeyboardAction.duplicateSelection,

      // Undo/Redo
      LogicalKeyboardKey.keyZ: KeyboardAction.undo,
      LogicalKeyboardKey.keyY: KeyboardAction.redo,
    };
  }

  KeyboardOptions copyWith({
    bool? enabled,
    bool? enableMultiSelection,
    bool? enableArrowKeyNavigation,
    bool? enableZoomShortcuts,
    bool? enableDuplication,
    double? arrowKeyMoveSpeed,
    double? zoomStep,
    Map<LogicalKeyboardKey, KeyboardAction>? shortcuts,
  }) {
    return KeyboardOptions._(
      enabled: enabled ?? this.enabled,
      enableMultiSelection: enableMultiSelection ?? this.enableMultiSelection,
      enableArrowKeyNavigation:
          enableArrowKeyNavigation ?? this.enableArrowKeyNavigation,
      enableZoomShortcuts: enableZoomShortcuts ?? this.enableZoomShortcuts,
      enableDuplication: enableDuplication ?? this.enableDuplication,
      arrowKeyMoveSpeed: arrowKeyMoveSpeed ?? this.arrowKeyMoveSpeed,
      zoomStep: zoomStep ?? this.zoomStep,
      shortcuts: shortcuts ?? this.shortcuts,
    );
  }

  @override
  bool operator ==(covariant KeyboardOptions other) {
    if (identical(this, other)) return true;

    return other.enabled == enabled &&
        other.enableMultiSelection == enableMultiSelection &&
        other.enableArrowKeyNavigation == enableArrowKeyNavigation &&
        other.enableZoomShortcuts == enableZoomShortcuts &&
        other.enableDuplication == enableDuplication &&
        other.arrowKeyMoveSpeed == arrowKeyMoveSpeed &&
        other.zoomStep == zoomStep &&
        mapEquals(other.shortcuts, shortcuts);
  }

  @override
  int get hashCode {
    return Object.hash(
      enabled,
      enableMultiSelection,
      enableArrowKeyNavigation,
      enableZoomShortcuts,
      enableDuplication,
      arrowKeyMoveSpeed,
      zoomStep,
      shortcuts,
    );
  }
}

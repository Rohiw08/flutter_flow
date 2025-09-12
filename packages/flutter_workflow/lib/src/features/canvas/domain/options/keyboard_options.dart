// import 'package:flutter/services.dart';
// import 'package:flutter_workflow/src/shared/enums.dart';

// /// Configuration options for keyboard interactions in the flow canvas
// class KeyboardOptions {
//   final bool enabled;
//   final bool enableMultiSelection;
//   final bool enableArrowKeyNavigation;
//   final bool enableZoomShortcuts;
//   final bool enableDuplication;
//   final double arrowKeyMoveSpeed;
//   final double zoomStep;
//   final Map<LogicalKeyboardKey, KeyboardAction> shortcuts;

//   // The 'const' keyword has been removed from the constructor
//   KeyboardOptions({
//     this.enabled = true,
//     this.enableMultiSelection = true,
//     this.enableArrowKeyNavigation = true,
//     this.enableZoomShortcuts = true,
//     this.enableDuplication = true,
//     this.arrowKeyMoveSpeed = 10.0,
//     this.zoomStep = 0.1,
//     // The 'const' keyword has been removed from the default map
//     this.shortcuts = const {
//       // Selection
//       LogicalKeyboardKey.keyA: KeyboardAction.selectAll,
//       LogicalKeyboardKey.escape: KeyboardAction.deselectAll,

//       // Deletion
//       LogicalKeyboardKey.delete: KeyboardAction.deleteSelection,
//       LogicalKeyboardKey.backspace: KeyboardAction.deleteSelection,

//       // Navigation
//       LogicalKeyboardKey.arrowUp: KeyboardAction.moveUp,
//       LogicalKeyboardKey.arrowDown: KeyboardAction.moveDown,
//       LogicalKeyboardKey.arrowLeft: KeyboardAction.moveLeft,
//       LogicalKeyboardKey.arrowRight: KeyboardAction.moveRight,

//       // Zoom
//       LogicalKeyboardKey.equal: KeyboardAction.zoomIn,
//       LogicalKeyboardKey.minus: KeyboardAction.zoomOut,
//       LogicalKeyboardKey.digit0: KeyboardAction.resetZoom,

//       // Duplication
//       LogicalKeyboardKey.keyD: KeyboardAction.duplicateSelection,

//       // Undo/Redo
//       LogicalKeyboardKey.keyZ: KeyboardAction.undo,
//       LogicalKeyboardKey.keyY: KeyboardAction.redo,
//     },
//   });

//   KeyboardOptions copyWith({
//     bool? enabled,
//     bool? enableMultiSelection,
//     bool? enableArrowKeyNavigation,
//     bool? enableZoomShortcuts,
//     bool? enableDuplication,
//     double? arrowKeyMoveSpeed,
//     double? zoomStep,
//     Map<LogicalKeyboardKey, KeyboardAction>? shortcuts,
//   }) {
//     return KeyboardOptions(
//       enabled: enabled ?? this.enabled,
//       enableMultiSelection: enableMultiSelection ?? this.enableMultiSelection,
//       enableArrowKeyNavigation:
//           enableArrowKeyNavigation ?? this.enableArrowKeyNavigation,
//       enableZoomShortcuts: enableZoomShortcuts ?? this.enableZoomShortcuts,
//       enableDuplication: enableDuplication ?? this.enableDuplication,
//       arrowKeyMoveSpeed: arrowKeyMoveSpeed ?? this.arrowKeyMoveSpeed,
//       zoomStep: zoomStep ?? this.zoomStep,
//       shortcuts: shortcuts ?? this.shortcuts,
//     );
//   }

//   @override
//   bool operator ==(covariant KeyboardOptions other) {
//     if (identical(this, other)) return true;

//     return other.enabled == enabled &&
//         other.enableMultiSelection == enableMultiSelection &&
//         other.enableArrowKeyNavigation == enableArrowKeyNavigation &&
//         other.enableZoomShortcuts == enableZoomShortcuts &&
//         other.enableDuplication == enableDuplication &&
//         other.arrowKeyMoveSpeed == arrowKeyMoveSpeed &&
//         other.zoomStep == zoomStep &&
//         mapEquals(other.shortcuts, shortcuts);
//   }

//   @override
//   int get hashCode {
//     return enabled.hashCode ^
//         enableMultiSelection.hashCode ^
//         enableArrowKeyNavigation.hashCode ^
//         enableZoomShortcuts.hashCode ^
//         enableDuplication.hashCode ^
//         arrowKeyMoveSpeed.hashCode ^
//         zoomStep.hashCode ^
//         shortcuts.hashCode;
//   }
// }

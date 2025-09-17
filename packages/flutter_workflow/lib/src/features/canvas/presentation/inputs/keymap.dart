import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'intent_actions.dart';

class Keymap {
  final Map<LogicalKeySet, Intent> shortcuts;

  const Keymap(this.shortcuts);

  factory Keymap.standard() {
    return Keymap({
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.equal):
          const ZoomInIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.minus):
          const ZoomOutIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
          const FitViewIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC):
          const CopyIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV):
          const PasteIntent(),
      LogicalKeySet(LogicalKeyboardKey.delete): const DeleteIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ):
          const UndoIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyY):
          const RedoIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
          const SelectAllIntent(),
    });
  }
}

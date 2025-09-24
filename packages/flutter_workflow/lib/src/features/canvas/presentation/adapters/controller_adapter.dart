import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workflow/src/features/canvas/application/flow_canvas_controller.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/flow_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/inputs/intent_actions.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/inputs/keymap.dart';

class KeyboardAdapter extends StatelessWidget {
  final FlowCanvasController controller;
  final FlowOptions options;
  final Keymap keymap;
  final Widget child;

  const KeyboardAdapter({
    super.key,
    required this.controller,
    required this.options,
    required this.keymap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Map<LogicalKeySet, Intent> shortcuts = keymap.shortcuts;
    final Map<Type, Action<Intent>> actions = buildActions(controller, options);

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            final kb = options.keyboardOptions;
            if (!kb.enabled) return KeyEventResult.ignored;

            // Find matching activator
            ShortcutActivator? matched;
            for (final activator in kb.shortcuts.keys) {
              if (activator.accepts(event, HardwareKeyboard.instance)) {
                matched = activator;
                break;
              }
            }
            if (matched == null) return KeyEventResult.ignored;
            final mapped = kb.shortcuts[matched];
            if (mapped == null) return KeyEventResult.ignored;

            controller.handleKeyboardAction(
              mapped,
              options: kb,
              minZoom: options.viewportOptions.minZoom,
              maxZoom: options.viewportOptions.maxZoom,
            );
            return KeyEventResult.handled;
          },
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/flow_options.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/inputs/intent_actions.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/inputs/keymap.dart';

class FlowFacadeProvider extends InheritedWidget {
  final FlowCanvasFacade facade;

  const FlowFacadeProvider({
    super.key,
    required this.facade,
    required super.child,
  });

  static FlowCanvasFacade of(BuildContext context) {
    final FlowFacadeProvider? provider =
        context.dependOnInheritedWidgetOfExactType<FlowFacadeProvider>();
    assert(provider != null, 'FlowFacadeProvider not found in context');
    return provider!.facade;
  }

  @override
  bool updateShouldNotify(covariant FlowFacadeProvider oldWidget) =>
      oldWidget.facade != facade;
}

class KeyboardAdapter extends StatelessWidget {
  final FlowCanvasFacade facade;
  final FlowOptions options;
  final Keymap keymap;
  final Widget child;

  const KeyboardAdapter({
    super.key,
    required this.facade,
    required this.options,
    required this.keymap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Map<LogicalKeySet, Intent> shortcuts = keymap.shortcuts;
    final Map<Type, Action<Intent>> actions = buildActions(facade, options);

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}

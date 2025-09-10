import 'package:flutter/foundation.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/painters/flow_painter.dart'
    show EdgePainter;

/// A registry for managing custom edge painters provided by the user.
///
/// An instance of this class is passed to the FlowCanvasController to make
/// custom edge types available to the canvas painter.
class EdgeRegistry {
  final Map<String, EdgePainter> _painters = {};

  void register(String type, EdgePainter painter) {
    if (type.trim().isEmpty) {
      throw ArgumentError('Edge type cannot be empty or whitespace');
    }
    _painters[type] = painter;
  }

  EdgePainter? getPainter(String? type) {
    if (type == null || type.isEmpty) {
      return null;
    }
    final painter = _painters[type];
    if (painter == null) {
      debugPrint('Warning: No painter registered for edge type "$type"');
    }
    return painter;
  }

  bool unregister(String type) {
    if (type.isEmpty) return false;
    return _painters.remove(type) != null;
  }

  bool isRegistered(String type) {
    return type.isNotEmpty && _painters.containsKey(type);
  }

  void clear() {
    _painters.clear();
  }
}

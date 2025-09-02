import 'package:flutter/foundation.dart';
import '../models/edge_painter.dart';

/// A registry for managing custom edge painters provided by the user.
///
/// An instance of this class is passed to the FlowCanvasController to make
/// custom edge types available to the canvas painter.
class EdgeRegistry {
  final Map<String, EdgePainter> _painters = {};

  /// Registers a custom edge type with its painter.
  void register(String type, EdgePainter painter) {
    if (type.trim().isEmpty) {
      throw ArgumentError('Edge type cannot be empty or whitespace');
    }
    _painters[type] = painter;
  }

  /// Retrieves the painter for a given edge type.
  /// Returns null if the type is not registered, allowing for a default fallback.
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

  /// Unregisters a custom edge type.
  bool unregister(String type) {
    if (type.isEmpty) return false;
    return _painters.remove(type) != null;
  }

  /// Checks if an edge type is registered.
  bool isRegistered(String type) {
    return type.isNotEmpty && _painters.containsKey(type);
  }

  /// Clears all registered edge types.
  void clear() {
    _painters.clear();
  }
}

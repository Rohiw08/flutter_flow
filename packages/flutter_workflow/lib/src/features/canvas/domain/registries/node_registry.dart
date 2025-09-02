import 'package:flutter/material.dart';
import '../models/node.dart';

typedef NodeWidgetBuilder = Widget Function(FlowNode node);

/// A registry for managing node widget builders provided by the user.
///
/// An instance of this class is passed to the FlowCanvasController to make
/// node types available to the canvas.
class NodeRegistry {
  final Map<String, NodeWidgetBuilder> _builders = {};

  /// Register a node type with its widget builder.
  void register(String type, NodeWidgetBuilder builder) {
    if (type.trim().isEmpty) {
      throw ArgumentError('Node type cannot be empty or whitespace');
    }
    _builders[type] = builder;
  }

  /// Build a widget for a given node based on its type.
  /// If the type is not registered, it returns a visible error widget.
  Widget buildWidget(FlowNode node) {
    final builder = _builders[node.type];
    if (builder == null) {
      debugPrint(
          'Error: No widget builder registered for node type "${node.type}"');
      return _buildErrorWidget(node.size, node.type);
    }
    return builder.call(node);
  }

  /// Unregister a node type.
  bool unregister(String type) {
    if (type.isEmpty) return false;
    return _builders.remove(type) != null;
  }

  /// Check if a node type is registered.
  bool isRegistered(String type) {
    return _builders.containsKey(type);
  }

  /// Clear all registered types.
  void clear() {
    _builders.clear();
  }

  /// Returns a default error widget to display when a node type is not found.
  Widget _buildErrorWidget(Size size, String type) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        color: Colors.red.withAlpha(25),
      ),
      child: Center(
        child: Text(
          'Missing Node Type:\n"$type"',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 10),
        ),
      ),
    );
  }
}

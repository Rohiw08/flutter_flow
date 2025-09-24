import 'package:flutter/material.dart';
import '../models/node.dart';
import '../../presentation/widgets/default_node_widget.dart';

typedef NodeWidgetBuilder = Widget Function(FlowNode node);

/// A registry for managing node widget builders provided by the user.
///
/// An instance of this class is passed to the FlowCanvasController to make
/// node types available to the canvas. If no builder is registered for a node type,
/// it will fall back to the default node widget that uses FlowNodeStyle.
class NodeRegistry {
  final Map<String, NodeWidgetBuilder> _builders = {};

  void register(String type, NodeWidgetBuilder builder) {
    assert(type.isNotEmpty, 'Node type cannot be empty');
    assert(!_builders.containsKey(type), 'Node type  already registered');
    _builders[type] = builder;
  }

  Widget buildWidget(FlowNode node) {
    final builder = _builders[node.type];
    if (builder == null) {
      // Use default node widget instead of showing error
      return buildDefaultNode(node);
    }
    return builder.call(node);
  }

  bool unregister(String type) {
    if (type.isEmpty) return false;
    return _builders.remove(type) != null;
  }

  bool isRegistered(String type) {
    return _builders.containsKey(type);
  }

  void clear() {
    _builders.clear();
  }

  /// Register default node types that match React Flow
  void registerDefaultTypes() {
    register('default', buildDefaultNode);
    register('input', buildInputNode);
    register('output', buildOutputNode);
  }

  /// Build error widget for debugging purposes
  Widget buildErrorWidget(Size size, String type) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        color: Colors.red.withAlpha(25),
      ),
      child: Center(
        child: Text(
          'Missing Node Type:\n""',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 10),
        ),
      ),
    );
  }
}

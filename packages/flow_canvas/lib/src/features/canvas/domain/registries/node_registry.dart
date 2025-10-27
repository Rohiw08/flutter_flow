import 'package:flutter/material.dart';
import '../models/node.dart';
import '../../presentation/widgets/flow_node.dart';

typedef NodeWidgetBuilder = Widget Function(FlowNode node);

/// A registry for mapping FlowNode types to widget builders.
///
/// Used by [FlowCanvasController] to resolve node visual widgets
/// dynamically based on node type.
///
/// If no builder is registered for a given type, it uses
/// the default node widget ([buildDefaultNode]).
///
/// ## Usage:
///
/// ```
/// final registry = NodeRegistry()
///   ..register('input', (node) => InputNodeWidget(node))
///   ..register('custom', (node) => CustomNode(node));
///
/// final widget = registry.buildWidget(flowNode);
/// ```
class NodeRegistry {
  final Map<String, NodeWidgetBuilder> _builders;

  /// Creates a registry with default node types registered.
  NodeRegistry() : _builders = {} {
    _registerDefaultTypes();
  }

  /// Creates an empty registry with no default node types.
  NodeRegistry.empty() : _builders = {};

  /// Registers a new node type.
  ///
  /// If a type already exists, this will overwrite its builder.
  void register(String type, NodeWidgetBuilder builder) {
    assert(type.isNotEmpty, 'Node type cannot be empty');
    _builders[type] = builder;
  }

  /// Unregisters a node type by its string key.
  ///
  /// Returns true if a type was removed.
  bool unregister(String type) =>
      type.isNotEmpty && _builders.remove(type) != null;

  /// Checks whether a type is registered.
  bool isRegistered(String type) => _builders.containsKey(type);

  /// Removes all registered node types.
  void clear() => _builders.clear();

  /// Resolves a widget for a given FlowNode.
  ///
  /// Falls back to [buildDefaultNode] if no builder is found.
  Widget buildWidget(FlowNode node) =>
      _builders[node.type]?.call(node) ?? buildDefaultNode(node);

  /// Registers the built-in/default node types.
  void _registerDefaultTypes() {
    register('default', buildDefaultNode);
  }

  /// Returns an immutable copy of the current registered type map.
  Map<String, NodeWidgetBuilder> get builders => Map.unmodifiable(_builders);

  /// Builds a red-outlined error widget for debugging missing node types.
  Widget buildErrorWidget(Size size, String type) => Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          color: Colors.red.withAlpha(25),
        ),
        child: Center(
          child: Text(
            'Unregistered node type:\n"$type"',
            style: const TextStyle(color: Colors.red, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ),
      );
}

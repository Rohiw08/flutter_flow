import 'package:flutter/foundation.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/edge.dart';
import 'package:flutter_workflow/src/shared/enums.dart';

import '../../presentation/theme/components/edge_marker_theme.dart';
import '../../presentation/theme/components/edge_theme.dart';

/// A registry for managing custom edge types and their configurations.
///
/// This registry allows users to register custom edge types with specific
/// configurations like default path types, styles, and behaviors.
class EdgeRegistry {
  final Map<String, EdgeTypeConfig> _edgeTypes = {};

  /// Register a custom edge type with its configuration.
  void register(String type, EdgeTypeConfig config) {
    if (type.trim().isEmpty) {
      throw ArgumentError('Edge type cannot be empty or whitespace');
    }
    _edgeTypes[type] = config;
  }

  /// Get the configuration for a specific edge type.
  EdgeTypeConfig? getConfig(String? type) {
    if (type == null || type.isEmpty) {
      return null;
    }
    final config = _edgeTypes[type];
    if (config == null) {
      debugPrint('Warning: No configuration registered for edge type "$type"');
    }
    return config;
  }

  /// Check if an edge type is registered.
  bool isRegistered(String type) {
    return type.isNotEmpty && _edgeTypes.containsKey(type);
  }

  /// Unregister an edge type.
  bool unregister(String type) {
    if (type.isEmpty) return false;
    return _edgeTypes.remove(type) != null;
  }

  /// Clear all registered edge types.
  void clear() {
    _edgeTypes.clear();
  }

  /// Get all registered edge types.
  List<String> get registeredTypes => _edgeTypes.keys.toList();

  /// Create a FlowEdge with the registered configuration for the given type.
  FlowEdge createEdge({
    required String id,
    required String sourceNodeId,
    required String targetNodeId,
    required String? sourceHandleId,
    required String? targetHandleId,
    String? type,
    Map<String, dynamic>? data,
  }) {
    final config = getConfig(type);

    return FlowEdge(
      id: id,
      sourceNodeId: sourceNodeId,
      targetNodeId: targetNodeId,
      sourceHandleId: sourceHandleId,
      targetHandleId: targetHandleId,
      pathType: config?.defaultPathType ?? EdgePathType.bezier,
      style: config?.defaultStyle,
      startMarkerStyle: config?.defaultStartMarker,
      endMarkerStyle: config?.defaultEndMarker,
      data: data ?? config?.defaultData ?? {},
      animated: config?.defaultAnimated,
      deletable: config?.defaultDeletable,
      selectable: config?.defaultSelectable,
      focusable: config?.defaultFocusable,
      reconnectable: config?.defaultReconnectable,
    );
  }
}

/// Configuration for a custom edge type.
class EdgeTypeConfig {
  final EdgePathType defaultPathType;
  final FlowEdgeStyle? defaultStyle;
  final FlowEdgeMarkerStyle? defaultStartMarker;
  final FlowEdgeMarkerStyle? defaultEndMarker;
  final Map<String, dynamic> defaultData;
  final bool? defaultAnimated;
  final bool? defaultDeletable;
  final bool? defaultSelectable;
  final bool? defaultFocusable;
  final bool? defaultReconnectable;

  const EdgeTypeConfig({
    this.defaultPathType = EdgePathType.bezier,
    this.defaultStyle,
    this.defaultStartMarker,
    this.defaultEndMarker,
    this.defaultData = const {},
    this.defaultAnimated,
    this.defaultDeletable,
    this.defaultSelectable,
    this.defaultFocusable,
    this.defaultReconnectable,
  });
}

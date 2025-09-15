// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flow_canvas_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlowCanvasState {
// Core data
  Map<String, FlowNode> get nodes;
  Map<String, FlowEdge> get edges;
  Map<String, NodeRuntimeState> get nodeStates;
  Map<String, EdgeRuntimeState> get edgeStates;
  Set<String> get selectedNodes;
  Set<String> get selectedEdges;
  Map<String, Set<String>> get spatialHash; // Edge indexing
  EdgeIndex get edgeIndex;
  NodeIndex get nodeIndex; // Z-index management
  int get minZIndex;
  int get maxZIndex; // Viewport state
  bool get isPanZoomLocked;
  FlowViewport get viewport;
  Size? get viewportSize; // Interaction state
  FlowConnection? get connection;
  FlowConnectionRuntimeState? get connectionState;
  Rect? get selectionRect;
  DragMode get dragMode;

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlowCanvasStateCopyWith<FlowCanvasState> get copyWith =>
      _$FlowCanvasStateCopyWithImpl<FlowCanvasState>(
          this as FlowCanvasState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlowCanvasState &&
            const DeepCollectionEquality().equals(other.nodes, nodes) &&
            const DeepCollectionEquality().equals(other.edges, edges) &&
            const DeepCollectionEquality()
                .equals(other.nodeStates, nodeStates) &&
            const DeepCollectionEquality()
                .equals(other.edgeStates, edgeStates) &&
            const DeepCollectionEquality()
                .equals(other.selectedNodes, selectedNodes) &&
            const DeepCollectionEquality()
                .equals(other.selectedEdges, selectedEdges) &&
            const DeepCollectionEquality()
                .equals(other.spatialHash, spatialHash) &&
            (identical(other.edgeIndex, edgeIndex) ||
                other.edgeIndex == edgeIndex) &&
            (identical(other.nodeIndex, nodeIndex) ||
                other.nodeIndex == nodeIndex) &&
            (identical(other.minZIndex, minZIndex) ||
                other.minZIndex == minZIndex) &&
            (identical(other.maxZIndex, maxZIndex) ||
                other.maxZIndex == maxZIndex) &&
            (identical(other.isPanZoomLocked, isPanZoomLocked) ||
                other.isPanZoomLocked == isPanZoomLocked) &&
            (identical(other.viewport, viewport) ||
                other.viewport == viewport) &&
            (identical(other.viewportSize, viewportSize) ||
                other.viewportSize == viewportSize) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            (identical(other.connectionState, connectionState) ||
                other.connectionState == connectionState) &&
            (identical(other.selectionRect, selectionRect) ||
                other.selectionRect == selectionRect) &&
            (identical(other.dragMode, dragMode) ||
                other.dragMode == dragMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(nodes),
      const DeepCollectionEquality().hash(edges),
      const DeepCollectionEquality().hash(nodeStates),
      const DeepCollectionEquality().hash(edgeStates),
      const DeepCollectionEquality().hash(selectedNodes),
      const DeepCollectionEquality().hash(selectedEdges),
      const DeepCollectionEquality().hash(spatialHash),
      edgeIndex,
      nodeIndex,
      minZIndex,
      maxZIndex,
      isPanZoomLocked,
      viewport,
      viewportSize,
      connection,
      connectionState,
      selectionRect,
      dragMode);

  @override
  String toString() {
    return 'FlowCanvasState(nodes: $nodes, edges: $edges, nodeStates: $nodeStates, edgeStates: $edgeStates, selectedNodes: $selectedNodes, selectedEdges: $selectedEdges, spatialHash: $spatialHash, edgeIndex: $edgeIndex, nodeIndex: $nodeIndex, minZIndex: $minZIndex, maxZIndex: $maxZIndex, isPanZoomLocked: $isPanZoomLocked, viewport: $viewport, viewportSize: $viewportSize, connection: $connection, connectionState: $connectionState, selectionRect: $selectionRect, dragMode: $dragMode)';
  }
}

/// @nodoc
abstract mixin class $FlowCanvasStateCopyWith<$Res> {
  factory $FlowCanvasStateCopyWith(
          FlowCanvasState value, $Res Function(FlowCanvasState) _then) =
      _$FlowCanvasStateCopyWithImpl;
  @useResult
  $Res call(
      {Map<String, FlowNode> nodes,
      Map<String, FlowEdge> edges,
      Map<String, NodeRuntimeState> nodeStates,
      Map<String, EdgeRuntimeState> edgeStates,
      Set<String> selectedNodes,
      Set<String> selectedEdges,
      Map<String, Set<String>> spatialHash,
      EdgeIndex edgeIndex,
      NodeIndex nodeIndex,
      int minZIndex,
      int maxZIndex,
      bool isPanZoomLocked,
      FlowViewport viewport,
      Size? viewportSize,
      FlowConnection? connection,
      FlowConnectionRuntimeState? connectionState,
      Rect? selectionRect,
      DragMode dragMode});

  $FlowViewportCopyWith<$Res> get viewport;
  $FlowConnectionCopyWith<$Res>? get connection;
  $FlowConnectionRuntimeStateCopyWith<$Res>? get connectionState;
}

/// @nodoc
class _$FlowCanvasStateCopyWithImpl<$Res>
    implements $FlowCanvasStateCopyWith<$Res> {
  _$FlowCanvasStateCopyWithImpl(this._self, this._then);

  final FlowCanvasState _self;
  final $Res Function(FlowCanvasState) _then;

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodes = null,
    Object? edges = null,
    Object? nodeStates = null,
    Object? edgeStates = null,
    Object? selectedNodes = null,
    Object? selectedEdges = null,
    Object? spatialHash = null,
    Object? edgeIndex = null,
    Object? nodeIndex = null,
    Object? minZIndex = null,
    Object? maxZIndex = null,
    Object? isPanZoomLocked = null,
    Object? viewport = null,
    Object? viewportSize = freezed,
    Object? connection = freezed,
    Object? connectionState = freezed,
    Object? selectionRect = freezed,
    Object? dragMode = null,
  }) {
    return _then(_self.copyWith(
      nodes: null == nodes
          ? _self.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as Map<String, FlowNode>,
      edges: null == edges
          ? _self.edges
          : edges // ignore: cast_nullable_to_non_nullable
              as Map<String, FlowEdge>,
      nodeStates: null == nodeStates
          ? _self.nodeStates
          : nodeStates // ignore: cast_nullable_to_non_nullable
              as Map<String, NodeRuntimeState>,
      edgeStates: null == edgeStates
          ? _self.edgeStates
          : edgeStates // ignore: cast_nullable_to_non_nullable
              as Map<String, EdgeRuntimeState>,
      selectedNodes: null == selectedNodes
          ? _self.selectedNodes
          : selectedNodes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      selectedEdges: null == selectedEdges
          ? _self.selectedEdges
          : selectedEdges // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      spatialHash: null == spatialHash
          ? _self.spatialHash
          : spatialHash // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<String>>,
      edgeIndex: null == edgeIndex
          ? _self.edgeIndex
          : edgeIndex // ignore: cast_nullable_to_non_nullable
              as EdgeIndex,
      nodeIndex: null == nodeIndex
          ? _self.nodeIndex
          : nodeIndex // ignore: cast_nullable_to_non_nullable
              as NodeIndex,
      minZIndex: null == minZIndex
          ? _self.minZIndex
          : minZIndex // ignore: cast_nullable_to_non_nullable
              as int,
      maxZIndex: null == maxZIndex
          ? _self.maxZIndex
          : maxZIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isPanZoomLocked: null == isPanZoomLocked
          ? _self.isPanZoomLocked
          : isPanZoomLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      viewport: null == viewport
          ? _self.viewport
          : viewport // ignore: cast_nullable_to_non_nullable
              as FlowViewport,
      viewportSize: freezed == viewportSize
          ? _self.viewportSize
          : viewportSize // ignore: cast_nullable_to_non_nullable
              as Size?,
      connection: freezed == connection
          ? _self.connection
          : connection // ignore: cast_nullable_to_non_nullable
              as FlowConnection?,
      connectionState: freezed == connectionState
          ? _self.connectionState
          : connectionState // ignore: cast_nullable_to_non_nullable
              as FlowConnectionRuntimeState?,
      selectionRect: freezed == selectionRect
          ? _self.selectionRect
          : selectionRect // ignore: cast_nullable_to_non_nullable
              as Rect?,
      dragMode: null == dragMode
          ? _self.dragMode
          : dragMode // ignore: cast_nullable_to_non_nullable
              as DragMode,
    ));
  }

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlowViewportCopyWith<$Res> get viewport {
    return $FlowViewportCopyWith<$Res>(_self.viewport, (value) {
      return _then(_self.copyWith(viewport: value));
    });
  }

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlowConnectionCopyWith<$Res>? get connection {
    if (_self.connection == null) {
      return null;
    }

    return $FlowConnectionCopyWith<$Res>(_self.connection!, (value) {
      return _then(_self.copyWith(connection: value));
    });
  }

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlowConnectionRuntimeStateCopyWith<$Res>? get connectionState {
    if (_self.connectionState == null) {
      return null;
    }

    return $FlowConnectionRuntimeStateCopyWith<$Res>(_self.connectionState!,
        (value) {
      return _then(_self.copyWith(connectionState: value));
    });
  }
}

/// Adds pattern-matching-related methods to [FlowCanvasState].
extension FlowCanvasStatePatterns on FlowCanvasState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FlowCanvasState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FlowCanvasState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FlowCanvasState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            Map<String, FlowNode> nodes,
            Map<String, FlowEdge> edges,
            Map<String, NodeRuntimeState> nodeStates,
            Map<String, EdgeRuntimeState> edgeStates,
            Set<String> selectedNodes,
            Set<String> selectedEdges,
            Map<String, Set<String>> spatialHash,
            EdgeIndex edgeIndex,
            NodeIndex nodeIndex,
            int minZIndex,
            int maxZIndex,
            bool isPanZoomLocked,
            FlowViewport viewport,
            Size? viewportSize,
            FlowConnection? connection,
            FlowConnectionRuntimeState? connectionState,
            Rect? selectionRect,
            DragMode dragMode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState() when $default != null:
        return $default(
            _that.nodes,
            _that.edges,
            _that.nodeStates,
            _that.edgeStates,
            _that.selectedNodes,
            _that.selectedEdges,
            _that.spatialHash,
            _that.edgeIndex,
            _that.nodeIndex,
            _that.minZIndex,
            _that.maxZIndex,
            _that.isPanZoomLocked,
            _that.viewport,
            _that.viewportSize,
            _that.connection,
            _that.connectionState,
            _that.selectionRect,
            _that.dragMode);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            Map<String, FlowNode> nodes,
            Map<String, FlowEdge> edges,
            Map<String, NodeRuntimeState> nodeStates,
            Map<String, EdgeRuntimeState> edgeStates,
            Set<String> selectedNodes,
            Set<String> selectedEdges,
            Map<String, Set<String>> spatialHash,
            EdgeIndex edgeIndex,
            NodeIndex nodeIndex,
            int minZIndex,
            int maxZIndex,
            bool isPanZoomLocked,
            FlowViewport viewport,
            Size? viewportSize,
            FlowConnection? connection,
            FlowConnectionRuntimeState? connectionState,
            Rect? selectionRect,
            DragMode dragMode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState():
        return $default(
            _that.nodes,
            _that.edges,
            _that.nodeStates,
            _that.edgeStates,
            _that.selectedNodes,
            _that.selectedEdges,
            _that.spatialHash,
            _that.edgeIndex,
            _that.nodeIndex,
            _that.minZIndex,
            _that.maxZIndex,
            _that.isPanZoomLocked,
            _that.viewport,
            _that.viewportSize,
            _that.connection,
            _that.connectionState,
            _that.selectionRect,
            _that.dragMode);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            Map<String, FlowNode> nodes,
            Map<String, FlowEdge> edges,
            Map<String, NodeRuntimeState> nodeStates,
            Map<String, EdgeRuntimeState> edgeStates,
            Set<String> selectedNodes,
            Set<String> selectedEdges,
            Map<String, Set<String>> spatialHash,
            EdgeIndex edgeIndex,
            NodeIndex nodeIndex,
            int minZIndex,
            int maxZIndex,
            bool isPanZoomLocked,
            FlowViewport viewport,
            Size? viewportSize,
            FlowConnection? connection,
            FlowConnectionRuntimeState? connectionState,
            Rect? selectionRect,
            DragMode dragMode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState() when $default != null:
        return $default(
            _that.nodes,
            _that.edges,
            _that.nodeStates,
            _that.edgeStates,
            _that.selectedNodes,
            _that.selectedEdges,
            _that.spatialHash,
            _that.edgeIndex,
            _that.nodeIndex,
            _that.minZIndex,
            _that.maxZIndex,
            _that.isPanZoomLocked,
            _that.viewport,
            _that.viewportSize,
            _that.connection,
            _that.connectionState,
            _that.selectionRect,
            _that.dragMode);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowCanvasState extends FlowCanvasState {
  const _FlowCanvasState(
      {final Map<String, FlowNode> nodes = const {},
      final Map<String, FlowEdge> edges = const {},
      final Map<String, NodeRuntimeState> nodeStates = const {},
      final Map<String, EdgeRuntimeState> edgeStates = const {},
      final Set<String> selectedNodes = const {},
      final Set<String> selectedEdges = const {},
      final Map<String, Set<String>> spatialHash = const {},
      required this.edgeIndex,
      required this.nodeIndex,
      this.minZIndex = 0,
      this.maxZIndex = 0,
      this.isPanZoomLocked = false,
      this.viewport = const FlowViewport(),
      this.viewportSize,
      this.connection,
      this.connectionState,
      this.selectionRect,
      this.dragMode = DragMode.none})
      : _nodes = nodes,
        _edges = edges,
        _nodeStates = nodeStates,
        _edgeStates = edgeStates,
        _selectedNodes = selectedNodes,
        _selectedEdges = selectedEdges,
        _spatialHash = spatialHash,
        super._();

// Core data
  final Map<String, FlowNode> _nodes;
// Core data
  @override
  @JsonKey()
  Map<String, FlowNode> get nodes {
    if (_nodes is EqualUnmodifiableMapView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nodes);
  }

  final Map<String, FlowEdge> _edges;
  @override
  @JsonKey()
  Map<String, FlowEdge> get edges {
    if (_edges is EqualUnmodifiableMapView) return _edges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_edges);
  }

  final Map<String, NodeRuntimeState> _nodeStates;
  @override
  @JsonKey()
  Map<String, NodeRuntimeState> get nodeStates {
    if (_nodeStates is EqualUnmodifiableMapView) return _nodeStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nodeStates);
  }

  final Map<String, EdgeRuntimeState> _edgeStates;
  @override
  @JsonKey()
  Map<String, EdgeRuntimeState> get edgeStates {
    if (_edgeStates is EqualUnmodifiableMapView) return _edgeStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_edgeStates);
  }

  final Set<String> _selectedNodes;
  @override
  @JsonKey()
  Set<String> get selectedNodes {
    if (_selectedNodes is EqualUnmodifiableSetView) return _selectedNodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedNodes);
  }

  final Set<String> _selectedEdges;
  @override
  @JsonKey()
  Set<String> get selectedEdges {
    if (_selectedEdges is EqualUnmodifiableSetView) return _selectedEdges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedEdges);
  }

  final Map<String, Set<String>> _spatialHash;
  @override
  @JsonKey()
  Map<String, Set<String>> get spatialHash {
    if (_spatialHash is EqualUnmodifiableMapView) return _spatialHash;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_spatialHash);
  }

// Edge indexing
  @override
  final EdgeIndex edgeIndex;
  @override
  final NodeIndex nodeIndex;
// Z-index management
  @override
  @JsonKey()
  final int minZIndex;
  @override
  @JsonKey()
  final int maxZIndex;
// Viewport state
  @override
  @JsonKey()
  final bool isPanZoomLocked;
  @override
  @JsonKey()
  final FlowViewport viewport;
  @override
  final Size? viewportSize;
// Interaction state
  @override
  final FlowConnection? connection;
  @override
  final FlowConnectionRuntimeState? connectionState;
  @override
  final Rect? selectionRect;
  @override
  @JsonKey()
  final DragMode dragMode;

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FlowCanvasStateCopyWith<_FlowCanvasState> get copyWith =>
      __$FlowCanvasStateCopyWithImpl<_FlowCanvasState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlowCanvasState &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(other._edges, _edges) &&
            const DeepCollectionEquality()
                .equals(other._nodeStates, _nodeStates) &&
            const DeepCollectionEquality()
                .equals(other._edgeStates, _edgeStates) &&
            const DeepCollectionEquality()
                .equals(other._selectedNodes, _selectedNodes) &&
            const DeepCollectionEquality()
                .equals(other._selectedEdges, _selectedEdges) &&
            const DeepCollectionEquality()
                .equals(other._spatialHash, _spatialHash) &&
            (identical(other.edgeIndex, edgeIndex) ||
                other.edgeIndex == edgeIndex) &&
            (identical(other.nodeIndex, nodeIndex) ||
                other.nodeIndex == nodeIndex) &&
            (identical(other.minZIndex, minZIndex) ||
                other.minZIndex == minZIndex) &&
            (identical(other.maxZIndex, maxZIndex) ||
                other.maxZIndex == maxZIndex) &&
            (identical(other.isPanZoomLocked, isPanZoomLocked) ||
                other.isPanZoomLocked == isPanZoomLocked) &&
            (identical(other.viewport, viewport) ||
                other.viewport == viewport) &&
            (identical(other.viewportSize, viewportSize) ||
                other.viewportSize == viewportSize) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            (identical(other.connectionState, connectionState) ||
                other.connectionState == connectionState) &&
            (identical(other.selectionRect, selectionRect) ||
                other.selectionRect == selectionRect) &&
            (identical(other.dragMode, dragMode) ||
                other.dragMode == dragMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nodes),
      const DeepCollectionEquality().hash(_edges),
      const DeepCollectionEquality().hash(_nodeStates),
      const DeepCollectionEquality().hash(_edgeStates),
      const DeepCollectionEquality().hash(_selectedNodes),
      const DeepCollectionEquality().hash(_selectedEdges),
      const DeepCollectionEquality().hash(_spatialHash),
      edgeIndex,
      nodeIndex,
      minZIndex,
      maxZIndex,
      isPanZoomLocked,
      viewport,
      viewportSize,
      connection,
      connectionState,
      selectionRect,
      dragMode);

  @override
  String toString() {
    return 'FlowCanvasState(nodes: $nodes, edges: $edges, nodeStates: $nodeStates, edgeStates: $edgeStates, selectedNodes: $selectedNodes, selectedEdges: $selectedEdges, spatialHash: $spatialHash, edgeIndex: $edgeIndex, nodeIndex: $nodeIndex, minZIndex: $minZIndex, maxZIndex: $maxZIndex, isPanZoomLocked: $isPanZoomLocked, viewport: $viewport, viewportSize: $viewportSize, connection: $connection, connectionState: $connectionState, selectionRect: $selectionRect, dragMode: $dragMode)';
  }
}

/// @nodoc
abstract mixin class _$FlowCanvasStateCopyWith<$Res>
    implements $FlowCanvasStateCopyWith<$Res> {
  factory _$FlowCanvasStateCopyWith(
          _FlowCanvasState value, $Res Function(_FlowCanvasState) _then) =
      __$FlowCanvasStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Map<String, FlowNode> nodes,
      Map<String, FlowEdge> edges,
      Map<String, NodeRuntimeState> nodeStates,
      Map<String, EdgeRuntimeState> edgeStates,
      Set<String> selectedNodes,
      Set<String> selectedEdges,
      Map<String, Set<String>> spatialHash,
      EdgeIndex edgeIndex,
      NodeIndex nodeIndex,
      int minZIndex,
      int maxZIndex,
      bool isPanZoomLocked,
      FlowViewport viewport,
      Size? viewportSize,
      FlowConnection? connection,
      FlowConnectionRuntimeState? connectionState,
      Rect? selectionRect,
      DragMode dragMode});

  @override
  $FlowViewportCopyWith<$Res> get viewport;
  @override
  $FlowConnectionCopyWith<$Res>? get connection;
  @override
  $FlowConnectionRuntimeStateCopyWith<$Res>? get connectionState;
}

/// @nodoc
class __$FlowCanvasStateCopyWithImpl<$Res>
    implements _$FlowCanvasStateCopyWith<$Res> {
  __$FlowCanvasStateCopyWithImpl(this._self, this._then);

  final _FlowCanvasState _self;
  final $Res Function(_FlowCanvasState) _then;

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? nodes = null,
    Object? edges = null,
    Object? nodeStates = null,
    Object? edgeStates = null,
    Object? selectedNodes = null,
    Object? selectedEdges = null,
    Object? spatialHash = null,
    Object? edgeIndex = null,
    Object? nodeIndex = null,
    Object? minZIndex = null,
    Object? maxZIndex = null,
    Object? isPanZoomLocked = null,
    Object? viewport = null,
    Object? viewportSize = freezed,
    Object? connection = freezed,
    Object? connectionState = freezed,
    Object? selectionRect = freezed,
    Object? dragMode = null,
  }) {
    return _then(_FlowCanvasState(
      nodes: null == nodes
          ? _self._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as Map<String, FlowNode>,
      edges: null == edges
          ? _self._edges
          : edges // ignore: cast_nullable_to_non_nullable
              as Map<String, FlowEdge>,
      nodeStates: null == nodeStates
          ? _self._nodeStates
          : nodeStates // ignore: cast_nullable_to_non_nullable
              as Map<String, NodeRuntimeState>,
      edgeStates: null == edgeStates
          ? _self._edgeStates
          : edgeStates // ignore: cast_nullable_to_non_nullable
              as Map<String, EdgeRuntimeState>,
      selectedNodes: null == selectedNodes
          ? _self._selectedNodes
          : selectedNodes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      selectedEdges: null == selectedEdges
          ? _self._selectedEdges
          : selectedEdges // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      spatialHash: null == spatialHash
          ? _self._spatialHash
          : spatialHash // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<String>>,
      edgeIndex: null == edgeIndex
          ? _self.edgeIndex
          : edgeIndex // ignore: cast_nullable_to_non_nullable
              as EdgeIndex,
      nodeIndex: null == nodeIndex
          ? _self.nodeIndex
          : nodeIndex // ignore: cast_nullable_to_non_nullable
              as NodeIndex,
      minZIndex: null == minZIndex
          ? _self.minZIndex
          : minZIndex // ignore: cast_nullable_to_non_nullable
              as int,
      maxZIndex: null == maxZIndex
          ? _self.maxZIndex
          : maxZIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isPanZoomLocked: null == isPanZoomLocked
          ? _self.isPanZoomLocked
          : isPanZoomLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      viewport: null == viewport
          ? _self.viewport
          : viewport // ignore: cast_nullable_to_non_nullable
              as FlowViewport,
      viewportSize: freezed == viewportSize
          ? _self.viewportSize
          : viewportSize // ignore: cast_nullable_to_non_nullable
              as Size?,
      connection: freezed == connection
          ? _self.connection
          : connection // ignore: cast_nullable_to_non_nullable
              as FlowConnection?,
      connectionState: freezed == connectionState
          ? _self.connectionState
          : connectionState // ignore: cast_nullable_to_non_nullable
              as FlowConnectionRuntimeState?,
      selectionRect: freezed == selectionRect
          ? _self.selectionRect
          : selectionRect // ignore: cast_nullable_to_non_nullable
              as Rect?,
      dragMode: null == dragMode
          ? _self.dragMode
          : dragMode // ignore: cast_nullable_to_non_nullable
              as DragMode,
    ));
  }

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlowViewportCopyWith<$Res> get viewport {
    return $FlowViewportCopyWith<$Res>(_self.viewport, (value) {
      return _then(_self.copyWith(viewport: value));
    });
  }

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlowConnectionCopyWith<$Res>? get connection {
    if (_self.connection == null) {
      return null;
    }

    return $FlowConnectionCopyWith<$Res>(_self.connection!, (value) {
      return _then(_self.copyWith(connection: value));
    });
  }

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlowConnectionRuntimeStateCopyWith<$Res>? get connectionState {
    if (_self.connectionState == null) {
      return null;
    }

    return $FlowConnectionRuntimeStateCopyWith<$Res>(_self.connectionState!,
        (value) {
      return _then(_self.copyWith(connectionState: value));
    });
  }
}

// dart format on

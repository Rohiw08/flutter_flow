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
  List<FlowNode> get nodes;
  List<FlowEdge> get edges;
  Set<String> get selectedNodes;
  Map<String, Set<String>> get spatialHash; // Interaction state
  FlowConnectionState? get connection;
  Rect? get selectionRect;
  DragMode get dragMode; // Viewport State
  double get zoom;
  bool get isPanZoomLocked;
  Size? get viewportSize;
  Rect? get viewport; // Configuration
  bool get enableMultiSelection;
  bool get enableKeyboardShortcuts;
  bool get enableBoxSelection;
  double get canvasWidth;
  double get canvasHeight; // Controller
  Matrix4? get matrix;

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
                .equals(other.selectedNodes, selectedNodes) &&
            const DeepCollectionEquality()
                .equals(other.spatialHash, spatialHash) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            (identical(other.selectionRect, selectionRect) ||
                other.selectionRect == selectionRect) &&
            (identical(other.dragMode, dragMode) ||
                other.dragMode == dragMode) &&
            (identical(other.zoom, zoom) || other.zoom == zoom) &&
            (identical(other.isPanZoomLocked, isPanZoomLocked) ||
                other.isPanZoomLocked == isPanZoomLocked) &&
            (identical(other.viewportSize, viewportSize) ||
                other.viewportSize == viewportSize) &&
            (identical(other.viewport, viewport) ||
                other.viewport == viewport) &&
            (identical(other.enableMultiSelection, enableMultiSelection) ||
                other.enableMultiSelection == enableMultiSelection) &&
            (identical(
                    other.enableKeyboardShortcuts, enableKeyboardShortcuts) ||
                other.enableKeyboardShortcuts == enableKeyboardShortcuts) &&
            (identical(other.enableBoxSelection, enableBoxSelection) ||
                other.enableBoxSelection == enableBoxSelection) &&
            (identical(other.canvasWidth, canvasWidth) ||
                other.canvasWidth == canvasWidth) &&
            (identical(other.canvasHeight, canvasHeight) ||
                other.canvasHeight == canvasHeight) &&
            const DeepCollectionEquality().equals(other.matrix, matrix));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(nodes),
      const DeepCollectionEquality().hash(edges),
      const DeepCollectionEquality().hash(selectedNodes),
      const DeepCollectionEquality().hash(spatialHash),
      connection,
      selectionRect,
      dragMode,
      zoom,
      isPanZoomLocked,
      viewportSize,
      viewport,
      enableMultiSelection,
      enableKeyboardShortcuts,
      enableBoxSelection,
      canvasWidth,
      canvasHeight,
      const DeepCollectionEquality().hash(matrix));

  @override
  String toString() {
    return 'FlowCanvasState(nodes: $nodes, edges: $edges, selectedNodes: $selectedNodes, spatialHash: $spatialHash, connection: $connection, selectionRect: $selectionRect, dragMode: $dragMode, zoom: $zoom, isPanZoomLocked: $isPanZoomLocked, viewportSize: $viewportSize, viewport: $viewport, enableMultiSelection: $enableMultiSelection, enableKeyboardShortcuts: $enableKeyboardShortcuts, enableBoxSelection: $enableBoxSelection, canvasWidth: $canvasWidth, canvasHeight: $canvasHeight, matrix: $matrix)';
  }
}

/// @nodoc
abstract mixin class $FlowCanvasStateCopyWith<$Res> {
  factory $FlowCanvasStateCopyWith(
          FlowCanvasState value, $Res Function(FlowCanvasState) _then) =
      _$FlowCanvasStateCopyWithImpl;
  @useResult
  $Res call(
      {List<FlowNode> nodes,
      List<FlowEdge> edges,
      Set<String> selectedNodes,
      Map<String, Set<String>> spatialHash,
      FlowConnectionState? connection,
      Rect? selectionRect,
      DragMode dragMode,
      double zoom,
      bool isPanZoomLocked,
      Size? viewportSize,
      Rect? viewport,
      bool enableMultiSelection,
      bool enableKeyboardShortcuts,
      bool enableBoxSelection,
      double canvasWidth,
      double canvasHeight,
      Matrix4? matrix});

  $FlowConnectionStateCopyWith<$Res>? get connection;
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
    Object? selectedNodes = null,
    Object? spatialHash = null,
    Object? connection = freezed,
    Object? selectionRect = freezed,
    Object? dragMode = null,
    Object? zoom = null,
    Object? isPanZoomLocked = null,
    Object? viewportSize = freezed,
    Object? viewport = freezed,
    Object? enableMultiSelection = null,
    Object? enableKeyboardShortcuts = null,
    Object? enableBoxSelection = null,
    Object? canvasWidth = null,
    Object? canvasHeight = null,
    Object? matrix = freezed,
  }) {
    return _then(_self.copyWith(
      nodes: null == nodes
          ? _self.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<FlowNode>,
      edges: null == edges
          ? _self.edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<FlowEdge>,
      selectedNodes: null == selectedNodes
          ? _self.selectedNodes
          : selectedNodes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      spatialHash: null == spatialHash
          ? _self.spatialHash
          : spatialHash // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<String>>,
      connection: freezed == connection
          ? _self.connection
          : connection // ignore: cast_nullable_to_non_nullable
              as FlowConnectionState?,
      selectionRect: freezed == selectionRect
          ? _self.selectionRect
          : selectionRect // ignore: cast_nullable_to_non_nullable
              as Rect?,
      dragMode: null == dragMode
          ? _self.dragMode
          : dragMode // ignore: cast_nullable_to_non_nullable
              as DragMode,
      zoom: null == zoom
          ? _self.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as double,
      isPanZoomLocked: null == isPanZoomLocked
          ? _self.isPanZoomLocked
          : isPanZoomLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      viewportSize: freezed == viewportSize
          ? _self.viewportSize
          : viewportSize // ignore: cast_nullable_to_non_nullable
              as Size?,
      viewport: freezed == viewport
          ? _self.viewport
          : viewport // ignore: cast_nullable_to_non_nullable
              as Rect?,
      enableMultiSelection: null == enableMultiSelection
          ? _self.enableMultiSelection
          : enableMultiSelection // ignore: cast_nullable_to_non_nullable
              as bool,
      enableKeyboardShortcuts: null == enableKeyboardShortcuts
          ? _self.enableKeyboardShortcuts
          : enableKeyboardShortcuts // ignore: cast_nullable_to_non_nullable
              as bool,
      enableBoxSelection: null == enableBoxSelection
          ? _self.enableBoxSelection
          : enableBoxSelection // ignore: cast_nullable_to_non_nullable
              as bool,
      canvasWidth: null == canvasWidth
          ? _self.canvasWidth
          : canvasWidth // ignore: cast_nullable_to_non_nullable
              as double,
      canvasHeight: null == canvasHeight
          ? _self.canvasHeight
          : canvasHeight // ignore: cast_nullable_to_non_nullable
              as double,
      matrix: freezed == matrix
          ? _self.matrix
          : matrix // ignore: cast_nullable_to_non_nullable
              as Matrix4?,
    ));
  }

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlowConnectionStateCopyWith<$Res>? get connection {
    if (_self.connection == null) {
      return null;
    }

    return $FlowConnectionStateCopyWith<$Res>(_self.connection!, (value) {
      return _then(_self.copyWith(connection: value));
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
            List<FlowNode> nodes,
            List<FlowEdge> edges,
            Set<String> selectedNodes,
            Map<String, Set<String>> spatialHash,
            FlowConnectionState? connection,
            Rect? selectionRect,
            DragMode dragMode,
            double zoom,
            bool isPanZoomLocked,
            Size? viewportSize,
            Rect? viewport,
            bool enableMultiSelection,
            bool enableKeyboardShortcuts,
            bool enableBoxSelection,
            double canvasWidth,
            double canvasHeight,
            Matrix4? matrix)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState() when $default != null:
        return $default(
            _that.nodes,
            _that.edges,
            _that.selectedNodes,
            _that.spatialHash,
            _that.connection,
            _that.selectionRect,
            _that.dragMode,
            _that.zoom,
            _that.isPanZoomLocked,
            _that.viewportSize,
            _that.viewport,
            _that.enableMultiSelection,
            _that.enableKeyboardShortcuts,
            _that.enableBoxSelection,
            _that.canvasWidth,
            _that.canvasHeight,
            _that.matrix);
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
            List<FlowNode> nodes,
            List<FlowEdge> edges,
            Set<String> selectedNodes,
            Map<String, Set<String>> spatialHash,
            FlowConnectionState? connection,
            Rect? selectionRect,
            DragMode dragMode,
            double zoom,
            bool isPanZoomLocked,
            Size? viewportSize,
            Rect? viewport,
            bool enableMultiSelection,
            bool enableKeyboardShortcuts,
            bool enableBoxSelection,
            double canvasWidth,
            double canvasHeight,
            Matrix4? matrix)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState():
        return $default(
            _that.nodes,
            _that.edges,
            _that.selectedNodes,
            _that.spatialHash,
            _that.connection,
            _that.selectionRect,
            _that.dragMode,
            _that.zoom,
            _that.isPanZoomLocked,
            _that.viewportSize,
            _that.viewport,
            _that.enableMultiSelection,
            _that.enableKeyboardShortcuts,
            _that.enableBoxSelection,
            _that.canvasWidth,
            _that.canvasHeight,
            _that.matrix);
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
            List<FlowNode> nodes,
            List<FlowEdge> edges,
            Set<String> selectedNodes,
            Map<String, Set<String>> spatialHash,
            FlowConnectionState? connection,
            Rect? selectionRect,
            DragMode dragMode,
            double zoom,
            bool isPanZoomLocked,
            Size? viewportSize,
            Rect? viewport,
            bool enableMultiSelection,
            bool enableKeyboardShortcuts,
            bool enableBoxSelection,
            double canvasWidth,
            double canvasHeight,
            Matrix4? matrix)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState() when $default != null:
        return $default(
            _that.nodes,
            _that.edges,
            _that.selectedNodes,
            _that.spatialHash,
            _that.connection,
            _that.selectionRect,
            _that.dragMode,
            _that.zoom,
            _that.isPanZoomLocked,
            _that.viewportSize,
            _that.viewport,
            _that.enableMultiSelection,
            _that.enableKeyboardShortcuts,
            _that.enableBoxSelection,
            _that.canvasWidth,
            _that.canvasHeight,
            _that.matrix);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowCanvasState implements FlowCanvasState {
  const _FlowCanvasState(
      {final List<FlowNode> nodes = const [],
      final List<FlowEdge> edges = const [],
      final Set<String> selectedNodes = const {},
      final Map<String, Set<String>> spatialHash = const {},
      this.connection,
      this.selectionRect,
      this.dragMode = DragMode.none,
      this.zoom = 1.0,
      this.isPanZoomLocked = false,
      this.viewportSize,
      this.viewport,
      this.enableMultiSelection = true,
      this.enableKeyboardShortcuts = true,
      this.enableBoxSelection = true,
      this.canvasWidth = 50000,
      this.canvasHeight = 50000,
      this.matrix})
      : _nodes = nodes,
        _edges = edges,
        _selectedNodes = selectedNodes,
        _spatialHash = spatialHash;

// Core data
  final List<FlowNode> _nodes;
// Core data
  @override
  @JsonKey()
  List<FlowNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  final List<FlowEdge> _edges;
  @override
  @JsonKey()
  List<FlowEdge> get edges {
    if (_edges is EqualUnmodifiableListView) return _edges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_edges);
  }

  final Set<String> _selectedNodes;
  @override
  @JsonKey()
  Set<String> get selectedNodes {
    if (_selectedNodes is EqualUnmodifiableSetView) return _selectedNodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedNodes);
  }

  final Map<String, Set<String>> _spatialHash;
  @override
  @JsonKey()
  Map<String, Set<String>> get spatialHash {
    if (_spatialHash is EqualUnmodifiableMapView) return _spatialHash;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_spatialHash);
  }

// Interaction state
  @override
  final FlowConnectionState? connection;
  @override
  final Rect? selectionRect;
  @override
  @JsonKey()
  final DragMode dragMode;
// Viewport State
  @override
  @JsonKey()
  final double zoom;
  @override
  @JsonKey()
  final bool isPanZoomLocked;
  @override
  final Size? viewportSize;
  @override
  final Rect? viewport;
// Configuration
  @override
  @JsonKey()
  final bool enableMultiSelection;
  @override
  @JsonKey()
  final bool enableKeyboardShortcuts;
  @override
  @JsonKey()
  final bool enableBoxSelection;
  @override
  @JsonKey()
  final double canvasWidth;
  @override
  @JsonKey()
  final double canvasHeight;
// Controller
  @override
  final Matrix4? matrix;

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
                .equals(other._selectedNodes, _selectedNodes) &&
            const DeepCollectionEquality()
                .equals(other._spatialHash, _spatialHash) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            (identical(other.selectionRect, selectionRect) ||
                other.selectionRect == selectionRect) &&
            (identical(other.dragMode, dragMode) ||
                other.dragMode == dragMode) &&
            (identical(other.zoom, zoom) || other.zoom == zoom) &&
            (identical(other.isPanZoomLocked, isPanZoomLocked) ||
                other.isPanZoomLocked == isPanZoomLocked) &&
            (identical(other.viewportSize, viewportSize) ||
                other.viewportSize == viewportSize) &&
            (identical(other.viewport, viewport) ||
                other.viewport == viewport) &&
            (identical(other.enableMultiSelection, enableMultiSelection) ||
                other.enableMultiSelection == enableMultiSelection) &&
            (identical(
                    other.enableKeyboardShortcuts, enableKeyboardShortcuts) ||
                other.enableKeyboardShortcuts == enableKeyboardShortcuts) &&
            (identical(other.enableBoxSelection, enableBoxSelection) ||
                other.enableBoxSelection == enableBoxSelection) &&
            (identical(other.canvasWidth, canvasWidth) ||
                other.canvasWidth == canvasWidth) &&
            (identical(other.canvasHeight, canvasHeight) ||
                other.canvasHeight == canvasHeight) &&
            const DeepCollectionEquality().equals(other.matrix, matrix));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nodes),
      const DeepCollectionEquality().hash(_edges),
      const DeepCollectionEquality().hash(_selectedNodes),
      const DeepCollectionEquality().hash(_spatialHash),
      connection,
      selectionRect,
      dragMode,
      zoom,
      isPanZoomLocked,
      viewportSize,
      viewport,
      enableMultiSelection,
      enableKeyboardShortcuts,
      enableBoxSelection,
      canvasWidth,
      canvasHeight,
      const DeepCollectionEquality().hash(matrix));

  @override
  String toString() {
    return 'FlowCanvasState(nodes: $nodes, edges: $edges, selectedNodes: $selectedNodes, spatialHash: $spatialHash, connection: $connection, selectionRect: $selectionRect, dragMode: $dragMode, zoom: $zoom, isPanZoomLocked: $isPanZoomLocked, viewportSize: $viewportSize, viewport: $viewport, enableMultiSelection: $enableMultiSelection, enableKeyboardShortcuts: $enableKeyboardShortcuts, enableBoxSelection: $enableBoxSelection, canvasWidth: $canvasWidth, canvasHeight: $canvasHeight, matrix: $matrix)';
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
      {List<FlowNode> nodes,
      List<FlowEdge> edges,
      Set<String> selectedNodes,
      Map<String, Set<String>> spatialHash,
      FlowConnectionState? connection,
      Rect? selectionRect,
      DragMode dragMode,
      double zoom,
      bool isPanZoomLocked,
      Size? viewportSize,
      Rect? viewport,
      bool enableMultiSelection,
      bool enableKeyboardShortcuts,
      bool enableBoxSelection,
      double canvasWidth,
      double canvasHeight,
      Matrix4? matrix});

  @override
  $FlowConnectionStateCopyWith<$Res>? get connection;
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
    Object? selectedNodes = null,
    Object? spatialHash = null,
    Object? connection = freezed,
    Object? selectionRect = freezed,
    Object? dragMode = null,
    Object? zoom = null,
    Object? isPanZoomLocked = null,
    Object? viewportSize = freezed,
    Object? viewport = freezed,
    Object? enableMultiSelection = null,
    Object? enableKeyboardShortcuts = null,
    Object? enableBoxSelection = null,
    Object? canvasWidth = null,
    Object? canvasHeight = null,
    Object? matrix = freezed,
  }) {
    return _then(_FlowCanvasState(
      nodes: null == nodes
          ? _self._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<FlowNode>,
      edges: null == edges
          ? _self._edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<FlowEdge>,
      selectedNodes: null == selectedNodes
          ? _self._selectedNodes
          : selectedNodes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      spatialHash: null == spatialHash
          ? _self._spatialHash
          : spatialHash // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<String>>,
      connection: freezed == connection
          ? _self.connection
          : connection // ignore: cast_nullable_to_non_nullable
              as FlowConnectionState?,
      selectionRect: freezed == selectionRect
          ? _self.selectionRect
          : selectionRect // ignore: cast_nullable_to_non_nullable
              as Rect?,
      dragMode: null == dragMode
          ? _self.dragMode
          : dragMode // ignore: cast_nullable_to_non_nullable
              as DragMode,
      zoom: null == zoom
          ? _self.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as double,
      isPanZoomLocked: null == isPanZoomLocked
          ? _self.isPanZoomLocked
          : isPanZoomLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      viewportSize: freezed == viewportSize
          ? _self.viewportSize
          : viewportSize // ignore: cast_nullable_to_non_nullable
              as Size?,
      viewport: freezed == viewport
          ? _self.viewport
          : viewport // ignore: cast_nullable_to_non_nullable
              as Rect?,
      enableMultiSelection: null == enableMultiSelection
          ? _self.enableMultiSelection
          : enableMultiSelection // ignore: cast_nullable_to_non_nullable
              as bool,
      enableKeyboardShortcuts: null == enableKeyboardShortcuts
          ? _self.enableKeyboardShortcuts
          : enableKeyboardShortcuts // ignore: cast_nullable_to_non_nullable
              as bool,
      enableBoxSelection: null == enableBoxSelection
          ? _self.enableBoxSelection
          : enableBoxSelection // ignore: cast_nullable_to_non_nullable
              as bool,
      canvasWidth: null == canvasWidth
          ? _self.canvasWidth
          : canvasWidth // ignore: cast_nullable_to_non_nullable
              as double,
      canvasHeight: null == canvasHeight
          ? _self.canvasHeight
          : canvasHeight // ignore: cast_nullable_to_non_nullable
              as double,
      matrix: freezed == matrix
          ? _self.matrix
          : matrix // ignore: cast_nullable_to_non_nullable
              as Matrix4?,
    ));
  }

  /// Create a copy of FlowCanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlowConnectionStateCopyWith<$Res>? get connection {
    if (_self.connection == null) {
      return null;
    }

    return $FlowConnectionStateCopyWith<$Res>(_self.connection!, (value) {
      return _then(_self.copyWith(connection: value));
    });
  }
}

// dart format on

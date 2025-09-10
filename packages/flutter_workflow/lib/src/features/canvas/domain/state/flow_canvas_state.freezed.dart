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
  BuiltMap<String, FlowNode> get internalNodes;
  BuiltMap<String, FlowEdge> get internalEdges;
  BuiltSet<String> get internalSelectedNodes;
  BuiltMap<String, BuiltSet<String>> get internalSpatialHash; // Edge indexing
  EdgeIndex get edgeIndex; // Interaction state
  FlowConnectionState? get connection;
  Rect? get selectionRect;
  DragMode get dragMode; // Viewport State
  double get zoom;
  Offset get viewportOffset;
  bool get isPanZoomLocked;
  Size? get viewportSize; // Configuration
  bool get enableMultiSelection;
  bool get enableKeyboardShortcuts;
  bool get enableBoxSelection;
  double get canvasWidth;
  double get canvasHeight; // Z-index management
  int get minZIndex;
  int get maxZIndex;

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
            (identical(other.internalNodes, internalNodes) ||
                other.internalNodes == internalNodes) &&
            (identical(other.internalEdges, internalEdges) ||
                other.internalEdges == internalEdges) &&
            const DeepCollectionEquality()
                .equals(other.internalSelectedNodes, internalSelectedNodes) &&
            (identical(other.internalSpatialHash, internalSpatialHash) ||
                other.internalSpatialHash == internalSpatialHash) &&
            (identical(other.edgeIndex, edgeIndex) ||
                other.edgeIndex == edgeIndex) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            (identical(other.selectionRect, selectionRect) ||
                other.selectionRect == selectionRect) &&
            (identical(other.dragMode, dragMode) ||
                other.dragMode == dragMode) &&
            (identical(other.zoom, zoom) || other.zoom == zoom) &&
            (identical(other.viewportOffset, viewportOffset) ||
                other.viewportOffset == viewportOffset) &&
            (identical(other.isPanZoomLocked, isPanZoomLocked) ||
                other.isPanZoomLocked == isPanZoomLocked) &&
            (identical(other.viewportSize, viewportSize) ||
                other.viewportSize == viewportSize) &&
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
            (identical(other.minZIndex, minZIndex) ||
                other.minZIndex == minZIndex) &&
            (identical(other.maxZIndex, maxZIndex) ||
                other.maxZIndex == maxZIndex));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        internalNodes,
        internalEdges,
        const DeepCollectionEquality().hash(internalSelectedNodes),
        internalSpatialHash,
        edgeIndex,
        connection,
        selectionRect,
        dragMode,
        zoom,
        viewportOffset,
        isPanZoomLocked,
        viewportSize,
        enableMultiSelection,
        enableKeyboardShortcuts,
        enableBoxSelection,
        canvasWidth,
        canvasHeight,
        minZIndex,
        maxZIndex
      ]);

  @override
  String toString() {
    return 'FlowCanvasState(internalNodes: $internalNodes, internalEdges: $internalEdges, internalSelectedNodes: $internalSelectedNodes, internalSpatialHash: $internalSpatialHash, edgeIndex: $edgeIndex, connection: $connection, selectionRect: $selectionRect, dragMode: $dragMode, zoom: $zoom, viewportOffset: $viewportOffset, isPanZoomLocked: $isPanZoomLocked, viewportSize: $viewportSize, enableMultiSelection: $enableMultiSelection, enableKeyboardShortcuts: $enableKeyboardShortcuts, enableBoxSelection: $enableBoxSelection, canvasWidth: $canvasWidth, canvasHeight: $canvasHeight, minZIndex: $minZIndex, maxZIndex: $maxZIndex)';
  }
}

/// @nodoc
abstract mixin class $FlowCanvasStateCopyWith<$Res> {
  factory $FlowCanvasStateCopyWith(
          FlowCanvasState value, $Res Function(FlowCanvasState) _then) =
      _$FlowCanvasStateCopyWithImpl;
  @useResult
  $Res call(
      {BuiltMap<String, FlowNode> internalNodes,
      BuiltMap<String, FlowEdge> internalEdges,
      BuiltSet<String> internalSelectedNodes,
      BuiltMap<String, BuiltSet<String>> internalSpatialHash,
      EdgeIndex edgeIndex,
      FlowConnectionState? connection,
      Rect? selectionRect,
      DragMode dragMode,
      double zoom,
      Offset viewportOffset,
      bool isPanZoomLocked,
      Size? viewportSize,
      bool enableMultiSelection,
      bool enableKeyboardShortcuts,
      bool enableBoxSelection,
      double canvasWidth,
      double canvasHeight,
      int minZIndex,
      int maxZIndex});

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
    Object? internalNodes = null,
    Object? internalEdges = null,
    Object? internalSelectedNodes = null,
    Object? internalSpatialHash = null,
    Object? edgeIndex = null,
    Object? connection = freezed,
    Object? selectionRect = freezed,
    Object? dragMode = null,
    Object? zoom = null,
    Object? viewportOffset = null,
    Object? isPanZoomLocked = null,
    Object? viewportSize = freezed,
    Object? enableMultiSelection = null,
    Object? enableKeyboardShortcuts = null,
    Object? enableBoxSelection = null,
    Object? canvasWidth = null,
    Object? canvasHeight = null,
    Object? minZIndex = null,
    Object? maxZIndex = null,
  }) {
    return _then(_self.copyWith(
      internalNodes: null == internalNodes
          ? _self.internalNodes
          : internalNodes // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, FlowNode>,
      internalEdges: null == internalEdges
          ? _self.internalEdges
          : internalEdges // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, FlowEdge>,
      internalSelectedNodes: null == internalSelectedNodes
          ? _self.internalSelectedNodes
          : internalSelectedNodes // ignore: cast_nullable_to_non_nullable
              as BuiltSet<String>,
      internalSpatialHash: null == internalSpatialHash
          ? _self.internalSpatialHash
          : internalSpatialHash // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, BuiltSet<String>>,
      edgeIndex: null == edgeIndex
          ? _self.edgeIndex
          : edgeIndex // ignore: cast_nullable_to_non_nullable
              as EdgeIndex,
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
      viewportOffset: null == viewportOffset
          ? _self.viewportOffset
          : viewportOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      isPanZoomLocked: null == isPanZoomLocked
          ? _self.isPanZoomLocked
          : isPanZoomLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      viewportSize: freezed == viewportSize
          ? _self.viewportSize
          : viewportSize // ignore: cast_nullable_to_non_nullable
              as Size?,
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
      minZIndex: null == minZIndex
          ? _self.minZIndex
          : minZIndex // ignore: cast_nullable_to_non_nullable
              as int,
      maxZIndex: null == maxZIndex
          ? _self.maxZIndex
          : maxZIndex // ignore: cast_nullable_to_non_nullable
              as int,
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
            BuiltMap<String, FlowNode> internalNodes,
            BuiltMap<String, FlowEdge> internalEdges,
            BuiltSet<String> internalSelectedNodes,
            BuiltMap<String, BuiltSet<String>> internalSpatialHash,
            EdgeIndex edgeIndex,
            FlowConnectionState? connection,
            Rect? selectionRect,
            DragMode dragMode,
            double zoom,
            Offset viewportOffset,
            bool isPanZoomLocked,
            Size? viewportSize,
            bool enableMultiSelection,
            bool enableKeyboardShortcuts,
            bool enableBoxSelection,
            double canvasWidth,
            double canvasHeight,
            int minZIndex,
            int maxZIndex)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState() when $default != null:
        return $default(
            _that.internalNodes,
            _that.internalEdges,
            _that.internalSelectedNodes,
            _that.internalSpatialHash,
            _that.edgeIndex,
            _that.connection,
            _that.selectionRect,
            _that.dragMode,
            _that.zoom,
            _that.viewportOffset,
            _that.isPanZoomLocked,
            _that.viewportSize,
            _that.enableMultiSelection,
            _that.enableKeyboardShortcuts,
            _that.enableBoxSelection,
            _that.canvasWidth,
            _that.canvasHeight,
            _that.minZIndex,
            _that.maxZIndex);
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
            BuiltMap<String, FlowNode> internalNodes,
            BuiltMap<String, FlowEdge> internalEdges,
            BuiltSet<String> internalSelectedNodes,
            BuiltMap<String, BuiltSet<String>> internalSpatialHash,
            EdgeIndex edgeIndex,
            FlowConnectionState? connection,
            Rect? selectionRect,
            DragMode dragMode,
            double zoom,
            Offset viewportOffset,
            bool isPanZoomLocked,
            Size? viewportSize,
            bool enableMultiSelection,
            bool enableKeyboardShortcuts,
            bool enableBoxSelection,
            double canvasWidth,
            double canvasHeight,
            int minZIndex,
            int maxZIndex)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState():
        return $default(
            _that.internalNodes,
            _that.internalEdges,
            _that.internalSelectedNodes,
            _that.internalSpatialHash,
            _that.edgeIndex,
            _that.connection,
            _that.selectionRect,
            _that.dragMode,
            _that.zoom,
            _that.viewportOffset,
            _that.isPanZoomLocked,
            _that.viewportSize,
            _that.enableMultiSelection,
            _that.enableKeyboardShortcuts,
            _that.enableBoxSelection,
            _that.canvasWidth,
            _that.canvasHeight,
            _that.minZIndex,
            _that.maxZIndex);
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
            BuiltMap<String, FlowNode> internalNodes,
            BuiltMap<String, FlowEdge> internalEdges,
            BuiltSet<String> internalSelectedNodes,
            BuiltMap<String, BuiltSet<String>> internalSpatialHash,
            EdgeIndex edgeIndex,
            FlowConnectionState? connection,
            Rect? selectionRect,
            DragMode dragMode,
            double zoom,
            Offset viewportOffset,
            bool isPanZoomLocked,
            Size? viewportSize,
            bool enableMultiSelection,
            bool enableKeyboardShortcuts,
            bool enableBoxSelection,
            double canvasWidth,
            double canvasHeight,
            int minZIndex,
            int maxZIndex)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowCanvasState() when $default != null:
        return $default(
            _that.internalNodes,
            _that.internalEdges,
            _that.internalSelectedNodes,
            _that.internalSpatialHash,
            _that.edgeIndex,
            _that.connection,
            _that.selectionRect,
            _that.dragMode,
            _that.zoom,
            _that.viewportOffset,
            _that.isPanZoomLocked,
            _that.viewportSize,
            _that.enableMultiSelection,
            _that.enableKeyboardShortcuts,
            _that.enableBoxSelection,
            _that.canvasWidth,
            _that.canvasHeight,
            _that.minZIndex,
            _that.maxZIndex);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowCanvasState extends FlowCanvasState {
  const _FlowCanvasState(
      {required this.internalNodes,
      required this.internalEdges,
      required this.internalSelectedNodes,
      required this.internalSpatialHash,
      required this.edgeIndex,
      this.connection,
      this.selectionRect,
      this.dragMode = DragMode.none,
      this.zoom = 1.0,
      this.viewportOffset = Offset.zero,
      this.isPanZoomLocked = false,
      this.viewportSize,
      this.enableMultiSelection = true,
      this.enableKeyboardShortcuts = true,
      this.enableBoxSelection = true,
      this.canvasWidth = 500000,
      this.canvasHeight = 500000,
      this.minZIndex = 0,
      this.maxZIndex = 0})
      : super._();

// Core data
  @override
  final BuiltMap<String, FlowNode> internalNodes;
  @override
  final BuiltMap<String, FlowEdge> internalEdges;
  @override
  final BuiltSet<String> internalSelectedNodes;
  @override
  final BuiltMap<String, BuiltSet<String>> internalSpatialHash;
// Edge indexing
  @override
  final EdgeIndex edgeIndex;
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
  final Offset viewportOffset;
  @override
  @JsonKey()
  final bool isPanZoomLocked;
  @override
  final Size? viewportSize;
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
// Z-index management
  @override
  @JsonKey()
  final int minZIndex;
  @override
  @JsonKey()
  final int maxZIndex;

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
            (identical(other.internalNodes, internalNodes) ||
                other.internalNodes == internalNodes) &&
            (identical(other.internalEdges, internalEdges) ||
                other.internalEdges == internalEdges) &&
            const DeepCollectionEquality()
                .equals(other.internalSelectedNodes, internalSelectedNodes) &&
            (identical(other.internalSpatialHash, internalSpatialHash) ||
                other.internalSpatialHash == internalSpatialHash) &&
            (identical(other.edgeIndex, edgeIndex) ||
                other.edgeIndex == edgeIndex) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            (identical(other.selectionRect, selectionRect) ||
                other.selectionRect == selectionRect) &&
            (identical(other.dragMode, dragMode) ||
                other.dragMode == dragMode) &&
            (identical(other.zoom, zoom) || other.zoom == zoom) &&
            (identical(other.viewportOffset, viewportOffset) ||
                other.viewportOffset == viewportOffset) &&
            (identical(other.isPanZoomLocked, isPanZoomLocked) ||
                other.isPanZoomLocked == isPanZoomLocked) &&
            (identical(other.viewportSize, viewportSize) ||
                other.viewportSize == viewportSize) &&
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
            (identical(other.minZIndex, minZIndex) ||
                other.minZIndex == minZIndex) &&
            (identical(other.maxZIndex, maxZIndex) ||
                other.maxZIndex == maxZIndex));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        internalNodes,
        internalEdges,
        const DeepCollectionEquality().hash(internalSelectedNodes),
        internalSpatialHash,
        edgeIndex,
        connection,
        selectionRect,
        dragMode,
        zoom,
        viewportOffset,
        isPanZoomLocked,
        viewportSize,
        enableMultiSelection,
        enableKeyboardShortcuts,
        enableBoxSelection,
        canvasWidth,
        canvasHeight,
        minZIndex,
        maxZIndex
      ]);

  @override
  String toString() {
    return 'FlowCanvasState(internalNodes: $internalNodes, internalEdges: $internalEdges, internalSelectedNodes: $internalSelectedNodes, internalSpatialHash: $internalSpatialHash, edgeIndex: $edgeIndex, connection: $connection, selectionRect: $selectionRect, dragMode: $dragMode, zoom: $zoom, viewportOffset: $viewportOffset, isPanZoomLocked: $isPanZoomLocked, viewportSize: $viewportSize, enableMultiSelection: $enableMultiSelection, enableKeyboardShortcuts: $enableKeyboardShortcuts, enableBoxSelection: $enableBoxSelection, canvasWidth: $canvasWidth, canvasHeight: $canvasHeight, minZIndex: $minZIndex, maxZIndex: $maxZIndex)';
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
      {BuiltMap<String, FlowNode> internalNodes,
      BuiltMap<String, FlowEdge> internalEdges,
      BuiltSet<String> internalSelectedNodes,
      BuiltMap<String, BuiltSet<String>> internalSpatialHash,
      EdgeIndex edgeIndex,
      FlowConnectionState? connection,
      Rect? selectionRect,
      DragMode dragMode,
      double zoom,
      Offset viewportOffset,
      bool isPanZoomLocked,
      Size? viewportSize,
      bool enableMultiSelection,
      bool enableKeyboardShortcuts,
      bool enableBoxSelection,
      double canvasWidth,
      double canvasHeight,
      int minZIndex,
      int maxZIndex});

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
    Object? internalNodes = null,
    Object? internalEdges = null,
    Object? internalSelectedNodes = null,
    Object? internalSpatialHash = null,
    Object? edgeIndex = null,
    Object? connection = freezed,
    Object? selectionRect = freezed,
    Object? dragMode = null,
    Object? zoom = null,
    Object? viewportOffset = null,
    Object? isPanZoomLocked = null,
    Object? viewportSize = freezed,
    Object? enableMultiSelection = null,
    Object? enableKeyboardShortcuts = null,
    Object? enableBoxSelection = null,
    Object? canvasWidth = null,
    Object? canvasHeight = null,
    Object? minZIndex = null,
    Object? maxZIndex = null,
  }) {
    return _then(_FlowCanvasState(
      internalNodes: null == internalNodes
          ? _self.internalNodes
          : internalNodes // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, FlowNode>,
      internalEdges: null == internalEdges
          ? _self.internalEdges
          : internalEdges // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, FlowEdge>,
      internalSelectedNodes: null == internalSelectedNodes
          ? _self.internalSelectedNodes
          : internalSelectedNodes // ignore: cast_nullable_to_non_nullable
              as BuiltSet<String>,
      internalSpatialHash: null == internalSpatialHash
          ? _self.internalSpatialHash
          : internalSpatialHash // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, BuiltSet<String>>,
      edgeIndex: null == edgeIndex
          ? _self.edgeIndex
          : edgeIndex // ignore: cast_nullable_to_non_nullable
              as EdgeIndex,
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
      viewportOffset: null == viewportOffset
          ? _self.viewportOffset
          : viewportOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      isPanZoomLocked: null == isPanZoomLocked
          ? _self.isPanZoomLocked
          : isPanZoomLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      viewportSize: freezed == viewportSize
          ? _self.viewportSize
          : viewportSize // ignore: cast_nullable_to_non_nullable
              as Size?,
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
      minZIndex: null == minZIndex
          ? _self.minZIndex
          : minZIndex // ignore: cast_nullable_to_non_nullable
              as int,
      maxZIndex: null == maxZIndex
          ? _self.maxZIndex
          : maxZIndex // ignore: cast_nullable_to_non_nullable
              as int,
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

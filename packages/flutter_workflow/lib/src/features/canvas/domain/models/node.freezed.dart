// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlowNode {
  String get id;
  Offset get position;
  Size get size;
  String get type;
  List<NodeHandle> get handles;
  Map<String, dynamic> get data;
  bool get isSelected; // Interaction configuration
  bool get isDraggable;
  bool get isSelectable;

  /// Create a copy of FlowNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlowNodeCopyWith<FlowNode> get copyWith =>
      _$FlowNodeCopyWithImpl<FlowNode>(this as FlowNode, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlowNode &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.handles, handles) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isDraggable, isDraggable) ||
                other.isDraggable == isDraggable) &&
            (identical(other.isSelectable, isSelectable) ||
                other.isSelectable == isSelectable));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      position,
      size,
      type,
      const DeepCollectionEquality().hash(handles),
      const DeepCollectionEquality().hash(data),
      isSelected,
      isDraggable,
      isSelectable);

  @override
  String toString() {
    return 'FlowNode(id: $id, position: $position, size: $size, type: $type, handles: $handles, data: $data, isSelected: $isSelected, isDraggable: $isDraggable, isSelectable: $isSelectable)';
  }
}

/// @nodoc
abstract mixin class $FlowNodeCopyWith<$Res> {
  factory $FlowNodeCopyWith(FlowNode value, $Res Function(FlowNode) _then) =
      _$FlowNodeCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      Offset position,
      Size size,
      String type,
      List<NodeHandle> handles,
      Map<String, dynamic> data,
      bool isSelected,
      bool isDraggable,
      bool isSelectable});
}

/// @nodoc
class _$FlowNodeCopyWithImpl<$Res> implements $FlowNodeCopyWith<$Res> {
  _$FlowNodeCopyWithImpl(this._self, this._then);

  final FlowNode _self;
  final $Res Function(FlowNode) _then;

  /// Create a copy of FlowNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? size = null,
    Object? type = null,
    Object? handles = null,
    Object? data = null,
    Object? isSelected = null,
    Object? isDraggable = null,
    Object? isSelectable = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      handles: null == handles
          ? _self.handles
          : handles // ignore: cast_nullable_to_non_nullable
              as List<NodeHandle>,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isDraggable: null == isDraggable
          ? _self.isDraggable
          : isDraggable // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelectable: null == isSelectable
          ? _self.isSelectable
          : isSelectable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [FlowNode].
extension FlowNodePatterns on FlowNode {
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
    TResult Function(_FlowNode value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowNode() when $default != null:
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
    TResult Function(_FlowNode value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowNode():
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
    TResult? Function(_FlowNode value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowNode() when $default != null:
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
            String id,
            Offset position,
            Size size,
            String type,
            List<NodeHandle> handles,
            Map<String, dynamic> data,
            bool isSelected,
            bool isDraggable,
            bool isSelectable)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowNode() when $default != null:
        return $default(
            _that.id,
            _that.position,
            _that.size,
            _that.type,
            _that.handles,
            _that.data,
            _that.isSelected,
            _that.isDraggable,
            _that.isSelectable);
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
            String id,
            Offset position,
            Size size,
            String type,
            List<NodeHandle> handles,
            Map<String, dynamic> data,
            bool isSelected,
            bool isDraggable,
            bool isSelectable)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowNode():
        return $default(
            _that.id,
            _that.position,
            _that.size,
            _that.type,
            _that.handles,
            _that.data,
            _that.isSelected,
            _that.isDraggable,
            _that.isSelectable);
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
            String id,
            Offset position,
            Size size,
            String type,
            List<NodeHandle> handles,
            Map<String, dynamic> data,
            bool isSelected,
            bool isDraggable,
            bool isSelectable)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowNode() when $default != null:
        return $default(
            _that.id,
            _that.position,
            _that.size,
            _that.type,
            _that.handles,
            _that.data,
            _that.isSelected,
            _that.isDraggable,
            _that.isSelectable);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowNode extends FlowNode {
  const _FlowNode(
      {required this.id,
      required this.position,
      required this.size,
      required this.type,
      final List<NodeHandle> handles = const [],
      final Map<String, dynamic> data = const {},
      this.isSelected = false,
      this.isDraggable = true,
      this.isSelectable = true})
      : _handles = handles,
        _data = data,
        super._();

  @override
  final String id;
  @override
  final Offset position;
  @override
  final Size size;
  @override
  final String type;
  final List<NodeHandle> _handles;
  @override
  @JsonKey()
  List<NodeHandle> get handles {
    if (_handles is EqualUnmodifiableListView) return _handles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_handles);
  }

  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey()
  final bool isSelected;
// Interaction configuration
  @override
  @JsonKey()
  final bool isDraggable;
  @override
  @JsonKey()
  final bool isSelectable;

  /// Create a copy of FlowNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FlowNodeCopyWith<_FlowNode> get copyWith =>
      __$FlowNodeCopyWithImpl<_FlowNode>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlowNode &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._handles, _handles) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isDraggable, isDraggable) ||
                other.isDraggable == isDraggable) &&
            (identical(other.isSelectable, isSelectable) ||
                other.isSelectable == isSelectable));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      position,
      size,
      type,
      const DeepCollectionEquality().hash(_handles),
      const DeepCollectionEquality().hash(_data),
      isSelected,
      isDraggable,
      isSelectable);

  @override
  String toString() {
    return 'FlowNode(id: $id, position: $position, size: $size, type: $type, handles: $handles, data: $data, isSelected: $isSelected, isDraggable: $isDraggable, isSelectable: $isSelectable)';
  }
}

/// @nodoc
abstract mixin class _$FlowNodeCopyWith<$Res>
    implements $FlowNodeCopyWith<$Res> {
  factory _$FlowNodeCopyWith(_FlowNode value, $Res Function(_FlowNode) _then) =
      __$FlowNodeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      Offset position,
      Size size,
      String type,
      List<NodeHandle> handles,
      Map<String, dynamic> data,
      bool isSelected,
      bool isDraggable,
      bool isSelectable});
}

/// @nodoc
class __$FlowNodeCopyWithImpl<$Res> implements _$FlowNodeCopyWith<$Res> {
  __$FlowNodeCopyWithImpl(this._self, this._then);

  final _FlowNode _self;
  final $Res Function(_FlowNode) _then;

  /// Create a copy of FlowNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? size = null,
    Object? type = null,
    Object? handles = null,
    Object? data = null,
    Object? isSelected = null,
    Object? isDraggable = null,
    Object? isSelectable = null,
  }) {
    return _then(_FlowNode(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      handles: null == handles
          ? _self._handles
          : handles // ignore: cast_nullable_to_non_nullable
              as List<NodeHandle>,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isDraggable: null == isDraggable
          ? _self.isDraggable
          : isDraggable // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelectable: null == isSelectable
          ? _self.isSelectable
          : isSelectable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on

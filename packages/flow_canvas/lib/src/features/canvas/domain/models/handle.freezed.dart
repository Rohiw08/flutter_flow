// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'handle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NodeHandle {
  String get id;
  HandleType get type;
  Offset get position;
  bool get isConnectable;
  Size get size;

  /// Create a copy of NodeHandle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NodeHandleCopyWith<NodeHandle> get copyWith =>
      _$NodeHandleCopyWithImpl<NodeHandle>(this as NodeHandle, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NodeHandle &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.isConnectable, isConnectable) ||
                other.isConnectable == isConnectable) &&
            (identical(other.size, size) || other.size == size));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, position, isConnectable, size);

  @override
  String toString() {
    return 'NodeHandle(id: $id, type: $type, position: $position, isConnectable: $isConnectable, size: $size)';
  }
}

/// @nodoc
abstract mixin class $NodeHandleCopyWith<$Res> {
  factory $NodeHandleCopyWith(
          NodeHandle value, $Res Function(NodeHandle) _then) =
      _$NodeHandleCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      HandleType type,
      Offset position,
      bool isConnectable,
      Size size});
}

/// @nodoc
class _$NodeHandleCopyWithImpl<$Res> implements $NodeHandleCopyWith<$Res> {
  _$NodeHandleCopyWithImpl(this._self, this._then);

  final NodeHandle _self;
  final $Res Function(NodeHandle) _then;

  /// Create a copy of NodeHandle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? position = null,
    Object? isConnectable = null,
    Object? size = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as HandleType,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      isConnectable: null == isConnectable
          ? _self.isConnectable
          : isConnectable // ignore: cast_nullable_to_non_nullable
              as bool,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
    ));
  }
}

/// Adds pattern-matching-related methods to [NodeHandle].
extension NodeHandlePatterns on NodeHandle {
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
    TResult Function(_NodeHandle value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NodeHandle() when $default != null:
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
    TResult Function(_NodeHandle value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NodeHandle():
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
    TResult? Function(_NodeHandle value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NodeHandle() when $default != null:
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
    TResult Function(String id, HandleType type, Offset position,
            bool isConnectable, Size size)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NodeHandle() when $default != null:
        return $default(_that.id, _that.type, _that.position,
            _that.isConnectable, _that.size);
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
    TResult Function(String id, HandleType type, Offset position,
            bool isConnectable, Size size)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NodeHandle():
        return $default(_that.id, _that.type, _that.position,
            _that.isConnectable, _that.size);
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
    TResult? Function(String id, HandleType type, Offset position,
            bool isConnectable, Size size)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NodeHandle() when $default != null:
        return $default(_that.id, _that.type, _that.position,
            _that.isConnectable, _that.size);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _NodeHandle extends NodeHandle {
  const _NodeHandle(
      {required this.id,
      required this.type,
      required this.position,
      this.isConnectable = true,
      this.size = const Size(10, 10)})
      : super._();

  @override
  final String id;
  @override
  final HandleType type;
  @override
  final Offset position;
  @override
  @JsonKey()
  final bool isConnectable;
  @override
  @JsonKey()
  final Size size;

  /// Create a copy of NodeHandle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NodeHandleCopyWith<_NodeHandle> get copyWith =>
      __$NodeHandleCopyWithImpl<_NodeHandle>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NodeHandle &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.isConnectable, isConnectable) ||
                other.isConnectable == isConnectable) &&
            (identical(other.size, size) || other.size == size));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, position, isConnectable, size);

  @override
  String toString() {
    return 'NodeHandle(id: $id, type: $type, position: $position, isConnectable: $isConnectable, size: $size)';
  }
}

/// @nodoc
abstract mixin class _$NodeHandleCopyWith<$Res>
    implements $NodeHandleCopyWith<$Res> {
  factory _$NodeHandleCopyWith(
          _NodeHandle value, $Res Function(_NodeHandle) _then) =
      __$NodeHandleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      HandleType type,
      Offset position,
      bool isConnectable,
      Size size});
}

/// @nodoc
class __$NodeHandleCopyWithImpl<$Res> implements _$NodeHandleCopyWith<$Res> {
  __$NodeHandleCopyWithImpl(this._self, this._then);

  final _NodeHandle _self;
  final $Res Function(_NodeHandle) _then;

  /// Create a copy of NodeHandle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? position = null,
    Object? isConnectable = null,
    Object? size = null,
  }) {
    return _then(_NodeHandle(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as HandleType,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      isConnectable: null == isConnectable
          ? _self.isConnectable
          : isConnectable // ignore: cast_nullable_to_non_nullable
              as bool,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
    ));
  }
}

// dart format on

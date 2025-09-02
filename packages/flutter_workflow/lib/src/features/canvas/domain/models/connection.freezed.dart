// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Connection {
  String get sourceNodeId;
  String get sourceHandleId;
  String get targetNodeId;
  String get targetHandleId;

  /// Create a copy of Connection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConnectionCopyWith<Connection> get copyWith =>
      _$ConnectionCopyWithImpl<Connection>(this as Connection, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Connection &&
            (identical(other.sourceNodeId, sourceNodeId) ||
                other.sourceNodeId == sourceNodeId) &&
            (identical(other.sourceHandleId, sourceHandleId) ||
                other.sourceHandleId == sourceHandleId) &&
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.targetHandleId, targetHandleId) ||
                other.targetHandleId == targetHandleId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, sourceNodeId, sourceHandleId, targetNodeId, targetHandleId);

  @override
  String toString() {
    return 'Connection(sourceNodeId: $sourceNodeId, sourceHandleId: $sourceHandleId, targetNodeId: $targetNodeId, targetHandleId: $targetHandleId)';
  }
}

/// @nodoc
abstract mixin class $ConnectionCopyWith<$Res> {
  factory $ConnectionCopyWith(
          Connection value, $Res Function(Connection) _then) =
      _$ConnectionCopyWithImpl;
  @useResult
  $Res call(
      {String sourceNodeId,
      String sourceHandleId,
      String targetNodeId,
      String targetHandleId});
}

/// @nodoc
class _$ConnectionCopyWithImpl<$Res> implements $ConnectionCopyWith<$Res> {
  _$ConnectionCopyWithImpl(this._self, this._then);

  final Connection _self;
  final $Res Function(Connection) _then;

  /// Create a copy of Connection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceNodeId = null,
    Object? sourceHandleId = null,
    Object? targetNodeId = null,
    Object? targetHandleId = null,
  }) {
    return _then(_self.copyWith(
      sourceNodeId: null == sourceNodeId
          ? _self.sourceNodeId
          : sourceNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceHandleId: null == sourceHandleId
          ? _self.sourceHandleId
          : sourceHandleId // ignore: cast_nullable_to_non_nullable
              as String,
      targetNodeId: null == targetNodeId
          ? _self.targetNodeId
          : targetNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      targetHandleId: null == targetHandleId
          ? _self.targetHandleId
          : targetHandleId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Connection].
extension ConnectionPatterns on Connection {
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
    TResult Function(_Connection value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Connection() when $default != null:
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
    TResult Function(_Connection value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Connection():
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
    TResult? Function(_Connection value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Connection() when $default != null:
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
    TResult Function(String sourceNodeId, String sourceHandleId,
            String targetNodeId, String targetHandleId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Connection() when $default != null:
        return $default(_that.sourceNodeId, _that.sourceHandleId,
            _that.targetNodeId, _that.targetHandleId);
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
    TResult Function(String sourceNodeId, String sourceHandleId,
            String targetNodeId, String targetHandleId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Connection():
        return $default(_that.sourceNodeId, _that.sourceHandleId,
            _that.targetNodeId, _that.targetHandleId);
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
    TResult? Function(String sourceNodeId, String sourceHandleId,
            String targetNodeId, String targetHandleId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Connection() when $default != null:
        return $default(_that.sourceNodeId, _that.sourceHandleId,
            _that.targetNodeId, _that.targetHandleId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Connection implements Connection {
  const _Connection(
      {required this.sourceNodeId,
      required this.sourceHandleId,
      required this.targetNodeId,
      required this.targetHandleId});

  @override
  final String sourceNodeId;
  @override
  final String sourceHandleId;
  @override
  final String targetNodeId;
  @override
  final String targetHandleId;

  /// Create a copy of Connection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConnectionCopyWith<_Connection> get copyWith =>
      __$ConnectionCopyWithImpl<_Connection>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Connection &&
            (identical(other.sourceNodeId, sourceNodeId) ||
                other.sourceNodeId == sourceNodeId) &&
            (identical(other.sourceHandleId, sourceHandleId) ||
                other.sourceHandleId == sourceHandleId) &&
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.targetHandleId, targetHandleId) ||
                other.targetHandleId == targetHandleId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, sourceNodeId, sourceHandleId, targetNodeId, targetHandleId);

  @override
  String toString() {
    return 'Connection(sourceNodeId: $sourceNodeId, sourceHandleId: $sourceHandleId, targetNodeId: $targetNodeId, targetHandleId: $targetHandleId)';
  }
}

/// @nodoc
abstract mixin class _$ConnectionCopyWith<$Res>
    implements $ConnectionCopyWith<$Res> {
  factory _$ConnectionCopyWith(
          _Connection value, $Res Function(_Connection) _then) =
      __$ConnectionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String sourceNodeId,
      String sourceHandleId,
      String targetNodeId,
      String targetHandleId});
}

/// @nodoc
class __$ConnectionCopyWithImpl<$Res> implements _$ConnectionCopyWith<$Res> {
  __$ConnectionCopyWithImpl(this._self, this._then);

  final _Connection _self;
  final $Res Function(_Connection) _then;

  /// Create a copy of Connection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sourceNodeId = null,
    Object? sourceHandleId = null,
    Object? targetNodeId = null,
    Object? targetHandleId = null,
  }) {
    return _then(_Connection(
      sourceNodeId: null == sourceNodeId
          ? _self.sourceNodeId
          : sourceNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceHandleId: null == sourceHandleId
          ? _self.sourceHandleId
          : sourceHandleId // ignore: cast_nullable_to_non_nullable
              as String,
      targetNodeId: null == targetNodeId
          ? _self.targetNodeId
          : targetNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      targetHandleId: null == targetHandleId
          ? _self.targetHandleId
          : targetHandleId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

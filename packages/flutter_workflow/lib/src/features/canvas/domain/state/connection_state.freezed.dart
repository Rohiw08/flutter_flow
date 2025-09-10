// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlowConnectionState {
  String get fromNodeId;
  String get fromHandleId;
  Offset get startPosition;
  Offset get endPosition;
  String? get targetNodeId;
  String? get targetHandleId;
  bool get isValid;

  /// Create a copy of FlowConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlowConnectionStateCopyWith<FlowConnectionState> get copyWith =>
      _$FlowConnectionStateCopyWithImpl<FlowConnectionState>(
          this as FlowConnectionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlowConnectionState &&
            (identical(other.fromNodeId, fromNodeId) ||
                other.fromNodeId == fromNodeId) &&
            (identical(other.fromHandleId, fromHandleId) ||
                other.fromHandleId == fromHandleId) &&
            (identical(other.startPosition, startPosition) ||
                other.startPosition == startPosition) &&
            (identical(other.endPosition, endPosition) ||
                other.endPosition == endPosition) &&
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.targetHandleId, targetHandleId) ||
                other.targetHandleId == targetHandleId) &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fromNodeId, fromHandleId,
      startPosition, endPosition, targetNodeId, targetHandleId, isValid);

  @override
  String toString() {
    return 'FlowConnectionState(fromNodeId: $fromNodeId, fromHandleId: $fromHandleId, startPosition: $startPosition, endPosition: $endPosition, targetNodeId: $targetNodeId, targetHandleId: $targetHandleId, isValid: $isValid)';
  }
}

/// @nodoc
abstract mixin class $FlowConnectionStateCopyWith<$Res> {
  factory $FlowConnectionStateCopyWith(
          FlowConnectionState value, $Res Function(FlowConnectionState) _then) =
      _$FlowConnectionStateCopyWithImpl;
  @useResult
  $Res call(
      {String fromNodeId,
      String fromHandleId,
      Offset startPosition,
      Offset endPosition,
      String? targetNodeId,
      String? targetHandleId,
      bool isValid});
}

/// @nodoc
class _$FlowConnectionStateCopyWithImpl<$Res>
    implements $FlowConnectionStateCopyWith<$Res> {
  _$FlowConnectionStateCopyWithImpl(this._self, this._then);

  final FlowConnectionState _self;
  final $Res Function(FlowConnectionState) _then;

  /// Create a copy of FlowConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromNodeId = null,
    Object? fromHandleId = null,
    Object? startPosition = null,
    Object? endPosition = null,
    Object? targetNodeId = freezed,
    Object? targetHandleId = freezed,
    Object? isValid = null,
  }) {
    return _then(_self.copyWith(
      fromNodeId: null == fromNodeId
          ? _self.fromNodeId
          : fromNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      fromHandleId: null == fromHandleId
          ? _self.fromHandleId
          : fromHandleId // ignore: cast_nullable_to_non_nullable
              as String,
      startPosition: null == startPosition
          ? _self.startPosition
          : startPosition // ignore: cast_nullable_to_non_nullable
              as Offset,
      endPosition: null == endPosition
          ? _self.endPosition
          : endPosition // ignore: cast_nullable_to_non_nullable
              as Offset,
      targetNodeId: freezed == targetNodeId
          ? _self.targetNodeId
          : targetNodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHandleId: freezed == targetHandleId
          ? _self.targetHandleId
          : targetHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: null == isValid
          ? _self.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [FlowConnectionState].
extension FlowConnectionStatePatterns on FlowConnectionState {
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
    TResult Function(_FlowConnectionState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionState() when $default != null:
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
    TResult Function(_FlowConnectionState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionState():
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
    TResult? Function(_FlowConnectionState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionState() when $default != null:
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
            String fromNodeId,
            String fromHandleId,
            Offset startPosition,
            Offset endPosition,
            String? targetNodeId,
            String? targetHandleId,
            bool isValid)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionState() when $default != null:
        return $default(
            _that.fromNodeId,
            _that.fromHandleId,
            _that.startPosition,
            _that.endPosition,
            _that.targetNodeId,
            _that.targetHandleId,
            _that.isValid);
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
            String fromNodeId,
            String fromHandleId,
            Offset startPosition,
            Offset endPosition,
            String? targetNodeId,
            String? targetHandleId,
            bool isValid)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionState():
        return $default(
            _that.fromNodeId,
            _that.fromHandleId,
            _that.startPosition,
            _that.endPosition,
            _that.targetNodeId,
            _that.targetHandleId,
            _that.isValid);
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
            String fromNodeId,
            String fromHandleId,
            Offset startPosition,
            Offset endPosition,
            String? targetNodeId,
            String? targetHandleId,
            bool isValid)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionState() when $default != null:
        return $default(
            _that.fromNodeId,
            _that.fromHandleId,
            _that.startPosition,
            _that.endPosition,
            _that.targetNodeId,
            _that.targetHandleId,
            _that.isValid);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowConnectionState implements FlowConnectionState {
  const _FlowConnectionState(
      {required this.fromNodeId,
      required this.fromHandleId,
      required this.startPosition,
      required this.endPosition,
      this.targetNodeId,
      this.targetHandleId,
      this.isValid = false});

  @override
  final String fromNodeId;
  @override
  final String fromHandleId;
  @override
  final Offset startPosition;
  @override
  final Offset endPosition;
  @override
  final String? targetNodeId;
  @override
  final String? targetHandleId;
  @override
  @JsonKey()
  final bool isValid;

  /// Create a copy of FlowConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FlowConnectionStateCopyWith<_FlowConnectionState> get copyWith =>
      __$FlowConnectionStateCopyWithImpl<_FlowConnectionState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlowConnectionState &&
            (identical(other.fromNodeId, fromNodeId) ||
                other.fromNodeId == fromNodeId) &&
            (identical(other.fromHandleId, fromHandleId) ||
                other.fromHandleId == fromHandleId) &&
            (identical(other.startPosition, startPosition) ||
                other.startPosition == startPosition) &&
            (identical(other.endPosition, endPosition) ||
                other.endPosition == endPosition) &&
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.targetHandleId, targetHandleId) ||
                other.targetHandleId == targetHandleId) &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fromNodeId, fromHandleId,
      startPosition, endPosition, targetNodeId, targetHandleId, isValid);

  @override
  String toString() {
    return 'FlowConnectionState(fromNodeId: $fromNodeId, fromHandleId: $fromHandleId, startPosition: $startPosition, endPosition: $endPosition, targetNodeId: $targetNodeId, targetHandleId: $targetHandleId, isValid: $isValid)';
  }
}

/// @nodoc
abstract mixin class _$FlowConnectionStateCopyWith<$Res>
    implements $FlowConnectionStateCopyWith<$Res> {
  factory _$FlowConnectionStateCopyWith(_FlowConnectionState value,
          $Res Function(_FlowConnectionState) _then) =
      __$FlowConnectionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String fromNodeId,
      String fromHandleId,
      Offset startPosition,
      Offset endPosition,
      String? targetNodeId,
      String? targetHandleId,
      bool isValid});
}

/// @nodoc
class __$FlowConnectionStateCopyWithImpl<$Res>
    implements _$FlowConnectionStateCopyWith<$Res> {
  __$FlowConnectionStateCopyWithImpl(this._self, this._then);

  final _FlowConnectionState _self;
  final $Res Function(_FlowConnectionState) _then;

  /// Create a copy of FlowConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fromNodeId = null,
    Object? fromHandleId = null,
    Object? startPosition = null,
    Object? endPosition = null,
    Object? targetNodeId = freezed,
    Object? targetHandleId = freezed,
    Object? isValid = null,
  }) {
    return _then(_FlowConnectionState(
      fromNodeId: null == fromNodeId
          ? _self.fromNodeId
          : fromNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      fromHandleId: null == fromHandleId
          ? _self.fromHandleId
          : fromHandleId // ignore: cast_nullable_to_non_nullable
              as String,
      startPosition: null == startPosition
          ? _self.startPosition
          : startPosition // ignore: cast_nullable_to_non_nullable
              as Offset,
      endPosition: null == endPosition
          ? _self.endPosition
          : endPosition // ignore: cast_nullable_to_non_nullable
              as Offset,
      targetNodeId: freezed == targetNodeId
          ? _self.targetNodeId
          : targetNodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHandleId: freezed == targetHandleId
          ? _self.targetHandleId
          : targetHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: null == isValid
          ? _self.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on

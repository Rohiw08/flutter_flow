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
mixin _$FlowConnectionRuntimeState {
  bool get isAnimating;
  bool get isValid;

  /// Create a copy of FlowConnectionRuntimeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlowConnectionRuntimeStateCopyWith<FlowConnectionRuntimeState>
      get copyWith =>
          _$FlowConnectionRuntimeStateCopyWithImpl<FlowConnectionRuntimeState>(
              this as FlowConnectionRuntimeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlowConnectionRuntimeState &&
            (identical(other.isAnimating, isAnimating) ||
                other.isAnimating == isAnimating) &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isAnimating, isValid);

  @override
  String toString() {
    return 'FlowConnectionRuntimeState(isAnimating: $isAnimating, isValid: $isValid)';
  }
}

/// @nodoc
abstract mixin class $FlowConnectionRuntimeStateCopyWith<$Res> {
  factory $FlowConnectionRuntimeStateCopyWith(FlowConnectionRuntimeState value,
          $Res Function(FlowConnectionRuntimeState) _then) =
      _$FlowConnectionRuntimeStateCopyWithImpl;
  @useResult
  $Res call({bool isAnimating, bool isValid});
}

/// @nodoc
class _$FlowConnectionRuntimeStateCopyWithImpl<$Res>
    implements $FlowConnectionRuntimeStateCopyWith<$Res> {
  _$FlowConnectionRuntimeStateCopyWithImpl(this._self, this._then);

  final FlowConnectionRuntimeState _self;
  final $Res Function(FlowConnectionRuntimeState) _then;

  /// Create a copy of FlowConnectionRuntimeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAnimating = null,
    Object? isValid = null,
  }) {
    return _then(_self.copyWith(
      isAnimating: null == isAnimating
          ? _self.isAnimating
          : isAnimating // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _self.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [FlowConnectionRuntimeState].
extension FlowConnectionRuntimeStatePatterns on FlowConnectionRuntimeState {
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
    TResult Function(_FlowConnectionRuntimeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionRuntimeState() when $default != null:
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
    TResult Function(_FlowConnectionRuntimeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionRuntimeState():
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
    TResult? Function(_FlowConnectionRuntimeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionRuntimeState() when $default != null:
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
    TResult Function(bool isAnimating, bool isValid)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionRuntimeState() when $default != null:
        return $default(_that.isAnimating, _that.isValid);
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
    TResult Function(bool isAnimating, bool isValid) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionRuntimeState():
        return $default(_that.isAnimating, _that.isValid);
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
    TResult? Function(bool isAnimating, bool isValid)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnectionRuntimeState() when $default != null:
        return $default(_that.isAnimating, _that.isValid);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowConnectionRuntimeState implements FlowConnectionRuntimeState {
  const _FlowConnectionRuntimeState(
      {this.isAnimating = false, this.isValid = false});

  @override
  @JsonKey()
  final bool isAnimating;
  @override
  @JsonKey()
  final bool isValid;

  /// Create a copy of FlowConnectionRuntimeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FlowConnectionRuntimeStateCopyWith<_FlowConnectionRuntimeState>
      get copyWith => __$FlowConnectionRuntimeStateCopyWithImpl<
          _FlowConnectionRuntimeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlowConnectionRuntimeState &&
            (identical(other.isAnimating, isAnimating) ||
                other.isAnimating == isAnimating) &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isAnimating, isValid);

  @override
  String toString() {
    return 'FlowConnectionRuntimeState(isAnimating: $isAnimating, isValid: $isValid)';
  }
}

/// @nodoc
abstract mixin class _$FlowConnectionRuntimeStateCopyWith<$Res>
    implements $FlowConnectionRuntimeStateCopyWith<$Res> {
  factory _$FlowConnectionRuntimeStateCopyWith(
          _FlowConnectionRuntimeState value,
          $Res Function(_FlowConnectionRuntimeState) _then) =
      __$FlowConnectionRuntimeStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isAnimating, bool isValid});
}

/// @nodoc
class __$FlowConnectionRuntimeStateCopyWithImpl<$Res>
    implements _$FlowConnectionRuntimeStateCopyWith<$Res> {
  __$FlowConnectionRuntimeStateCopyWithImpl(this._self, this._then);

  final _FlowConnectionRuntimeState _self;
  final $Res Function(_FlowConnectionRuntimeState) _then;

  /// Create a copy of FlowConnectionRuntimeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isAnimating = null,
    Object? isValid = null,
  }) {
    return _then(_FlowConnectionRuntimeState(
      isAnimating: null == isAnimating
          ? _self.isAnimating
          : isAnimating // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _self.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on

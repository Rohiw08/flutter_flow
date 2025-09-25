// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'handle_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HandleRuntimeState {
// Visual states
  bool get isHovered;
  bool get isActive; // Currently being used for connection
  bool get isValidTarget; // Valid target for current connection
  bool get isInvalidTarget; // Invalid target for current connection
// Connection state
  int get currentConnections; // Number of current connections
  List<String> get connectedEdgeIds; // IDs of connected edges
// Animation state
  bool get isAnimating;

  /// Create a copy of HandleRuntimeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HandleRuntimeStateCopyWith<HandleRuntimeState> get copyWith =>
      _$HandleRuntimeStateCopyWithImpl<HandleRuntimeState>(
          this as HandleRuntimeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HandleRuntimeState &&
            (identical(other.isHovered, isHovered) ||
                other.isHovered == isHovered) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isValidTarget, isValidTarget) ||
                other.isValidTarget == isValidTarget) &&
            (identical(other.isInvalidTarget, isInvalidTarget) ||
                other.isInvalidTarget == isInvalidTarget) &&
            (identical(other.currentConnections, currentConnections) ||
                other.currentConnections == currentConnections) &&
            const DeepCollectionEquality()
                .equals(other.connectedEdgeIds, connectedEdgeIds) &&
            (identical(other.isAnimating, isAnimating) ||
                other.isAnimating == isAnimating));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isHovered,
      isActive,
      isValidTarget,
      isInvalidTarget,
      currentConnections,
      const DeepCollectionEquality().hash(connectedEdgeIds),
      isAnimating);

  @override
  String toString() {
    return 'HandleRuntimeState(isHovered: $isHovered, isActive: $isActive, isValidTarget: $isValidTarget, isInvalidTarget: $isInvalidTarget, currentConnections: $currentConnections, connectedEdgeIds: $connectedEdgeIds, isAnimating: $isAnimating)';
  }
}

/// @nodoc
abstract mixin class $HandleRuntimeStateCopyWith<$Res> {
  factory $HandleRuntimeStateCopyWith(
          HandleRuntimeState value, $Res Function(HandleRuntimeState) _then) =
      _$HandleRuntimeStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isHovered,
      bool isActive,
      bool isValidTarget,
      bool isInvalidTarget,
      int currentConnections,
      List<String> connectedEdgeIds,
      bool isAnimating});
}

/// @nodoc
class _$HandleRuntimeStateCopyWithImpl<$Res>
    implements $HandleRuntimeStateCopyWith<$Res> {
  _$HandleRuntimeStateCopyWithImpl(this._self, this._then);

  final HandleRuntimeState _self;
  final $Res Function(HandleRuntimeState) _then;

  /// Create a copy of HandleRuntimeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isHovered = null,
    Object? isActive = null,
    Object? isValidTarget = null,
    Object? isInvalidTarget = null,
    Object? currentConnections = null,
    Object? connectedEdgeIds = null,
    Object? isAnimating = null,
  }) {
    return _then(_self.copyWith(
      isHovered: null == isHovered
          ? _self.isHovered
          : isHovered // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidTarget: null == isValidTarget
          ? _self.isValidTarget
          : isValidTarget // ignore: cast_nullable_to_non_nullable
              as bool,
      isInvalidTarget: null == isInvalidTarget
          ? _self.isInvalidTarget
          : isInvalidTarget // ignore: cast_nullable_to_non_nullable
              as bool,
      currentConnections: null == currentConnections
          ? _self.currentConnections
          : currentConnections // ignore: cast_nullable_to_non_nullable
              as int,
      connectedEdgeIds: null == connectedEdgeIds
          ? _self.connectedEdgeIds
          : connectedEdgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAnimating: null == isAnimating
          ? _self.isAnimating
          : isAnimating // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [HandleRuntimeState].
extension HandleRuntimeStatePatterns on HandleRuntimeState {
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
    TResult Function(_HandleRuntimeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HandleRuntimeState() when $default != null:
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
    TResult Function(_HandleRuntimeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HandleRuntimeState():
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
    TResult? Function(_HandleRuntimeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HandleRuntimeState() when $default != null:
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
            bool isHovered,
            bool isActive,
            bool isValidTarget,
            bool isInvalidTarget,
            int currentConnections,
            List<String> connectedEdgeIds,
            bool isAnimating)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HandleRuntimeState() when $default != null:
        return $default(
            _that.isHovered,
            _that.isActive,
            _that.isValidTarget,
            _that.isInvalidTarget,
            _that.currentConnections,
            _that.connectedEdgeIds,
            _that.isAnimating);
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
            bool isHovered,
            bool isActive,
            bool isValidTarget,
            bool isInvalidTarget,
            int currentConnections,
            List<String> connectedEdgeIds,
            bool isAnimating)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HandleRuntimeState():
        return $default(
            _that.isHovered,
            _that.isActive,
            _that.isValidTarget,
            _that.isInvalidTarget,
            _that.currentConnections,
            _that.connectedEdgeIds,
            _that.isAnimating);
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
            bool isHovered,
            bool isActive,
            bool isValidTarget,
            bool isInvalidTarget,
            int currentConnections,
            List<String> connectedEdgeIds,
            bool isAnimating)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HandleRuntimeState() when $default != null:
        return $default(
            _that.isHovered,
            _that.isActive,
            _that.isValidTarget,
            _that.isInvalidTarget,
            _that.currentConnections,
            _that.connectedEdgeIds,
            _that.isAnimating);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HandleRuntimeState implements HandleRuntimeState {
  const _HandleRuntimeState(
      {this.isHovered = false,
      this.isActive = false,
      this.isValidTarget = false,
      this.isInvalidTarget = false,
      this.currentConnections = 0,
      final List<String> connectedEdgeIds = const [],
      this.isAnimating = false})
      : _connectedEdgeIds = connectedEdgeIds;

// Visual states
  @override
  @JsonKey()
  final bool isHovered;
  @override
  @JsonKey()
  final bool isActive;
// Currently being used for connection
  @override
  @JsonKey()
  final bool isValidTarget;
// Valid target for current connection
  @override
  @JsonKey()
  final bool isInvalidTarget;
// Invalid target for current connection
// Connection state
  @override
  @JsonKey()
  final int currentConnections;
// Number of current connections
  final List<String> _connectedEdgeIds;
// Number of current connections
  @override
  @JsonKey()
  List<String> get connectedEdgeIds {
    if (_connectedEdgeIds is EqualUnmodifiableListView)
      return _connectedEdgeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connectedEdgeIds);
  }

// IDs of connected edges
// Animation state
  @override
  @JsonKey()
  final bool isAnimating;

  /// Create a copy of HandleRuntimeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HandleRuntimeStateCopyWith<_HandleRuntimeState> get copyWith =>
      __$HandleRuntimeStateCopyWithImpl<_HandleRuntimeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HandleRuntimeState &&
            (identical(other.isHovered, isHovered) ||
                other.isHovered == isHovered) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isValidTarget, isValidTarget) ||
                other.isValidTarget == isValidTarget) &&
            (identical(other.isInvalidTarget, isInvalidTarget) ||
                other.isInvalidTarget == isInvalidTarget) &&
            (identical(other.currentConnections, currentConnections) ||
                other.currentConnections == currentConnections) &&
            const DeepCollectionEquality()
                .equals(other._connectedEdgeIds, _connectedEdgeIds) &&
            (identical(other.isAnimating, isAnimating) ||
                other.isAnimating == isAnimating));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isHovered,
      isActive,
      isValidTarget,
      isInvalidTarget,
      currentConnections,
      const DeepCollectionEquality().hash(_connectedEdgeIds),
      isAnimating);

  @override
  String toString() {
    return 'HandleRuntimeState(isHovered: $isHovered, isActive: $isActive, isValidTarget: $isValidTarget, isInvalidTarget: $isInvalidTarget, currentConnections: $currentConnections, connectedEdgeIds: $connectedEdgeIds, isAnimating: $isAnimating)';
  }
}

/// @nodoc
abstract mixin class _$HandleRuntimeStateCopyWith<$Res>
    implements $HandleRuntimeStateCopyWith<$Res> {
  factory _$HandleRuntimeStateCopyWith(
          _HandleRuntimeState value, $Res Function(_HandleRuntimeState) _then) =
      __$HandleRuntimeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isHovered,
      bool isActive,
      bool isValidTarget,
      bool isInvalidTarget,
      int currentConnections,
      List<String> connectedEdgeIds,
      bool isAnimating});
}

/// @nodoc
class __$HandleRuntimeStateCopyWithImpl<$Res>
    implements _$HandleRuntimeStateCopyWith<$Res> {
  __$HandleRuntimeStateCopyWithImpl(this._self, this._then);

  final _HandleRuntimeState _self;
  final $Res Function(_HandleRuntimeState) _then;

  /// Create a copy of HandleRuntimeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isHovered = null,
    Object? isActive = null,
    Object? isValidTarget = null,
    Object? isInvalidTarget = null,
    Object? currentConnections = null,
    Object? connectedEdgeIds = null,
    Object? isAnimating = null,
  }) {
    return _then(_HandleRuntimeState(
      isHovered: null == isHovered
          ? _self.isHovered
          : isHovered // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidTarget: null == isValidTarget
          ? _self.isValidTarget
          : isValidTarget // ignore: cast_nullable_to_non_nullable
              as bool,
      isInvalidTarget: null == isInvalidTarget
          ? _self.isInvalidTarget
          : isInvalidTarget // ignore: cast_nullable_to_non_nullable
              as bool,
      currentConnections: null == currentConnections
          ? _self.currentConnections
          : currentConnections // ignore: cast_nullable_to_non_nullable
              as int,
      connectedEdgeIds: null == connectedEdgeIds
          ? _self._connectedEdgeIds
          : connectedEdgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAnimating: null == isAnimating
          ? _self.isAnimating
          : isAnimating // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on

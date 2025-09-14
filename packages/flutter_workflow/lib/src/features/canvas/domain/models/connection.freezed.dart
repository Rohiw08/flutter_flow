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
mixin _$FlowConnection {
  String get id;
  String get type;
  Offset get startPoint;
  Offset get endPoint;
  String? get fromNodeId;
  String? get fromHandleId;
  String? get toNodeId;
  String? get toHandleId;
  int get zIndex;
  FlowConnectionStyle? get connectionStyle;
  EdgeMarkerStyle? get startMarker;
  EdgeMarkerStyle? get endMarker;

  /// Create a copy of FlowConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlowConnectionCopyWith<FlowConnection> get copyWith =>
      _$FlowConnectionCopyWithImpl<FlowConnection>(
          this as FlowConnection, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlowConnection &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startPoint, startPoint) ||
                other.startPoint == startPoint) &&
            (identical(other.endPoint, endPoint) ||
                other.endPoint == endPoint) &&
            (identical(other.fromNodeId, fromNodeId) ||
                other.fromNodeId == fromNodeId) &&
            (identical(other.fromHandleId, fromHandleId) ||
                other.fromHandleId == fromHandleId) &&
            (identical(other.toNodeId, toNodeId) ||
                other.toNodeId == toNodeId) &&
            (identical(other.toHandleId, toHandleId) ||
                other.toHandleId == toHandleId) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.connectionStyle, connectionStyle) ||
                other.connectionStyle == connectionStyle) &&
            (identical(other.startMarker, startMarker) ||
                other.startMarker == startMarker) &&
            (identical(other.endMarker, endMarker) ||
                other.endMarker == endMarker));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      startPoint,
      endPoint,
      fromNodeId,
      fromHandleId,
      toNodeId,
      toHandleId,
      zIndex,
      connectionStyle,
      startMarker,
      endMarker);

  @override
  String toString() {
    return 'FlowConnection(id: $id, type: $type, startPoint: $startPoint, endPoint: $endPoint, fromNodeId: $fromNodeId, fromHandleId: $fromHandleId, toNodeId: $toNodeId, toHandleId: $toHandleId, zIndex: $zIndex, connectionStyle: $connectionStyle, startMarker: $startMarker, endMarker: $endMarker)';
  }
}

/// @nodoc
abstract mixin class $FlowConnectionCopyWith<$Res> {
  factory $FlowConnectionCopyWith(
          FlowConnection value, $Res Function(FlowConnection) _then) =
      _$FlowConnectionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String type,
      Offset startPoint,
      Offset endPoint,
      String? fromNodeId,
      String? fromHandleId,
      String? toNodeId,
      String? toHandleId,
      int zIndex,
      FlowConnectionStyle? connectionStyle,
      EdgeMarkerStyle? startMarker,
      EdgeMarkerStyle? endMarker});
}

/// @nodoc
class _$FlowConnectionCopyWithImpl<$Res>
    implements $FlowConnectionCopyWith<$Res> {
  _$FlowConnectionCopyWithImpl(this._self, this._then);

  final FlowConnection _self;
  final $Res Function(FlowConnection) _then;

  /// Create a copy of FlowConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? startPoint = null,
    Object? endPoint = null,
    Object? fromNodeId = freezed,
    Object? fromHandleId = freezed,
    Object? toNodeId = freezed,
    Object? toHandleId = freezed,
    Object? zIndex = null,
    Object? connectionStyle = freezed,
    Object? startMarker = freezed,
    Object? endMarker = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      startPoint: null == startPoint
          ? _self.startPoint
          : startPoint // ignore: cast_nullable_to_non_nullable
              as Offset,
      endPoint: null == endPoint
          ? _self.endPoint
          : endPoint // ignore: cast_nullable_to_non_nullable
              as Offset,
      fromNodeId: freezed == fromNodeId
          ? _self.fromNodeId
          : fromNodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromHandleId: freezed == fromHandleId
          ? _self.fromHandleId
          : fromHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      toNodeId: freezed == toNodeId
          ? _self.toNodeId
          : toNodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      toHandleId: freezed == toHandleId
          ? _self.toHandleId
          : toHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      connectionStyle: freezed == connectionStyle
          ? _self.connectionStyle
          : connectionStyle // ignore: cast_nullable_to_non_nullable
              as FlowConnectionStyle?,
      startMarker: freezed == startMarker
          ? _self.startMarker
          : startMarker // ignore: cast_nullable_to_non_nullable
              as EdgeMarkerStyle?,
      endMarker: freezed == endMarker
          ? _self.endMarker
          : endMarker // ignore: cast_nullable_to_non_nullable
              as EdgeMarkerStyle?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FlowConnection].
extension FlowConnectionPatterns on FlowConnection {
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
    TResult Function(_FlowConnection value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowConnection() when $default != null:
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
    TResult Function(_FlowConnection value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnection():
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
    TResult? Function(_FlowConnection value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnection() when $default != null:
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
            String type,
            Offset startPoint,
            Offset endPoint,
            String? fromNodeId,
            String? fromHandleId,
            String? toNodeId,
            String? toHandleId,
            int zIndex,
            FlowConnectionStyle? connectionStyle,
            EdgeMarkerStyle? startMarker,
            EdgeMarkerStyle? endMarker)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowConnection() when $default != null:
        return $default(
            _that.id,
            _that.type,
            _that.startPoint,
            _that.endPoint,
            _that.fromNodeId,
            _that.fromHandleId,
            _that.toNodeId,
            _that.toHandleId,
            _that.zIndex,
            _that.connectionStyle,
            _that.startMarker,
            _that.endMarker);
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
            String type,
            Offset startPoint,
            Offset endPoint,
            String? fromNodeId,
            String? fromHandleId,
            String? toNodeId,
            String? toHandleId,
            int zIndex,
            FlowConnectionStyle? connectionStyle,
            EdgeMarkerStyle? startMarker,
            EdgeMarkerStyle? endMarker)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnection():
        return $default(
            _that.id,
            _that.type,
            _that.startPoint,
            _that.endPoint,
            _that.fromNodeId,
            _that.fromHandleId,
            _that.toNodeId,
            _that.toHandleId,
            _that.zIndex,
            _that.connectionStyle,
            _that.startMarker,
            _that.endMarker);
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
            String type,
            Offset startPoint,
            Offset endPoint,
            String? fromNodeId,
            String? fromHandleId,
            String? toNodeId,
            String? toHandleId,
            int zIndex,
            FlowConnectionStyle? connectionStyle,
            EdgeMarkerStyle? startMarker,
            EdgeMarkerStyle? endMarker)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowConnection() when $default != null:
        return $default(
            _that.id,
            _that.type,
            _that.startPoint,
            _that.endPoint,
            _that.fromNodeId,
            _that.fromHandleId,
            _that.toNodeId,
            _that.toHandleId,
            _that.zIndex,
            _that.connectionStyle,
            _that.startMarker,
            _that.endMarker);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowConnection extends FlowConnection {
  const _FlowConnection(
      {required this.id,
      required this.type,
      required this.startPoint,
      required this.endPoint,
      this.fromNodeId,
      this.fromHandleId,
      this.toNodeId,
      this.toHandleId,
      this.zIndex = 0,
      this.connectionStyle,
      this.startMarker,
      this.endMarker})
      : super._();

  @override
  final String id;
  @override
  final String type;
  @override
  final Offset startPoint;
  @override
  final Offset endPoint;
  @override
  final String? fromNodeId;
  @override
  final String? fromHandleId;
  @override
  final String? toNodeId;
  @override
  final String? toHandleId;
  @override
  @JsonKey()
  final int zIndex;
  @override
  final FlowConnectionStyle? connectionStyle;
  @override
  final EdgeMarkerStyle? startMarker;
  @override
  final EdgeMarkerStyle? endMarker;

  /// Create a copy of FlowConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FlowConnectionCopyWith<_FlowConnection> get copyWith =>
      __$FlowConnectionCopyWithImpl<_FlowConnection>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlowConnection &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startPoint, startPoint) ||
                other.startPoint == startPoint) &&
            (identical(other.endPoint, endPoint) ||
                other.endPoint == endPoint) &&
            (identical(other.fromNodeId, fromNodeId) ||
                other.fromNodeId == fromNodeId) &&
            (identical(other.fromHandleId, fromHandleId) ||
                other.fromHandleId == fromHandleId) &&
            (identical(other.toNodeId, toNodeId) ||
                other.toNodeId == toNodeId) &&
            (identical(other.toHandleId, toHandleId) ||
                other.toHandleId == toHandleId) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.connectionStyle, connectionStyle) ||
                other.connectionStyle == connectionStyle) &&
            (identical(other.startMarker, startMarker) ||
                other.startMarker == startMarker) &&
            (identical(other.endMarker, endMarker) ||
                other.endMarker == endMarker));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      startPoint,
      endPoint,
      fromNodeId,
      fromHandleId,
      toNodeId,
      toHandleId,
      zIndex,
      connectionStyle,
      startMarker,
      endMarker);

  @override
  String toString() {
    return 'FlowConnection(id: $id, type: $type, startPoint: $startPoint, endPoint: $endPoint, fromNodeId: $fromNodeId, fromHandleId: $fromHandleId, toNodeId: $toNodeId, toHandleId: $toHandleId, zIndex: $zIndex, connectionStyle: $connectionStyle, startMarker: $startMarker, endMarker: $endMarker)';
  }
}

/// @nodoc
abstract mixin class _$FlowConnectionCopyWith<$Res>
    implements $FlowConnectionCopyWith<$Res> {
  factory _$FlowConnectionCopyWith(
          _FlowConnection value, $Res Function(_FlowConnection) _then) =
      __$FlowConnectionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      Offset startPoint,
      Offset endPoint,
      String? fromNodeId,
      String? fromHandleId,
      String? toNodeId,
      String? toHandleId,
      int zIndex,
      FlowConnectionStyle? connectionStyle,
      EdgeMarkerStyle? startMarker,
      EdgeMarkerStyle? endMarker});
}

/// @nodoc
class __$FlowConnectionCopyWithImpl<$Res>
    implements _$FlowConnectionCopyWith<$Res> {
  __$FlowConnectionCopyWithImpl(this._self, this._then);

  final _FlowConnection _self;
  final $Res Function(_FlowConnection) _then;

  /// Create a copy of FlowConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? startPoint = null,
    Object? endPoint = null,
    Object? fromNodeId = freezed,
    Object? fromHandleId = freezed,
    Object? toNodeId = freezed,
    Object? toHandleId = freezed,
    Object? zIndex = null,
    Object? connectionStyle = freezed,
    Object? startMarker = freezed,
    Object? endMarker = freezed,
  }) {
    return _then(_FlowConnection(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      startPoint: null == startPoint
          ? _self.startPoint
          : startPoint // ignore: cast_nullable_to_non_nullable
              as Offset,
      endPoint: null == endPoint
          ? _self.endPoint
          : endPoint // ignore: cast_nullable_to_non_nullable
              as Offset,
      fromNodeId: freezed == fromNodeId
          ? _self.fromNodeId
          : fromNodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromHandleId: freezed == fromHandleId
          ? _self.fromHandleId
          : fromHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      toNodeId: freezed == toNodeId
          ? _self.toNodeId
          : toNodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      toHandleId: freezed == toHandleId
          ? _self.toHandleId
          : toHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      connectionStyle: freezed == connectionStyle
          ? _self.connectionStyle
          : connectionStyle // ignore: cast_nullable_to_non_nullable
              as FlowConnectionStyle?,
      startMarker: freezed == startMarker
          ? _self.startMarker
          : startMarker // ignore: cast_nullable_to_non_nullable
              as EdgeMarkerStyle?,
      endMarker: freezed == endMarker
          ? _self.endMarker
          : endMarker // ignore: cast_nullable_to_non_nullable
              as EdgeMarkerStyle?,
    ));
  }
}

// dart format on

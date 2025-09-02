// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlowEdge {
  String get id;
  String get sourceNodeId;
  String get sourceHandleId;
  String get targetNodeId;
  String get targetHandleId;

  /// The type of the edge, used to look up a custom painter in the EdgeRegistry.
  String? get type;

  /// The shape of the edge's path.
  EdgePathType get pathType;

  /// A generic data map for any other custom properties.
  Map<String, dynamic>
      get data; // Note: Visual properties like Paint, label styles etc.,
// are best handled in the presentation layer (the painter)
// based on the theme, rather than storing them in the data model.
  String? get label;

  /// Create a copy of FlowEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlowEdgeCopyWith<FlowEdge> get copyWith =>
      _$FlowEdgeCopyWithImpl<FlowEdge>(this as FlowEdge, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlowEdge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceNodeId, sourceNodeId) ||
                other.sourceNodeId == sourceNodeId) &&
            (identical(other.sourceHandleId, sourceHandleId) ||
                other.sourceHandleId == sourceHandleId) &&
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.targetHandleId, targetHandleId) ||
                other.targetHandleId == targetHandleId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.pathType, pathType) ||
                other.pathType == pathType) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sourceNodeId,
      sourceHandleId,
      targetNodeId,
      targetHandleId,
      type,
      pathType,
      const DeepCollectionEquality().hash(data),
      label);

  @override
  String toString() {
    return 'FlowEdge(id: $id, sourceNodeId: $sourceNodeId, sourceHandleId: $sourceHandleId, targetNodeId: $targetNodeId, targetHandleId: $targetHandleId, type: $type, pathType: $pathType, data: $data, label: $label)';
  }
}

/// @nodoc
abstract mixin class $FlowEdgeCopyWith<$Res> {
  factory $FlowEdgeCopyWith(FlowEdge value, $Res Function(FlowEdge) _then) =
      _$FlowEdgeCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String sourceNodeId,
      String sourceHandleId,
      String targetNodeId,
      String targetHandleId,
      String? type,
      EdgePathType pathType,
      Map<String, dynamic> data,
      String? label});
}

/// @nodoc
class _$FlowEdgeCopyWithImpl<$Res> implements $FlowEdgeCopyWith<$Res> {
  _$FlowEdgeCopyWithImpl(this._self, this._then);

  final FlowEdge _self;
  final $Res Function(FlowEdge) _then;

  /// Create a copy of FlowEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceNodeId = null,
    Object? sourceHandleId = null,
    Object? targetNodeId = null,
    Object? targetHandleId = null,
    Object? type = freezed,
    Object? pathType = null,
    Object? data = null,
    Object? label = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      pathType: null == pathType
          ? _self.pathType
          : pathType // ignore: cast_nullable_to_non_nullable
              as EdgePathType,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FlowEdge].
extension FlowEdgePatterns on FlowEdge {
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
    TResult Function(_FlowEdge value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowEdge() when $default != null:
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
    TResult Function(_FlowEdge value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowEdge():
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
    TResult? Function(_FlowEdge value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowEdge() when $default != null:
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
            String sourceNodeId,
            String sourceHandleId,
            String targetNodeId,
            String targetHandleId,
            String? type,
            EdgePathType pathType,
            Map<String, dynamic> data,
            String? label)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowEdge() when $default != null:
        return $default(
            _that.id,
            _that.sourceNodeId,
            _that.sourceHandleId,
            _that.targetNodeId,
            _that.targetHandleId,
            _that.type,
            _that.pathType,
            _that.data,
            _that.label);
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
            String sourceNodeId,
            String sourceHandleId,
            String targetNodeId,
            String targetHandleId,
            String? type,
            EdgePathType pathType,
            Map<String, dynamic> data,
            String? label)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowEdge():
        return $default(
            _that.id,
            _that.sourceNodeId,
            _that.sourceHandleId,
            _that.targetNodeId,
            _that.targetHandleId,
            _that.type,
            _that.pathType,
            _that.data,
            _that.label);
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
            String sourceNodeId,
            String sourceHandleId,
            String targetNodeId,
            String targetHandleId,
            String? type,
            EdgePathType pathType,
            Map<String, dynamic> data,
            String? label)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowEdge() when $default != null:
        return $default(
            _that.id,
            _that.sourceNodeId,
            _that.sourceHandleId,
            _that.targetNodeId,
            _that.targetHandleId,
            _that.type,
            _that.pathType,
            _that.data,
            _that.label);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowEdge implements FlowEdge {
  const _FlowEdge(
      {required this.id,
      required this.sourceNodeId,
      required this.sourceHandleId,
      required this.targetNodeId,
      required this.targetHandleId,
      this.type,
      this.pathType = EdgePathType.bezier,
      final Map<String, dynamic> data = const {},
      this.label})
      : _data = data;

  @override
  final String id;
  @override
  final String sourceNodeId;
  @override
  final String sourceHandleId;
  @override
  final String targetNodeId;
  @override
  final String targetHandleId;

  /// The type of the edge, used to look up a custom painter in the EdgeRegistry.
  @override
  final String? type;

  /// The shape of the edge's path.
  @override
  @JsonKey()
  final EdgePathType pathType;

  /// A generic data map for any other custom properties.
  final Map<String, dynamic> _data;

  /// A generic data map for any other custom properties.
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

// Note: Visual properties like Paint, label styles etc.,
// are best handled in the presentation layer (the painter)
// based on the theme, rather than storing them in the data model.
  @override
  final String? label;

  /// Create a copy of FlowEdge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FlowEdgeCopyWith<_FlowEdge> get copyWith =>
      __$FlowEdgeCopyWithImpl<_FlowEdge>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlowEdge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceNodeId, sourceNodeId) ||
                other.sourceNodeId == sourceNodeId) &&
            (identical(other.sourceHandleId, sourceHandleId) ||
                other.sourceHandleId == sourceHandleId) &&
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.targetHandleId, targetHandleId) ||
                other.targetHandleId == targetHandleId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.pathType, pathType) ||
                other.pathType == pathType) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sourceNodeId,
      sourceHandleId,
      targetNodeId,
      targetHandleId,
      type,
      pathType,
      const DeepCollectionEquality().hash(_data),
      label);

  @override
  String toString() {
    return 'FlowEdge(id: $id, sourceNodeId: $sourceNodeId, sourceHandleId: $sourceHandleId, targetNodeId: $targetNodeId, targetHandleId: $targetHandleId, type: $type, pathType: $pathType, data: $data, label: $label)';
  }
}

/// @nodoc
abstract mixin class _$FlowEdgeCopyWith<$Res>
    implements $FlowEdgeCopyWith<$Res> {
  factory _$FlowEdgeCopyWith(_FlowEdge value, $Res Function(_FlowEdge) _then) =
      __$FlowEdgeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String sourceNodeId,
      String sourceHandleId,
      String targetNodeId,
      String targetHandleId,
      String? type,
      EdgePathType pathType,
      Map<String, dynamic> data,
      String? label});
}

/// @nodoc
class __$FlowEdgeCopyWithImpl<$Res> implements _$FlowEdgeCopyWith<$Res> {
  __$FlowEdgeCopyWithImpl(this._self, this._then);

  final _FlowEdge _self;
  final $Res Function(_FlowEdge) _then;

  /// Create a copy of FlowEdge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sourceNodeId = null,
    Object? sourceHandleId = null,
    Object? targetNodeId = null,
    Object? targetHandleId = null,
    Object? type = freezed,
    Object? pathType = null,
    Object? data = null,
    Object? label = freezed,
  }) {
    return _then(_FlowEdge(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      pathType: null == pathType
          ? _self.pathType
          : pathType // ignore: cast_nullable_to_non_nullable
              as EdgePathType,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

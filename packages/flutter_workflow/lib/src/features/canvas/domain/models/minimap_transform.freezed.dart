// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'minimap_transform.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MiniMapTransform {
  double get scale;
  double get offsetX;
  double get offsetY;
  Rect get contentBounds;

  /// Create a copy of MiniMapTransform
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MiniMapTransformCopyWith<MiniMapTransform> get copyWith =>
      _$MiniMapTransformCopyWithImpl<MiniMapTransform>(
          this as MiniMapTransform, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MiniMapTransform &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.offsetX, offsetX) || other.offsetX == offsetX) &&
            (identical(other.offsetY, offsetY) || other.offsetY == offsetY) &&
            (identical(other.contentBounds, contentBounds) ||
                other.contentBounds == contentBounds));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, scale, offsetX, offsetY, contentBounds);

  @override
  String toString() {
    return 'MiniMapTransform(scale: $scale, offsetX: $offsetX, offsetY: $offsetY, contentBounds: $contentBounds)';
  }
}

/// @nodoc
abstract mixin class $MiniMapTransformCopyWith<$Res> {
  factory $MiniMapTransformCopyWith(
          MiniMapTransform value, $Res Function(MiniMapTransform) _then) =
      _$MiniMapTransformCopyWithImpl;
  @useResult
  $Res call({double scale, double offsetX, double offsetY, Rect contentBounds});
}

/// @nodoc
class _$MiniMapTransformCopyWithImpl<$Res>
    implements $MiniMapTransformCopyWith<$Res> {
  _$MiniMapTransformCopyWithImpl(this._self, this._then);

  final MiniMapTransform _self;
  final $Res Function(MiniMapTransform) _then;

  /// Create a copy of MiniMapTransform
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scale = null,
    Object? offsetX = null,
    Object? offsetY = null,
    Object? contentBounds = null,
  }) {
    return _then(_self.copyWith(
      scale: null == scale
          ? _self.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      offsetX: null == offsetX
          ? _self.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double,
      offsetY: null == offsetY
          ? _self.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double,
      contentBounds: null == contentBounds
          ? _self.contentBounds
          : contentBounds // ignore: cast_nullable_to_non_nullable
              as Rect,
    ));
  }
}

/// Adds pattern-matching-related methods to [MiniMapTransform].
extension MiniMapTransformPatterns on MiniMapTransform {
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
    TResult Function(_MiniMapTransform value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MiniMapTransform() when $default != null:
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
    TResult Function(_MiniMapTransform value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MiniMapTransform():
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
    TResult? Function(_MiniMapTransform value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MiniMapTransform() when $default != null:
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
            double scale, double offsetX, double offsetY, Rect contentBounds)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MiniMapTransform() when $default != null:
        return $default(
            _that.scale, _that.offsetX, _that.offsetY, _that.contentBounds);
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
            double scale, double offsetX, double offsetY, Rect contentBounds)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MiniMapTransform():
        return $default(
            _that.scale, _that.offsetX, _that.offsetY, _that.contentBounds);
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
            double scale, double offsetX, double offsetY, Rect contentBounds)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MiniMapTransform() when $default != null:
        return $default(
            _that.scale, _that.offsetX, _that.offsetY, _that.contentBounds);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MiniMapTransform implements MiniMapTransform {
  const _MiniMapTransform(
      {required this.scale,
      required this.offsetX,
      required this.offsetY,
      required this.contentBounds});

  @override
  final double scale;
  @override
  final double offsetX;
  @override
  final double offsetY;
  @override
  final Rect contentBounds;

  /// Create a copy of MiniMapTransform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MiniMapTransformCopyWith<_MiniMapTransform> get copyWith =>
      __$MiniMapTransformCopyWithImpl<_MiniMapTransform>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MiniMapTransform &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.offsetX, offsetX) || other.offsetX == offsetX) &&
            (identical(other.offsetY, offsetY) || other.offsetY == offsetY) &&
            (identical(other.contentBounds, contentBounds) ||
                other.contentBounds == contentBounds));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, scale, offsetX, offsetY, contentBounds);

  @override
  String toString() {
    return 'MiniMapTransform(scale: $scale, offsetX: $offsetX, offsetY: $offsetY, contentBounds: $contentBounds)';
  }
}

/// @nodoc
abstract mixin class _$MiniMapTransformCopyWith<$Res>
    implements $MiniMapTransformCopyWith<$Res> {
  factory _$MiniMapTransformCopyWith(
          _MiniMapTransform value, $Res Function(_MiniMapTransform) _then) =
      __$MiniMapTransformCopyWithImpl;
  @override
  @useResult
  $Res call({double scale, double offsetX, double offsetY, Rect contentBounds});
}

/// @nodoc
class __$MiniMapTransformCopyWithImpl<$Res>
    implements _$MiniMapTransformCopyWith<$Res> {
  __$MiniMapTransformCopyWithImpl(this._self, this._then);

  final _MiniMapTransform _self;
  final $Res Function(_MiniMapTransform) _then;

  /// Create a copy of MiniMapTransform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? scale = null,
    Object? offsetX = null,
    Object? offsetY = null,
    Object? contentBounds = null,
  }) {
    return _then(_MiniMapTransform(
      scale: null == scale
          ? _self.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      offsetX: null == offsetX
          ? _self.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double,
      offsetY: null == offsetY
          ? _self.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double,
      contentBounds: null == contentBounds
          ? _self.contentBounds
          : contentBounds // ignore: cast_nullable_to_non_nullable
              as Rect,
    ));
  }
}

// dart format on

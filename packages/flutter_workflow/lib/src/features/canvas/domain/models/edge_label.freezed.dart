// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edge_label.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EdgeLabel {
  String get id;
  String get text;
  BuiltMap<String, dynamic> get internalData;
  double get position;
  Offset get offset;
  bool get visible;
  bool get showBackground;
  BoxDecoration? get backgroundDecoration;
  EdgeInsets get backgroundPadding;
  double get backgroundBorderRadius;
  TextStyle? get textStyle;
  int get zIndex;

  /// Create a copy of EdgeLabel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EdgeLabelCopyWith<EdgeLabel> get copyWith =>
      _$EdgeLabelCopyWithImpl<EdgeLabel>(this as EdgeLabel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EdgeLabel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.internalData, internalData) ||
                other.internalData == internalData) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.showBackground, showBackground) ||
                other.showBackground == showBackground) &&
            (identical(other.backgroundDecoration, backgroundDecoration) ||
                other.backgroundDecoration == backgroundDecoration) &&
            (identical(other.backgroundPadding, backgroundPadding) ||
                other.backgroundPadding == backgroundPadding) &&
            (identical(other.backgroundBorderRadius, backgroundBorderRadius) ||
                other.backgroundBorderRadius == backgroundBorderRadius) &&
            (identical(other.textStyle, textStyle) ||
                other.textStyle == textStyle) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      internalData,
      position,
      offset,
      visible,
      showBackground,
      backgroundDecoration,
      backgroundPadding,
      backgroundBorderRadius,
      textStyle,
      zIndex);

  @override
  String toString() {
    return 'EdgeLabel(id: $id, text: $text, internalData: $internalData, position: $position, offset: $offset, visible: $visible, showBackground: $showBackground, backgroundDecoration: $backgroundDecoration, backgroundPadding: $backgroundPadding, backgroundBorderRadius: $backgroundBorderRadius, textStyle: $textStyle, zIndex: $zIndex)';
  }
}

/// @nodoc
abstract mixin class $EdgeLabelCopyWith<$Res> {
  factory $EdgeLabelCopyWith(EdgeLabel value, $Res Function(EdgeLabel) _then) =
      _$EdgeLabelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String text,
      BuiltMap<String, dynamic> internalData,
      double position,
      Offset offset,
      bool visible,
      bool showBackground,
      BoxDecoration? backgroundDecoration,
      EdgeInsets backgroundPadding,
      double backgroundBorderRadius,
      TextStyle? textStyle,
      int zIndex});
}

/// @nodoc
class _$EdgeLabelCopyWithImpl<$Res> implements $EdgeLabelCopyWith<$Res> {
  _$EdgeLabelCopyWithImpl(this._self, this._then);

  final EdgeLabel _self;
  final $Res Function(EdgeLabel) _then;

  /// Create a copy of EdgeLabel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? internalData = null,
    Object? position = null,
    Object? offset = null,
    Object? visible = null,
    Object? showBackground = null,
    Object? backgroundDecoration = freezed,
    Object? backgroundPadding = null,
    Object? backgroundBorderRadius = null,
    Object? textStyle = freezed,
    Object? zIndex = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      internalData: null == internalData
          ? _self.internalData
          : internalData // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, dynamic>,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as double,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as Offset,
      visible: null == visible
          ? _self.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      showBackground: null == showBackground
          ? _self.showBackground
          : showBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      backgroundDecoration: freezed == backgroundDecoration
          ? _self.backgroundDecoration
          : backgroundDecoration // ignore: cast_nullable_to_non_nullable
              as BoxDecoration?,
      backgroundPadding: null == backgroundPadding
          ? _self.backgroundPadding
          : backgroundPadding // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      backgroundBorderRadius: null == backgroundBorderRadius
          ? _self.backgroundBorderRadius
          : backgroundBorderRadius // ignore: cast_nullable_to_non_nullable
              as double,
      textStyle: freezed == textStyle
          ? _self.textStyle
          : textStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle?,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [EdgeLabel].
extension EdgeLabelPatterns on EdgeLabel {
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
    TResult Function(_EdgeLabel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EdgeLabel() when $default != null:
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
    TResult Function(_EdgeLabel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EdgeLabel():
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
    TResult? Function(_EdgeLabel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EdgeLabel() when $default != null:
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
            String text,
            BuiltMap<String, dynamic> internalData,
            double position,
            Offset offset,
            bool visible,
            bool showBackground,
            BoxDecoration? backgroundDecoration,
            EdgeInsets backgroundPadding,
            double backgroundBorderRadius,
            TextStyle? textStyle,
            int zIndex)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EdgeLabel() when $default != null:
        return $default(
            _that.id,
            _that.text,
            _that.internalData,
            _that.position,
            _that.offset,
            _that.visible,
            _that.showBackground,
            _that.backgroundDecoration,
            _that.backgroundPadding,
            _that.backgroundBorderRadius,
            _that.textStyle,
            _that.zIndex);
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
            String text,
            BuiltMap<String, dynamic> internalData,
            double position,
            Offset offset,
            bool visible,
            bool showBackground,
            BoxDecoration? backgroundDecoration,
            EdgeInsets backgroundPadding,
            double backgroundBorderRadius,
            TextStyle? textStyle,
            int zIndex)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EdgeLabel():
        return $default(
            _that.id,
            _that.text,
            _that.internalData,
            _that.position,
            _that.offset,
            _that.visible,
            _that.showBackground,
            _that.backgroundDecoration,
            _that.backgroundPadding,
            _that.backgroundBorderRadius,
            _that.textStyle,
            _that.zIndex);
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
            String text,
            BuiltMap<String, dynamic> internalData,
            double position,
            Offset offset,
            bool visible,
            bool showBackground,
            BoxDecoration? backgroundDecoration,
            EdgeInsets backgroundPadding,
            double backgroundBorderRadius,
            TextStyle? textStyle,
            int zIndex)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EdgeLabel() when $default != null:
        return $default(
            _that.id,
            _that.text,
            _that.internalData,
            _that.position,
            _that.offset,
            _that.visible,
            _that.showBackground,
            _that.backgroundDecoration,
            _that.backgroundPadding,
            _that.backgroundBorderRadius,
            _that.textStyle,
            _that.zIndex);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _EdgeLabel extends EdgeLabel {
  _EdgeLabel(
      {required this.id,
      required this.text,
      required this.internalData,
      this.position = 0.5,
      this.offset = const Offset(0, 0),
      this.visible = true,
      this.showBackground = false,
      this.backgroundDecoration,
      this.backgroundPadding = const EdgeInsets.all(2.0),
      this.backgroundBorderRadius = 4.0,
      this.textStyle,
      this.zIndex = 0})
      : super._();

  @override
  final String id;
  @override
  final String text;
  @override
  final BuiltMap<String, dynamic> internalData;
  @override
  @JsonKey()
  final double position;
  @override
  @JsonKey()
  final Offset offset;
  @override
  @JsonKey()
  final bool visible;
  @override
  @JsonKey()
  final bool showBackground;
  @override
  final BoxDecoration? backgroundDecoration;
  @override
  @JsonKey()
  final EdgeInsets backgroundPadding;
  @override
  @JsonKey()
  final double backgroundBorderRadius;
  @override
  final TextStyle? textStyle;
  @override
  @JsonKey()
  final int zIndex;

  /// Create a copy of EdgeLabel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EdgeLabelCopyWith<_EdgeLabel> get copyWith =>
      __$EdgeLabelCopyWithImpl<_EdgeLabel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EdgeLabel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.internalData, internalData) ||
                other.internalData == internalData) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.showBackground, showBackground) ||
                other.showBackground == showBackground) &&
            (identical(other.backgroundDecoration, backgroundDecoration) ||
                other.backgroundDecoration == backgroundDecoration) &&
            (identical(other.backgroundPadding, backgroundPadding) ||
                other.backgroundPadding == backgroundPadding) &&
            (identical(other.backgroundBorderRadius, backgroundBorderRadius) ||
                other.backgroundBorderRadius == backgroundBorderRadius) &&
            (identical(other.textStyle, textStyle) ||
                other.textStyle == textStyle) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      internalData,
      position,
      offset,
      visible,
      showBackground,
      backgroundDecoration,
      backgroundPadding,
      backgroundBorderRadius,
      textStyle,
      zIndex);

  @override
  String toString() {
    return 'EdgeLabel(id: $id, text: $text, internalData: $internalData, position: $position, offset: $offset, visible: $visible, showBackground: $showBackground, backgroundDecoration: $backgroundDecoration, backgroundPadding: $backgroundPadding, backgroundBorderRadius: $backgroundBorderRadius, textStyle: $textStyle, zIndex: $zIndex)';
  }
}

/// @nodoc
abstract mixin class _$EdgeLabelCopyWith<$Res>
    implements $EdgeLabelCopyWith<$Res> {
  factory _$EdgeLabelCopyWith(
          _EdgeLabel value, $Res Function(_EdgeLabel) _then) =
      __$EdgeLabelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String text,
      BuiltMap<String, dynamic> internalData,
      double position,
      Offset offset,
      bool visible,
      bool showBackground,
      BoxDecoration? backgroundDecoration,
      EdgeInsets backgroundPadding,
      double backgroundBorderRadius,
      TextStyle? textStyle,
      int zIndex});
}

/// @nodoc
class __$EdgeLabelCopyWithImpl<$Res> implements _$EdgeLabelCopyWith<$Res> {
  __$EdgeLabelCopyWithImpl(this._self, this._then);

  final _EdgeLabel _self;
  final $Res Function(_EdgeLabel) _then;

  /// Create a copy of EdgeLabel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? internalData = null,
    Object? position = null,
    Object? offset = null,
    Object? visible = null,
    Object? showBackground = null,
    Object? backgroundDecoration = freezed,
    Object? backgroundPadding = null,
    Object? backgroundBorderRadius = null,
    Object? textStyle = freezed,
    Object? zIndex = null,
  }) {
    return _then(_EdgeLabel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      internalData: null == internalData
          ? _self.internalData
          : internalData // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, dynamic>,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as double,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as Offset,
      visible: null == visible
          ? _self.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      showBackground: null == showBackground
          ? _self.showBackground
          : showBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      backgroundDecoration: freezed == backgroundDecoration
          ? _self.backgroundDecoration
          : backgroundDecoration // ignore: cast_nullable_to_non_nullable
              as BoxDecoration?,
      backgroundPadding: null == backgroundPadding
          ? _self.backgroundPadding
          : backgroundPadding // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      backgroundBorderRadius: null == backgroundBorderRadius
          ? _self.backgroundBorderRadius
          : backgroundBorderRadius // ignore: cast_nullable_to_non_nullable
              as double,
      textStyle: freezed == textStyle
          ? _self.textStyle
          : textStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle?,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on

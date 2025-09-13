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
  String get targetNodeId;
  String? get sourceHandleId;
  String? get targetHandleId;
  int get zIndex;
  EdgePathType get pathType;
  double get interactionWidth;
  Widget? get label;
  BoxDecoration? get labelDecoration;
  EdgeMarkerStyle? get startMarkerStyle;
  EdgeMarkerStyle? get endMarkerStyle;
  EdgeStyle? get style;
  dynamic get data;
  bool? get animated;
  bool? get hidden;
  bool? get deletable;
  bool? get selectable;
  bool? get focusable;
  bool? get reconnectable;
  bool? get elevateEdgeOnSelected;

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
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.sourceHandleId, sourceHandleId) ||
                other.sourceHandleId == sourceHandleId) &&
            (identical(other.targetHandleId, targetHandleId) ||
                other.targetHandleId == targetHandleId) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.pathType, pathType) ||
                other.pathType == pathType) &&
            (identical(other.interactionWidth, interactionWidth) ||
                other.interactionWidth == interactionWidth) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.labelDecoration, labelDecoration) ||
                other.labelDecoration == labelDecoration) &&
            (identical(other.startMarkerStyle, startMarkerStyle) ||
                other.startMarkerStyle == startMarkerStyle) &&
            (identical(other.endMarkerStyle, endMarkerStyle) ||
                other.endMarkerStyle == endMarkerStyle) &&
            (identical(other.style, style) || other.style == style) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.animated, animated) ||
                other.animated == animated) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.deletable, deletable) ||
                other.deletable == deletable) &&
            (identical(other.selectable, selectable) ||
                other.selectable == selectable) &&
            (identical(other.focusable, focusable) ||
                other.focusable == focusable) &&
            (identical(other.reconnectable, reconnectable) ||
                other.reconnectable == reconnectable) &&
            (identical(other.elevateEdgeOnSelected, elevateEdgeOnSelected) ||
                other.elevateEdgeOnSelected == elevateEdgeOnSelected));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        sourceNodeId,
        targetNodeId,
        sourceHandleId,
        targetHandleId,
        zIndex,
        pathType,
        interactionWidth,
        label,
        labelDecoration,
        startMarkerStyle,
        endMarkerStyle,
        style,
        const DeepCollectionEquality().hash(data),
        animated,
        hidden,
        deletable,
        selectable,
        focusable,
        reconnectable,
        elevateEdgeOnSelected
      ]);

  @override
  String toString() {
    return 'FlowEdge(id: $id, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId, sourceHandleId: $sourceHandleId, targetHandleId: $targetHandleId, zIndex: $zIndex, pathType: $pathType, interactionWidth: $interactionWidth, label: $label, labelDecoration: $labelDecoration, startMarkerStyle: $startMarkerStyle, endMarkerStyle: $endMarkerStyle, style: $style, data: $data, animated: $animated, hidden: $hidden, deletable: $deletable, selectable: $selectable, focusable: $focusable, reconnectable: $reconnectable, elevateEdgeOnSelected: $elevateEdgeOnSelected)';
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
      String targetNodeId,
      String? sourceHandleId,
      String? targetHandleId,
      int zIndex,
      EdgePathType pathType,
      double interactionWidth,
      Widget? label,
      BoxDecoration? labelDecoration,
      EdgeMarkerStyle? startMarkerStyle,
      EdgeMarkerStyle? endMarkerStyle,
      EdgeStyle? style,
      dynamic data,
      bool? animated,
      bool? hidden,
      bool? deletable,
      bool? selectable,
      bool? focusable,
      bool? reconnectable,
      bool? elevateEdgeOnSelected});
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
    Object? targetNodeId = null,
    Object? sourceHandleId = freezed,
    Object? targetHandleId = freezed,
    Object? zIndex = null,
    Object? pathType = null,
    Object? interactionWidth = null,
    Object? label = freezed,
    Object? labelDecoration = freezed,
    Object? startMarkerStyle = freezed,
    Object? endMarkerStyle = freezed,
    Object? style = freezed,
    Object? data = freezed,
    Object? animated = freezed,
    Object? hidden = freezed,
    Object? deletable = freezed,
    Object? selectable = freezed,
    Object? focusable = freezed,
    Object? reconnectable = freezed,
    Object? elevateEdgeOnSelected = freezed,
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
      targetNodeId: null == targetNodeId
          ? _self.targetNodeId
          : targetNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceHandleId: freezed == sourceHandleId
          ? _self.sourceHandleId
          : sourceHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHandleId: freezed == targetHandleId
          ? _self.targetHandleId
          : targetHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pathType: null == pathType
          ? _self.pathType
          : pathType // ignore: cast_nullable_to_non_nullable
              as EdgePathType,
      interactionWidth: null == interactionWidth
          ? _self.interactionWidth
          : interactionWidth // ignore: cast_nullable_to_non_nullable
              as double,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as Widget?,
      labelDecoration: freezed == labelDecoration
          ? _self.labelDecoration
          : labelDecoration // ignore: cast_nullable_to_non_nullable
              as BoxDecoration?,
      startMarkerStyle: freezed == startMarkerStyle
          ? _self.startMarkerStyle
          : startMarkerStyle // ignore: cast_nullable_to_non_nullable
              as EdgeMarkerStyle?,
      endMarkerStyle: freezed == endMarkerStyle
          ? _self.endMarkerStyle
          : endMarkerStyle // ignore: cast_nullable_to_non_nullable
              as EdgeMarkerStyle?,
      style: freezed == style
          ? _self.style
          : style // ignore: cast_nullable_to_non_nullable
              as EdgeStyle?,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      animated: freezed == animated
          ? _self.animated
          : animated // ignore: cast_nullable_to_non_nullable
              as bool?,
      hidden: freezed == hidden
          ? _self.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      deletable: freezed == deletable
          ? _self.deletable
          : deletable // ignore: cast_nullable_to_non_nullable
              as bool?,
      selectable: freezed == selectable
          ? _self.selectable
          : selectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      focusable: freezed == focusable
          ? _self.focusable
          : focusable // ignore: cast_nullable_to_non_nullable
              as bool?,
      reconnectable: freezed == reconnectable
          ? _self.reconnectable
          : reconnectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      elevateEdgeOnSelected: freezed == elevateEdgeOnSelected
          ? _self.elevateEdgeOnSelected
          : elevateEdgeOnSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
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
            String targetNodeId,
            String? sourceHandleId,
            String? targetHandleId,
            int zIndex,
            EdgePathType pathType,
            double interactionWidth,
            Widget? label,
            BoxDecoration? labelDecoration,
            EdgeMarkerStyle? startMarkerStyle,
            EdgeMarkerStyle? endMarkerStyle,
            EdgeStyle? style,
            dynamic data,
            bool? animated,
            bool? hidden,
            bool? deletable,
            bool? selectable,
            bool? focusable,
            bool? reconnectable,
            bool? elevateEdgeOnSelected)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowEdge() when $default != null:
        return $default(
            _that.id,
            _that.sourceNodeId,
            _that.targetNodeId,
            _that.sourceHandleId,
            _that.targetHandleId,
            _that.zIndex,
            _that.pathType,
            _that.interactionWidth,
            _that.label,
            _that.labelDecoration,
            _that.startMarkerStyle,
            _that.endMarkerStyle,
            _that.style,
            _that.data,
            _that.animated,
            _that.hidden,
            _that.deletable,
            _that.selectable,
            _that.focusable,
            _that.reconnectable,
            _that.elevateEdgeOnSelected);
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
            String targetNodeId,
            String? sourceHandleId,
            String? targetHandleId,
            int zIndex,
            EdgePathType pathType,
            double interactionWidth,
            Widget? label,
            BoxDecoration? labelDecoration,
            EdgeMarkerStyle? startMarkerStyle,
            EdgeMarkerStyle? endMarkerStyle,
            EdgeStyle? style,
            dynamic data,
            bool? animated,
            bool? hidden,
            bool? deletable,
            bool? selectable,
            bool? focusable,
            bool? reconnectable,
            bool? elevateEdgeOnSelected)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowEdge():
        return $default(
            _that.id,
            _that.sourceNodeId,
            _that.targetNodeId,
            _that.sourceHandleId,
            _that.targetHandleId,
            _that.zIndex,
            _that.pathType,
            _that.interactionWidth,
            _that.label,
            _that.labelDecoration,
            _that.startMarkerStyle,
            _that.endMarkerStyle,
            _that.style,
            _that.data,
            _that.animated,
            _that.hidden,
            _that.deletable,
            _that.selectable,
            _that.focusable,
            _that.reconnectable,
            _that.elevateEdgeOnSelected);
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
            String targetNodeId,
            String? sourceHandleId,
            String? targetHandleId,
            int zIndex,
            EdgePathType pathType,
            double interactionWidth,
            Widget? label,
            BoxDecoration? labelDecoration,
            EdgeMarkerStyle? startMarkerStyle,
            EdgeMarkerStyle? endMarkerStyle,
            EdgeStyle? style,
            dynamic data,
            bool? animated,
            bool? hidden,
            bool? deletable,
            bool? selectable,
            bool? focusable,
            bool? reconnectable,
            bool? elevateEdgeOnSelected)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowEdge() when $default != null:
        return $default(
            _that.id,
            _that.sourceNodeId,
            _that.targetNodeId,
            _that.sourceHandleId,
            _that.targetHandleId,
            _that.zIndex,
            _that.pathType,
            _that.interactionWidth,
            _that.label,
            _that.labelDecoration,
            _that.startMarkerStyle,
            _that.endMarkerStyle,
            _that.style,
            _that.data,
            _that.animated,
            _that.hidden,
            _that.deletable,
            _that.selectable,
            _that.focusable,
            _that.reconnectable,
            _that.elevateEdgeOnSelected);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowEdge extends FlowEdge {
  const _FlowEdge(
      {required this.id,
      required this.sourceNodeId,
      required this.targetNodeId,
      required this.sourceHandleId,
      required this.targetHandleId,
      this.zIndex = 0,
      this.pathType = EdgePathType.bezier,
      this.interactionWidth = 10.0,
      this.label,
      this.labelDecoration,
      this.startMarkerStyle,
      this.endMarkerStyle,
      this.style,
      this.data = const {},
      this.animated,
      this.hidden,
      this.deletable,
      this.selectable,
      this.focusable,
      this.reconnectable,
      this.elevateEdgeOnSelected})
      : assert(sourceNodeId != targetNodeId,
            'Source and target cannot be the same node'),
        super._();

  @override
  final String id;
  @override
  final String sourceNodeId;
  @override
  final String targetNodeId;
  @override
  final String? sourceHandleId;
  @override
  final String? targetHandleId;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final EdgePathType pathType;
  @override
  @JsonKey()
  final double interactionWidth;
  @override
  final Widget? label;
  @override
  final BoxDecoration? labelDecoration;
  @override
  final EdgeMarkerStyle? startMarkerStyle;
  @override
  final EdgeMarkerStyle? endMarkerStyle;
  @override
  final EdgeStyle? style;
  @override
  @JsonKey()
  final dynamic data;
  @override
  final bool? animated;
  @override
  final bool? hidden;
  @override
  final bool? deletable;
  @override
  final bool? selectable;
  @override
  final bool? focusable;
  @override
  final bool? reconnectable;
  @override
  final bool? elevateEdgeOnSelected;

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
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.sourceHandleId, sourceHandleId) ||
                other.sourceHandleId == sourceHandleId) &&
            (identical(other.targetHandleId, targetHandleId) ||
                other.targetHandleId == targetHandleId) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.pathType, pathType) ||
                other.pathType == pathType) &&
            (identical(other.interactionWidth, interactionWidth) ||
                other.interactionWidth == interactionWidth) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.labelDecoration, labelDecoration) ||
                other.labelDecoration == labelDecoration) &&
            (identical(other.startMarkerStyle, startMarkerStyle) ||
                other.startMarkerStyle == startMarkerStyle) &&
            (identical(other.endMarkerStyle, endMarkerStyle) ||
                other.endMarkerStyle == endMarkerStyle) &&
            (identical(other.style, style) || other.style == style) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.animated, animated) ||
                other.animated == animated) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.deletable, deletable) ||
                other.deletable == deletable) &&
            (identical(other.selectable, selectable) ||
                other.selectable == selectable) &&
            (identical(other.focusable, focusable) ||
                other.focusable == focusable) &&
            (identical(other.reconnectable, reconnectable) ||
                other.reconnectable == reconnectable) &&
            (identical(other.elevateEdgeOnSelected, elevateEdgeOnSelected) ||
                other.elevateEdgeOnSelected == elevateEdgeOnSelected));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        sourceNodeId,
        targetNodeId,
        sourceHandleId,
        targetHandleId,
        zIndex,
        pathType,
        interactionWidth,
        label,
        labelDecoration,
        startMarkerStyle,
        endMarkerStyle,
        style,
        const DeepCollectionEquality().hash(data),
        animated,
        hidden,
        deletable,
        selectable,
        focusable,
        reconnectable,
        elevateEdgeOnSelected
      ]);

  @override
  String toString() {
    return 'FlowEdge(id: $id, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId, sourceHandleId: $sourceHandleId, targetHandleId: $targetHandleId, zIndex: $zIndex, pathType: $pathType, interactionWidth: $interactionWidth, label: $label, labelDecoration: $labelDecoration, startMarkerStyle: $startMarkerStyle, endMarkerStyle: $endMarkerStyle, style: $style, data: $data, animated: $animated, hidden: $hidden, deletable: $deletable, selectable: $selectable, focusable: $focusable, reconnectable: $reconnectable, elevateEdgeOnSelected: $elevateEdgeOnSelected)';
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
      String targetNodeId,
      String? sourceHandleId,
      String? targetHandleId,
      int zIndex,
      EdgePathType pathType,
      double interactionWidth,
      Widget? label,
      BoxDecoration? labelDecoration,
      EdgeMarkerStyle? startMarkerStyle,
      EdgeMarkerStyle? endMarkerStyle,
      EdgeStyle? style,
      dynamic data,
      bool? animated,
      bool? hidden,
      bool? deletable,
      bool? selectable,
      bool? focusable,
      bool? reconnectable,
      bool? elevateEdgeOnSelected});
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
    Object? targetNodeId = null,
    Object? sourceHandleId = freezed,
    Object? targetHandleId = freezed,
    Object? zIndex = null,
    Object? pathType = null,
    Object? interactionWidth = null,
    Object? label = freezed,
    Object? labelDecoration = freezed,
    Object? startMarkerStyle = freezed,
    Object? endMarkerStyle = freezed,
    Object? style = freezed,
    Object? data = freezed,
    Object? animated = freezed,
    Object? hidden = freezed,
    Object? deletable = freezed,
    Object? selectable = freezed,
    Object? focusable = freezed,
    Object? reconnectable = freezed,
    Object? elevateEdgeOnSelected = freezed,
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
      targetNodeId: null == targetNodeId
          ? _self.targetNodeId
          : targetNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceHandleId: freezed == sourceHandleId
          ? _self.sourceHandleId
          : sourceHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHandleId: freezed == targetHandleId
          ? _self.targetHandleId
          : targetHandleId // ignore: cast_nullable_to_non_nullable
              as String?,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pathType: null == pathType
          ? _self.pathType
          : pathType // ignore: cast_nullable_to_non_nullable
              as EdgePathType,
      interactionWidth: null == interactionWidth
          ? _self.interactionWidth
          : interactionWidth // ignore: cast_nullable_to_non_nullable
              as double,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as Widget?,
      labelDecoration: freezed == labelDecoration
          ? _self.labelDecoration
          : labelDecoration // ignore: cast_nullable_to_non_nullable
              as BoxDecoration?,
      startMarkerStyle: freezed == startMarkerStyle
          ? _self.startMarkerStyle
          : startMarkerStyle // ignore: cast_nullable_to_non_nullable
              as EdgeMarkerStyle?,
      endMarkerStyle: freezed == endMarkerStyle
          ? _self.endMarkerStyle
          : endMarkerStyle // ignore: cast_nullable_to_non_nullable
              as EdgeMarkerStyle?,
      style: freezed == style
          ? _self.style
          : style // ignore: cast_nullable_to_non_nullable
              as EdgeStyle?,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      animated: freezed == animated
          ? _self.animated
          : animated // ignore: cast_nullable_to_non_nullable
              as bool?,
      hidden: freezed == hidden
          ? _self.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      deletable: freezed == deletable
          ? _self.deletable
          : deletable // ignore: cast_nullable_to_non_nullable
              as bool?,
      selectable: freezed == selectable
          ? _self.selectable
          : selectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      focusable: freezed == focusable
          ? _self.focusable
          : focusable // ignore: cast_nullable_to_non_nullable
              as bool?,
      reconnectable: freezed == reconnectable
          ? _self.reconnectable
          : reconnectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      elevateEdgeOnSelected: freezed == elevateEdgeOnSelected
          ? _self.elevateEdgeOnSelected
          : elevateEdgeOnSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on

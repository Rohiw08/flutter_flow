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
  /// Unique identifier for this edge.
  String get id;

  /// ID of the source node this edge originates from.
  String get sourceNodeId;

  /// ID of the target node this edge points to.
  String get targetNodeId;

  /// Optional handle ID on the source node where the edge connects.
  /// If null, the edge connects to the node's center or default position.
  String? get sourceHandleId;

  /// Optional handle ID on the target node where the edge connects.
  /// If null, the edge connects to the node's center or default position.
  String? get targetHandleId;

  /// Z-index for layering edges. Higher values render on top.
  int get zIndex;

  /// The path rendering algorithm for this edge.
  EdgePathType get pathType;

  /// Width of the invisible interaction area around the edge for easier selection.
  /// Makes thin edges easier to click/hover.
  double get interactionWidth;

  /// Optional widget to display as a label on the edge.
  Widget? get label;

  /// Optional decoration for the label container.
  /// If null, uses a default decoration or no decoration.
  FlowEdgeLabelStyle? get labelDecoration;

  /// Optional custom marker style for the start of the edge.
  /// Overrides the theme's start marker style.
  FlowEdgeMarkerStyle? get startMarkerStyle;

  /// Optional custom marker style for the end of the edge.
  /// Overrides the theme's end marker style.
  FlowEdgeMarkerStyle? get endMarkerStyle;

  /// Optional custom style for this edge.
  /// If null, uses the style from the current theme.
  FlowEdgeStyle? get style;

  /// Custom data that can be attached to this edge.
  /// Useful for storing application-specific metadata.
  Map<String, dynamic> get data;

  /// Whether this edge should be animated (e.g., flowing dots).
  /// If null, uses the global canvas setting.
  bool? get animated;

  /// Whether this edge should be hidden from view.
  /// Hidden edges are not rendered but remain in the data structure.
  bool? get hidden;

  /// Whether this edge can be deleted by the user.
  /// If null, uses the global canvas setting.
  bool? get deletable;

  /// Whether this edge can be selected by the user.
  /// If null, uses the global canvas setting.
  bool? get selectable;

  /// Whether this edge can receive keyboard focus.
  /// If null, uses the global canvas setting.
  bool? get focusable;

  /// Whether this edge's connections can be changed by dragging.
  /// If null, uses the global canvas setting.
  bool? get reconnectable;

  /// Whether this edge should be elevated (z-index increased) when selected.
  /// If null, uses the global canvas setting.
  bool? get elevateEdgeOnSelect;

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
            (identical(other.elevateEdgeOnSelect, elevateEdgeOnSelect) ||
                other.elevateEdgeOnSelect == elevateEdgeOnSelect));
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
        elevateEdgeOnSelect
      ]);

  @override
  String toString() {
    return 'FlowEdge(id: $id, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId, sourceHandleId: $sourceHandleId, targetHandleId: $targetHandleId, zIndex: $zIndex, pathType: $pathType, interactionWidth: $interactionWidth, label: $label, labelDecoration: $labelDecoration, startMarkerStyle: $startMarkerStyle, endMarkerStyle: $endMarkerStyle, style: $style, data: $data, animated: $animated, hidden: $hidden, deletable: $deletable, selectable: $selectable, focusable: $focusable, reconnectable: $reconnectable, elevateEdgeOnSelect: $elevateEdgeOnSelect)';
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
      FlowEdgeLabelStyle? labelDecoration,
      FlowEdgeMarkerStyle? startMarkerStyle,
      FlowEdgeMarkerStyle? endMarkerStyle,
      FlowEdgeStyle? style,
      Map<String, dynamic> data,
      bool? animated,
      bool? hidden,
      bool? deletable,
      bool? selectable,
      bool? focusable,
      bool? reconnectable,
      bool? elevateEdgeOnSelect});
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
    Object? data = null,
    Object? animated = freezed,
    Object? hidden = freezed,
    Object? deletable = freezed,
    Object? selectable = freezed,
    Object? focusable = freezed,
    Object? reconnectable = freezed,
    Object? elevateEdgeOnSelect = freezed,
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
              as FlowEdgeLabelStyle?,
      startMarkerStyle: freezed == startMarkerStyle
          ? _self.startMarkerStyle
          : startMarkerStyle // ignore: cast_nullable_to_non_nullable
              as FlowEdgeMarkerStyle?,
      endMarkerStyle: freezed == endMarkerStyle
          ? _self.endMarkerStyle
          : endMarkerStyle // ignore: cast_nullable_to_non_nullable
              as FlowEdgeMarkerStyle?,
      style: freezed == style
          ? _self.style
          : style // ignore: cast_nullable_to_non_nullable
              as FlowEdgeStyle?,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
      elevateEdgeOnSelect: freezed == elevateEdgeOnSelect
          ? _self.elevateEdgeOnSelect
          : elevateEdgeOnSelect // ignore: cast_nullable_to_non_nullable
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
            FlowEdgeLabelStyle? labelDecoration,
            FlowEdgeMarkerStyle? startMarkerStyle,
            FlowEdgeMarkerStyle? endMarkerStyle,
            FlowEdgeStyle? style,
            Map<String, dynamic> data,
            bool? animated,
            bool? hidden,
            bool? deletable,
            bool? selectable,
            bool? focusable,
            bool? reconnectable,
            bool? elevateEdgeOnSelect)?
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
            _that.elevateEdgeOnSelect);
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
            FlowEdgeLabelStyle? labelDecoration,
            FlowEdgeMarkerStyle? startMarkerStyle,
            FlowEdgeMarkerStyle? endMarkerStyle,
            FlowEdgeStyle? style,
            Map<String, dynamic> data,
            bool? animated,
            bool? hidden,
            bool? deletable,
            bool? selectable,
            bool? focusable,
            bool? reconnectable,
            bool? elevateEdgeOnSelect)
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
            _that.elevateEdgeOnSelect);
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
            FlowEdgeLabelStyle? labelDecoration,
            FlowEdgeMarkerStyle? startMarkerStyle,
            FlowEdgeMarkerStyle? endMarkerStyle,
            FlowEdgeStyle? style,
            Map<String, dynamic> data,
            bool? animated,
            bool? hidden,
            bool? deletable,
            bool? selectable,
            bool? focusable,
            bool? reconnectable,
            bool? elevateEdgeOnSelect)?
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
            _that.elevateEdgeOnSelect);
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
      this.sourceHandleId,
      this.targetHandleId,
      this.zIndex = 0,
      this.pathType = EdgePathType.bezier,
      this.interactionWidth = 10.0,
      this.label,
      this.labelDecoration,
      this.startMarkerStyle,
      this.endMarkerStyle,
      this.style,
      final Map<String, dynamic> data = const <String, dynamic>{},
      this.animated,
      this.hidden,
      this.deletable,
      this.selectable,
      this.focusable,
      this.reconnectable,
      this.elevateEdgeOnSelect})
      : assert(sourceNodeId != targetNodeId,
            'Source and target cannot be the same node'),
        _data = data,
        super._();

  /// Unique identifier for this edge.
  @override
  final String id;

  /// ID of the source node this edge originates from.
  @override
  final String sourceNodeId;

  /// ID of the target node this edge points to.
  @override
  final String targetNodeId;

  /// Optional handle ID on the source node where the edge connects.
  /// If null, the edge connects to the node's center or default position.
  @override
  final String? sourceHandleId;

  /// Optional handle ID on the target node where the edge connects.
  /// If null, the edge connects to the node's center or default position.
  @override
  final String? targetHandleId;

  /// Z-index for layering edges. Higher values render on top.
  @override
  @JsonKey()
  final int zIndex;

  /// The path rendering algorithm for this edge.
  @override
  @JsonKey()
  final EdgePathType pathType;

  /// Width of the invisible interaction area around the edge for easier selection.
  /// Makes thin edges easier to click/hover.
  @override
  @JsonKey()
  final double interactionWidth;

  /// Optional widget to display as a label on the edge.
  @override
  final Widget? label;

  /// Optional decoration for the label container.
  /// If null, uses a default decoration or no decoration.
  @override
  final FlowEdgeLabelStyle? labelDecoration;

  /// Optional custom marker style for the start of the edge.
  /// Overrides the theme's start marker style.
  @override
  final FlowEdgeMarkerStyle? startMarkerStyle;

  /// Optional custom marker style for the end of the edge.
  /// Overrides the theme's end marker style.
  @override
  final FlowEdgeMarkerStyle? endMarkerStyle;

  /// Optional custom style for this edge.
  /// If null, uses the style from the current theme.
  @override
  final FlowEdgeStyle? style;

  /// Custom data that can be attached to this edge.
  /// Useful for storing application-specific metadata.
  final Map<String, dynamic> _data;

  /// Custom data that can be attached to this edge.
  /// Useful for storing application-specific metadata.
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  /// Whether this edge should be animated (e.g., flowing dots).
  /// If null, uses the global canvas setting.
  @override
  final bool? animated;

  /// Whether this edge should be hidden from view.
  /// Hidden edges are not rendered but remain in the data structure.
  @override
  final bool? hidden;

  /// Whether this edge can be deleted by the user.
  /// If null, uses the global canvas setting.
  @override
  final bool? deletable;

  /// Whether this edge can be selected by the user.
  /// If null, uses the global canvas setting.
  @override
  final bool? selectable;

  /// Whether this edge can receive keyboard focus.
  /// If null, uses the global canvas setting.
  @override
  final bool? focusable;

  /// Whether this edge's connections can be changed by dragging.
  /// If null, uses the global canvas setting.
  @override
  final bool? reconnectable;

  /// Whether this edge should be elevated (z-index increased) when selected.
  /// If null, uses the global canvas setting.
  @override
  final bool? elevateEdgeOnSelect;

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
            const DeepCollectionEquality().equals(other._data, _data) &&
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
            (identical(other.elevateEdgeOnSelect, elevateEdgeOnSelect) ||
                other.elevateEdgeOnSelect == elevateEdgeOnSelect));
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
        const DeepCollectionEquality().hash(_data),
        animated,
        hidden,
        deletable,
        selectable,
        focusable,
        reconnectable,
        elevateEdgeOnSelect
      ]);

  @override
  String toString() {
    return 'FlowEdge(id: $id, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId, sourceHandleId: $sourceHandleId, targetHandleId: $targetHandleId, zIndex: $zIndex, pathType: $pathType, interactionWidth: $interactionWidth, label: $label, labelDecoration: $labelDecoration, startMarkerStyle: $startMarkerStyle, endMarkerStyle: $endMarkerStyle, style: $style, data: $data, animated: $animated, hidden: $hidden, deletable: $deletable, selectable: $selectable, focusable: $focusable, reconnectable: $reconnectable, elevateEdgeOnSelect: $elevateEdgeOnSelect)';
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
      FlowEdgeLabelStyle? labelDecoration,
      FlowEdgeMarkerStyle? startMarkerStyle,
      FlowEdgeMarkerStyle? endMarkerStyle,
      FlowEdgeStyle? style,
      Map<String, dynamic> data,
      bool? animated,
      bool? hidden,
      bool? deletable,
      bool? selectable,
      bool? focusable,
      bool? reconnectable,
      bool? elevateEdgeOnSelect});
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
    Object? data = null,
    Object? animated = freezed,
    Object? hidden = freezed,
    Object? deletable = freezed,
    Object? selectable = freezed,
    Object? focusable = freezed,
    Object? reconnectable = freezed,
    Object? elevateEdgeOnSelect = freezed,
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
              as FlowEdgeLabelStyle?,
      startMarkerStyle: freezed == startMarkerStyle
          ? _self.startMarkerStyle
          : startMarkerStyle // ignore: cast_nullable_to_non_nullable
              as FlowEdgeMarkerStyle?,
      endMarkerStyle: freezed == endMarkerStyle
          ? _self.endMarkerStyle
          : endMarkerStyle // ignore: cast_nullable_to_non_nullable
              as FlowEdgeMarkerStyle?,
      style: freezed == style
          ? _self.style
          : style // ignore: cast_nullable_to_non_nullable
              as FlowEdgeStyle?,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
      elevateEdgeOnSelect: freezed == elevateEdgeOnSelect
          ? _self.elevateEdgeOnSelect
          : elevateEdgeOnSelect // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on

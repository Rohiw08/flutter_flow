// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlowNode {
  String get type;
  String get id;
  Offset get position;
  Size get size;
  String? get parentId;
  Map<String, NodeHandle> get handles;
  Map<String, dynamic> get data;
  int get zIndex;
  double get hitTestPadding;
  bool? get hidden;
  bool? get draggable;
  bool? get selectable;
  bool? get connectable;
  bool? get deletable;
  bool? get focusable;
  bool? get elevateNodeOnSelected;

  /// Create a copy of FlowNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlowNodeCopyWith<FlowNode> get copyWith =>
      _$FlowNodeCopyWithImpl<FlowNode>(this as FlowNode, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlowNode &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality().equals(other.handles, handles) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.hitTestPadding, hitTestPadding) ||
                other.hitTestPadding == hitTestPadding) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.draggable, draggable) ||
                other.draggable == draggable) &&
            (identical(other.selectable, selectable) ||
                other.selectable == selectable) &&
            (identical(other.connectable, connectable) ||
                other.connectable == connectable) &&
            (identical(other.deletable, deletable) ||
                other.deletable == deletable) &&
            (identical(other.focusable, focusable) ||
                other.focusable == focusable) &&
            (identical(other.elevateNodeOnSelected, elevateNodeOnSelected) ||
                other.elevateNodeOnSelected == elevateNodeOnSelected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      id,
      position,
      size,
      parentId,
      const DeepCollectionEquality().hash(handles),
      const DeepCollectionEquality().hash(data),
      zIndex,
      hitTestPadding,
      hidden,
      draggable,
      selectable,
      connectable,
      deletable,
      focusable,
      elevateNodeOnSelected);

  @override
  String toString() {
    return 'FlowNode(type: $type, id: $id, position: $position, size: $size, parentId: $parentId, handles: $handles, data: $data, zIndex: $zIndex, hitTestPadding: $hitTestPadding, hidden: $hidden, draggable: $draggable, selectable: $selectable, connectable: $connectable, deletable: $deletable, focusable: $focusable, elevateNodeOnSelected: $elevateNodeOnSelected)';
  }
}

/// @nodoc
abstract mixin class $FlowNodeCopyWith<$Res> {
  factory $FlowNodeCopyWith(FlowNode value, $Res Function(FlowNode) _then) =
      _$FlowNodeCopyWithImpl;
  @useResult
  $Res call(
      {String type,
      String id,
      Offset position,
      Size size,
      String? parentId,
      Map<String, NodeHandle> handles,
      Map<String, dynamic> data,
      int zIndex,
      double hitTestPadding,
      bool? hidden,
      bool? draggable,
      bool? selectable,
      bool? connectable,
      bool? deletable,
      bool? focusable,
      bool? elevateNodeOnSelected});
}

/// @nodoc
class _$FlowNodeCopyWithImpl<$Res> implements $FlowNodeCopyWith<$Res> {
  _$FlowNodeCopyWithImpl(this._self, this._then);

  final FlowNode _self;
  final $Res Function(FlowNode) _then;

  /// Create a copy of FlowNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? position = null,
    Object? size = null,
    Object? parentId = freezed,
    Object? handles = null,
    Object? data = null,
    Object? zIndex = null,
    Object? hitTestPadding = null,
    Object? hidden = freezed,
    Object? draggable = freezed,
    Object? selectable = freezed,
    Object? connectable = freezed,
    Object? deletable = freezed,
    Object? focusable = freezed,
    Object? elevateNodeOnSelected = freezed,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      handles: null == handles
          ? _self.handles
          : handles // ignore: cast_nullable_to_non_nullable
              as Map<String, NodeHandle>,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      hitTestPadding: null == hitTestPadding
          ? _self.hitTestPadding
          : hitTestPadding // ignore: cast_nullable_to_non_nullable
              as double,
      hidden: freezed == hidden
          ? _self.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      draggable: freezed == draggable
          ? _self.draggable
          : draggable // ignore: cast_nullable_to_non_nullable
              as bool?,
      selectable: freezed == selectable
          ? _self.selectable
          : selectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      connectable: freezed == connectable
          ? _self.connectable
          : connectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      deletable: freezed == deletable
          ? _self.deletable
          : deletable // ignore: cast_nullable_to_non_nullable
              as bool?,
      focusable: freezed == focusable
          ? _self.focusable
          : focusable // ignore: cast_nullable_to_non_nullable
              as bool?,
      elevateNodeOnSelected: freezed == elevateNodeOnSelected
          ? _self.elevateNodeOnSelected
          : elevateNodeOnSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FlowNode].
extension FlowNodePatterns on FlowNode {
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
    TResult Function(_FlowNode value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowNode() when $default != null:
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
    TResult Function(_FlowNode value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowNode():
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
    TResult? Function(_FlowNode value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowNode() when $default != null:
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
            String type,
            String id,
            Offset position,
            Size size,
            String? parentId,
            Map<String, NodeHandle> handles,
            Map<String, dynamic> data,
            int zIndex,
            double hitTestPadding,
            bool? hidden,
            bool? draggable,
            bool? selectable,
            bool? connectable,
            bool? deletable,
            bool? focusable,
            bool? elevateNodeOnSelected)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlowNode() when $default != null:
        return $default(
            _that.type,
            _that.id,
            _that.position,
            _that.size,
            _that.parentId,
            _that.handles,
            _that.data,
            _that.zIndex,
            _that.hitTestPadding,
            _that.hidden,
            _that.draggable,
            _that.selectable,
            _that.connectable,
            _that.deletable,
            _that.focusable,
            _that.elevateNodeOnSelected);
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
            String type,
            String id,
            Offset position,
            Size size,
            String? parentId,
            Map<String, NodeHandle> handles,
            Map<String, dynamic> data,
            int zIndex,
            double hitTestPadding,
            bool? hidden,
            bool? draggable,
            bool? selectable,
            bool? connectable,
            bool? deletable,
            bool? focusable,
            bool? elevateNodeOnSelected)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowNode():
        return $default(
            _that.type,
            _that.id,
            _that.position,
            _that.size,
            _that.parentId,
            _that.handles,
            _that.data,
            _that.zIndex,
            _that.hitTestPadding,
            _that.hidden,
            _that.draggable,
            _that.selectable,
            _that.connectable,
            _that.deletable,
            _that.focusable,
            _that.elevateNodeOnSelected);
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
            String type,
            String id,
            Offset position,
            Size size,
            String? parentId,
            Map<String, NodeHandle> handles,
            Map<String, dynamic> data,
            int zIndex,
            double hitTestPadding,
            bool? hidden,
            bool? draggable,
            bool? selectable,
            bool? connectable,
            bool? deletable,
            bool? focusable,
            bool? elevateNodeOnSelected)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlowNode() when $default != null:
        return $default(
            _that.type,
            _that.id,
            _that.position,
            _that.size,
            _that.parentId,
            _that.handles,
            _that.data,
            _that.zIndex,
            _that.hitTestPadding,
            _that.hidden,
            _that.draggable,
            _that.selectable,
            _that.connectable,
            _that.deletable,
            _that.focusable,
            _that.elevateNodeOnSelected);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowNode extends FlowNode {
  const _FlowNode(
      {required this.type,
      required this.id,
      required this.position,
      required this.size,
      this.parentId,
      final Map<String, NodeHandle> handles = const {},
      final Map<String, dynamic> data = const {},
      this.zIndex = 0,
      this.hitTestPadding = 10,
      this.hidden,
      this.draggable,
      this.selectable,
      this.connectable,
      this.deletable,
      this.focusable,
      this.elevateNodeOnSelected})
      : _handles = handles,
        _data = data,
        super._();

  @override
  final String type;
  @override
  final String id;
  @override
  final Offset position;
  @override
  final Size size;
  @override
  final String? parentId;
  final Map<String, NodeHandle> _handles;
  @override
  @JsonKey()
  Map<String, NodeHandle> get handles {
    if (_handles is EqualUnmodifiableMapView) return _handles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_handles);
  }

  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final double hitTestPadding;
  @override
  final bool? hidden;
  @override
  final bool? draggable;
  @override
  final bool? selectable;
  @override
  final bool? connectable;
  @override
  final bool? deletable;
  @override
  final bool? focusable;
  @override
  final bool? elevateNodeOnSelected;

  /// Create a copy of FlowNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FlowNodeCopyWith<_FlowNode> get copyWith =>
      __$FlowNodeCopyWithImpl<_FlowNode>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlowNode &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality().equals(other._handles, _handles) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.hitTestPadding, hitTestPadding) ||
                other.hitTestPadding == hitTestPadding) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.draggable, draggable) ||
                other.draggable == draggable) &&
            (identical(other.selectable, selectable) ||
                other.selectable == selectable) &&
            (identical(other.connectable, connectable) ||
                other.connectable == connectable) &&
            (identical(other.deletable, deletable) ||
                other.deletable == deletable) &&
            (identical(other.focusable, focusable) ||
                other.focusable == focusable) &&
            (identical(other.elevateNodeOnSelected, elevateNodeOnSelected) ||
                other.elevateNodeOnSelected == elevateNodeOnSelected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      id,
      position,
      size,
      parentId,
      const DeepCollectionEquality().hash(_handles),
      const DeepCollectionEquality().hash(_data),
      zIndex,
      hitTestPadding,
      hidden,
      draggable,
      selectable,
      connectable,
      deletable,
      focusable,
      elevateNodeOnSelected);

  @override
  String toString() {
    return 'FlowNode(type: $type, id: $id, position: $position, size: $size, parentId: $parentId, handles: $handles, data: $data, zIndex: $zIndex, hitTestPadding: $hitTestPadding, hidden: $hidden, draggable: $draggable, selectable: $selectable, connectable: $connectable, deletable: $deletable, focusable: $focusable, elevateNodeOnSelected: $elevateNodeOnSelected)';
  }
}

/// @nodoc
abstract mixin class _$FlowNodeCopyWith<$Res>
    implements $FlowNodeCopyWith<$Res> {
  factory _$FlowNodeCopyWith(_FlowNode value, $Res Function(_FlowNode) _then) =
      __$FlowNodeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String type,
      String id,
      Offset position,
      Size size,
      String? parentId,
      Map<String, NodeHandle> handles,
      Map<String, dynamic> data,
      int zIndex,
      double hitTestPadding,
      bool? hidden,
      bool? draggable,
      bool? selectable,
      bool? connectable,
      bool? deletable,
      bool? focusable,
      bool? elevateNodeOnSelected});
}

/// @nodoc
class __$FlowNodeCopyWithImpl<$Res> implements _$FlowNodeCopyWith<$Res> {
  __$FlowNodeCopyWithImpl(this._self, this._then);

  final _FlowNode _self;
  final $Res Function(_FlowNode) _then;

  /// Create a copy of FlowNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? position = null,
    Object? size = null,
    Object? parentId = freezed,
    Object? handles = null,
    Object? data = null,
    Object? zIndex = null,
    Object? hitTestPadding = null,
    Object? hidden = freezed,
    Object? draggable = freezed,
    Object? selectable = freezed,
    Object? connectable = freezed,
    Object? deletable = freezed,
    Object? focusable = freezed,
    Object? elevateNodeOnSelected = freezed,
  }) {
    return _then(_FlowNode(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      handles: null == handles
          ? _self._handles
          : handles // ignore: cast_nullable_to_non_nullable
              as Map<String, NodeHandle>,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      hitTestPadding: null == hitTestPadding
          ? _self.hitTestPadding
          : hitTestPadding // ignore: cast_nullable_to_non_nullable
              as double,
      hidden: freezed == hidden
          ? _self.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      draggable: freezed == draggable
          ? _self.draggable
          : draggable // ignore: cast_nullable_to_non_nullable
              as bool?,
      selectable: freezed == selectable
          ? _self.selectable
          : selectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      connectable: freezed == connectable
          ? _self.connectable
          : connectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      deletable: freezed == deletable
          ? _self.deletable
          : deletable // ignore: cast_nullable_to_non_nullable
              as bool?,
      focusable: freezed == focusable
          ? _self.focusable
          : focusable // ignore: cast_nullable_to_non_nullable
              as bool?,
      elevateNodeOnSelected: freezed == elevateNodeOnSelected
          ? _self.elevateNodeOnSelected
          : elevateNodeOnSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on

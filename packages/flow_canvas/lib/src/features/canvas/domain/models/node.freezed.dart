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
mixin _$FlowNode implements DiagnosticableTreeMixin {
  /// Unique identifier for this node.
  String get id;

  /// Type identifier for this node (e.g., 'default', 'input', 'output').
  ///
  /// Used for applying type-specific styling or behavior.
  String get type;

  /// Position of the node's center in canvas coordinates.
  ///
  /// This is the reference point for the node. The visual representation
  /// is rendered centered on this position.
  Offset get position;

  /// Size of the node in logical pixels.
  ///
  /// Defines the width and height of the node's bounding box.
  Size get size;

  /// Optional ID of the parent node (for nested/grouped nodes).
  ///
  /// When set, this node is a child of another node, creating a
  /// parent-child hierarchy for grouping or nesting.
  String? get parentId;

  /// Map of handles attached to this node, keyed by handle ID.
  ///
  /// Handles define connection points where edges can attach.
  /// Handle positions are relative to the node's top-left corner.
  ///
  /// Example:
  /// ```
  /// handles: {
  ///   'input': FlowHandle(/* ... */),
  ///   'output-1': FlowHandle(/* ... */),
  ///   'output-2': FlowHandle(/* ... */),
  /// }
  /// ```
  Map<String, FlowHandle> get handles;

  /// Custom data that can be attached to this node.
  ///
  /// Store application-specific information like labels, values,
  /// configuration, etc.
  Map<String, dynamic> get data;

  /// Z-index for rendering order (higher values render on top).
  ///
  /// Used for layering nodes. Selected nodes are often elevated
  /// temporarily by increasing their z-index.
  int get zIndex;

  /// Padding around the node for easier hit testing in pixels.
  ///
  /// Expands the interactive area beyond the visual bounds, making
  /// the node easier to click/select.
  double get hitTestPadding;

  /// Whether this node should be hidden from view.
  ///
  /// Hidden nodes are not rendered but remain in the data structure.
  /// If null, uses the global canvas setting.
  bool? get hidden;

  /// Whether this node can be dragged by the user.
  ///
  /// If null, uses the global canvas setting.
  bool? get draggable;

  /// Whether this node can be selected by the user.
  ///
  /// If null, uses the global canvas setting.
  bool? get hoverable;

  /// Whether this node can be selected by the user.
  ///
  /// If null, uses the global canvas setting.
  bool? get selectable;

  /// Whether edges can be connected to/from this node.
  ///
  /// If null, uses the global canvas setting.
  bool? get connectable;

  /// Whether this node can be deleted by the user.
  ///
  /// If null, uses the global canvas setting.
  bool? get deletable;

  /// Whether this node can receive keyboard focus.
  ///
  /// If null, uses the global canvas setting.
  bool? get focusable;

  /// Whether this node should be elevated when selected.
  ///
  /// If null, uses the global canvas setting.
  bool? get elevateNodeOnSelected;

  /// Create a copy of FlowNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlowNodeCopyWith<FlowNode> get copyWith =>
      _$FlowNodeCopyWithImpl<FlowNode>(this as FlowNode, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'FlowNode'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('position', position))
      ..add(DiagnosticsProperty('size', size))
      ..add(DiagnosticsProperty('parentId', parentId))
      ..add(DiagnosticsProperty('handles', handles))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('zIndex', zIndex))
      ..add(DiagnosticsProperty('hitTestPadding', hitTestPadding))
      ..add(DiagnosticsProperty('hidden', hidden))
      ..add(DiagnosticsProperty('draggable', draggable))
      ..add(DiagnosticsProperty('hoverable', hoverable))
      ..add(DiagnosticsProperty('selectable', selectable))
      ..add(DiagnosticsProperty('connectable', connectable))
      ..add(DiagnosticsProperty('deletable', deletable))
      ..add(DiagnosticsProperty('focusable', focusable))
      ..add(
          DiagnosticsProperty('elevateNodeOnSelected', elevateNodeOnSelected));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlowNode &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
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
            (identical(other.hoverable, hoverable) ||
                other.hoverable == hoverable) &&
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
      id,
      type,
      position,
      size,
      parentId,
      const DeepCollectionEquality().hash(handles),
      const DeepCollectionEquality().hash(data),
      zIndex,
      hitTestPadding,
      hidden,
      draggable,
      hoverable,
      selectable,
      connectable,
      deletable,
      focusable,
      elevateNodeOnSelected);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FlowNode(id: $id, type: $type, position: $position, size: $size, parentId: $parentId, handles: $handles, data: $data, zIndex: $zIndex, hitTestPadding: $hitTestPadding, hidden: $hidden, draggable: $draggable, hoverable: $hoverable, selectable: $selectable, connectable: $connectable, deletable: $deletable, focusable: $focusable, elevateNodeOnSelected: $elevateNodeOnSelected)';
  }
}

/// @nodoc
abstract mixin class $FlowNodeCopyWith<$Res> {
  factory $FlowNodeCopyWith(FlowNode value, $Res Function(FlowNode) _then) =
      _$FlowNodeCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String type,
      Offset position,
      Size size,
      String? parentId,
      Map<String, FlowHandle> handles,
      Map<String, dynamic> data,
      int zIndex,
      double hitTestPadding,
      bool? hidden,
      bool? draggable,
      bool? hoverable,
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
    Object? id = null,
    Object? type = null,
    Object? position = null,
    Object? size = null,
    Object? parentId = freezed,
    Object? handles = null,
    Object? data = null,
    Object? zIndex = null,
    Object? hitTestPadding = null,
    Object? hidden = freezed,
    Object? draggable = freezed,
    Object? hoverable = freezed,
    Object? selectable = freezed,
    Object? connectable = freezed,
    Object? deletable = freezed,
    Object? focusable = freezed,
    Object? elevateNodeOnSelected = freezed,
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
              as Map<String, FlowHandle>,
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
      hoverable: freezed == hoverable
          ? _self.hoverable
          : hoverable // ignore: cast_nullable_to_non_nullable
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
            String id,
            String type,
            Offset position,
            Size size,
            String? parentId,
            Map<String, FlowHandle> handles,
            Map<String, dynamic> data,
            int zIndex,
            double hitTestPadding,
            bool? hidden,
            bool? draggable,
            bool? hoverable,
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
            _that.id,
            _that.type,
            _that.position,
            _that.size,
            _that.parentId,
            _that.handles,
            _that.data,
            _that.zIndex,
            _that.hitTestPadding,
            _that.hidden,
            _that.draggable,
            _that.hoverable,
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
            String id,
            String type,
            Offset position,
            Size size,
            String? parentId,
            Map<String, FlowHandle> handles,
            Map<String, dynamic> data,
            int zIndex,
            double hitTestPadding,
            bool? hidden,
            bool? draggable,
            bool? hoverable,
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
            _that.id,
            _that.type,
            _that.position,
            _that.size,
            _that.parentId,
            _that.handles,
            _that.data,
            _that.zIndex,
            _that.hitTestPadding,
            _that.hidden,
            _that.draggable,
            _that.hoverable,
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
            String id,
            String type,
            Offset position,
            Size size,
            String? parentId,
            Map<String, FlowHandle> handles,
            Map<String, dynamic> data,
            int zIndex,
            double hitTestPadding,
            bool? hidden,
            bool? draggable,
            bool? hoverable,
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
            _that.id,
            _that.type,
            _that.position,
            _that.size,
            _that.parentId,
            _that.handles,
            _that.data,
            _that.zIndex,
            _that.hitTestPadding,
            _that.hidden,
            _that.draggable,
            _that.hoverable,
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

class _FlowNode extends FlowNode with DiagnosticableTreeMixin {
  const _FlowNode(
      {required this.id,
      required this.type,
      required this.position,
      required this.size,
      this.parentId,
      final Map<String, FlowHandle> handles = const {},
      final Map<String, dynamic> data = const {},
      this.zIndex = 0,
      this.hitTestPadding = 10.0,
      this.hidden,
      this.draggable,
      this.hoverable,
      this.selectable,
      this.connectable,
      this.deletable,
      this.focusable,
      this.elevateNodeOnSelected})
      : _handles = handles,
        _data = data,
        super._();

  /// Unique identifier for this node.
  @override
  final String id;

  /// Type identifier for this node (e.g., 'default', 'input', 'output').
  ///
  /// Used for applying type-specific styling or behavior.
  @override
  final String type;

  /// Position of the node's center in canvas coordinates.
  ///
  /// This is the reference point for the node. The visual representation
  /// is rendered centered on this position.
  @override
  final Offset position;

  /// Size of the node in logical pixels.
  ///
  /// Defines the width and height of the node's bounding box.
  @override
  final Size size;

  /// Optional ID of the parent node (for nested/grouped nodes).
  ///
  /// When set, this node is a child of another node, creating a
  /// parent-child hierarchy for grouping or nesting.
  @override
  final String? parentId;

  /// Map of handles attached to this node, keyed by handle ID.
  ///
  /// Handles define connection points where edges can attach.
  /// Handle positions are relative to the node's top-left corner.
  ///
  /// Example:
  /// ```
  /// handles: {
  ///   'input': FlowHandle(/* ... */),
  ///   'output-1': FlowHandle(/* ... */),
  ///   'output-2': FlowHandle(/* ... */),
  /// }
  /// ```
  final Map<String, FlowHandle> _handles;

  /// Map of handles attached to this node, keyed by handle ID.
  ///
  /// Handles define connection points where edges can attach.
  /// Handle positions are relative to the node's top-left corner.
  ///
  /// Example:
  /// ```
  /// handles: {
  ///   'input': FlowHandle(/* ... */),
  ///   'output-1': FlowHandle(/* ... */),
  ///   'output-2': FlowHandle(/* ... */),
  /// }
  /// ```
  @override
  @JsonKey()
  Map<String, FlowHandle> get handles {
    if (_handles is EqualUnmodifiableMapView) return _handles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_handles);
  }

  /// Custom data that can be attached to this node.
  ///
  /// Store application-specific information like labels, values,
  /// configuration, etc.
  final Map<String, dynamic> _data;

  /// Custom data that can be attached to this node.
  ///
  /// Store application-specific information like labels, values,
  /// configuration, etc.
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  /// Z-index for rendering order (higher values render on top).
  ///
  /// Used for layering nodes. Selected nodes are often elevated
  /// temporarily by increasing their z-index.
  @override
  @JsonKey()
  final int zIndex;

  /// Padding around the node for easier hit testing in pixels.
  ///
  /// Expands the interactive area beyond the visual bounds, making
  /// the node easier to click/select.
  @override
  @JsonKey()
  final double hitTestPadding;

  /// Whether this node should be hidden from view.
  ///
  /// Hidden nodes are not rendered but remain in the data structure.
  /// If null, uses the global canvas setting.
  @override
  final bool? hidden;

  /// Whether this node can be dragged by the user.
  ///
  /// If null, uses the global canvas setting.
  @override
  final bool? draggable;

  /// Whether this node can be selected by the user.
  ///
  /// If null, uses the global canvas setting.
  @override
  final bool? hoverable;

  /// Whether this node can be selected by the user.
  ///
  /// If null, uses the global canvas setting.
  @override
  final bool? selectable;

  /// Whether edges can be connected to/from this node.
  ///
  /// If null, uses the global canvas setting.
  @override
  final bool? connectable;

  /// Whether this node can be deleted by the user.
  ///
  /// If null, uses the global canvas setting.
  @override
  final bool? deletable;

  /// Whether this node can receive keyboard focus.
  ///
  /// If null, uses the global canvas setting.
  @override
  final bool? focusable;

  /// Whether this node should be elevated when selected.
  ///
  /// If null, uses the global canvas setting.
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'FlowNode'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('position', position))
      ..add(DiagnosticsProperty('size', size))
      ..add(DiagnosticsProperty('parentId', parentId))
      ..add(DiagnosticsProperty('handles', handles))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('zIndex', zIndex))
      ..add(DiagnosticsProperty('hitTestPadding', hitTestPadding))
      ..add(DiagnosticsProperty('hidden', hidden))
      ..add(DiagnosticsProperty('draggable', draggable))
      ..add(DiagnosticsProperty('hoverable', hoverable))
      ..add(DiagnosticsProperty('selectable', selectable))
      ..add(DiagnosticsProperty('connectable', connectable))
      ..add(DiagnosticsProperty('deletable', deletable))
      ..add(DiagnosticsProperty('focusable', focusable))
      ..add(
          DiagnosticsProperty('elevateNodeOnSelected', elevateNodeOnSelected));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlowNode &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
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
            (identical(other.hoverable, hoverable) ||
                other.hoverable == hoverable) &&
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
      id,
      type,
      position,
      size,
      parentId,
      const DeepCollectionEquality().hash(_handles),
      const DeepCollectionEquality().hash(_data),
      zIndex,
      hitTestPadding,
      hidden,
      draggable,
      hoverable,
      selectable,
      connectable,
      deletable,
      focusable,
      elevateNodeOnSelected);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FlowNode(id: $id, type: $type, position: $position, size: $size, parentId: $parentId, handles: $handles, data: $data, zIndex: $zIndex, hitTestPadding: $hitTestPadding, hidden: $hidden, draggable: $draggable, hoverable: $hoverable, selectable: $selectable, connectable: $connectable, deletable: $deletable, focusable: $focusable, elevateNodeOnSelected: $elevateNodeOnSelected)';
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
      {String id,
      String type,
      Offset position,
      Size size,
      String? parentId,
      Map<String, FlowHandle> handles,
      Map<String, dynamic> data,
      int zIndex,
      double hitTestPadding,
      bool? hidden,
      bool? draggable,
      bool? hoverable,
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
    Object? id = null,
    Object? type = null,
    Object? position = null,
    Object? size = null,
    Object? parentId = freezed,
    Object? handles = null,
    Object? data = null,
    Object? zIndex = null,
    Object? hitTestPadding = null,
    Object? hidden = freezed,
    Object? draggable = freezed,
    Object? hoverable = freezed,
    Object? selectable = freezed,
    Object? connectable = freezed,
    Object? deletable = freezed,
    Object? focusable = freezed,
    Object? elevateNodeOnSelected = freezed,
  }) {
    return _then(_FlowNode(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
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
              as Map<String, FlowHandle>,
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
      hoverable: freezed == hoverable
          ? _self.hoverable
          : hoverable // ignore: cast_nullable_to_non_nullable
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

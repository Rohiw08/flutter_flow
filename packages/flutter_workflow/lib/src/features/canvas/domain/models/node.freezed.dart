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
  BuiltMap<String, NodeHandle> get internalHandles;
  BuiltMap<String, dynamic> get internalData;
  bool get isSelected;
  bool? get isDraggable;
  bool? get isSelectable;
  bool? get isFocusable; // optional
  bool get isHidden;
  bool get isDragging;
  bool get isResizing;
  int get zIndex;

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
            (identical(other.internalHandles, internalHandles) ||
                other.internalHandles == internalHandles) &&
            (identical(other.internalData, internalData) ||
                other.internalData == internalData) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isDraggable, isDraggable) ||
                other.isDraggable == isDraggable) &&
            (identical(other.isSelectable, isSelectable) ||
                other.isSelectable == isSelectable) &&
            (identical(other.isFocusable, isFocusable) ||
                other.isFocusable == isFocusable) &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            (identical(other.isDragging, isDragging) ||
                other.isDragging == isDragging) &&
            (identical(other.isResizing, isResizing) ||
                other.isResizing == isResizing) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      id,
      position,
      size,
      internalHandles,
      internalData,
      isSelected,
      isDraggable,
      isSelectable,
      isFocusable,
      isHidden,
      isDragging,
      isResizing,
      zIndex);

  @override
  String toString() {
    return 'FlowNode(type: $type, id: $id, position: $position, size: $size, internalHandles: $internalHandles, internalData: $internalData, isSelected: $isSelected, isDraggable: $isDraggable, isSelectable: $isSelectable, isFocusable: $isFocusable, isHidden: $isHidden, isDragging: $isDragging, isResizing: $isResizing, zIndex: $zIndex)';
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
      BuiltMap<String, NodeHandle> internalHandles,
      BuiltMap<String, dynamic> internalData,
      bool isSelected,
      bool? isDraggable,
      bool? isSelectable,
      bool? isFocusable,
      bool isHidden,
      bool isDragging,
      bool isResizing,
      int zIndex});
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
    Object? internalHandles = null,
    Object? internalData = null,
    Object? isSelected = null,
    Object? isDraggable = freezed,
    Object? isSelectable = freezed,
    Object? isFocusable = freezed,
    Object? isHidden = null,
    Object? isDragging = null,
    Object? isResizing = null,
    Object? zIndex = null,
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
      internalHandles: null == internalHandles
          ? _self.internalHandles
          : internalHandles // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, NodeHandle>,
      internalData: null == internalData
          ? _self.internalData
          : internalData // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, dynamic>,
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isDraggable: freezed == isDraggable
          ? _self.isDraggable
          : isDraggable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSelectable: freezed == isSelectable
          ? _self.isSelectable
          : isSelectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isFocusable: freezed == isFocusable
          ? _self.isFocusable
          : isFocusable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isHidden: null == isHidden
          ? _self.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      isDragging: null == isDragging
          ? _self.isDragging
          : isDragging // ignore: cast_nullable_to_non_nullable
              as bool,
      isResizing: null == isResizing
          ? _self.isResizing
          : isResizing // ignore: cast_nullable_to_non_nullable
              as bool,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
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
            BuiltMap<String, NodeHandle> internalHandles,
            BuiltMap<String, dynamic> internalData,
            bool isSelected,
            bool? isDraggable,
            bool? isSelectable,
            bool? isFocusable,
            bool isHidden,
            bool isDragging,
            bool isResizing,
            int zIndex)?
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
            _that.internalHandles,
            _that.internalData,
            _that.isSelected,
            _that.isDraggable,
            _that.isSelectable,
            _that.isFocusable,
            _that.isHidden,
            _that.isDragging,
            _that.isResizing,
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
            String type,
            String id,
            Offset position,
            Size size,
            BuiltMap<String, NodeHandle> internalHandles,
            BuiltMap<String, dynamic> internalData,
            bool isSelected,
            bool? isDraggable,
            bool? isSelectable,
            bool? isFocusable,
            bool isHidden,
            bool isDragging,
            bool isResizing,
            int zIndex)
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
            _that.internalHandles,
            _that.internalData,
            _that.isSelected,
            _that.isDraggable,
            _that.isSelectable,
            _that.isFocusable,
            _that.isHidden,
            _that.isDragging,
            _that.isResizing,
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
            String type,
            String id,
            Offset position,
            Size size,
            BuiltMap<String, NodeHandle> internalHandles,
            BuiltMap<String, dynamic> internalData,
            bool isSelected,
            bool? isDraggable,
            bool? isSelectable,
            bool? isFocusable,
            bool isHidden,
            bool isDragging,
            bool isResizing,
            int zIndex)?
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
            _that.internalHandles,
            _that.internalData,
            _that.isSelected,
            _that.isDraggable,
            _that.isSelectable,
            _that.isFocusable,
            _that.isHidden,
            _that.isDragging,
            _that.isResizing,
            _that.zIndex);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FlowNode extends FlowNode {
  _FlowNode(
      {required this.type,
      required this.id,
      required this.position,
      required this.size,
      required this.internalHandles,
      required this.internalData,
      this.isSelected = false,
      this.isDraggable,
      this.isSelectable,
      this.isFocusable,
      this.isHidden = false,
      this.isDragging = false,
      this.isResizing = false,
      this.zIndex = 0})
      : super._();

  @override
  final String type;
  @override
  final String id;
  @override
  final Offset position;
  @override
  final Size size;
  @override
  final BuiltMap<String, NodeHandle> internalHandles;
  @override
  final BuiltMap<String, dynamic> internalData;
  @override
  @JsonKey()
  final bool isSelected;
  @override
  final bool? isDraggable;
  @override
  final bool? isSelectable;
  @override
  final bool? isFocusable;
// optional
  @override
  @JsonKey()
  final bool isHidden;
  @override
  @JsonKey()
  final bool isDragging;
  @override
  @JsonKey()
  final bool isResizing;
  @override
  @JsonKey()
  final int zIndex;

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
            (identical(other.internalHandles, internalHandles) ||
                other.internalHandles == internalHandles) &&
            (identical(other.internalData, internalData) ||
                other.internalData == internalData) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isDraggable, isDraggable) ||
                other.isDraggable == isDraggable) &&
            (identical(other.isSelectable, isSelectable) ||
                other.isSelectable == isSelectable) &&
            (identical(other.isFocusable, isFocusable) ||
                other.isFocusable == isFocusable) &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            (identical(other.isDragging, isDragging) ||
                other.isDragging == isDragging) &&
            (identical(other.isResizing, isResizing) ||
                other.isResizing == isResizing) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      id,
      position,
      size,
      internalHandles,
      internalData,
      isSelected,
      isDraggable,
      isSelectable,
      isFocusable,
      isHidden,
      isDragging,
      isResizing,
      zIndex);

  @override
  String toString() {
    return 'FlowNode(type: $type, id: $id, position: $position, size: $size, internalHandles: $internalHandles, internalData: $internalData, isSelected: $isSelected, isDraggable: $isDraggable, isSelectable: $isSelectable, isFocusable: $isFocusable, isHidden: $isHidden, isDragging: $isDragging, isResizing: $isResizing, zIndex: $zIndex)';
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
      BuiltMap<String, NodeHandle> internalHandles,
      BuiltMap<String, dynamic> internalData,
      bool isSelected,
      bool? isDraggable,
      bool? isSelectable,
      bool? isFocusable,
      bool isHidden,
      bool isDragging,
      bool isResizing,
      int zIndex});
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
    Object? internalHandles = null,
    Object? internalData = null,
    Object? isSelected = null,
    Object? isDraggable = freezed,
    Object? isSelectable = freezed,
    Object? isFocusable = freezed,
    Object? isHidden = null,
    Object? isDragging = null,
    Object? isResizing = null,
    Object? zIndex = null,
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
      internalHandles: null == internalHandles
          ? _self.internalHandles
          : internalHandles // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, NodeHandle>,
      internalData: null == internalData
          ? _self.internalData
          : internalData // ignore: cast_nullable_to_non_nullable
              as BuiltMap<String, dynamic>,
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isDraggable: freezed == isDraggable
          ? _self.isDraggable
          : isDraggable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSelectable: freezed == isSelectable
          ? _self.isSelectable
          : isSelectable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isFocusable: freezed == isFocusable
          ? _self.isFocusable
          : isFocusable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isHidden: null == isHidden
          ? _self.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      isDragging: null == isDragging
          ? _self.isDragging
          : isDragging // ignore: cast_nullable_to_non_nullable
              as bool,
      isResizing: null == isResizing
          ? _self.isResizing
          : isResizing // ignore: cast_nullable_to_non_nullable
              as bool,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on

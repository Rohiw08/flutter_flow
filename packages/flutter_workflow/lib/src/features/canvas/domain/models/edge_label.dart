import 'package:built_collection/built_collection.dart';
import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/utility/random_id_generator.dart';

part 'edge_label.freezed.dart';

/// Represents a label attached to an edge on the canvas.
@freezed
abstract class EdgeLabel with _$EdgeLabel {
  const EdgeLabel._();

  factory EdgeLabel({
    required String id,
    required String text,
    required BuiltMap<String, dynamic> internalData,
    @Default(0.5) double position,
    @Default(Offset(0, 0)) Offset offset,
    @Default(true) bool visible,
    @Default(false) bool showBackground,
    BoxDecoration? backgroundDecoration,
    @Default(EdgeInsets.all(2.0)) EdgeInsets backgroundPadding,
    @Default(4.0) double backgroundBorderRadius,
    TextStyle? textStyle,
    @Default(0) int zIndex,
  }) = _EdgeLabel;

  /// Convenient getter to expose `data` as regular `Map`.
  Map<String, dynamic> get data => Map.unmodifiable(internalData.asMap());

  /// Create a label with an auto-generated unique id.
  factory EdgeLabel.create({
    required String text,
    double position = 0.5,
    Offset offset = const Offset(0, 0),
    bool visible = true,
    bool showBackground = false,
    BoxDecoration? backgroundDecoration,
    EdgeInsets backgroundPadding = const EdgeInsets.all(2.0),
    double backgroundBorderRadius = 4.0,
    TextStyle? textStyle,
    int zIndex = 0,
    Map<String, dynamic>? data,
  }) {
    return EdgeLabel(
      id: generateUniqueId(),
      text: text,
      position: position,
      offset: offset,
      visible: visible,
      showBackground: showBackground,
      backgroundDecoration: backgroundDecoration,
      backgroundPadding: backgroundPadding,
      backgroundBorderRadius: backgroundBorderRadius,
      textStyle: textStyle,
      zIndex: zIndex,
      internalData: BuiltMap<String, dynamic>(data ?? {}),
    );
  }
}

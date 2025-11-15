import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// ParentData used by children of ZIndexStack
class ZIndexStackParentData extends ContainerBoxParentData<RenderBox> {
  /// Z index for ordering. Can be negative or positive.
  int zIndex = 0;

  /// Offset for child's top-left relative to the stack's origin.
  /// You should set this using ZIndexedPositioned.
  @override
  String toString() => 'zIndex=$zIndex; offset=$offset';
}

/// ParentDataWidget for setting zIndex alone.
class ZIndex extends ParentDataWidget<ZIndexStackParentData> {
  final int zIndex;

  const ZIndex({
    super.key,
    required this.zIndex,
    required super.child,
  });

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is ZIndexStackParentData);
    final parentData = renderObject.parentData as ZIndexStackParentData;
    if (parentData.zIndex != zIndex) {
      parentData.zIndex = zIndex;
      final parent = renderObject.parent;
      if (parent is RenderZIndexStack) {
        parent.markNeedsSortAndPaint();
      } else if (parent is RenderObject) {
        parent.markNeedsPaint();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => ZIndexStack;
}

/// Multi-child widget that only handles Z-index + painting order + culling.
/// Children must set their own pd.offset (via ZIndexedPositioned) to be placed.
class ZIndexStack extends MultiChildRenderObjectWidget {
  const ZIndexStack({
    super.key,
    super.children = const <Widget>[],
  });

  @override
  RenderZIndexStack createRenderObject(BuildContext context) =>
      RenderZIndexStack();
}

/// The optimized RenderBox backing ZIndexStack.
class RenderZIndexStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ZIndexStackParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ZIndexStackParentData> {
  RenderZIndexStack();

  // Cached sorted children (back-to-front)
  final List<RenderBox> _sortedChildren = <RenderBox>[];
  bool _needsSort = true;

  /// Mark that sorting is needed and repaint should occur.
  void markNeedsSortAndPaint() {
    _needsSort = true;
    markNeedsPaint();
  }

  // Hooks to mark sort dirty when children change
  @override
  void insert(RenderBox child, {RenderBox? after}) {
    super.insert(child, after: after);
    _needsSort = true;
    markNeedsPaint();
    markNeedsLayout();
  }

  @override
  void remove(RenderBox child) {
    super.remove(child);
    _needsSort = true;
    markNeedsPaint();
    markNeedsLayout();
  }

  @override
  void move(RenderBox child, {RenderBox? after}) {
    super.move(child, after: after);
    _needsSort = true;
    markNeedsPaint();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ZIndexStackParentData) {
      child.parentData = ZIndexStackParentData();
    }
  }

  // Perform layout. We try to be cheap: children get loose constraints and
  // parentUsesSize=false. We select our own size either from bounded constraints
  // or by calculating the union of child bounds when unbounded.
  @override
  void performLayout() {
    // Layout children with loose constraints if we have bounded constraints.
    // If constraints are unbounded, we will compute a size from children bounds.
    final hasBoundedWidth = constraints.hasBoundedWidth;
    final hasBoundedHeight = constraints.hasBoundedHeight;

    if (hasBoundedWidth && hasBoundedHeight) {
      size = constraints.biggest;
      final BoxConstraints loose = BoxConstraints.loose(size);
      RenderBox? child = firstChild;
      while (child != null) {
        final childParentData = child.parentData as ZIndexStackParentData;
        child.layout(loose, parentUsesSize: false);
        child = childParentData.nextSibling;
      }
    } else {
      // Unbounded in at least one axis. Compute union of children bounds.
      double maxRight = 0.0;
      double maxBottom = 0.0;
      double minLeft = double.infinity;
      double minTop = double.infinity;
      bool any = false;

      RenderBox? child = firstChild;
      while (child != null) {
        final childParentData = child.parentData as ZIndexStackParentData;
        // Give child an unconstrained layout but avoid infinite constraints.
        child.layout(const BoxConstraints(), parentUsesSize: false);

        if (child.hasSize) {
          any = true;
          final Offset o = childParentData.offset;
          minLeft = math.min(minLeft, o.dx);
          minTop = math.min(minTop, o.dy);
          maxRight = math.max(maxRight, o.dx + child.size.width);
          maxBottom = math.max(maxBottom, o.dy + child.size.height);
        } else {
          // For children without size, we still consider their offset
          any = true;
          final Offset o = childParentData.offset;
          minLeft = math.min(minLeft, o.dx);
          minTop = math.min(minTop, o.dy);
          maxRight = math.max(maxRight, o.dx);
          maxBottom = math.max(maxBottom, o.dy);
        }
        child = childParentData.nextSibling;
      }

      if (!any) {
        size = constraints.smallest;
      } else {
        final double width = (maxRight.isFinite ? maxRight : 0.0) -
            (minLeft.isFinite ? minLeft : 0.0);
        final double height = (maxBottom.isFinite ? maxBottom : 0.0) -
            (minTop.isFinite ? minTop : 0.0);
        // Use constraints.constrain to clamp to any finite maxima.
        size = constraints.constrain(Size(width, height));
      }
    }
  }

  // Ensure children list is sorted by zIndex into _sortedChildren (back-to-front)
  void _ensureSorted() {
    if (!_needsSort) return;
    _needsSort = false;
    _sortedChildren.clear();

    RenderBox? child = firstChild;
    while (child != null) {
      _sortedChildren.add(child);
      final pd = child.parentData as ZIndexStackParentData;
      child = pd.nextSibling;
    }

    // Sort in-place by accessing parentData directly (avoid extra allocations).
    _sortedChildren.sort((a, b) {
      final az = (a.parentData as ZIndexStackParentData).zIndex;
      final bz = (b.parentData as ZIndexStackParentData).zIndex;
      return az.compareTo(bz);
    });
  }

  // Paint children in z order; cull children whose bounds don't overlap viewport.
  @override
  void paint(PaintingContext context, Offset offset) {
    if (size.isEmpty) return;
    _ensureSorted();

    final Rect viewport = offset & size;

    for (final child in _sortedChildren) {
      final pd = child.parentData as ZIndexStackParentData;
      final Offset childOffset = offset + pd.offset;

      if (child.hasSize) {
        final Rect childRect = childOffset & child.size;
        if (!childRect.overlaps(viewport)) {
          // Cull off-screen child
          continue;
        }
      }

      // Paint child at its offset
      context.paintChild(child, childOffset);
    }
  }

  // Hit test children from front-to-back (reverse sorted order).
  // We do a conservative check using child's axis-aligned bounds and offset.
  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (firstChild == null) return false;
    _ensureSorted();

    // Iterate reversed (front = last in _sortedChildren)
    for (int i = _sortedChildren.length - 1; i >= 0; --i) {
      final child = _sortedChildren[i];
      final pd = child.parentData as ZIndexStackParentData;
      final Offset childOffset = pd.offset;

      // Quick culling using child bounds if available
      if (child.hasSize) {
        final Rect childRect = childOffset & child.size;
        if (!childRect.contains(position)) {
          continue;
        }
      }

      final bool isHit = result.addWithPaintOffset(
        offset: childOffset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child.hitTest(result, position: transformed);
        },
      );

      if (isHit) return true;
    }

    return false;
  }

  // Debug info
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('needsSort',
        value: _needsSort, ifTrue: 'needs sort', ifFalse: 'sorted'));
    properties.add(IntProperty('childCount', childCount));
  }
}

/// Helper widget to set z-index
class ZIndexed extends ParentDataWidget<ZIndexStackParentData> {
  final int zIndex;

  const ZIndexed({
    super.key,
    required this.zIndex,
    required super.child,
  });

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as ZIndexStackParentData;
    if (parentData.zIndex != zIndex) {
      parentData.zIndex = zIndex;
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsPaint();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => ZIndexStack;
}

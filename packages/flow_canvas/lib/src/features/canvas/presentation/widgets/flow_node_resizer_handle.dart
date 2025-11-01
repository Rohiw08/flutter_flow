import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A simple draggable handle for node resizing.
///
/// - Supports offset translation (x → right, y → up).
/// - No animations or theming — lightweight and direct.
class NodeResizeHandle extends StatelessWidget {
  final String nodeId;
  final Alignment direction;
  final Offset offset;
  final double size;
  final Color color;
  final VoidCallback? onResizeStart;
  final ValueChanged<Offset>? onResizeUpdate;
  final VoidCallback? onResizeEnd;

  const NodeResizeHandle({
    super.key,
    required this.nodeId,
    required this.direction,
    this.offset = Offset.zero,
    this.size = 10.0,
    this.color = Colors.blue,
    this.onResizeStart,
    this.onResizeUpdate,
    this.onResizeEnd,
  });

  SystemMouseCursor get _cursor {
    switch (direction) {
      case Alignment.topLeft:
      case Alignment.bottomRight:
        return SystemMouseCursors.resizeUpLeftDownRight;
      case Alignment.topRight:
      case Alignment.bottomLeft:
        return SystemMouseCursors.resizeUpRightDownLeft;
      case Alignment.centerLeft:
      case Alignment.centerRight:
        return SystemMouseCursors.resizeRight;
      case Alignment.topCenter:
      case Alignment.bottomCenter:
        return SystemMouseCursors.resizeDown;
      default:
        return SystemMouseCursors.move;
    }
  }

  @override
  Widget build(BuildContext context) {
    final adjustedOffset = Offset(offset.dx, -offset.dy);

    return Align(
      alignment: direction,
      child: Transform.translate(
        offset: adjustedOffset,
        child: MouseRegion(
          cursor: _cursor,
          child: GestureDetector(
            onPanStart: (_) => onResizeStart?.call(),
            onPanUpdate: (details) => onResizeUpdate?.call(details.delta),
            onPanEnd: (_) => onResizeEnd?.call(),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

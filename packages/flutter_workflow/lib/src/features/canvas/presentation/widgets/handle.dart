import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/features/canvas/domain/state/connection_state.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/flow_canvas_facade.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/theme/components/handle_theme.dart';
import 'package:flutter_workflow/src/theme/theme_extensions.dart';
import 'package:flutter_workflow/src/options/options_extensions.dart';
import 'package:flutter_workflow/src/options/components/node_options.dart';

/// A callback function to validate a potential connection.
typedef IsValidConnectionCallback = bool Function(String connection);

class Handle extends ConsumerStatefulWidget {
  final FlowCanvasFacade facade;
  final String nodeId;
  final String handleId;
  final HandlePosition? position;
  final HandleType type;
  final Widget? child;

  // --- Style Overrides (Tier 1 Theming) ---
  final double? size;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;

  // A callback to determine if a connection to this handle is valid.
  final IsValidConnectionCallback? onValidateConnection;

  const Handle({
    super.key,
    required this.facade,
    required this.nodeId,
    required this.handleId,
    this.position,
    this.type = HandleType.source,
    this.child,
    this.size,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.onValidateConnection,
  });

  @override
  ConsumerState<Handle> createState() => _HandleState();
}

class _HandleState extends ConsumerState<Handle> {
  bool _isHovered = false;

  String get handleKey => '${widget.nodeId}/${widget.handleId}';

  @override
  Widget build(BuildContext context) {
    final theme = context.flowCanvasTheme;
    final handleTheme = theme.handle;

    // Resolve final styles using the three-tier system.
    final double finalSize = widget.size ?? handleTheme.size;
    final Color finalBorderColor =
        widget.borderColor ?? handleTheme.borderColor;
    final double finalBorderWidth =
        widget.borderWidth ?? handleTheme.borderWidth;

    return StreamBuilder<FlowConnectionState?>(
      stream: widget.facade.connectionStream,
      builder: (context, snapshot) {
        final connection = snapshot.data;
        final isMyConnectionSource = connection?.fromNodeId == widget.nodeId &&
            connection?.fromHandleId == widget.handleId;
        final isTargeted = connection?.hoveredTargetKey == handleKey;

        final Color finalColor = widget.color ??
            _getHandleColor(handleTheme, isMyConnectionSource, isTargeted);
        final scale =
            (_isHovered || isMyConnectionSource || isTargeted) ? 1.4 : 1.0;

        final handleWidget = MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.grab,
          child: GestureDetector(
            onPanStart: (details) {
              if (widget.type == HandleType.target) return;
              final flowOptions = context.flowCanvasOptions;
              if (!flowOptions.enableConnectivity) return;
              final node = widget.facade.state.nodes[widget.nodeId];
              if (node != null && !node.isConnectable(context)) return;
              widget.facade.startConnection(
                widget.nodeId,
                widget.handleId,
                details.globalPosition,
              );
            },
            onPanEnd: (details) {
              if (widget.type == HandleType.target) return;
              widget.facade.endConnection();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transformAlignment: Alignment.center,
              transform: Matrix4.identity()..scale(scale),
              width: finalSize * 3, // Gesture area
              height: finalSize * 3, // Gesture area
              child: Center(
                child: widget.child ??
                    Container(
                      width: finalSize,
                      height: finalSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: finalColor,
                        border: Border.all(
                          color: finalBorderColor,
                          width: finalBorderWidth,
                        ),
                      ),
                    ),
              ),
            ),
          ),
        );

        if (widget.position != null) {
          return Align(
            alignment: _getAlignment(),
            child: handleWidget,
          );
        }
        return handleWidget;
      },
    );
  }

  Color _getHandleColor(
    FlowCanvasHandleStyle handleTheme,
    bool isMyConnectionSource,
    bool isTargeted,
  ) {
    if (isMyConnectionSource) {
      return handleTheme.activeColor;
    }
    if (isTargeted) {
      // TODO: Implement connection validation logic via facade
      return handleTheme.validTargetColor;
    }
    if (_isHovered) {
      return handleTheme.hoverColor;
    }
    return handleTheme.idleColor;
  }

  Alignment _getAlignment() {
    switch (widget.position) {
      case HandlePosition.top:
        return Alignment.topCenter;
      case HandlePosition.right:
        return Alignment.centerRight;
      case HandlePosition.bottom:
        return Alignment.bottomCenter;
      case HandlePosition.left:
        return Alignment.centerLeft;
      default:
        return Alignment.center;
    }
  }
}

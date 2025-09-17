import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/src/shared/enums.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/theme/components/handle_theme.dart';
import 'package:flutter_workflow/src/features/canvas/presentation/options/options_extensions.dart';
import 'package:flutter_workflow/src/features/canvas/domain/models/connection.dart';

/// A callback function to validate a potential connection.
typedef IsValidConnectionCallback = bool Function(String connection);

class Handle extends ConsumerStatefulWidget {
  final String nodeId;
  final String handleId;
  final HandlePosition? position;
  final HandleType type;
  final Widget? child;

  // Theming override
  final FlowHandleStyle? handleStyle;

  // Connection wiring (disassociated from facade)
  final Stream<FlowConnection?> connectionStream;
  final void Function(String nodeId, String handleId, Offset globalPos)
      onStartConnection;
  final VoidCallback onEndConnection;

  // A callback to determine if a connection to this handle is valid.
  final IsValidConnectionCallback? onValidateConnection;

  const Handle({
    super.key,
    required this.nodeId,
    required this.handleId,
    required this.connectionStream,
    required this.onStartConnection,
    required this.onEndConnection,
    this.position,
    this.type = HandleType.both,
    this.child,
    this.handleStyle,
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
    final theme =
        const FlowHandleStyle().resolveHandleTheme(context, widget.handleStyle);

    final double finalSize = theme.size ?? 10.0;
    final Color finalBorderColor = theme.borderColor ?? Colors.white;
    final double finalBorderWidth = theme.borderWidth ?? 1.5;

    return StreamBuilder<FlowConnection?>(
      stream: widget.connectionStream,
      builder: (context, snapshot) {
        final connection = snapshot.data;
        final isMyConnectionSource = connection?.fromNodeId == widget.nodeId &&
            connection?.fromHandleId == widget.handleId;
        final isTargeted = connection?.toNodeId == widget.nodeId &&
            connection?.toHandleId == widget.handleId;

        final bool? isValid = _evaluateValidity(connection);

        final Color finalColor =
            _getHandleColor(theme, isMyConnectionSource, isTargeted, isValid);
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
              widget.onStartConnection(
                widget.nodeId,
                widget.handleId,
                details.globalPosition,
              );
            },
            onPanEnd: (details) {
              if (widget.type == HandleType.target) return;
              widget.onEndConnection();
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

  // Returns true/false when both ends are known, otherwise null (unknown)
  bool? _evaluateValidity(FlowConnection? connection) {
    if (widget.onValidateConnection == null || connection == null) {
      return null; // No validation or no active connection yet
    }
    final from = '${connection.fromNodeId}/${connection.fromHandleId}';
    final to = '${connection.toNodeId}/${connection.toHandleId}';
    // Only validate if both ends are non-null
    if (connection.fromNodeId == null ||
        connection.fromHandleId == null ||
        connection.toNodeId == null ||
        connection.toHandleId == null) {
      return null;
    }
    final descriptor = '$from->$to';
    return widget.onValidateConnection!(descriptor);
  }

  Color _getHandleColor(
    FlowHandleStyle handleTheme,
    bool isMyConnectionSource,
    bool isTargeted,
    bool? isValid,
  ) {
    if (isMyConnectionSource) {
      return handleTheme.activeColor ?? handleTheme.idleColor ?? Colors.blue;
    }
    if (isTargeted) {
      // Use validation result if available when targeted
      if (isValid == false) {
        return handleTheme.invalidTargetColor ??
            handleTheme.hoverColor ??
            handleTheme.idleColor ??
            Colors.redAccent;
      }
      return handleTheme.validTargetColor ??
          handleTheme.hoverColor ??
          handleTheme.idleColor ??
          Colors.green;
    }
    if (_isHovered) {
      return handleTheme.hoverColor ?? handleTheme.idleColor ?? Colors.blueGrey;
    }
    return handleTheme.idleColor ?? Colors.grey;
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

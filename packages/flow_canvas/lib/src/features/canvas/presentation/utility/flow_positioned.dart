import 'package:flutter/material.dart';

class FlowPositioned extends StatelessWidget {
  final double dx;
  final double dy;
  final Widget child;

  const FlowPositioned({
    super.key,
    required this.dx,
    required this.dy,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(dx, -dy),
        child: child,
      ),
    );
  }
}

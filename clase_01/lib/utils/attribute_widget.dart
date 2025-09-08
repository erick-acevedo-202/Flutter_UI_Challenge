import 'package:clase_01/utils/attribute_painter.dart';
import 'package:flutter/material.dart';

class AttributeWidget extends StatelessWidget {
  final double size;
  final double progress;
  final Widget child;

  const AttributeWidget({
    super.key,
    required this.progress,
    this.size = 50,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AttributePainter(
        progressPercent: progress,
      ),
      size: Size(size, size),
      child: Container(
        padding: EdgeInsets.all(size / 5),
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}

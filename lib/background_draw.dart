import 'package:flutter/material.dart';

class DrawCircle extends CustomPainter {
  DrawCircle({
    required this.radius,
    required this.offset,
    required this.color,
    this.elevation = 8,
    this.transparentOccluder = false,
    required this.shadowColor,
    this.hasShadow = true,
    this.shadowOffset = 3,
  })  : assert(radius >= 0 && elevation >= 0 && shadowOffset >= 0),
        _paint = Paint()
          ..color = color
          ..strokeWidth = 10.0
          ..style = PaintingStyle.fill;

  final double radius;
  final Offset offset;
  final Color color;
  final double elevation;
  final bool transparentOccluder;
  final bool hasShadow;
  final Color shadowColor;
  final double shadowOffset;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    if (hasShadow) {
      Path oval = Path()
        ..addOval(
            Rect.fromCircle(center: offset, radius: radius + shadowOffset));

      canvas.drawShadow(
        oval,
        shadowColor,
        elevation,
        transparentOccluder,
      );
    }

    canvas.drawCircle(offset, radius, _paint);
  }

  @override
  bool shouldRepaint(DrawCircle oldDelegate) {
    return radius != oldDelegate.radius ||
        offset != oldDelegate.offset ||
        color != oldDelegate.color ||
        elevation != oldDelegate.elevation ||
        transparentOccluder != oldDelegate.transparentOccluder ||
        hasShadow != oldDelegate.hasShadow ||
        shadowColor != oldDelegate.shadowColor ||
        shadowOffset != oldDelegate.shadowOffset;
  }
}

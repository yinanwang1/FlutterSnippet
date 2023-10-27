import 'dart:math';

import 'package:flutter/material.dart';

class Rainbow extends StatelessWidget {
  final Offset startPoint;
  final double rowHeight;
  final Size size;
  final Widget? child;

  const Rainbow(
      {this.startPoint = const Offset(0, 50), this.rowHeight = 12, this.size = const Size(300, 300), this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RainbowPainter(startPoint, size.width, rowHeight),
      size: size,
      child: child,
    );
  }
}

class RainbowPainter extends CustomPainter {
  final Offset startPoint;
  final double width;
  final double rowHeight;

  final Paint _paint = Paint();
  final List<Color> _colors = const [
    Color(0xFFE05100),
    Color(0xFFF0A060),
    Color(0xFFe0E000),
    Color(0xFF10F020),
    Color(0xFF2080F5),
    Color(0xFF104FF0),
    Color(0xFFA040E5),
  ];

  RainbowPainter(this.startPoint, this.width, this.rowHeight) {
    _paint.strokeWidth = rowHeight / 2;
    _paint.style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 7; i++) {
      Path path = Path();
      double innerWidth = width - i * rowHeight;
      Rect rect = Rect.fromLTWH(startPoint.dx + i * rowHeight / 2, startPoint.dy + i * rowHeight / 2, innerWidth, innerWidth);
      path.arcTo(rect, -pi / 6, -2 * pi / 3, true);
      _paint.color = _colors[i];

      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

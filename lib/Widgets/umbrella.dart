import 'dart:math';

import 'package:flutter/material.dart';

/// 使用绘制60度的一个小三角来组成一个伞面
/// 可以填充彩虹色
/// Beta  还有很多小问题

class Umbrella extends StatelessWidget {
  final Offset startVertex;
  final double length;
  final double startAngle;
  final bool clockwise;
  final bool filled;
  final List<Color> colors;
  final int number;

  const Umbrella(
      {this.startVertex = const Offset(0, 150),
      this.length = 120,
      this.startAngle = 0,
      this.clockwise = true,
      this.filled = true,
      this.colors = const [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
      ],
      this.number = 30,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: CircleClipper(startAngle),
          child: CustomPaint(
            painter: UmbrellaPainter(
                startVertex: startVertex,
                length: length,
                startAngle: startAngle,
                clockwise: clockwise,
                filled: filled,
                colors: colors,
                number: number),
          ),
        ),
        ClipPath(
          clipper: CircleClipper(startAngle, half: true),
          child: CustomPaint(
            painter: UmbrellaPainter(
                startVertex: startVertex,
                length: length,
                startAngle: startAngle + 180,
                clockwise: clockwise,
                filled: filled,
                colors: colors,
                number: number),
          ),
        ),
      ],
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  final double startAngle;
  bool half;

  CircleClipper(this.startAngle, {this.half = false});

  @override
  Path getClip(Size size) {
    Path path = Path();
    double angle = startAngle * pi * 180;
    path.addArc(Rect.fromCenter(center: const Offset(0, 150), width: 400, height: 400), half ? angle + pi : angle, pi);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class UmbrellaPainter extends CustomPainter {
  Offset startVertex;
  double length;
  double startAngle;
  bool clockwise;
  bool filled;
  List<Color> colors;
  int number;

  UmbrellaPainter(
      {required this.startVertex,
      required this.length,
      required this.startAngle,
      required this.clockwise,
      required this.filled,
      required this.colors,
      required this.number});

  @override
  void paint(Canvas canvas, Size size) {
    int i = 0;
    for (; i < number; i++) {
      var colorIndex = i % colors.length;
      drawEquilateralTriangle(
        canvas,
        color: colors[colorIndex],
        startVertex: startVertex,
        length: length,
        startAngle: startAngle + i * 2 * pi / number,
        clockwise: clockwise,
        filled: filled,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  List<Offset> getEquilateralTriangleVertexes(Offset startVertex, double length, {double startAngle = 0, bool clockwise = true}) {
    double point2X, point2Y, point3X, point3Y;
    point2X = startVertex.dx + length * cos(startAngle);
    point2Y = startVertex.dy - length * sin(startAngle);
    if (clockwise) {
      point3X = startVertex.dx + length * cos(pi / 3 + startAngle);
      point3Y = startVertex.dy - length * sin(pi / 3 + startAngle);
    } else {
      point3X = startVertex.dx + length * cos(startAngle - pi / 3);
      point3Y = startVertex.dy - length * sin(startAngle - pi / 3);
    }

    return [startVertex, Offset(point2X, point2Y), Offset(point3X, point3Y)];
  }

  void drawEquilateralTriangle(Canvas canvas,
      {required Color color,
      required Offset startVertex,
      required double length,
      double startAngle = 0,
      bool clockwise = true,
      bool filled = true}) {
    assert(length > 0);
    Path trianglePath = Path();
    List<Offset> vertexes = getEquilateralTriangleVertexes(startVertex, length, clockwise: clockwise, startAngle: startAngle);
    trianglePath.moveTo(vertexes[0].dx, vertexes[0].dy);
    for (int i = 1; i < vertexes.length; i++) {
      trianglePath.lineTo(vertexes[i].dx, vertexes[i].dy);
    }
    trianglePath.close();

    Paint paint = Paint();
    paint.color = color;

    if (!filled) {
      paint.style = PaintingStyle.stroke;
    }

    canvas.drawPath(trianglePath, paint);
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

/// 绘制n多边形
/// 传入多边形的个数n，外半径R，内半径r，填充的颜色color

class NStarView extends StatelessWidget {
  final int num;
  final double R;
  final double r;
  final Color color;

  const NStarView(this.num, this.R, this.r, {this.color = Colors.blue, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2 * R,
      height: 2 * R,
      child: CustomPaint(
        painter: NStarPainter(num, R, r, color),
      ),
    );
  }
}

class NStarPainter extends CustomPainter {
  final int num;
  final double R;
  final double r;
  final Color color;

  NStarPainter(this.num, this.R, this.r, this.color) {
    starPaint.style = PaintingStyle.fill;
    starPaint.color = color;
  }

  final Paint starPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(R, R);
    canvas.drawPath(nStarPath(), starPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Path nStarPath() {
    Path path = Path();
    double perDeg = 360 / num;
    double degA = perDeg / 2 / 2;
    double degB = 360 / (num - 1) / 2 - degA / 2 + degA;

    path.moveTo(cos(_rad(degA)) * R, (-sin(_rad(degA)) * R));
    for (int i = 0; i < num; i++) {
      path.lineTo(cos(_rad(degA + perDeg * i)) * R, -sin(_rad(degA + perDeg * i)) * R);
      path.lineTo(cos(_rad(degB + perDeg * i)) * r, -sin(_rad(degB + perDeg * i)) * r);
    }

    path.close();

    return path;
  }

  double _rad(double deg) {
    return deg * pi / 180;
  }
}

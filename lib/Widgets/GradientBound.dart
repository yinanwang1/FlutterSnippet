
import 'dart:math';

import 'package:flutter/material.dart';

class GradientBoundDemo extends StatefulWidget {
  const GradientBoundDemo({super.key});

  @override
  State createState() {
    return _GradientBoundDemoState();
  }
}

class _GradientBoundDemoState extends State<GradientBoundDemo>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: CustomPaint(
        painter: GradientBoundPainter(
          <Color>[
            Colors.blue,
            Colors.blue[400]!,
            Colors.blue[300]!,
            Colors.blue[100]!,
          ],
          animation.value,
        ),
        child: const Text(
          "流动的渐变",
          style: TextStyle(
              color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class GradientBoundPainter extends CustomPainter {
  final List<Color> colors;
  final double animation;

  GradientBoundPainter(
      this.colors,
      this.animation,
      );

  @override
  void paint(Canvas canvas, Size size) {
    const rectWidth = 300.0, rectHeight = 200.0;
    Rect rect = Offset(
        size.width / 2 - rectWidth / 2, size.height / 2 - rectHeight / 2) &
    const Size(rectWidth, rectHeight);

    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        transform: GradientRotation(
          animation * 2 * pi,
        ),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(GradientBoundPainter oldDelegate) {
    return oldDelegate.colors != colors || oldDelegate.animation != animation;
  }
}
import 'dart:math';

import 'package:flutter/material.dart';

// 风车

class Windmill extends StatefulWidget {
  const Windmill({Key? key}) : super(key: key);

  @override
  State createState() => _WindmillState();
}

class _WindmillState extends State<Windmill> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));
  late Animation<double> rotate;

  @override
  void initState() {
    rotate = CurveTween(curve: Curves.linear).animate(_ctrl);

    super.initState();

    _ctrl.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: WindmillPainter(rotate),
      ),
    );
  }
}

class WindmillPainter extends CustomPainter {
  final Animation<double> rotate;

  WindmillPainter(this.rotate) : super(repaint: rotate);

  List<Color> colors = const [
    Color(0xffE74437),
    Color(0xfffbbd19),
    Color(0xff3482f0),
    Color(0xff30a04c),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    double d = size.width * 0.4;
    canvas.rotate(rotate.value * 2 * pi);

    Path path = Path()..addArc(Rect.fromCenter(center: Offset(d / 2, 0), width: d, height: d), 0, pi);
    Paint paint = Paint();

    for (Color color in colors) {
      canvas.drawPath(path, paint..color = color);
      canvas.rotate(pi / 2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

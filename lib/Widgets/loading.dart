import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class BallLoading extends StatefulWidget {
  const BallLoading({Key? key}) : super(key: key);

  @override
  State createState() => _BallLoadingState();
}

class _BallLoadingState extends State<BallLoading>
    with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 3));
  late final _animation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine))
    ..addListener(() {
      setState(() {});
    });

  @override
  void initState() {
    super.initState();

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 100,
      width: 350,
      child: CustomPaint(
        painter: BallPinter(_animation.value),
      ),
    );
  }
}

class BallPinter extends CustomPainter {
  final double animationValue;

  BallPinter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue[400]!
      ..strokeWidth = 2.0;
    var path = Path();
    const radius = 40.0;
    var center = Offset(size.width / 2, size.height / 2);
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(path, paint);

    var innerPath = Path();
    const ballRadius = 4.0;
    innerPath
        .addOval(Rect.fromCircle(center: center, radius: radius - ballRadius));
    var metrics = innerPath.computeMetrics();
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill;
    for (var pathMetric in metrics) {
      var tangent =
          pathMetric.getTangentForOffset(pathMetric.length * animationValue);
      canvas.drawCircle(tangent!.position, ballRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DoubleBallLoading extends StatefulWidget {
  const DoubleBallLoading({Key? key}) : super(key: key);

  @override
  State createState() => _DoubleBallLoadingState();
}

class _DoubleBallLoadingState extends State<DoubleBallLoading>
    with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2));
  late final _animation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine))
    ..addListener(() {
      setState(() {});
    });

  @override
  void initState() {
    super.initState();

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 100,
      width: 350,
      child: CustomPaint(
        painter: DoubleBallPainter(_animation.value),
      ),
    );
  }
}

class DoubleBallPainter extends CustomPainter {
  final double animationValue;

  DoubleBallPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue[400]!
      ..strokeWidth = 2.0;
    const radius = 50.0;
    const ballRadius = 6.0;
    var center = Offset(size.width / 2, size.height / 2);

    // 第一个圆
    var circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.blue[400]!;
    canvas.drawPath(circlePath, paint);

    var circleMetrics = circlePath.computeMetrics();
    for (var element in circleMetrics) {
      var tangent =
          element.getTangentForOffset(element.length * animationValue);
      paint.style = PaintingStyle.fill;
      paint.color = Colors.blue;
      canvas.drawCircle(tangent!.position, ballRadius, paint);
    }

    // 第二个圆
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.green[600]!;
    var ovalPath = Path()
      ..addOval(Rect.fromCenter(center: center, width: 3 * radius, height: 40));
    canvas.drawPath(ovalPath, paint);
    var ovalMetrics = ovalPath.computeMetrics();
    for (var element in ovalMetrics) {
      var tangent = element
          .getTangentForOffset(element.length * ((animationValue + 0.5) % 1.0));
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(tangent!.position, ballRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClockPendulum extends StatefulWidget {
  const ClockPendulum({Key? key}) : super(key: key);

  @override
  State createState() => _ClockPendulumState();
}

class _ClockPendulumState extends State<ClockPendulum>
    with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2));
  late final _animation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart))
    ..addListener(() {
      setState(() {});
    });

  @override
  void initState() {
    super.initState();

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 300,
      width: 350,
      child: CustomPaint(
        painter: ClockPendulumPainter(_animation.value),
      ),
    );
  }
}

class ClockPendulumPainter extends CustomPainter {
  final double animationValue;

  ClockPendulumPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue[400]!
      ..strokeWidth = 2.0;
    const ceilWidth = 60.0;
    const pendulumHeight = 200.0;

    // 天花板
    var ceilCenter =
        Offset(size.width / 2, size.height / 2 - pendulumHeight / 2);
    var ceilPath = Path()
      ..moveTo(ceilCenter.dx - ceilWidth / 2, ceilCenter.dy)
      ..lineTo(ceilCenter.dx + ceilWidth / 2, ceilCenter.dy);
    canvas.drawPath(ceilPath, paint);

    // 钟摆
    var pendulumArcPath = Path()
      ..addArc(Rect.fromCircle(center: ceilCenter, radius: pendulumHeight),
          3 * pi / 4, -pi / 2);
    paint.color = Colors.white70;
    var metrics = pendulumArcPath.computeMetrics();
    for (var element in metrics) {
      var tangent = element.getTangentForOffset(element.length * animationValue);
      canvas.drawLine(ceilCenter, tangent!.position, paint);
      paint.style = PaintingStyle.fill;
      paint.color = Colors.blue;
      paint.maskFilter = const MaskFilter.blur(BlurStyle.solid, 50.0);

      canvas.drawCircle(tangent.position, 50.0, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

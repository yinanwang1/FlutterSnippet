import 'dart:math';

import 'package:flutter/material.dart';

/// 用CustomPainter绘制雪人和雪花
/// 用显示动画播放

class Snowing extends StatefulWidget {
  const Snowing({Key? key}) : super(key: key);

  @override
  State createState() => _SnowingState();
}

class _SnowingState extends State<Snowing> with SingleTickerProviderStateMixin {
  final List<SnowFlake> _snowFlakes = List.generate(1000, (index) => SnowFlake());
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text("我的新世界"),
        //   scrolledUnderElevation: 0,
        // ),
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.lightBlue, Colors.white],
              stops: [0.0, 0.7, 0.95])),
      width: double.infinity,
      height: double.infinity,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          for (var element in _snowFlakes) {
            element.fall();
          }
          return CustomPaint(
            painter: SnowPainter(_snowFlakes),
          );
        },
      ),
    ));
  }
}

class SnowPainter extends CustomPainter {
  final List<SnowFlake> snowFlakes;

  SnowPainter(this.snowFlakes);

  final painter = Paint()..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(size.center(const Offset(0, 100)), 50, painter);
    canvas.drawOval(Rect.fromCenter(center: size.center(const Offset(0, 280)), width: 200, height: 300), painter);

    for (var element in snowFlakes) {
      canvas.drawCircle(Offset(element.x, element.y), element.radius, painter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SnowFlake {
  var x = Random().nextDouble() * 400;
  var y = Random().nextDouble() * 800;
  var radius = Random().nextDouble() * 4 + 2;
  var velocity = Random().nextDouble() * 2 + 1;

  void fall() {
    y += velocity;

    if (y > 800) {
      x = Random().nextDouble() * 400;
      y = Random().nextDouble() * 800;
      radius = Random().nextDouble() * 4 + 2;
      velocity = Random().nextDouble() * 2 + 1;
    }
  }
}

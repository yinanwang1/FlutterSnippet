import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Lightning extends StatefulWidget {


  const Lightning({Key? key}) : super(key: key);

  @override
  _LightningState createState() => _LightningState();
}

class _LightningState extends State<Lightning> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const int durationMilliseconds = 1000;
  late Size windowSize;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: durationMilliseconds));
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
      ..addListener(() {
        setState(() {
          debugPrint("");
        });
      })
      ..addStatusListener((status) {
        if (AnimationStatus.completed == status) {
          setState(() {
            pointsList.clear();
          });
          _controller.reset();
        }
      });

    Timer.periodic(const Duration(milliseconds: durationMilliseconds * 2),
            (timer) {
          _controller.forward();
          setState(() {
            pointsList.clear();

            create();
          });
        });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("pointsList is $pointsList");

    windowSize = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        SizedBox(
          width: windowSize.width,
          height: windowSize.height,
          child: Image.asset(
            "images/darkSky.jpeg",
            fit: BoxFit.fitHeight,
          ),
        ),
        Container(
          color: backgroundColor(_animation.value),
          width: windowSize.width,
          height: windowSize.height,
        ),
        CustomPaint(
          painter:
          LightningPainter(pointsList, 1, Colors.red, _animation.value),
        ),
      ],
    );
  }

  Color backgroundColor(double value) {
    var whiteColors = [
      Colors.white10,
      Colors.white10,
      Colors.white10,
      Colors.white10,
      Colors.white10,
      Colors.white12,
      Colors.white12,
      Colors.white12,
      Colors.white12,
      Colors.white12,
      Colors.white24,
      Colors.white38,
      Colors.white38,
      Colors.white38,
      Colors.white38,
      Colors.white70,
      Colors.white70,
      Colors.white70,
      Colors.white70,
      Colors.white70,
    ];

    var index = (value * whiteColors.length).floor();

    return whiteColors[index];
  }

  var curDetail = 10.0;
  var random = Random();
  var pointsList = <Offset>[];

  Future<List<Offset>> create() async {
    Offset start = _createStart();
    Offset end = _createEnd();
    drawLightning(start.dx, start.dy, end.dx, end.dy, 500);

    return pointsList;
  }

  Offset _createStart() {
    return Offset(
        random.nextDouble() * windowSize.width, -random.nextDouble() * 20);
  }

  Offset _createEnd() {
    return Offset(random.nextDouble() * windowSize.width,
        windowSize.height + random.nextDouble() * 20);
  }

  void drawLightning(
      double x1, double y1, double x2, double y2, double displace) {
    if (displace < curDetail) {
      pointsList.add(Offset(x1, y1));
      pointsList.add(Offset(x2, y2));
    } else {
      var midX = (x2 + x1) / 2;
      var midY = (y2 + y1) / 2;
      midX += (random.nextDouble() - 0.5) * displace;
      midY += (random.nextDouble() - 0.5) * displace;

      midX = midX.clamp(0, windowSize.width);
      midY = midY.clamp(0, windowSize.height);

      drawLightning(x1, y1, midX, midY, displace / 2);
      drawLightning(midX, midY, x2, y2, displace / 2);
    }
  }
}

class LightningPainter extends CustomPainter {
  // 点集合
  final List<Offset> points;

  // 曲线的绘制宽度
  final double curveStrokeWidth;

  // 曲线的颜色
  final Color curveColor;

  final double animationValue;

  final Paint _mainPaint = Paint();
  final Path _linePath = Path();

  LightningPainter(
      this.points, this.curveStrokeWidth, this.curveColor, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制
    _drawHelp(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// Private Methods
  var whiteColors = [
    const Color(0x05FFFFFF),
    Colors.white12,
    Colors.white30,
    Colors.white,
  ];
  var strokeWidths = [60.0, 40.0, 20.0, 10.0];

  void _drawHelp(Canvas canvas) {
    // 绘制曲线
    addBezierPathWithPoints(_linePath, points);
    var pathMetric = _linePath.computeMetrics();
    for (var metric in pathMetric) {
      var subPath = metric.extractPath(0.0, metric.length * animationValue);
      for (var i = 0; i < whiteColors.length; i++) {
        canvas.drawPath(
            subPath,
            _mainPaint
              ..color = whiteColors[i]
              ..style = PaintingStyle.stroke
              ..strokeJoin = StrokeJoin.round
              ..strokeWidth = strokeWidths[i]);
      }
      break;
    }
  }

  void addBezierPathWithPoints(Path path, List<Offset> points) {
    for (int i = 0; i < points.length - 1; i++) {
      Offset current = points[i];
      Offset next = points[i + 1];

      if (i == 0) {
        path.moveTo(current.dx, current.dy);
        double ctrlX = current.dx + (next.dx - current.dx) / 2;
        double ctrlY = next.dy;
        path.quadraticBezierTo(ctrlX, ctrlY, next.dx, next.dy);
      } else if (i < points.length - 2) {
        double ctrl1X = current.dx + (next.dx - current.dx) / 2;
        double ctrl1Y = current.dy;

        double ctrl2X = ctrl1X;
        double ctrl2Y = next.dy;

        path.cubicTo(ctrl1X, ctrl1Y, ctrl2X, ctrl2Y, next.dx, next.dy);
      } else {
        path.moveTo(current.dx, current.dy);

        double ctrlX = current.dx + (next.dx - current.dx) / 2;
        double ctrlY = current.dy;

        path.quadraticBezierTo(ctrlX, ctrlY, next.dx, next.dy);
      }
    }
  }
}

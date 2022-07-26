import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyColors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      // 国际化配置 __START__
      localeListResolutionCallback:
          (List<Locale>? locals, Iterable<Locale>? supportedLocales) {
        return const Locale('zh');
      },
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale>? supportedLocales) {
        return const Locale("zh");
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('zh', 'CH'),
        Locale('en', 'US'),
      ],
      // 国际化配置 __END__
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const int durationMilliseconds = 3000;
  late Size windowSize;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: durationMilliseconds));
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCirc))
      ..addListener(() {
        setState(() {
          debugPrint("wyn 222");
        });
      })..addStatusListener((status) {
        if (AnimationStatus.completed == status) {
          _controller.reset();
        }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("我就是我"),
      ),
      body: Stack(
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
          LightningView(
            pointsList,
            showStraight: false,
            showStraightCircle: false,
            curveColor: Colors.red,
          ),
          ElevatedButton(
              onPressed: () {
                _controller.forward();
                setState(() {
                  pointsList.clear();

                  create();
                });
              },
              child: const Text("点我")),
        ],
      ),
    );
  }

  Color backgroundColor(double value) {
    debugPrint("wyn 111");
    var whiteColors = [
      Colors.white10,
      Colors.white10,
      Colors.white12,
      Colors.white24,
      Colors.white54,
      Colors.white70,
      Colors.white70,
      Colors.white54,
      Colors.white24,
      Colors.white12,
      Colors.white10,
      Colors.white10,
    ];

    var index = (value * 10).floor();

    return whiteColors[index];
  }

  var curDetail = 100.0;
  var random = Random();
  var pointsList = <Offset>[];

  Future<List<Offset>> create() async {
    Offset start = _createStart();
    Offset end = _createEnd();
    drawLightning(start.dx, start.dy, end.dx, end.dy, 300);

    return pointsList;
  }

  Offset _createStart() {
    return Offset(random.nextDouble() * windowSize.width, random.nextDouble() * 20);
  }

  Offset _createEnd() {
    return Offset(random.nextDouble() * windowSize.width, windowSize.height - random.nextDouble() * 20);
  }

  void drawLightning(
      double x1, double y1, double x2, double y2, double displace) {
    if (displace < curDetail) {
      pointsList.add(Offset(x1, y1));
      pointsList.add(Offset(x2, y2));
    } else {
      var midX = (x2 + x1) / 2;
      var midY = (y2 + y1) / 2;
      midX += (random.nextDouble() - 0.8) * displace;
      midY += (random.nextDouble() - 0.8) * displace;

      drawLightning(x1, y1, midX, midY, displace / 2);
      drawLightning(midX, midY, x2, y2, displace / 2);
    }
  }
}

class LightningView extends StatelessWidget {
  // 点集合
  final List<Offset> points;

  // 是否显示直线
  final bool showStraight;

  // 是否显示直线的线
  final bool showStraightLine;

  // 是否显示点的圆圈
  final bool showStraightCircle;

  // 是否显示曲线
  final bool showCurve;

  // 直线圆圈的半径
  final double radius;

  // 直线圆圈的绘制宽度
  final double circleStrokeWidth;

  // 直线圆圈的颜色
  final Color circleColor;

  // 直线的绘制宽度
  final double straightLineStrokeWidth;

  // 直线的颜色
  final Color straightLineColor;

  // 曲线的绘制宽度
  final double curveStrokeWidth;

  // 曲线的颜色
  final Color curveColor;

  const LightningView(this.points,
      {this.showStraight = true,
        this.showStraightLine = true,
        this.showStraightCircle = true,
        this.showCurve = true,
        this.radius = 2,
        this.circleStrokeWidth = 1,
        this.circleColor = Colors.orange,
        this.straightLineStrokeWidth = 0.5,
        this.straightLineColor = Colors.red,
        this.curveStrokeWidth = 1,
        this.curveColor = Colors.blue,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: PaperPainter(
            points,
            showStraight,
            showStraightLine,
            showStraightCircle,
            showCurve,
            radius,
            circleStrokeWidth,
            circleColor,
            straightLineStrokeWidth,
            straightLineColor,
            curveStrokeWidth,
            curveColor),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  // 点集合
  final List<Offset> points;

  // 是否显示直线
  final bool showStraight;

  // 是否显示直线的线
  final bool showStraightLine;

  // 是否显示点的圆圈
  final bool showStraightCircle;

  // 是否显示曲线
  final bool showCurve;

  // 直线圆圈的半径
  final double radius;

  // 直线圆圈的绘制宽度
  final double circleStrokeWidth;

  // 直线圆圈的颜色
  final Color circleColor;

  // 直线的绘制宽度
  final double straightLineStrokeWidth;

  // 直线的颜色
  final Color straightLineColor;

  // 曲线的绘制宽度
  final double curveStrokeWidth;

  // 曲线的颜色
  final Color curveColor;

  final Paint _helpPaint = Paint();
  final Paint _mainPaint = Paint();
  final Path _linePath = Path();


  PaperPainter(this.points, this.showStraight, this.showStraightLine,
      this.showStraightCircle, this.showCurve, this.radius,
      this.circleStrokeWidth, this.circleColor, this.straightLineStrokeWidth,
      this.straightLineColor, this.curveStrokeWidth, this.curveColor,);

  @override
  void paint(Canvas canvas, Size size) {
    // 从视图的左边中间点开始绘制
    canvas.translate(0, size.height / 2);

    // 绘制
    _drawHelp(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  /// Private Methods

  void _drawHelp(Canvas canvas) {
    _helpPaint.style = PaintingStyle.stroke;

    if (showStraight) {
      if (showStraightCircle) {
        // 绘制圆点
        for (var element in points) {
          canvas.drawCircle(
              element,
              radius,
              _helpPaint
                ..strokeWidth = circleStrokeWidth
                ..color = circleColor);
        }
      }
      if (showStraightLine) {
        // 连接点的线
        canvas.drawPoints(
            PointMode.polygon,
            points,
            _helpPaint
              ..strokeWidth = straightLineStrokeWidth
              ..color = straightLineColor);
      }
    }

    if (showCurve) {
      // 绘制曲线
      addBezierPathWithPoints(_linePath, points);
      canvas.drawPath(
          _linePath,
          _mainPaint
            ..color = curveColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = curveStrokeWidth);
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

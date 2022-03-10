import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() {
    return _ClockState();
  }
}

class _ClockState extends State<Clock> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPainter(),
      size: const Size(200, 200),
    );
  }
}

class ClockPainter extends CustomPainter {
  late double width;
  late double height;
  late double radius;
  late final Paint _paint = _initPaint();
  late double unit;

  Paint _initPaint() {
    return Paint()
      ..isAntiAlias = true
      ..color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    initSize(size);

    var date = DateTime.now();
    drawSeconds(canvas, date);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void initSize(Size size) {
    width = size.width;
    height = size.height;
    radius = min(width, height) / 2;
    // 宽或高上，被分成30等分
    unit = radius / 15;

    debugPrint("width is $width, height is $height, radius is $radius, unit is $unit");
  }

  void drawHour(Canvas canvas, DateTime date) {
    double hourHalfHeight = 0.4 * unit;
    double hourRectRight = 7 * unit;

    Path hourPath = Path();
    // 添加矩形 时针主体
    hourPath.moveTo(0 - hourHalfHeight, 0 - hourHalfHeight);
    hourPath.lineTo(hourRectRight, 0 - hourHalfHeight);
    hourPath.lineTo(hourRectRight, 0 + hourHalfHeight);
    hourPath.lineTo(0 - hourHalfHeight, 0 + hourHalfHeight);

    // 时针箭头尾部弧形
    double offsetTop = 0.5 * unit;
    double arcWidth = 1.5 * unit;
    double arrowWidth = 2.17 * unit;
    double offset = 0.42 * unit;
    var rect = Rect.fromLTWH(hourRectRight - offset, 0 - hourHalfHeight- offsetTop,
        arcWidth, hourHalfHeight * 2 + offsetTop * 2);
    hourPath.addArc(rect, pi/2, pi);

    // 时针箭头
    hourPath.moveTo(hourRectRight - offset + arcWidth / 2, 0 - hourHalfHeight - offsetTop);
    hourPath.lineTo(hourRectRight - offset + arcWidth / 2 + arrowWidth, 0);
    hourPath.lineTo(hourRectRight - offset + arcWidth/ 2, 0 + hourHalfHeight + offsetTop);
    hourPath.close();

    canvas.save();
    canvas.translate(width/2, height/2);
    canvas.rotate(2*pi/60*((date.hour - 3 + date.minute / 60 + date.second/60/60)* 5));

    // 绘制
    _paint.color = const Color(0xFF232425);
    canvas.drawPath(hourPath, _paint);
    canvas.restore();
  }

  void drawMinutes(Canvas canvas, DateTime date) {
    double hourHalfHeight = 0.4 * unit;
    double minutesLeft = -1.33 * unit;
    double minutesTop = -hourHalfHeight;
    double minutesRight = 11 * unit;
    double minutesBottom = hourHalfHeight;

    canvas.save();
    canvas.translate(width / 2, height / 2);
    canvas.rotate(2 * pi / 60 * (date.minute - 15 + date.second / 60));

    // 绘制分针
    var rRect = RRect.fromLTRBR(minutesLeft, minutesTop, minutesRight,
        minutesBottom, Radius.circular(0.42 * unit));
    _paint.color = const Color(0xFF343536);
    canvas.drawRRect(rRect, _paint);

    canvas.restore();
  }

  void drawSeconds(Canvas canvas, DateTime date) {
    double hourHalfHeight = 0.4 * unit;
    double secondsLeft = -4.5 * unit;
    double secondsTop = -hourHalfHeight;
    double secondsRight = 12.5 * unit;
    double secondsBottom = hourHalfHeight;

    Path secondsPath = Path();
    secondsPath.moveTo(secondsLeft, secondsTop);

    // 尾部弧形
    var rect =
        Rect.fromLTWH(secondsLeft, secondsTop, 2.5 * unit, hourHalfHeight * 2);
    secondsPath.addArc(rect, pi / 2, pi);

    // 尾部圆角矩形
    var rRect = RRect.fromLTRBR(secondsLeft + 1 * unit, secondsTop, -2 * unit,
        secondsBottom, Radius.circular(0.25 * unit));
    secondsPath.addRRect(rRect);

    // 指针
    secondsPath.moveTo(-2 * unit, -0.125 * unit);
    secondsPath.lineTo(secondsRight, 0);
    secondsPath.lineTo(-2 * unit, 0.125 * unit);

    // 中心圆
    var ovalRect =
        Rect.fromLTWH(-0.67 * unit, -0.67 * unit, 1.33 * unit, 1.33 * unit);
    secondsPath.addOval(ovalRect);

    canvas.save();
    canvas.translate(width / 2, height / 2);
    canvas.rotate(2 * pi / 60 * (date.second - 15));

    // 绘制阴影
    canvas.drawShadow(secondsPath, const Color(0xFFcc0000), 0.17 * unit, true);

    // 绘制秒针
    _paint.color = const Color(0xFFcc0000);
    canvas.drawPath(secondsPath, _paint);

    canvas.restore();
  }
}

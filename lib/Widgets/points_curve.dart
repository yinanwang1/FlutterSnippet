import 'dart:ui';

import 'package:flutter/material.dart';

/// 根据多个坐标，用直线和贝塞尔曲线连接。
/// 可以设置直线的颜色和坐标点的颜色，圆的半径。
/// 可以设置曲线的颜色和线的宽度。
///
/// 注意：从左边中间点开始绘制
///
/// @author 阿南
/// @since 2021/11/23 11:19
///
class PointsCurve extends StatelessWidget {
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

  const PointsCurve(this.points,
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

import 'dart:math';

import 'package:flutter/material.dart';

/// 圆形进度条 通过Progress来设置属性
///

class CircleProgressWidget extends StatefulWidget {
  final Progress progress;

  const CircleProgressWidget(this.progress, {super.key});

  @override
  State createState() => _CircleProgressWidgetState();
}

class _CircleProgressWidgetState extends State<CircleProgressWidget> {
  @override
  Widget build(BuildContext context) {
    var progress = SizedBox(
      width: widget.progress.radius * 2,
      height: widget.progress.radius * 2,
      child: CustomPaint(
        painter: ProgressPainter(widget.progress),
      ),
    );

    String txt = "${(100 * widget.progress.value).toStringAsFixed(1)} %";
    var text = Text(
      widget.progress.value >= 1.0 ? widget.progress.completeText : txt,
      style: widget.progress.style ?? TextStyle(fontSize: widget.progress.radius / 4),
    );

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[progress, text],
    );
  }
}

class Progress {
  double value;
  Color color;
  Color backgroundColor;
  double radius;
  double strokeWidth;
  int dotCount;
  TextStyle? style;
  String completeText;

  Progress(
      {this.value = 0.0,
      this.color = Colors.blue,
      this.backgroundColor = Colors.white,
      this.radius = 60.0,
      this.strokeWidth = 2.0,
      this.completeText = "OK",
      this.dotCount = 50,
      this.style});
}

class ProgressPainter extends CustomPainter {
  final Progress _progress;
  late Paint _paint;
  late Paint _arrowPaint;
  late Path _arrowPath;
  late double _radius;

  ProgressPainter(this._progress) {
    _radius = _progress.radius - _progress.strokeWidth / 2;
    _paint = Paint();
    _arrowPaint = Paint();
    _arrowPath = Path();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    canvas.clipRect(rect);
    canvas.translate(_progress.strokeWidth / 2, _progress.strokeWidth / 2);

    drawProgress(canvas);
    drawArrow(canvas);
    drawDot(canvas);
  }

  void drawProgress(Canvas canvas) {
    canvas.save();

    _paint
      ..style = PaintingStyle.stroke
      ..color = _progress.backgroundColor
      ..strokeWidth = _progress.strokeWidth;
    canvas.drawCircle(Offset(_radius, _radius), _radius, _paint);

    _paint
      ..color = _progress.color
      ..strokeWidth = _progress.strokeWidth * 1.2
      ..strokeCap = StrokeCap.round;

    double sweepAngle = _progress.value * 360;
    debugPrint("sweepAngle is $sweepAngle");
    canvas.drawArc(Rect.fromLTRB(0, 0, _radius * 2, _radius * 2), -90 / 180 * pi, sweepAngle / 180 * pi, false, _paint);

    canvas.restore();
  }

  void drawArrow(Canvas canvas) {
    canvas.save();

    canvas.translate(_radius, _radius);
    canvas.rotate((180 + _progress.value * 360) / 180 * pi);

    var half = _radius / 2;
    var eg = _radius / 50;

    _arrowPath.moveTo(0, -half - eg * 2);
    _arrowPath.relativeLineTo(eg * 2, eg * 6);
    _arrowPath.lineTo(0, -half + eg * 2);
    _arrowPath.lineTo(0, -half - eg * 2);
    _arrowPath.relativeLineTo(-eg * 2, eg * 6);
    _arrowPath.lineTo(0, -half + eg * 2);
    _arrowPath.lineTo(0, -half - eg * 2);
    canvas.drawPath(_arrowPath, _arrowPaint);

    canvas.restore();
  }

  void drawDot(Canvas canvas) {
    canvas.save();

    canvas.translate(_radius, _radius);

    int num = _progress.dotCount;
    for (double i = 0; i < num; i++) {
      canvas.save();

      double deg = 360 / num * i;
      canvas.rotate(deg / 180 * pi);

      _paint
        ..strokeWidth = _progress.strokeWidth / 2
        ..color = i / num > _progress.value ? _progress.backgroundColor : _progress.color
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(0, _radius * 3 / 4), Offset(0, _radius * 4 / 5), _paint);

      canvas.restore();
    }

    canvas.restore();
  }
}

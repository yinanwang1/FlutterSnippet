import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LoadingAnimations extends StatefulWidget {
  final Color bgColor;
  final Color foregroundColor;
  final String? loadingText;
  final double size;

  const LoadingAnimations({required this.bgColor, required this.foregroundColor, this.loadingText, this.size = 100, super.key});

  @override
  State createState() => LoadingAnimationsState();
}

class LoadingAnimationsState extends State<LoadingAnimations> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late ui.Image planeImage;
  bool isImageLoaded = false;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      });
    controller.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircleLoading(
          animationValue: animation.value,
          bgColor: widget.bgColor,
          foregroundColor: widget.foregroundColor,
          loadingText: widget.loadingText,
          boxSize: widget.size),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}

class CircleLoading extends CustomPainter {
  final double animationValue;
  final Color bgColor;
  final Color foregroundColor;
  final String? loadingText;
  final double boxSize;

  CircleLoading(
      {required this.animationValue,
      required this.bgColor,
      required this.foregroundColor,
      this.loadingText,
      required this.boxSize});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = bgColor
      ..strokeWidth = 2.0;
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(4.0)), paint);
    paint.color = foregroundColor;

    var center = Offset(size.width / 2, size.height / 2);
    if (null != loadingText) {
      _drawText(canvas, loadingText ?? "", size, center);
    }

    // _drawBezierLoadingAnimation(canvas, size, center, paint);
    // _drawCircleLoadingAnimation(canvas, size, center, paint);
    _drawOvalLoadingAnimation(canvas, size, center, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawCircleLoadingAnimation(Canvas canvas, Size size, Offset center, Paint paint) {
    final radius = boxSize / 2;
    const ballCount = 10;
    final ballRadius = boxSize / 10;

    var circlePath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));

    var circleMetrics = circlePath.computeMetrics();
    for (var pathMetric in circleMetrics) {
      for (var i = 0; i < ballCount; i++) {
        var lengthRatio = animationValue * (1 - i / ballCount);
        var tangent = pathMetric.getTangentForOffset(pathMetric.length * lengthRatio);
        var ballPosition = tangent!.position;
        canvas.drawCircle(ballPosition, ballRadius / (1 + i), paint);
        canvas.drawCircle(Offset(size.width - ballPosition.dx, size.height - ballPosition.dy), ballRadius / (1 + i), paint);
      }
    }
  }

  void _drawOvalLoadingAnimation(Canvas canvas, Size size, Offset center, Paint paint) {
    const ballCount = 6;
    final ballRadius = boxSize / 15;
    var ovalPath = Path()..addOval(Rect.fromCenter(center: center, width: boxSize, height: boxSize / 1.5));
    paint.shader = LinearGradient(
            colors: [foregroundColor, Colors.blue[400]!, Colors.grey, Colors.yellow, Colors.orange, bgColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)
        .createShader(Offset.zero & size);
    var ovalMetrics = ovalPath.computeMetrics();
    for (var pathMetric in ovalMetrics) {
      for (var i = 0; i < ballCount; i++) {
        var lengthRatio = animationValue * (1 - i / ballCount);
        var tangent = pathMetric.getTangentForOffset(pathMetric.length * lengthRatio);
        var ballPosition = tangent!.position;
        canvas.drawCircle(ballPosition, ballRadius / (1 + i), paint);
        canvas.drawCircle(Offset(size.width - ballPosition.dx, size.height - ballPosition.dy), ballRadius / (1 + i), paint);
      }
    }
  }

  void _drawBezierLoadingAnimation(Canvas canvas, Size size, Offset center, Paint paint) {
    const ballCount = 30;
    final ballRadius = boxSize / 40;

    var bezierPath = Path()
      ..moveTo(size.width / 2 - boxSize / 2, center.dy)
      ..quadraticBezierTo(size.width / 2 - boxSize / 4, center.dy - boxSize - boxSize / 4, size.width / 2, center.dy)
      ..quadraticBezierTo(size.width + boxSize / 4, center.dy + boxSize / 4, size.width / 2 + boxSize / 2, center.dy)
      ..quadraticBezierTo(size.width / 2 + boxSize / 4, center.dy - boxSize / 4, size.width / 2, center.dy)
      ..quadraticBezierTo(size.width / 2 - boxSize / 4, center.dy + boxSize / 4, size.width / 2 - boxSize / 2, center.dy);
    var ovalMetrics = bezierPath.computeMetrics();
    for (var pathMetric in ovalMetrics) {
      for (var i = 0; i < ballCount; i++) {
        var lengthRatio = animationValue * (1 - i / ballRadius);
        var tangent = pathMetric.getTangentForOffset(pathMetric.length * lengthRatio);
        var ballPosition = tangent!.position;
        canvas.drawCircle(ballPosition, ballRadius / (1 + i), paint);
        canvas.drawCircle(Offset(ballPosition.dy, ballPosition.dx), ballRadius / (1 + i), paint);
      }
    }
  }

  void _drawText(Canvas canvas, String text, Size size, Offset center) {
    const fontSize = 16.0;
    final textWidth = boxSize;
    var style = const TextStyle(fontSize: fontSize, color: Colors.black87);
    final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
          fontSize: style.fontSize,
          fontFamily: style.fontFamily,
          fontStyle: style.fontStyle,
          fontWeight: style.fontWeight,
          textAlign: TextAlign.center),
    )
      ..pushStyle(style.getTextStyle())
      ..addText(text);

    final ui.Paragraph paragraph = paragraphBuilder.build()..layout(ui.ParagraphConstraints(width: textWidth));

    canvas.drawParagraph(paragraph, Offset(center.dx - textWidth / 2, center.dy - fontSize / 2.0));
  }
}

import 'package:flutter/material.dart';

///  滚动的波浪。
///  可用于加载，下载进度等。
/// @author 阿南
/// @since 2021/11/17 16:49

class FlutterWaveLoading extends StatefulWidget {
  final double width;
  final double height;
  final double waveHeight;
  final Color color;
  final double strokeWidth;
  final double progress;
  final double factor;
  final int secondAlpha;
  final double borderRadius;
  final bool isOval;
  final Curve curve;

  const FlutterWaveLoading(
      {this.width = 100,
      this.height = 100 / 0.618,
      this.waveHeight = 5,
      this.color = Colors.green,
      this.strokeWidth = 3,
      this.progress = 0.5,
      this.factor = 1,
      this.secondAlpha = 88,
      this.borderRadius = 20,
      this.isOval = false,
      this.curve = Curves.linear,
      Key? key})
      : super(key: key);

  @override
  _FlutterWaveLoadingState createState() => _FlutterWaveLoadingState();
}

class _FlutterWaveLoadingState extends State<FlutterWaveLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..addListener(() {
        setState(() {});
      })
      ..repeat();
    _animation = CurveTween(curve: widget.curve).animate(_controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: BezierPainter(
            factor: _animation.value,
            waveHeight: widget.waveHeight,
            progress: widget.progress,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
            secondAlpha: widget.secondAlpha,
            isOval: widget.isOval,
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }
}

class BezierPainter extends CustomPainter {
  late Paint _mainPaint;
  late Path _mainPath;
  double waveWidth = 80;
  double wrapHeight = 0;

  final double waveHeight;
  final Color color;
  final double strokeWidth;
  final double progress;
  final double factor;
  final int secondAlpha;
  final double borderRadius;
  final bool isOval;

  BezierPainter(
      {this.waveHeight = 8,
      this.color = Colors.green,
      this.strokeWidth = 3,
      this.progress = 0.5,
      this.factor = 1,
      this.secondAlpha = 88,
      this.borderRadius = 20,
      this.isOval = false}) {
    _mainPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _mainPath = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint("size is $size");
    waveWidth = size.width / 2;
    wrapHeight = size.height;

    Path path = Path();
    if (isOval) {
      path.addOval(const Offset(0, 0) & size);
      canvas.clipPath(path);
      canvas.drawPath(
          path,
          _mainPaint
            ..strokeWidth = strokeWidth
            ..color = color);
    } else {
      path.addRRect(RRect.fromRectXY(
          const Offset(0, 0) & size, borderRadius, borderRadius));
      canvas.clipPath(path);
      canvas.drawPath(
          path,
          _mainPaint
            ..strokeWidth = strokeWidth
            ..color = color);
    }

    canvas.translate(0, wrapHeight);
    canvas.save();
    canvas.translate(0, waveHeight);
    canvas.save();

    canvas.translate(-4 * waveWidth + 2 * waveWidth * factor, 0);
    drawWave(canvas);
    canvas.drawPath(
        _mainPath,
        _mainPaint
          ..style = PaintingStyle.fill
          ..color = color.withAlpha(88));
    canvas.restore();

    canvas.translate(-4 * waveWidth + 2 * waveWidth * factor * 2, 0);
    canvas.drawPath(
        _mainPath,
        _mainPaint
          ..style = PaintingStyle.fill
          ..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawWave(Canvas canvas) {
    _mainPath.moveTo(0, 0);
    _mainPath.relativeLineTo(0, -wrapHeight * progress);
    _mainPath.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight * 2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(
        waveWidth / 2, waveHeight * 2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight * 2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(
        waveWidth / 2, waveHeight * 2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight * 2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(
        waveWidth / 2, waveHeight * 2, waveWidth, 0);
    _mainPath.relativeLineTo(0, wrapHeight);
    _mainPath.relativeLineTo(-waveHeight * 3 * 2.0, 0);
  }
}

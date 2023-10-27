import 'package:flutter/material.dart';

///  类似水波的效果，可以设置一个中心圆，然后一个波动的圆。
///
/// @author 阿南
/// @since 2021/12/3 17:08
class Wave extends StatefulWidget {
  // 动画持续时间
  final int durationMilliseconds;

  // 中心圆的颜色
  final Color centerColor;

  // 水波的颜色
  final Color waveColor;

  // 组件的大小
  final Size waveSize;

  // 中心圆的半径。默认为组件大小的1/6
  final double centerRadius;

  // 水波是否显示中心圈的上面
  final bool isWaveUp;

  const Wave(
      {this.durationMilliseconds = 2000,
      this.centerColor = Colors.blue,
      this.waveColor = Colors.green,
      this.waveSize = const Size(120, 120),
      this.centerRadius = 0,
      this.isWaveUp = true,
      super.key});

  @override
  State createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController spread;

  @override
  void initState() {
    super.initState();

    spread = AnimationController(vsync: this, duration: Duration(milliseconds: widget.durationMilliseconds))..repeat();
  }

  @override
  void dispose() {
    spread.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radius = widget.centerRadius;
    if (0 == radius) {
      radius = widget.waveSize.width / 6;
    }

    return CustomPaint(
      size: widget.waveSize,
      painter: ShapePainter(spread, widget.centerColor, widget.waveColor, radius, widget.isWaveUp),
    );
  }
}

class ShapePainter extends CustomPainter {
  final Animation<double> spread;
  final Color centerColor;
  final Color waveColor;
  final double centerRadius;
  final bool isWaveUp;

  ShapePainter(this.spread, this.centerColor, this.waveColor, this.centerRadius, this.isWaveUp) : super(repaint: spread);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    canvas.translate(size.width / 2, size.height / 2);

    if (isWaveUp) {
      _drawCenter(canvas, paint);
      _drawWave(canvas, paint, size);
    } else {
      _drawWave(canvas, paint, size);
      _drawCenter(canvas, paint);
    }
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) {
    return oldDelegate.spread != spread;
  }

  void _drawCenter(Canvas canvas, Paint paint) {
    paint.color = centerColor;
    canvas.drawCircle(const Offset(0, 0), centerRadius, paint);
  }

  void _drawWave(Canvas canvas, Paint paint, Size size) {
    if (0 != spread.value) {
      double radius = size.width < size.height ? size.width / 2 : size.height / 2;
      paint.color = waveColor.withOpacity(1 - spread.value);
      canvas.drawCircle(const Offset(0, 0), radius * spread.value, paint);
    }
  }
}

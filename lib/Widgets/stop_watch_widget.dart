import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StopWatchWidget extends StatefulWidget {
  const StopWatchWidget({super.key});

  @override
  State createState() => StopWatchWidgetState();
}

class StopWatchWidgetState extends State<StopWatchWidget> {
  ValueNotifier<Duration> durationNotifier = ValueNotifier(Duration.zero);
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();

    _ticker = Ticker((elapsed) {
      updateDuration(elapsed);
    });

    _ticker.start();
  }

  @override
  void dispose() {
    durationNotifier.dispose();
    _ticker.dispose();

    super.dispose();
  }

  void updateDuration(Duration elapsed) {
    int minutes = elapsed.inMinutes % 60;
    int seconds = elapsed.inSeconds % 60;
    int milliseconds = elapsed.inMilliseconds % 1000;
    durationNotifier.value = Duration(minutes: minutes, seconds: seconds, milliseconds: milliseconds);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<Duration>(
        valueListenable: durationNotifier,
        builder: (_, value, __) => SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: StopWatchPaint(value),
          ),
        ),
      ),
    );
  }
}

const double _kScaleWidthRate = 0.4 / 10;
TextPainter textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);
TextStyle commonStyle = const TextStyle(color: Colors.black, fontSize: 25);
TextStyle highlightStyle = const TextStyle(color: Colors.blue, fontSize: 25);

class StopWatchPaint extends CustomPainter {
  final Paint scalePainter = Paint();
  final Duration duration;

  StopWatchPaint(this.duration);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    scalePainter
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    final double scaleLineWidth = size.width * _kScaleWidthRate;

    canvas.save();
    for (int i = 0; i < 180; i++) {
      canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2 - scaleLineWidth, 0), scalePainter);

      canvas.rotate(pi / 180 * 2);
    }
    canvas.restore();

    drawText(canvas, duration);
  }

  void drawText(Canvas canvas, Duration duration) {
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    int milliseconds = duration.inMilliseconds % 1000;
    String commonStr = '${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
    String highlightStr = ".${(milliseconds ~/ 10).toString().padLeft(2, "0")}";

    textPainter.text = TextSpan(text: commonStr, style: commonStyle, children: [
      TextSpan(text: highlightStr, style: highlightStyle),
    ]);
    textPainter.layout();
    final double width = textPainter.size.width;
    final double height = textPainter.size.height;

    textPainter.paint(canvas, Offset(-width / 2, -height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

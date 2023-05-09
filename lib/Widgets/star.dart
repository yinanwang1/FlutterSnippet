import 'dart:math';

import 'package:flutter/material.dart';

/// 评分
/// @author 阿南
/// @since 2021/11/16 13:40
class CustomRating extends StatefulWidget {
  final int max;
  final Star star;
  final double score;
  final Function(double) onRating;

  const CustomRating({this.max = 5, this.star = const Star(), this.score = 0, required this.onRating, Key? key})
      : assert(score <= max),
        super(key: key);

  @override
  State createState() {
    return _CustomRatingState();
  }
}

class _CustomRatingState extends State<CustomRating> {
  late double _score;

  @override
  void initState() {
    _score = widget.score;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var li = <_StarWidget>[];

    int count = _score.floor();
    for (int i = 0; i < count; i++) {
      li.add(_StarWidget(
        star: widget.star.copyWith(progress: 1.0),
      ));
    }

    if (_score != widget.max.toDouble()) {
      li.add(_StarWidget(
        star: widget.star.copyWith(progress: _score - count),
      ));
    }

    var empty = widget.max - count - 1;
    for (int i = 0; i < empty; i++) {
      li.add(_StarWidget(
        star: widget.star.copyWith(progress: 0),
      ));
    }

    return GestureDetector(
      onTapDown: (d) {
        setState(() {
          _score = d.localPosition.dx / widget.star.size;
          if (_score - _score.floorToDouble() > 0.5) {
            _score = _score.floorToDouble() + 1.0;
          } else {
            _score = _score.floorToDouble() + 0.5;
          }

          if (_score >= widget.max.toDouble()) {
            _score = widget.max.toDouble();
          }

          widget.onRating(_score);
        });
      },
      child: Wrap(
        children: li,
      ),
    );
  }
}

/// 展示评分
/// @author 阿南
/// @since 2021/11/16 13:41
class StarScore extends StatelessWidget {
  final Star star;
  final double score;
  final Widget? tail;

  const StarScore({this.star = const Star(), required this.score, this.tail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var li = <_StarWidget>[];
    int count = score.floor();
    for (int i = 0; i < count; i++) {
      li.add(_StarWidget(
        star: star.copyWith(progress: 1.0),
      ));
    }
    if (score - count > 0) {
      li.add(_StarWidget(
        star: star.copyWith(progress: score - count),
      ));
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...li,
        const SizedBox(
          width: 10,
        ),
        if (null != tail) tail!,
      ],
    );
  }
}

class _StarWidget extends StatelessWidget {
  final Star star;

  const _StarWidget({Key? key, this.star = const Star()}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: star.size,
      height: star.size,
      child: CustomPaint(
        painter: _StarPainter(star),
      ),
    );
  }
}

class Star {
  final int num;
  final double progress;
  final Color emptyColor;
  final Color fillColor;
  final double size;
  final double fat;

  const Star(
      {this.num = 5,
      this.progress = 0,
      this.emptyColor = Colors.grey,
      this.fillColor = Colors.yellow,
      this.size = 25,
      this.fat = 0.5});

  Star copyWith({int? num, double? progress = 0, Color? emptyColor, Color? fillColor, double? size, double? fat}) {
    return Star(
        num: num ?? this.num,
        progress: progress ?? this.progress,
        emptyColor: emptyColor ?? this.emptyColor,
        fillColor: fillColor ?? this.fillColor,
        size: size ?? this.size,
        fat: fat ?? this.fat);
  }
}

class _StarPainter extends CustomPainter {
  Star star;
  late Paint _paint;
  late Paint _fillPaint;
  late Path _path;
  late double _radius;

  _StarPainter(this.star) {
    _paint = Paint()
      ..color = (star.emptyColor)
      ..isAntiAlias = true;
    _fillPaint = Paint()..color = (star.fillColor);
    _path = Path();
    _radius = star.size / 2.0;

    _nStarPath(star.num, _radius, _radius * star.fat);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(_radius, _radius);
    canvas.drawPath(_path, _paint);
    canvas.clipRect(Rect.fromLTRB(-_radius, -_radius, _radius * 2 * star.progress - _radius, _radius));
    canvas.drawPath(_path, _fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path _nStarPath(int num, double R, double r, {dx = 0, dy = 0, rotate = 0}) {
    _path.reset();
    double perRad = 2 * pi / num;
    double radA = perRad / 2 / 2 + rotate;
    double radB = 2 * pi / (num - 1) / 2 - radA / 2 + radA + rotate;
    _path.moveTo(cos(radA) * R + dx, -sin(radA) * R + dy);
    for (int i = 0; i < num; i++) {
      _path.lineTo(cos(radA + perRad * i) * R + dx, -sin(radA + perRad * i) * R + dy);
      _path.lineTo(cos(radB + perRad * i) * r + dx, -sin(radB + perRad * i) * r + dy);
    }
    _path.close();

    return _path;
  }
}

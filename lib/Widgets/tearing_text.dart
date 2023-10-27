import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polygon/polygon.dart';

class TearingText extends StatefulWidget {
  final String text;

  const TearingText(this.text, {super.key});

  @override
  State createState() => _TearingTextState();
}

class _TearingTextState extends State<TearingText> {
  late Timer _timer;
  late Timer _timer2;
  int _count = 0;
  bool _tear = false;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      _tearFunction();
    });
    _timer2 = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      _tearFunction();
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer2.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var status = Random().nextInt(3);
    return Stack(
      children: [
        if (_tear && (status == 1)) _renderTearText1(RandomTearingClipper(_tear)),
        if (!_tear || (_tear && 2 != status)) _renderMainText(RandomTearingClipper(_tear)),
        if (_tear && 2 == status) _renderTearText2(RandomTearingClipper(_tear))
      ],
    );
  }

  void _tearFunction() {
    _count++;
    _tear = _count % 2 == 0;
    if (_tear) {
      setState(() {});
      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() {
          _tear = false;
        });
      });
    }
  }

  double _randomPosition(position) {
    return Random().nextInt(position).toDouble() * (Random().nextBool() ? -1 : 1);
  }

  Widget _renderMainText(CustomClipper<Path>? clipper) {
    return ClipPath(
      clipper: clipper,
      child: Center(
        child: Text(
          widget.text,
          style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..strokeWidth = 5
                ..color = Colors.white,
              shadows: const [
                Shadow(blurRadius: 10, color: Colors.white, offset: Offset(0, 0)),
                Shadow(blurRadius: 20, color: Colors.white30, offset: Offset(0, 0)),
              ]),
        ),
      ),
    );
  }

  Widget _renderTearText1(CustomClipper<Path>? clipper) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return const LinearGradient(colors: [Colors.blue, Colors.green, Colors.red], stops: [0.0, 0.5, 1.0]).createShader(bounds);
      },
      child: Container(
        alignment: Alignment.center,
        transform: Matrix4.translationValues(_randomPosition(4), _randomPosition(4), 0),
        child: ClipPath(
          clipper: clipper,
          child: ClipRect(
            clipper: SizeClipper(top: 30, bottomAspectRatio: 1.5),
            child: Text(
              widget.text,
              style: TextStyle(
                  fontSize: 48,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 5
                    ..color = Colors.white70,
                  shadows: const [
                    Shadow(blurRadius: 10, color: Colors.white30, offset: Offset.zero),
                    Shadow(blurRadius: 30, color: Colors.white30, offset: Offset.zero)
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderTearText2(CustomClipper<Path>? clipper) {
    return ClipPath(
      clipper: clipper,
      child: Container(
        alignment: Alignment.center,
        transform: Matrix4.translationValues(_randomPosition(10), _randomPosition(10), 0),
        padding: const EdgeInsets.only(top: 10),
        child: ClipRect(
          clipper: SizeClipper(top: 20, bottomAspectRatio: 2),
          child: Text(
            widget.text,
            style: TextStyle(
                fontSize: 48,
                fontStyle: FontStyle.italic,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.white30,
                shadows: const [
                  Shadow(blurRadius: 10, color: Colors.white30, offset: Offset(0, 0)),
                  Shadow(blurRadius: 30, color: Colors.white30, offset: Offset(0, 0))
                ]),
          ),
        ),
      ),
    );
  }
}

class RandomTearingClipper extends CustomClipper<Path> {
  final bool tear;

  RandomTearingClipper(this.tear);

  List<Offset> generatePoint() {
    List<Offset> points = [];
    var x = -1.0;
    var y = -1.0;
    for (var i = 0; i < 60; i++) {
      if (i % 2 != 0) {
        x = Random().nextDouble() * (Random().nextBool() ? -1 : 1);
      } else {
        y = Random().nextDouble() * (Random().nextBool() ? -1 : 1);
      }
      points.add(Offset(x, y));
    }

    return points;
  }

  @override
  Path getClip(Size size) {
    var points = generatePoint();
    var polygon = Polygon(points);
    if (tear) {
      return polygon.computePath(rect: Offset.zero & size);
    } else {
      return Path()..addRect(Offset.zero & size);
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class SizeClipper extends CustomClipper<Rect> {
  final double top;
  final double bottomAspectRatio;

  SizeClipper({required this.top, required this.bottomAspectRatio});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, top, size.width, size.height / bottomAspectRatio);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}

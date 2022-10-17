import 'dart:math';

import 'package:flutter/material.dart';

class ProgressImage extends StatelessWidget {
  final double progress;

  const ProgressImage(this.progress, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "images/namei.png",
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
        ClipPath(
          clipper: ProgressClipper(progress: progress),
          child: Container(
            width: 150,
            height: 150,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        Text(
          "${(progress * 100).toInt()}%",
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ],
    );
  }
}

class ProgressClipper extends CustomClipper<Path> {
  final double progress;

  ProgressClipper({this.progress = 0});

  @override
  Path getClip(Size size) {
    if (0 == progress) {
      return Path();
    }

    // 红色区域
    Path zone = Path()..addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    // 蓝色弧线
    double outRadius = sqrt(size.width / 2 * size.width / 2 + size.height / 2 * size.height / 2);
    debugPrint("outRadius is $outRadius, size is $size");
    Path path = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..arcTo(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: 2 * outRadius, height: 2 * outRadius),
          -pi / 2, 2 * pi * progress, false);
    return Path.combine(PathOperation.xor, path, zone);
  }

  @override
  bool shouldReclip(covariant ProgressClipper oldClipper) {
    // return progress != oldClipper.progress;
    return true;
  }
}

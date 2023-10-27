import 'package:flutter/material.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

/// 渐变的边框

class GradientBorder extends StatelessWidget {
  final Widget? child;

  const GradientBorder({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 48,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return CustomPaint(
            painter: GradientBoundPainter(
                colors: [MyColors.mainColor, const Color(0xffff8D1A)],
                width: constraints.maxWidth,
                height: constraints.maxHeight),
            child: Center(
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class GradientBoundPainter extends CustomPainter {
  final List<Color> colors;
  final double width;
  final double height;
  final double strokeWidth;
  final double radius;

  GradientBoundPainter({
    required this.colors,
    required this.width,
    required this.height,
    this.strokeWidth = 2.0,
    this.radius = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset(size.width / 2 - width / 2, size.height / 2 - height / 2) & Size(width, height);
    RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final paint = Paint()
      ..shader = LinearGradient(colors: colors, begin: Alignment.centerLeft, end: Alignment.centerRight).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBoundPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}

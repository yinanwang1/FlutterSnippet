import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 绘制10000个园，作为背景，设置为RepaintBoundary后，不会被重新渲染。
/// 再绘制一个小圆，跟随手指滚动

class RepaintBoundaryBackground extends ConsumerStatefulWidget {
  const RepaintBoundaryBackground({super.key});

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<RepaintBoundaryBackground> {
  final GlobalKey _paintKey = GlobalKey();
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    debugPrint("_MyHomePageState build");

    return Stack(
      fit: StackFit.expand,
      children: [_buildBackground(), _buildCursor()],
    );
  }

  Widget _buildBackground() {
    return RepaintBoundary(
      child: CustomPaint(
        painter: BackgroundColor(MediaQuery.of(context).size),
        isComplex: true,
        willChange: false,
      ),
    );
  }

  Widget _buildCursor() {
    return Listener(
      onPointerDown: _updateOffset,
      onPointerMove: _updateOffset,
      child: CustomPaint(
        key: _paintKey,
        painter: CursorPointer(_offset),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
        ),
      ),
    );
  }

  void _updateOffset(PointerEvent event) {
    RenderBox? referenceBox = _paintKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = referenceBox.globalToLocal(event.position);

    setState(() {
      _offset = offset;
    });
  }
}

class BackgroundColor extends CustomPainter {
  static const List<Color> colors = [
    Colors.orange,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.red,
  ];

  final Size _size;

  BackgroundColor(this._size);

  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random(12345);

    for (int i = 0; i < 10000; i++) {
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(random.nextDouble() * _size.width - 100, random.nextDouble() * _size.height),
              width: random.nextDouble() * random.nextInt(150) + 200,
              height: random.nextDouble() * random.nextInt(150) + 200),
          Paint()..color = colors[random.nextInt(colors.length)].withOpacity(0.3));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CursorPointer extends CustomPainter {
  final Offset _offset;

  CursorPointer(this._offset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(_offset, 10.0, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(covariant CursorPointer oldDelegate) {
    return oldDelegate._offset != _offset;
  }
}
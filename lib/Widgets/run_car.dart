import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RunCar extends StatefulWidget {
  const RunCar({super.key});

  @override
  State<StatefulWidget> createState() => _RunCarState();
}

class _RunCarState extends State<RunCar> with SingleTickerProviderStateMixin {
  ui.Image? _image;
  final ValueNotifier<Matrix4> _matrix = ValueNotifier(Matrix4.identity());
  late Matrix4 rotate90;
  late Matrix4 moveMatrix;
  late AnimationController _controller;
  late Matrix4Tween moveTween;
  late Matrix4Tween rotateTween;
  final Matrix4 moveCenter = Matrix4.translationValues(50, 50, 0);
  final Matrix4 moveBack = Matrix4.translationValues(-50, -50, 0);

  @override
  void initState() {
    _loadImage();
    _initMatrix();
    _initTween();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    super.initState();
  }

  @override
  void dispose() {
    _matrix.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomPaint(size: const Size(300, 400), painter: Playground(_image, _matrix)),
            const Padding(padding: EdgeInsets.only(top: 18)),
            ControlTools(onReset: _onReset, onMove: _onMove, onRotate: _onRotate)
          ],
        ),
      ),
    );
  }

  void _loadImage() async {
    _image = await _loadImageFromAssets("images/car.png");
    setState(() {});
  }

  Future<ui.Image>? _loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  void _initMatrix() {
    rotate90 = Matrix4.rotationZ(pi / 2);
    rotate90 = moveCenter.multiplied(rotate90).multiplied(moveBack);
    moveMatrix = Matrix4.translationValues(100, 0, 0);
  }

  void _onRotate() {
    Matrix4 start = _matrix.value.clone();
    Animation<Matrix4> m4Tween = rotateTween.animate(_controller);
    m4Tween.addListener(() {
      Matrix4 rotate = moveCenter.multiplied(m4Tween.value).multiplied(moveBack);
      _matrix.value = start.multiplied(rotate);
    });

    _controller.forward(from: 0);
  }

  void _onMove() {
    Matrix4 start = _matrix.value.clone();
    Animation<Matrix4> m4Anima = moveTween.animate(_controller);
    m4Anima.addListener(() {
      _matrix.value = start.multiplied(m4Anima.value);
    });
    _controller.forward(from: 0);
  }

  void _onReset() {
    _matrix.value = Matrix4.identity();
  }

  void _initTween() {
    rotateTween = Matrix4Tween(begin: Matrix4.rotationZ(0), end: Matrix4.rotationZ(pi / 2));
    moveTween = Matrix4Tween(begin: Matrix4.translationValues(0, 0, 0), end: Matrix4.translationValues(100, 0, 0));
  }
}

class ControlTools extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onRotate;
  final VoidCallback onMove;

  const ControlTools({required this.onReset, required this.onRotate, required this.onMove, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(onTap: onReset, child: const Icon(Icons.refresh, color: Colors.blue, size: 40)),
          const SizedBox(width: 30),
          GestureDetector(onTap: onRotate, child: const Icon(Icons.rotate_90_degrees_ccw, color: Colors.blue, size: 40)),
          const SizedBox(width: 30),
          GestureDetector(onTap: onMove, child: const Icon(Icons.run_circle_outlined, color: Colors.blue, size: 40)),
        ],
      ),
    );
  }
}

class Playground extends CustomPainter {
  final ui.Image? image;
  final ValueListenable<Matrix4> matrix;

  Playground(this.image, this.matrix) : super(repaint: matrix);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.stroke;
    canvas.drawRect(Offset.zero & size, paint);

    if (null != image) {
      canvas.save();
      canvas.transform(matrix.value.storage);

      _drawCarWithRange(canvas, paint);

      canvas.restore();
    }
  }

  void _drawCarWithRange(Canvas canvas, Paint paint) {
    Rect zone = Rect.fromLTRB(0, 0, image!.width.toDouble(), image!.height.toDouble());
    paint.color = Colors.orange;
    canvas.drawRect(zone, paint);

    // 图片
    canvas.drawImage(image!, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant Playground oldDelegate) {
    return oldDelegate.image != image;
  }
}

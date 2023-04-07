import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';

void main() {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyApp()), {})));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("突飞猛进"),
      ),
      body: const SafeArea(
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("心有猛虎"),
      ),
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("data"),
          TextButton(onPressed: (){
            debugPrint("wyn aaa");
            _testSync();
            debugPrint("wyn bbb");
          }, child: const Text("测试下"))
        ],
      )),
    );
  }

  void _testSync() async {
    debugPrint("wyn 111");
    var result = await Future.delayed(const Duration(seconds: 1), () {
      return "很好";
    });
    debugPrint("wyn 222");
    sleep(const Duration(seconds: 1));
    debugPrint("wyn 333");
    debugPrint("wyn 444");
    debugPrint("wyn 555");
    debugPrint("wyn 666");
    debugPrint("wyn 777");
  }
}

// TEMP

class RunCar extends StatefulWidget {
  const RunCar({super.key});

  @override
  State<StatefulWidget> createState() => _RunCarState();
}

class _RunCarState extends State<RunCar> {
  ui.Image? _image;

  @override
  void initState() {
    _loadImage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
}

class ControlTools extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onRotate;
  final VoidCallback onMove;

  const ControlTools(this.onReset, this.onRotate, this.onMove, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(onTap: onReset, child: const Icon(Icons.refresh, color: Colors.blue)),
          const SizedBox(width: 16),
          GestureDetector(onTap: onRotate, child: const Icon(Icons.rotate_90_degrees_ccw, color: Colors.blue)),
          const SizedBox(width: 16),
          GestureDetector(onTap: onMove, child: const Icon(Icons.run_circle_outlined, color: Colors.blue)),
        ],
      ),
    );
  }
}

class Playground extends CustomPainter {
  final ui.Image? image;

  Playground(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.stroke;
    canvas.drawRect(Offset.zero & size, paint);

    if (null != image) {
      _drawCarWithRange(canvas, paint);
    }
  }

  void _drawCarWithRange(Canvas canvas, Paint paint) {
    Rect zone = Rect.fromLTRB(0, 0, image!.width.toDouble(), image!.width.toDouble());
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

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlurImageDemo extends StatefulWidget {
  const BlurImageDemo({super.key});

  @override
  State createState() {
    return _BlurImageDemoState();
  }
}

class _BlurImageDemoState extends State<BlurImageDemo> with SingleTickerProviderStateMixin {
  late ui.Image fillImage;
  var slideValue = 0.0;
  bool isImageLoaded = false;
  var blurValue = 0.0;

  _BlurImageDemoState();

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    final ByteData data = await rootBundle.load('images/namei.png');
    fillImage = await loadImage(Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (result) {
      setState(() {
        isImageLoaded = true;
      });

      return completer.complete(result);
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if (isImageLoaded) {
      return Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          CustomPaint(
            painter: BlurImagePainter(bgImage: fillImage, blur: blurValue),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Center(
            child: Container(
              alignment: Alignment.center,
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Material(
                color: Colors.transparent,
                child: Text(
                  "模糊效果",
                  style: TextStyle(
                    fontSize: 36.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
            child: Material(
              child: Slider(
                value: slideValue,
                min: 0.0,
                max: 20.0,
                onChanged: (value) {
                  slideValue = value;
                  setState(() {});
                },
                onChangeEnd: (value) {
                  setState(() {
                    blurValue = value;
                  });
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class BlurImagePainter extends CustomPainter {
  final ui.Image bgImage;
  final double blur;

  BlurImagePainter({required this.bgImage, required this.blur});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    if (blur > 0) {
      paint.imageFilter = ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur, tileMode: TileMode.mirror);
    }

    canvas.drawImageRect(
        bgImage, Rect.fromLTRB(0, 0, bgImage.width.toDouble(), bgImage.height.toDouble()), Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

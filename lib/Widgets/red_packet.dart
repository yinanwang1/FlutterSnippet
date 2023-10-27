import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

OverlayEntry? entry;

void showRedPacket(BuildContext context, Function? onOpen) {
  entry = OverlayEntry(
      builder: (context) => RedPacket(
            onFinish: _removeRedPacket,
            onOpen: onOpen,
          ));
  Overlay.of(context).insert(entry!);
}

void _removeRedPacket() {
  entry?.remove();
  entry = null;
}

class RedPacket extends StatefulWidget {
  final Function? onFinish;
  final Function? onOpen;

  const RedPacket({super.key, this.onFinish, this.onOpen});

  @override
  State createState() {
    return _RedPacketState();
  }
}

class _RedPacketState extends State<RedPacket> with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(vsync: this)
    ..duration = const Duration(milliseconds: 500)
    ..forward();

  late RedPacketController controller = RedPacketController(this);

  @override
  void initState() {
    super.initState();

    controller.onOpen = widget.onOpen;
    controller.onFinish = widget.onFinish;
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690), minTextAdapt: true);

    return Material(
      color: const Color(0x88000000),
      child: GestureDetector(
        child: ScaleTransition(
          scale:
              Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: scaleController, curve: Curves.fastOutSlowIn)),
          child: buildRedPacket(),
        ),
        onPanDown: (d) => controller.handleClick(d.globalPosition),
      ),
    );
  }

  Widget buildRedPacket() {
    return GestureDetector(
      onTapUp: controller.clickGold,
      child: CustomPaint(
        size: Size(1.sw, 1.sh),
        painter: RedPacketPainter(controller: controller),
        child: buildChild(),
      ),
    );
  }

  Widget buildChild() {
    return AnimatedBuilder(
      animation: controller.translateController,
      builder: (context, child) => Container(
        padding: EdgeInsets.only(top: 0.3.sh * (1 - controller.translateCtrl.value)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3.w),
                  child: Image.network(
                    "https://p26-passport.byteacctimg.com/img/user-avatar/32f1f514b874554f69fe265644ca84e4~300x300.image",
                    width: 24.w,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "周杰伦 发出的红包",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFFF8E7CB),
                    fontWeight: FontWeight.w500,
                    decorationStyle: TextDecorationStyle.dashed,
                    decorationColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.w,
            ),
            Text(
              "新歌快递",
              style: TextStyle(
                fontSize: 18.sp,
                color: const Color(0xFFF8E7CB),
                decorationStyle: TextDecorationStyle.dashed,
                decorationColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RedPacketPainter extends CustomPainter {
  late final Paint _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.redAccent;
  final Path path = Path();

  late double height = 1.2.sw;

  late double topBezierEnd = (1.sh - height) / 2 + height / 8 * 7;
  late double topBezierStart = topBezierEnd - 0.2.sw;
  late double bottomBezierStart = topBezierEnd - 0.4.sw;

  Offset goldCenter = Offset.zero;

  late double centerWidth = 0.5.sw;
  late double left = 0.1.sw;
  late double right = 0.9.sw;
  late double top = (1.sh - height) / 2;
  late double bottom = (1.sh - height) / 2 + height;

  final RedPacketController controller;

  RedPacketPainter({required this.controller}) : super(repaint: controller.repaint);

  @override
  void paint(Canvas canvas, Size size) {
    drawBottom(canvas);
    drawTop(canvas);
    if (controller.showOpenBtn) {
      drawGold(canvas);
      drawOpenText(canvas);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void drawTop(Canvas canvas) {
    canvas.save();
    canvas.translate(0, topBezierEnd * (-controller.translateCtrl.value));

    path.reset();
    path.addRRect(RRect.fromLTRBAndCorners(left, top, right, topBezierStart,
        topLeft: const Radius.circular(5), topRight: const Radius.circular(5)));
    var bezierPath = getTopBezierPath();
    path.addPath(bezierPath, Offset.zero);
    path.close();

    canvas.drawShadow(path, Colors.redAccent, 2, true);
    canvas.drawPath(path, _paint..color = Colors.redAccent);
    canvas.restore();
  }

  Path getTopBezierPath() {
    Path bezierPath = Path();
    bezierPath.moveTo(left, topBezierStart);
    bezierPath.quadraticBezierTo(centerWidth, topBezierEnd, right, topBezierStart);

    var pms = bezierPath.computeMetrics();
    var pm = pms.first;
    goldCenter = pm.getTangentForOffset(pm.length / 2)?.position ?? Offset.zero;

    return bezierPath;
  }

  void drawBottom(Canvas canvas) {
    canvas.save();
    canvas.translate(0, topBezierEnd * controller.translateCtrl.value);

    path.reset();
    path.moveTo(left, bottomBezierStart);
    path.quadraticBezierTo(centerWidth, topBezierEnd, right, bottomBezierStart);

    path.lineTo(right, topBezierEnd);
    path.lineTo(left, topBezierEnd);

    path.addRRect(RRect.fromLTRBAndCorners(left, topBezierEnd, right, bottom,
        bottomLeft: const Radius.circular(5), bottomRight: const Radius.circular(5)));
    path.close();

    canvas.drawShadow(path, Colors.redAccent, 2, true);

    canvas.drawPath(path, _paint..color = Colors.redAccent);
    canvas.restore();
  }

  void drawGold(Canvas canvas) {
    Path path = Path();

    double angle = controller.angleCtrl.value;

    canvas.save();
    canvas.translate(0.5.sw, goldCenter.dy);

    path.reset();
    _paint.style = PaintingStyle.fill;
    path.addOval(Rect.fromLTRB(-40.w * angle, -40.w, 40.w * angle, 40.w));
    if (!controller.showOpenText) {
      path.addRect(Rect.fromLTRB(-10.w * angle, -10.w, 10.w * angle, 10.w));
      path.fillType = PathFillType.evenOdd;
    }

    var frontOffset = 0.0;
    var backOffset = 0.0;
    if (controller.angleCtrl.status == AnimationStatus.reverse) {
      frontOffset = 4.w;
      backOffset = -4.w;
    } else if (controller.angleCtrl.status == AnimationStatus.forward) {
      frontOffset = -4.w;
      backOffset = 4.w;
    }
    var path2 = path.shift(Offset(backOffset * (1 - angle), 0));
    path = path.shift(Offset(frontOffset * (1 - angle), 0));

    controller.goldPath = path.shift(Offset(0.5.sw, goldCenter.dy));

    _paint.color = const Color(0xFFFCE5BF);
    canvas.drawPath(path2, _paint);

    drawGoldCenterRect(path, path2, canvas);

    _paint.color = const Color(0xFFFCE5BF);
    canvas.drawPath(path, _paint);

    canvas.restore();
  }

  void drawGoldCenterRect(Path path, Path path2, Canvas canvas) {
    var pms1 = path.computeMetrics();
    var pms2 = path2.computeMetrics();

    var pathMetric1 = pms1.first;
    var pathMetric2 = pms2.first;
    var length = pathMetric1.length;
    Path centerPath = Path();
    for (int i = 0; i < length; i++) {
      var position1 = pathMetric1.getTangentForOffset(i.toDouble())?.position;
      var position2 = pathMetric2.getTangentForOffset(i.toDouble())?.position;
      if (position1 == null || position2 == null) {
        continue;
      }
      centerPath.moveTo(position1.dx, position1.dy);
      centerPath.lineTo(position2.dx, position2.dy);
    }

    Paint centerPaint = Paint()
      ..color = const Color(0xFFE5CDA8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(centerPath, centerPaint);
  }

  void drawOpenText(Canvas canvas) {
    if (controller.showOpenText) {
      TextPainter textPainter = TextPainter(
          text: TextSpan(
              text: "開", style: TextStyle(fontSize: 34.sp, color: Colors.black87, height: 1.0, fontWeight: FontWeight.w400)),
          textDirection: TextDirection.ltr,
          maxLines: 1,
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false))
        ..layout();

      canvas.save();
      canvas.translate(0.5.sw, goldCenter.dy);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }
}

class RedPacketController {
  final TickerProviderStateMixin tickerProviderStateMixin;
  Listenable? repaint;

  late AnimationController angleController;
  late AnimationController translateController;
  late AnimationController scaleController;
  late Animation<double> translateCtrl;
  late Animation<Color?> colorCtrl;
  late Animation<double> angleCtrl;
  Path? goldPath;
  bool isAdd = false;
  bool showOpenText = true;
  bool showOpenBtn = true;

  Timer? timer;

  Function? onFinish;
  Function? onOpen;

  RedPacketController(this.tickerProviderStateMixin) {
    initAnimation();
  }

  void initAnimation() {
    angleController = AnimationController(
      vsync: tickerProviderStateMixin,
      duration: const Duration(milliseconds: 300),
    );
    translateController = AnimationController(vsync: tickerProviderStateMixin, duration: const Duration(milliseconds: 800));
    scaleController = AnimationController(vsync: tickerProviderStateMixin, duration: const Duration(milliseconds: 500))
      ..forward();

    angleCtrl = angleController.drive(Tween(begin: 1.0, end: 0.0));
    translateCtrl = translateController.drive(Tween(begin: 0.0, end: 1.0));
    colorCtrl = translateController.drive(ColorTween(begin: Colors.redAccent, end: const Color(0x00FF5252)));

    translateController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onFinish?.call();
      }
    });
    repaint = Listenable.merge([angleController, translateController]);
  }

  void stop() async {
    if (angleController.isAnimating) {
      if (angleController.status == AnimationStatus.forward) {
        await angleController.forward();
        angleController.reverse();
      } else if (angleController.status == AnimationStatus.reverse) {
        angleController.reverse();
      }

      tickerProviderStateMixin.setState(() {
        showOpenBtn = false;
      });
      translateController.forward();
      onOpen?.call();
    }
  }

  void dispose() {
    angleController.dispose();
    translateController.dispose();
    timer?.cancel();
  }

  bool checkClickGold(Offset point) {
    return goldPath?.contains(point) == true;
  }

  void clickGold(TapUpDetails details) {
    if (checkClickGold(details.globalPosition)) {
      if (angleController.isAnimating) {
        stop();
      } else {
        angleController.repeat(reverse: true);
        tickerProviderStateMixin.setState(() {
          showOpenText = false;
        });
        timer = Timer(const Duration(seconds: 2), stop);
      }
    }
  }

  void handleClick(Offset point) async {
    if (checkClickGold(point)) {
      return;
    }

    await scaleController.reverse();
    onFinish?.call();
  }
}

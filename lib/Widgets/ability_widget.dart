import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 蛛网图 摘自 https://juejin.cn/post/6844903903251660808#comment
/// 使用方式:
/// AbilityWidget(
///   ability: Ability(100, 1500, AssetImage("images/namei.png"), {
///     "攻击力": 70.0,
///     "生命": 90.0,
///     "闪避": 50.0,
///     "暴击": 70.0,
///     "破格": 80.0,
///     "格挡": 100.0,
///   }, Colors.black),
/// ),
/// 如果需要可以动态设置
class AbilityWidget extends StatefulWidget {
  final Ability ability;

  const AbilityWidget({Key? key, required this.ability}) : super(key: key);

  @override
  State createState() => _AbilityWidgetState();
}

class _AbilityWidgetState extends State<AbilityWidget> with SingleTickerProviderStateMixin {
  var _angle = 0.0;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(milliseconds: widget.ability.duration), vsync: this);
    var curveTween = CurveTween(curve: const Cubic(0.96, 0.13, 0.1, 1.2));
    var tween = Tween(begin: 0.0, end: 360.0);
    animation = tween.animate(curveTween.animate(controller));

    animation.addListener(() {
      setState(() {
        _angle = animation.value;
        debugPrint("angle is $_angle");
      });
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    var paint = CustomPaint(
      painter: AbilityPainter(widget.ability.radius, widget.ability.data),
    );

    var outlinePainter = Transform.rotate(
      angle: _angle / 180 * pi,
      child: CustomPaint(
        painter: OutlinePainter(widget.ability.radius),
      ),
    );

    var img = Transform.rotate(
      angle: _angle / 180 * pi,
      child: Opacity(
        opacity: animation.value / 360 * 0.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.ability.radius),
          child: Image(
              image: widget.ability.imageProvider,
              width: widget.ability.radius * 2,
              height: widget.ability.radius * 2,
              fit: BoxFit.cover),
        ),
      ),
    );

    var center = Transform.rotate(
      angle: -_angle / 180 * pi,
      child: Transform.scale(
        scale: 0.5 + animation.value / 360 / 2,
        child: SizedBox(
          width: widget.ability.radius * 2,
          height: widget.ability.radius * 2,
          child: paint,
        ),
      ),
    );

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[img, center, outlinePainter],
      ),
    );
  }
}

class Ability {
  final double radius;
  final int duration;
  final ImageProvider imageProvider;
  final Map<String, double> data;
  final Color color;

  const Ability(this.radius, this.duration, this.imageProvider, this.data, this.color);
}

class AbilityPainter extends CustomPainter {
  Map<String, double> data;
  double mRadius;
  late Paint mLinePaint;
  late Paint mAbilityPaint;
  late Paint mFillPaint;

  late Path mLinePath;
  late Path mAbilityPath;

  AbilityPainter(this.mRadius, this.data) {
    mLinePath = Path();
    mAbilityPath = Path();

    mLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.008 * mRadius
      ..isAntiAlias = true;
    mFillPaint = Paint()
      ..strokeWidth = 0.05 * mRadius
      ..color = Colors.black
      ..isAntiAlias = true;
    mAbilityPaint = Paint()
      ..color = const Color(0x8897C5FE)
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    canvas.translate(mRadius, mRadius);

    drawInnerCircle(canvas);
    drawInfoText(canvas);
    drawAbility(canvas, data.values.toList());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawInnerCircle(Canvas canvas) {
    double innerRadius = 0.618 * mRadius;
    canvas.drawCircle(const Offset(0, 0), innerRadius, mLinePaint);

    canvas.save();

    for (var i = 0; i < 6; i++) {
      canvas.save();

      canvas.rotate(60 * i.toDouble() / 180 * pi);
      mLinePath.moveTo(0, -innerRadius);
      mLinePath.relativeLineTo(0, innerRadius);

      for (int j = 1; j < 6; j++) {
        mLinePath.moveTo(-mRadius * 0.02, innerRadius / 6 * j);
        mLinePath.relativeLineTo(mRadius * 0.02 * 2, 0);
      }

      canvas.drawPath(mLinePath, mLinePaint);

      canvas.restore();
    }

    canvas.restore();
  }

  void drawInfoText(Canvas canvas) {
    double r2 = mRadius - 0.08 * mRadius;
    for (int i = 0; i < data.length; i++) {
      canvas.save();

      canvas.rotate(360 / data.length * i / 180 * pi + pi);
      drawText(canvas, data.keys.toList()[i], Offset(-50, r2 - 0.22 * mRadius), fontSize: mRadius * 0.1);

      canvas.restore();
    }
  }

  void drawText(Canvas canvas, String text, Offset offset,
      {Color color = Colors.black,
      double maxWidth = 100,
      double? fontSize,
      String? fontFamily,
      TextAlign textAlign = TextAlign.center,
      FontWeight fontWeight = FontWeight.bold}) {
    var paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      fontFamily: fontFamily,
      textAlign: textAlign,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ));
    paragraphBuilder.pushStyle(ui.TextStyle(color: color, textBaseline: TextBaseline.alphabetic));
    paragraphBuilder.addText(text);

    var paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: maxWidth));

    canvas.drawParagraph(paragraph, Offset(offset.dx, offset.dy));
  }

  void drawAbility(Canvas canvas, List<double> value) {
    double step = mRadius * 0.618 / 6;
    mAbilityPath.moveTo(0, -value[0] / 20 * step);
    for (int i = 1; i < 6; i++) {
      double mark = value[i] / 20;
      mAbilityPath.lineTo(mark * step * cos(pi / 180 * (-30 + 60 * (i - 1))), mark * step * sin(pi / 180 * (-30 + 60 * (i - 1))));
    }
    mAbilityPath.close();

    canvas.drawPath(mAbilityPath, mAbilityPaint);
  }
}

class OutlinePainter extends CustomPainter {
  double mRadius;
  late Paint mLinePaint;
  late Paint mFillPaint;

  OutlinePainter(this.mRadius) {
    mLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.008 * mRadius
      ..isAntiAlias = true;
    mFillPaint = Paint()
      ..strokeWidth = 0.05 * mRadius
      ..color = Colors.black
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.drawCircle(const Offset(0, 0), mRadius, mLinePaint);

    double r2 = mRadius - 0.08 * mRadius;
    canvas.drawCircle(const Offset(0, 0), r2, mLinePaint);

    for (var i = 0.0; i < 22; i++) {
      canvas.save();

      canvas.rotate(360 / 22 * i / 180 * pi);
      canvas.drawLine(Offset(0, -mRadius), Offset(0, -r2), mFillPaint);

      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

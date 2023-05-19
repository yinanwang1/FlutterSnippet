import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 建造者模式

abstract class PersonBuilder {
  Paint paint;
  Path path;

  PersonBuilder(this.paint, this.path);

  void buildHead();

  void buildBody();

  void buildArmLeft();

  void buildArmRight();

  void buildLegLeft();

  void buildLegRight();
}

// 瘦子
class PersonThinBuilder extends PersonBuilder {
  PersonThinBuilder(super.paint, super.path);

  @override
  void buildArmLeft() {
    path.moveTo(-10, 60);
    path.relativeLineTo(-100, 100);
    path.relativeLineTo(0, 10);
    path.relativeLineTo(100, -100);
  }

  @override
  void buildArmRight() {
    path.moveTo(10, 60);
    path.relativeLineTo(100, 100);
    path.relativeLineTo(0, 10);
    path.relativeLineTo(-100, -100);
  }

  @override
  void buildBody() {
    path.addOval(const Rect.fromLTWH(-15, 50, 30, 150));
  }

  @override
  void buildHead() {
    path.addOval(const Rect.fromLTWH(-25, 10, 50, 50));
  }

  @override
  void buildLegLeft() {
    path.addOval(const Rect.fromLTWH(-15, 190, 10, 150));
  }

  @override
  void buildLegRight() {
    path.addOval(const Rect.fromLTWH(5, 190, 10, 150));
  }
}

// 瘦子
class PersonFatBuilder extends PersonBuilder {
  PersonFatBuilder(super.paint, super.path);

  @override
  void buildArmLeft() {
    path.moveTo(-30, 50);
    path.relativeLineTo(-100, 100);
    path.relativeLineTo(0, 10);
    path.relativeLineTo(100, -100);
  }

  @override
  void buildArmRight() {
    path.moveTo(30, 50);
    path.relativeLineTo(100, 100);
    path.relativeLineTo(0, 10);
    path.relativeLineTo(-100, -100);
  }

  @override
  void buildBody() {
    path.addOval(const Rect.fromLTWH(-50, 50, 100, 150));
  }

  @override
  void buildHead() {
    path.addOval(const Rect.fromLTWH(-25, 10, 50, 50));
  }

  @override
  void buildLegLeft() {
    path.addOval(const Rect.fromLTWH(-35, 190, 25, 150));
  }

  @override
  void buildLegRight() {
    path.addOval(const Rect.fromLTWH(12, 190, 25, 150));
  }
}

class PersonDirector {
  final PersonBuilder personBuilder;

  PersonDirector(this.personBuilder);

  void createPerson() {
    personBuilder.buildHead();
    personBuilder.buildBody();
    personBuilder.buildArmLeft();
    personBuilder.buildArmRight();
    personBuilder.buildLegLeft();
    personBuilder.buildLegRight();
  }
}

// 绘制人

class BuilderWidget extends StatelessWidget {
  const BuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Colors.redAccent;
    final Path path = Path();
    var builder = PersonFatBuilder(paint, path);
    PersonDirector personDirector = PersonDirector(builder);
    personDirector.createPerson();

    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      child: CustomPaint(
        painter: BuilderCanvas(paint, path),
      ),
    );
  }
}

class BuilderCanvas extends CustomPainter {
  final Paint buildPaint;
  final Path path;

  BuilderCanvas(this.buildPaint, this.path);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, buildPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

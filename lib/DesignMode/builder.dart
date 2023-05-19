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

class PersonThinBuilder extends PersonBuilder {
  PersonThinBuilder(super.paint, super.path);

  @override
  void buildArmLeft() {
    path.moveTo(60, 50);
    path.lineTo(40, 100);
  }

  @override
  void buildArmRight() {
    path.moveTo(70, 50);
    path.lineTo(90, 100);
  }

  @override
  void buildBody() {
    path.addOval(const Rect.fromLTRB(60, 50, 10, 50));
  }

  @override
  void buildHead() {
    path.addOval(const Rect.fromLTRB(50, 20, 30, 30));
  }

  @override
  void buildLegLeft() {
    path.addOval(const Rect.fromLTRB(60, 100, 45, 150));
  }

  @override
  void buildLegRight() {
    path.addOval(const Rect.fromLTRB(70, 100, 85, 150));
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

class BuilderWidget extends StatelessWidget {
  const BuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Colors.redAccent;
    final Path path = Path();
    PersonThinBuilder personThinBuilder = PersonThinBuilder(paint, path);
    PersonDirector personDirector = PersonDirector(personThinBuilder);
    personDirector.createPerson();

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      alignment: Alignment.center,
      color: Colors.green,
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

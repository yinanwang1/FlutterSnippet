import 'package:flutter/cupertino.dart';

abstract class IGiveGift {
  void giveDolls();

  void giveFlowers();

  void giveChocolate();
}

class Pursuit implements IGiveGift {
  final SchoolGirl mm;

  Pursuit(this.mm);

  @override
  void giveChocolate() {
    debugPrint("${mm.name} 送礼巧克力");
  }

  @override
  void giveDolls() {
    debugPrint("${mm.name} 送礼洋娃娃");
  }

  @override
  void giveFlowers() {
    debugPrint("${mm.name} 送礼鲜花");
  }
}

class Proxy implements IGiveGift {
  Pursuit gg;

  Proxy(SchoolGirl mm) : gg = Pursuit(mm);

  @override
  void giveChocolate() {
    gg.giveChocolate();
  }

  @override
  void giveDolls() {
    gg.giveDolls();
  }

  @override
  void giveFlowers() {
    gg.giveFlowers();
  }
}

class SchoolGirl {
  final String name;

  SchoolGirl(this.name);
}

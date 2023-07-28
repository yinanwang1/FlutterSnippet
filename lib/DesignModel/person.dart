import 'package:flutter/widgets.dart';


// 装饰模式 Demo

class Person {
  String? name;

  Person({this.name});

  void show() {
    debugPrint("装扮的$name");
  }
}

// 服饰类 Decorator
class Finery extends Person {
  Person? _person;

  void decorate(Person? person) {
    _person = person;
  }

  @override
  void show() {
    _person?.show();
  }
}

// 具体服饰类 ConcreteDecorator
class TShirts extends Finery {
  @override
  void show() {
    debugPrint("大T恤");
    super.show();
  }
}

class BigTrouser extends Finery {
  @override
  void show() {
    debugPrint("垮裤");
    super.show();
  }
}

class Sneakers extends Finery {
  @override
  void show() {
    debugPrint("破球鞋");
    super.show();
  }
}
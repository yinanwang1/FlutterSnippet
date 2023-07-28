import 'dart:core';

import 'package:flutter/cupertino.dart';

// 观察者模式

// 观察者1
class StockObserver implements Observer {
  String name;
  Subject subject;

  StockObserver(this.name, this.subject);

  @override
  void update() {
    debugPrint("${subject.subjectState} $name 关闭股票行情，继续工作！");
  }
}


// 观察者2
class NBAObserver implements Observer {
  String name;
  Subject subject;

  NBAObserver(this.name, this.subject);

  @override
  void update() {
    debugPrint("${subject.subjectState} $name 关闭NBA直播，继续工作！");
  }
}

// 观察者 抽象
abstract class Observer {
  void update();
}

// 被观察者
abstract class Subject {
  final List<Observer> _observers = [];

  void attach(Observer observer) {
    _observers.add(observer);
  }

  void detach(Observer observer) {
    _observers.remove(observer);
  }

  void notify() {
    for (var element in _observers) {
      element.update();
    }
  }

  String? subjectState;
}

typedef EventHandler = Function();

class Boss extends Subject {
  Boss();
}

// 备忘录模式

import 'package:flutter/cupertino.dart';

// 发起人
class Originator {
  String state;

  Originator(this.state);

  Memento createMemento() {
    return Memento(state);
  }

  void setMemento(Memento memento) {
    state = memento.state;
  }

  void show() {
    debugPrint("state = $state");
  }
}

// 备忘录
class Memento {
  final String state;

  Memento(this.state);
}

// 管理者
class Caretaker {
  Memento memento;

  Caretaker(this.memento);
}

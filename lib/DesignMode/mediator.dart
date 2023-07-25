import 'package:flutter/material.dart';

/// 中介者模式

// 抽象中介者
abstract class Mediator {
  void send(String message, Colleague colleague);
}

// 具体中介者类
class ConcreteMediator extends Mediator {
  ConcreteColleague1? colleague1;
  ConcreteColleague2? colleague2;

  @override
  void send(String message, Colleague colleague) {
    // 互相发消息
    if (colleague == colleague1) {
      colleague2?.notify(message);
    } else {
      colleague1?.notify(message);
    }
  }
}

// 抽象同事类
abstract class Colleague {
  final Mediator mediator;

  Colleague(this.mediator);
}

// 具体同事类
class ConcreteColleague1 extends Colleague {
  ConcreteColleague1(super.mediator);

  void send(String message) {
    mediator.send(message, this);
  }

  void notify(String message) {
    debugPrint("同事1得到信息：$message");
  }
}

class ConcreteColleague2 extends Colleague {
  ConcreteColleague2(super.mediator);

  void send(String message) {
    mediator.send(message, this);
  }

  void notify(String message) {
    debugPrint("同事2得到信息：$message");
  }
}


// 客户端
class MediatorWidget extends StatelessWidget {
  const MediatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(onPressed: _sendMessage, icon: const Icon(Icons.message_outlined, size: 50,),),
    );
  }

  void _sendMessage() {
    ConcreteMediator mediator = ConcreteMediator();
    ConcreteColleague1 colleague1 = ConcreteColleague1(mediator);
    ConcreteColleague2 colleague2 = ConcreteColleague2(mediator);

    mediator.colleague1 = colleague1;
    mediator.colleague2 = colleague2;

    colleague1.send("吃过饭了吗？");
    colleague2.send("没有呢，你打算请客吗？");

    debugPrint("Done");
  }

}

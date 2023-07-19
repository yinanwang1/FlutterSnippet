import 'package:flutter/material.dart';

/// 命令模式

// 命令  烤串的抽象类
abstract class Command {
  final Receiver receiver;

  Command(this.receiver);

  void execute();
}

// 实类   具体的烤串
class ConcreteCommand extends Command {
  ConcreteCommand(super.receiver);

  @override
  void execute() {
    receiver.action();
  }
}

// 发起者  客户点菜
class Invoker {
  Command? command;

  Invoker({this.command});

  void executeCommand() {
    command?.execute();
  }
}

// 收接者  做烤串的师傅
class Receiver {
  void action() {
    debugPrint("执行请求");
  }
}

class CommandWidget extends StatelessWidget {
  const CommandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: _execute, child: const Text("执行例子"));
  }

  void _execute() {
    Receiver receiver = Receiver();
    Command command = ConcreteCommand(receiver);
    Invoker invoker = Invoker();

    invoker.command = command;
    invoker.executeCommand();

  }
}

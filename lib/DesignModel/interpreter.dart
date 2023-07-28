import 'package:flutter/material.dart';

/// 解释器模式

// 抽象表达式
abstract class AbstractExpression {
  void interpret(InterpretContext context);
}

// 终结符表达式
class TerminalExpression extends AbstractExpression {
  @override
  void interpret(InterpretContext context) {
    debugPrint("终端解释器");
  }
}

// 非终结符表达式
class NonTerminalExpression extends AbstractExpression {
  @override
  void interpret(InterpretContext context) {
    debugPrint("非终端解释器");
  }
}

class InterpretContext {
  final String input;
  final String output;

  InterpretContext(this.input, this.output);
}

// 实例
class InterpretWidget extends StatelessWidget {
  const InterpretWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: _onClick, child: const Text("Click Me"));
  }

  void _onClick() {
    var context = InterpretContext("", "output");
    TerminalExpression().interpret(context);
    TerminalExpression().interpret(context);
    NonTerminalExpression().interpret(context);
    TerminalExpression().interpret(context);
  }
}

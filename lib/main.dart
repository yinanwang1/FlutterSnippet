import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';

void main() {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {})));
  // runApp(const ProviderScope(child: MyHomePage()));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    debugPrint("wyn MediaQuery.of(context).size.height is ${MediaQuery.of(context).size.height}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("我的新世界"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("试试看"),
            TextButton(onPressed: () {
              // ConcreteComponent c = ConcreteComponent();
              // ConcreteDecoratorA d1 = ConcreteDecoratorA();
              // ConcreteDecoratorB d2 = ConcreteDecoratorB();
              //
              // d1.component = c;
              // d2.component = d1;
              // d2.operation();
              while (true) {

              }

            }, child: const Text("点我执行")),
          ],
        ),
      ),
    );
  }
}

// 装饰模式 Demo

abstract class Component {
  void operation();
}

class ConcreteComponent extends Component {
  @override
  void operation() {
    debugPrint("具体对象的操作。");
  }
}

abstract class Decorator extends Component {
  Component? _component;

  set component(value) {
    _component = value;
  }

  @override
  void operation() {
    _component?.operation();
  }
}

class ConcreteDecoratorA extends Decorator {
  String? _addedState;

  @override
  void operation() {
    super.operation();

    _addedState = "New State";
    debugPrint("具体装饰对象A的操作");
  }
}

class ConcreteDecoratorB extends Decorator {
  @override
  void operation() {
    super.operation();

    _addedBehavior();

    debugPrint("具体装饰对象B的操作");
  }

  void _addedBehavior() {
    // TODO
  }
}

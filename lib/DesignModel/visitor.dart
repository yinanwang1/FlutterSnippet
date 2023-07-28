import 'package:flutter/material.dart';

/// 访问者模式

// 访问者的抽象类  相当于 状态
abstract class Visitor {
  void visitConcreteElementA(ConcreteElementA concreteElementA);

  void visitConcreteElementB(ConcreteElementB concreteElementB);
}

// 具体访问者A  相当于 成功
class ConcreteVisitor1 extends Visitor {
  @override
  void visitConcreteElementA(ConcreteElementA concreteElementA) {
    debugPrint("${concreteElementA.runtimeType}被$runtimeType访问");
  }

  @override
  void visitConcreteElementB(ConcreteElementB concreteElementB) {
    debugPrint("${concreteElementB.runtimeType}被$runtimeType访问");
  }
}

// 具体访问者B  相当于 失败
class ConcreteVisitor2 extends Visitor {
  @override
  void visitConcreteElementA(ConcreteElementA concreteElementA) {
    debugPrint("${concreteElementA.runtimeType}被$runtimeType访问");
  }

  @override
  void visitConcreteElementB(ConcreteElementB concreteElementB) {
    debugPrint("${concreteElementB.runtimeType}被$runtimeType访问");
  }
}

// 可以添加更多的访问者C，D，E 等等。 表示不同的状态。

// 抽象元素类  相当于人类
abstract class Element {
  void accept(Visitor visitor);
}

// 具体元素  相当于 男人
class ConcreteElementA extends Element {
  @override
  void accept(Visitor visitor) {
    visitor.visitConcreteElementA(this);
  }

  void operationA() {
    // TODO
  }
}

// 具体元素  相当于 女人
class ConcreteElementB extends Element {
  @override
  void accept(Visitor visitor) {
    visitor.visitConcreteElementB(this);
  }

  void operationB() {
    // TODO
  }
}

class ObjectStructure {
  final List<Element> _elements = [];

  void attach(Element element) {
    _elements.add(element);
  }

  void detach(Element element) {
    _elements.remove(element);
  }

  void accept(Visitor visitor) {
    for (var element in _elements) {
      element.accept(visitor);
    }
  }
}

// 访问者模式的demo
class VisitorWidget extends StatelessWidget {
  const VisitorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: _onClick, child: const Text("Click Me"));
  }

  void _onClick() {
    ObjectStructure objectStructure = ObjectStructure();
    objectStructure.attach(ConcreteElementA());
    objectStructure.attach(ConcreteElementB());

    ConcreteVisitor1 visitor1 = ConcreteVisitor1();
    ConcreteVisitor2 visitor2 = ConcreteVisitor2();

    objectStructure.accept(visitor1);
    objectStructure.accept(visitor2);
  }
}

import 'package:flutter/cupertino.dart';

// 模板方法模式

abstract class TestPaper {
  void testQuestion1() {
    debugPrint("问题1");

    answer1();
  }

  void testQuestion2() {
    debugPrint("问题2");

    answer2();
  }

  void testQuestion3() {
    debugPrint("问题3");

    answer3();
  }

  void answer1();

  void answer2();

  void answer3();
}

class TestPagerA extends TestPaper {
  @override
  void answer1() {
    debugPrint("A");
  }

  @override
  void answer2() {
    debugPrint("B");
  }

  @override
  void answer3() {
    debugPrint("C");
  }
}

class TestPagerB extends TestPaper {
  @override
  void answer1() {
    debugPrint("D");
  }

  @override
  void answer2() {
    debugPrint("C");
  }

  @override
  void answer3() {
    debugPrint("B");
  }
}

class Main {
  void main() {
    // 使用
    TestPaper student = TestPagerA();
    student.testQuestion1();
    student.testQuestion2();
    student.testQuestion3();
  }
}

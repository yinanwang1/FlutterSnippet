import 'package:flutter/cupertino.dart';

// 外观模式

class Facade {
  SubSystemOne one;
  SubSystemTwo two;
  SubSystemThree three;
  SubSystemFour four;

  Facade()
      : one = SubSystemOne(),
        two = SubSystemTwo(),
        three = SubSystemThree(),
        four = SubSystemFour();

  void methodA() {
    debugPrint("方法组A ---");
    one.methodOne();
    two.methodTwo();
    four.methodFour();
  }

  void methodB() {
    debugPrint("方法组B ---");
    two.methodTwo();
    three.methodThree();
  }
}

class SubSystemOne {
  void methodOne() {
    debugPrint("子系统方法一");
  }
}

class SubSystemTwo {
  void methodTwo() {
    debugPrint("子系统方法二");
  }
}

class SubSystemThree {
  void methodThree() {
    debugPrint("子系统方法三");
  }
}

class SubSystemFour {
  void methodFour() {
    debugPrint("子系统方法四");
  }
}

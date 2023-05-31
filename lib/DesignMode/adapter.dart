
// 适配器模式

import 'package:flutter/cupertino.dart';

// 客户期待的接口
class Target {
  void request() {
    debugPrint("普通请求");
  }
}

// 需要被适配的类
class Adaptee {
  void specificRequest() {
    debugPrint("特殊请求");
  }
}

// 适配类
class Adapter extends Target {
  Adaptee adaptee = Adaptee();

  @override
  void request() {
    adaptee.specificRequest();
  }
}

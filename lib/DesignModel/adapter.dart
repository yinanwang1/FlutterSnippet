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



// 球员
abstract class Player {
  final String name;

  Player(this.name);

  void attack();

  void defense();
}

// 前锋
class Forwards extends Player {
  Forwards(super.name);

  @override
  void attack() {
    debugPrint("前锋 $name 进攻。");
  }

  @override
  void defense() {
    debugPrint("前锋 $name 防守。");
  }
}

// 中锋
class BasketCenter extends Player {
  BasketCenter(super.name);

  @override
  void attack() {
    debugPrint("中锋 $name  进攻。");
  }

  @override
  void defense() {
    debugPrint("中锋 $name 防守。");
  }
}

// 后卫
class Guards extends Player {
  Guards(super.name);

  @override
  void attack() {
    debugPrint("后卫 $name 进攻。");
  }

  @override
  void defense() {
    debugPrint("后卫 $name 防守。");
  }
}

// 外籍中锋
class ForeignCenter {
  final String name;

  ForeignCenter(this.name);

  void attackByChina() {
    debugPrint("外籍中锋 $name 进攻。");
  }

  void defenseByChina() {
    debugPrint("外籍中锋 $name 防守。");
  }
}

// 翻译者
class Translator extends Player {
  final ForeignCenter _foreignCenter;

  Translator(super.name): _foreignCenter = ForeignCenter(name);

  @override
  void attack() {
    _foreignCenter.attackByChina();
  }

  @override
  void defense() {
    _foreignCenter.defenseByChina();
  }

}

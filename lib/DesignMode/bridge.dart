import 'package:flutter/material.dart';

/// 桥接模式

// 手机软件
abstract class HandsetSoft {
  void run();
}

// 手机游戏
class HandsetGame extends HandsetSoft {
  @override
  void run() {
    debugPrint("运行手机游戏");
  }
}

// 手机通讯录
class HandsetAddressList extends HandsetSoft {
  @override
  void run() {
    debugPrint("运行手机通讯录");
  }
}

// 手机品牌类
abstract class HandsetBrand {
  HandsetSoft? soft;

  HandsetBrand({this.soft});

  void run();
}

// 手机品牌N
class HandsetBrandN extends HandsetBrand {
  HandsetBrandN({super.soft});

  @override
  void run() {
    soft?.run();
  }
}

// 手机品牌M
class HandsetBrandM extends HandsetBrand {
  HandsetBrandM({super.soft});

  @override
  void run() {
    soft?.run();
  }
}

class BridgeWidget extends StatelessWidget {
  const BridgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: _simulate, child: const Text("点我"));
  }

  void _simulate() {
    HandsetBrand handsetBrand = HandsetBrandN();
    handsetBrand.soft = HandsetGame();
    handsetBrand.run();

    handsetBrand.soft = HandsetAddressList();
    handsetBrand.run();

    handsetBrand = HandsetBrandM();
    handsetBrand.soft = HandsetGame();
    handsetBrand.run();

    handsetBrand.soft = HandsetAddressList();
    handsetBrand.run();
  }
}

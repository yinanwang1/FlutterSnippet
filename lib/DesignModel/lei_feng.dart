import 'package:flutter/cupertino.dart';

// 工厂方法模式

class LeiFeng {
  void sweep() {
    debugPrint("扫地");
  }

  void wash() {
    debugPrint("洗衣");
  }

  void buyRice() {
    debugPrint("买米");
  }
}

class Volunteer extends LeiFeng {}

class Undergraduate extends LeiFeng {}

abstract class IFactory {
  LeiFeng createLeiFeng();
}

class UndergraduateFactory implements IFactory {
  @override
  LeiFeng createLeiFeng() {
    return Undergraduate();
  }
}

class VolunteerFactory extends IFactory {
  @override
  LeiFeng createLeiFeng() {
    return Volunteer();
  }
}

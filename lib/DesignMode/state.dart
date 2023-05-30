// 状态模式

import 'package:flutter/cupertino.dart';

class Work {
  int hour;
  bool taskFinished;
  State? state;

  Work({this.hour = 0, this.taskFinished = false, this.state});

  void writeProgram() {
    state?.writeProgram(this);
  }
}

abstract class State {
  void writeProgram(Work work);
}

class ForenoonState implements State {
  @override
  void writeProgram(Work work) {
    if (work.hour < 12) {
      debugPrint("当前时间：${work.hour}点 上午工作，精神百倍");
    } else {
      work.state = NoonState();
      work.writeProgram();
    }
  }
}

class NoonState implements State {
  @override
  void writeProgram(Work work) {
    if (work.hour < 13) {
      debugPrint("当前时间： ${work.hour}点，饿了，午饭；犯困，午休。");
    } else {
      work.state = AfternoonState();
      work.writeProgram();
    }
  }
}

class AfternoonState implements State {
  @override
  void writeProgram(Work work) {
    if (work.hour < 17) {
      debugPrint("当前时间：${work.hour}点，下午状态还不错，继续努力");
    } else {
      work.state = EveningState();
      work.writeProgram();
    }
  }
}

class EveningState implements State {
  @override
  void writeProgram(Work work) {
    if (work.taskFinished) {
      work.state = RestState();
      work.writeProgram();
    } else {
      if (work.hour < 21) {
        debugPrint("当前时间：${work.hour}点，加班哦。疲累至极");
      } else {
        work.state = SleepingState();
        work.writeProgram();
      }
    }
  }
}

class RestState implements State {
  @override
  void writeProgram(Work work) {
    debugPrint("当前时间：${work.hour}点，下班回家了");
  }
}

class SleepingState implements State {
  @override
  void writeProgram(Work work) {
    debugPrint("当前时间：${work.hour}点，不行嘞，睡着了。");
  }
}

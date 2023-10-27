import 'package:flutter/material.dart';

/// 职责链模式

// 管理者
abstract class Manager {
  final String name;

  // 管理者的上级
  Manager? superior;

  Manager(this.name);

  // 申请请求
  void requestApplications(Request request);
}

// 经理
class CommonManager extends Manager {
  CommonManager(super.name);

  @override
  void requestApplications(Request request) {
    if (request.requestType == "请假" && request.number <= 2) {
      debugPrint("$name:${request.requestContent} 数量${request.number}被批准");
    } else {
      superior?.requestApplications(request);
    }
  }
}

// 总监
class Majordomo extends Manager {
  Majordomo(super.name);

  @override
  void requestApplications(Request request) {
    if (request.requestType == "请假" && request.number <= 5) {
      debugPrint("$name:${request.requestContent}数量${request.number}被批准");
    } else {
      superior?.requestApplications(request);
    }
  }
}

// 总经理
class GeneralManager extends Manager {
  GeneralManager(super.name);

  @override
  void requestApplications(Request request) {
    if (request.requestType == "请假") {
      debugPrint("$name:${request.requestContent}数量${request.number}被批准");
    } else if (request.requestType == "加薪" && request.number <= 500) {
      debugPrint("$name:${request.requestContent}数量${request.number}被批准");
    } else if (request.requestType == "加薪" && request.number > 500) {
      debugPrint("$name:${request.requestContent}数量${request.number}再说吧");
    }
  }
}

class Request {
  final String requestType;
  final String requestContent;
  final int number;

  Request(this.requestType, this.requestContent, this.number);
}


class ManagerWidget extends StatelessWidget {
  const ManagerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: _handleManager, child: const Text("点我"));
  }

  void _handleManager() {
    CommonManager jinli = CommonManager("金利");
    Majordomo zongjian = Majordomo("宗剑");
    GeneralManager zhongjingli = GeneralManager("钟锦鲤");
    jinli.superior = zongjian;
    zongjian.superior = zhongjingli;

    Request request = Request("请假", "小菜请假", 1);
    jinli.requestApplications(request);

    Request request2 = Request("请假", "小菜请假", 4);
    jinli.requestApplications(request2);

    Request request3 = Request("加薪", "小菜请求加薪", 500);
    jinli.requestApplications(request3);

    Request request4 = Request("加薪", "小菜请求加薪", 5000);
    jinli.requestApplications(request4);

    Request request5 = Request("请假", "小菜请假", 40);
    jinli.requestApplications(request5);
  }

}

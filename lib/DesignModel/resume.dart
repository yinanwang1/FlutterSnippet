
// 原型模式

class Resume {
  String? id;
  String? name;
  int? status;
  int? addTime;
  double? timeRemainAvg;
  double? openAvg;
  double? closeAvg;
  double? dispatchIntoAvg;
  bool? dispatchInto;

  Resume();

  Resume copyWith(
      {String? id,
      String? name,
      int? status,
      int? addTime,
      double? timeRemainAvg,
      double? openAvg,
      double? closeAvg,
      double? dispatchIntoAvg,
      bool? dispatchInto}) {
    return Resume()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..status = status ?? this.status
      ..addTime = addTime ?? this.addTime
      ..timeRemainAvg = timeRemainAvg ?? this.timeRemainAvg
      ..openAvg = openAvg ?? this.openAvg
      ..closeAvg = closeAvg ?? this.closeAvg
      ..dispatchIntoAvg = dispatchIntoAvg ?? this.dispatchIntoAvg
      ..dispatchInto = dispatchInto ?? this.dispatchInto;
  }
}

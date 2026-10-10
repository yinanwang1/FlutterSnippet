import 'package:drift/drift.dart';

@DataClassName('HeartRateRecord')
class HeartRateRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get deviceId => text().withLength(min: 1, max: 128)();

  IntColumn get bpm => integer()();

  DateTimeColumn get measuredAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// V3 新增：摄氏温度，旧记录和未指定温度的新记录默认 36.8°C。
  RealColumn get temperature => real().withDefault(const Constant(36.8))();

  @override
  List<String> get customConstraints => ['CHECK (bpm BETWEEN 1 AND 300)'];
}

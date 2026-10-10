import 'package:drift/drift.dart';

@DataClassName('HeartRateRecord')
class HeartRateRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get deviceId => text().withLength(min: 1, max: 128)();

  IntColumn get bpm => integer()();

  DateTimeColumn get measuredAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// V2 新增：旧记录和新记录默认均为未同步。
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  List<String> get customConstraints => ['CHECK (bpm BETWEEN 1 AND 300)'];
}

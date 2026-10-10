import 'package:drift/drift.dart';

@DataClassName('HeartRateRecord')
class HeartRateRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get deviceId => text().withLength(min: 1, max: 128)();

  IntColumn get bpm => integer()();

  DateTimeColumn get measuredAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => ['CHECK (bpm BETWEEN 1 AND 300)'];
}

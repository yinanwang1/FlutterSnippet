import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/heart_rate_records.dart';

part 'app_database.g.dart';

/// V2：保存心率记录及同步状态，打开旧数据库时保留记录并升级。
@DriftDatabase(tables: [HeartRateRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(
          executor ??
              driftDatabase(
                name: 'drift_demo',
                native: const DriftNativeOptions(
                  databaseDirectory: getApplicationSupportDirectory,
                ),
              ),
        );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) => migrator.createAll(),
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(
                heartRateRecords, heartRateRecords.isSynced);
          }
        },
      );

  Stream<List<HeartRateRecord>> watchHeartRateRecords() {
    return (select(heartRateRecords)
          ..orderBy([
            (table) => OrderingTerm.desc(table.measuredAt),
            (table) => OrderingTerm.desc(table.id),
          ]))
        .watch();
  }

  Future<int> addHeartRateRecord({
    required String deviceId,
    required int bpm,
    required DateTime measuredAt,
  }) {
    return into(heartRateRecords).insert(
      HeartRateRecordsCompanion.insert(
        deviceId: deviceId,
        bpm: bpm,
        measuredAt: measuredAt,
      ),
    );
  }

  Future<int> updateHeartRate(int id, int bpm) {
    return (update(heartRateRecords)..where((table) => table.id.equals(id)))
        .write(HeartRateRecordsCompanion(bpm: Value(bpm)));
  }

  Future<int> deleteHeartRateRecord(int id) {
    return (delete(heartRateRecords)..where((table) => table.id.equals(id)))
        .go();
  }

  /// 学习示例仅更新本地状态，实际同步应在服务器确认后调用。
  Future<int> markHeartRateSynced(int id) {
    return (update(heartRateRecords)..where((table) => table.id.equals(id)))
        .write(const HeartRateRecordsCompanion(isSynced: Value(true)));
  }

  /// 查询实际打开的文件路径，同时等待首次建库完成。
  Future<String> databaseFilePath() async {
    final databases = await customSelect('PRAGMA database_list').get();
    return databases
        .firstWhere((row) => row.read<String>('name') == 'main')
        .read<String>('file');
  }
}

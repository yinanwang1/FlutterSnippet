import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/heart_rate_records.dart';

part 'app_database.g.dart';

/// V4：保存心率与温度，移除旧版本的同步状态。
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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) => migrator.createAll(),
        onUpgrade: (migrator, from, to) async {
          await transaction(() async {
            // V1/V2 缺少温度字段，先补齐，再迁移到最终 V4 表结构。
            if (from < 3) {
              await migrator.addColumn(
                  heartRateRecords, heartRateRecords.temperature);
            }
            if (from < 4) {
              // 重建表时保留历史自增序列，避免复用已删除记录的 ID。
              final sequence = await customSelect(
                "SELECT seq FROM sqlite_sequence WHERE name = 'heart_rate_records'",
              ).getSingleOrNull();
              await migrator.alterTable(TableMigration(heartRateRecords));
              if (sequence != null) {
                final previousSequence = sequence.read<int>('seq');
                await customStatement(
                  "INSERT INTO sqlite_sequence (name, seq) SELECT 'heart_rate_records', ? "
                  "WHERE NOT EXISTS (SELECT 1 FROM sqlite_sequence WHERE name = 'heart_rate_records')",
                  [previousSequence],
                );
                await customStatement(
                  "UPDATE sqlite_sequence SET seq = MAX(seq, ?) WHERE name = 'heart_rate_records'",
                  [previousSequence],
                );
              }
            }
          });
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

  /// 查询实际打开的文件路径，同时等待首次建库完成。
  Future<String> databaseFilePath() async {
    final databases = await customSelect('PRAGMA database_list').get();
    return databases
        .firstWhere((row) => row.read<String>('name') == 'main')
        .read<String>('file');
  }
}

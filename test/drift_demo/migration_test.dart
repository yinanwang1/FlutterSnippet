import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_snippet/drift_demo/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

/// 从已保存的 V1 快照创建真实旧库，不使用当前 V2 的表声明。
class _V1Database extends GeneratedDatabase {
  _V1Database(super.executor, this.createTableSql);

  final String createTableSql;

  @override
  int get schemaVersion => 1;

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => const [];

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (_) => customStatement(createTableSql),
      );
}

Future<List<Map<String, Object?>>> _columns(AppDatabase database) async {
  final rows = await database
      .customSelect(
        'PRAGMA table_info(heart_rate_records)',
      )
      .get();
  return rows.map((row) => row.data).toList();
}

void main() {
  test('V1 文件实际升级至 V2：保留旧字段、补默认值，重开不重复迁移', () async {
    final directory = await Directory.systemTemp.createTemp('drift_migration_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/drift_demo.sqlite');
    final snapshot = jsonDecode(
      await File('drift_schemas/drift_schema_v1.json').readAsString(),
    ) as Map<String, dynamic>;
    final createTableSql = snapshot['fixed_sql'][0]['sql'][0]['sql'] as String;
    final measuredAt = DateTime.utc(2026, 10, 10, 8);
    final createdAt = measuredAt.add(const Duration(minutes: 1));
    final v1 = _V1Database(NativeDatabase(file), createTableSql);
    try {
      await v1.customStatement(
        'INSERT INTO heart_rate_records '
        '(id, device_id, bpm, measured_at, created_at) VALUES (?, ?, ?, ?, ?)',
        [
          7,
          'legacy-ring',
          72,
          measuredAt.millisecondsSinceEpoch ~/ 1000,
          createdAt.millisecondsSinceEpoch ~/ 1000
        ],
      );
      await v1.customStatement(
        'INSERT INTO heart_rate_records '
        '(id, device_id, bpm, measured_at, created_at) VALUES (?, ?, ?, ?, ?)',
        [
          8,
          'legacy-ring',
          80,
          measuredAt.millisecondsSinceEpoch ~/ 1000,
          createdAt.millisecondsSinceEpoch ~/ 1000
        ],
      );
      final version = await v1.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 1);
      final columns =
          await v1.customSelect('PRAGMA table_info(heart_rate_records)').get();
      expect(columns.map((row) => row.read<String>('name')),
          isNot(contains('is_synced')));
    } finally {
      await v1.close();
    }

    final freshV2 = AppDatabase(NativeDatabase.memory());
    late final List<Map<String, Object?>> freshColumns;
    try {
      freshColumns = await _columns(freshV2);
    } finally {
      await freshV2.close();
    }
    // 第一次以 V2 打开同一文件，触发真正的 onUpgrade。
    final v2 = AppDatabase(NativeDatabase(file));
    int newId;
    try {
      final records = await v2.watchHeartRateRecords().first;
      expect(records.map((record) => record.id), [8, 7]);
      expect(records.every((record) => !record.isSynced), isTrue);
      final legacy = records.last;
      expect(legacy.deviceId, 'legacy-ring');
      expect(legacy.bpm, 72);
      expect(legacy.measuredAt.toUtc(), measuredAt);
      expect(legacy.createdAt.toUtc(), createdAt);
      final version = await v2.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 2);
      // 升级后的列定义与全新安装 V2 一致。
      expect(await _columns(v2), freshColumns);
      expect(await v2.markHeartRateSynced(7), 1);
      newId = await v2.addHeartRateRecord(
        deviceId: 'new-ring',
        bpm: 85,
        measuredAt: measuredAt.add(const Duration(hours: 1)),
      );
      expect(newId, greaterThan(8));
    } finally {
      await v2.close();
    }

    final reopened = AppDatabase(NativeDatabase(file));
    try {
      final records = await reopened.watchHeartRateRecords().first;
      expect(records, hasLength(3));
      expect(records.singleWhere((record) => record.id == 7).isSynced, isTrue);
      expect(records.singleWhere((record) => record.id == 8).isSynced, isFalse);
      expect(records.singleWhere((record) => record.id == newId).isSynced,
          isFalse);
      final columns = await _columns(reopened);
      expect(columns.where((column) => column['name'] == 'is_synced'),
          hasLength(1));
      final version =
          await reopened.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 2);
    } finally {
      await reopened.close();
    }
  });
}

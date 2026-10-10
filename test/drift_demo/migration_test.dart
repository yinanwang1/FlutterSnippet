import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_snippet/drift_demo/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

/// 根据历史版本快照创建真实旧库，不使用当前 V4 的表声明。
class _LegacyDatabase extends GeneratedDatabase {
  _LegacyDatabase(super.executor, this.createTableSql, this.version);

  final String createTableSql;
  final int version;

  @override
  int get schemaVersion => version;

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
  test('V3 空表升级 V4 后仍可插入，保留已删除记录的自增序列', () async {
    final directory = await Directory.systemTemp.createTemp('drift_empty_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/drift_demo.sqlite');
    final snapshot = jsonDecode(
      await File('drift_schemas/drift_schema_v3.json').readAsString(),
    ) as Map<String, dynamic>;
    final legacy = _LegacyDatabase(
      NativeDatabase(file),
      snapshot['fixed_sql'][0]['sql'][0]['sql'] as String,
      3,
    );
    try {
      await legacy.customStatement(
        "INSERT INTO heart_rate_records (id, device_id, bpm, measured_at) VALUES (50, 'deleted', 60, 0)",
      );
      await legacy.customStatement('DELETE FROM heart_rate_records');
    } finally {
      await legacy.close();
    }
    final current = AppDatabase(NativeDatabase(file));
    try {
      expect(await current.watchHeartRateRecords().first, isEmpty);
      final columns = await _columns(current);
      expect(columns.where((column) => column['name'] == 'is_synced'), isEmpty);
      final id = await current.addHeartRateRecord(
        deviceId: 'new-ring',
        bpm: 80,
        measuredAt: DateTime(2026, 10, 10),
      );
      expect(id, greaterThan(50));
      expect((await current.watchHeartRateRecords().first).single.temperature,
          36.8);
    } finally {
      await current.close();
    }
  });

  for (final oldVersion in [1, 2, 3]) {
    test('V$oldVersion 文件升级至 V4：保留旧字段、移除同步字段，重开不重复迁移', () async {
      final directory =
          await Directory.systemTemp.createTemp('drift_migration_');
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/drift_demo.sqlite');
      final snapshot = jsonDecode(
        await File('drift_schemas/drift_schema_v$oldVersion.json')
            .readAsString(),
      ) as Map<String, dynamic>;
      final createTableSql =
          snapshot['fixed_sql'][0]['sql'][0]['sql'] as String;
      final measuredAt = DateTime.utc(2026, 10, 10, 8);
      final createdAt = measuredAt.add(const Duration(minutes: 1));
      final legacyDatabase =
          _LegacyDatabase(NativeDatabase(file), createTableSql, oldVersion);
      try {
        await legacyDatabase.customStatement(
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
        await legacyDatabase.customStatement(
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
        if (oldVersion >= 2) {
          await legacyDatabase.customStatement(
              'UPDATE heart_rate_records SET is_synced = 1 WHERE id = 7');
        }
        if (oldVersion == 3) {
          await legacyDatabase.customStatement(
              'UPDATE heart_rate_records SET temperature = 37.2 WHERE id = 7');
        }
        // 模拟曾经创建又删除的高 ID，迁移后不得复用。
        await legacyDatabase.customStatement(
            'INSERT INTO heart_rate_records (id, device_id, bpm, measured_at) VALUES (50, \'deleted-ring\', 60, 0)');
        await legacyDatabase
            .customStatement('DELETE FROM heart_rate_records WHERE id = 50');
        final version = await legacyDatabase
            .customSelect('PRAGMA user_version')
            .getSingle();
        expect(version.read<int>('user_version'), oldVersion);
        final columns = await legacyDatabase
            .customSelect('PRAGMA table_info(heart_rate_records)')
            .get();
        expect(
            columns.map((row) => row.read<String>('name')),
            oldVersion == 3
                ? contains('temperature')
                : isNot(contains('temperature')));
      } finally {
        await legacyDatabase.close();
      }

      final freshV4 = AppDatabase(NativeDatabase.memory());
      late final List<Map<String, Object?>> freshColumns;
      try {
        freshColumns = await _columns(freshV4);
      } finally {
        await freshV4.close();
      }
      // 第一次以 V4 打开同一文件，触发真正的 onUpgrade。
      final v4 = AppDatabase(NativeDatabase(file));
      int newId;
      try {
        final records = await v4.watchHeartRateRecords().first;
        expect(records.map((record) => record.id), [8, 7]);
        expect(records.singleWhere((record) => record.id == 7).temperature,
            oldVersion == 3 ? 37.2 : 36.8);
        expect(
            records.singleWhere((record) => record.id == 8).temperature, 36.8);
        final legacy = records.last;
        expect(legacy.deviceId, 'legacy-ring');
        expect(legacy.bpm, 72);
        expect(legacy.measuredAt.toUtc(), measuredAt);
        expect(legacy.createdAt.toUtc(), createdAt);
        final version =
            await v4.customSelect('PRAGMA user_version').getSingle();
        expect(version.read<int>('user_version'), 4);
        // 升级后的列定义与全新安装 V4 一致。
        expect(await _columns(v4), freshColumns);
        newId = await v4.addHeartRateRecord(
          deviceId: 'new-ring',
          bpm: 85,
          measuredAt: measuredAt.add(const Duration(hours: 1)),
        );
        expect(newId, greaterThan(50));
      } finally {
        await v4.close();
      }

      final reopened = AppDatabase(NativeDatabase(file));
      try {
        final records = await reopened.watchHeartRateRecords().first;
        expect(records, hasLength(3));
        expect(records.singleWhere((record) => record.id == 7).temperature,
            oldVersion == 3 ? 37.2 : 36.8);
        expect(
            records.singleWhere((record) => record.id == 8).temperature, 36.8);
        expect(records.singleWhere((record) => record.id == newId).temperature,
            36.8);
        final columns = await _columns(reopened);
        expect(
            columns.where((column) => column['name'] == 'is_synced'), isEmpty);
        expect(columns.where((column) => column['name'] == 'temperature'),
            hasLength(1));
        final version =
            await reopened.customSelect('PRAGMA user_version').getSingle();
        expect(version.read<int>('user_version'), 4);
      } finally {
        await reopened.close();
      }
    });
  }
}

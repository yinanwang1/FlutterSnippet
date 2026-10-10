import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_snippet/drift_demo/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('V1 建表、按测量时间排序，并通过 stream 返回增删改结果', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    expect(database.schemaVersion, 1);

    final stream = database.watchHeartRateRecords();
    expect(await stream.first, isEmpty);
    final later = DateTime(2026, 10, 10, 12);
    final firstId = await database.addHeartRateRecord(
      deviceId: 'ring-001',
      bpm: 80,
      measuredAt: later,
    );
    final secondId = await database.addHeartRateRecord(
      deviceId: 'ring-002',
      bpm: 70,
      measuredAt: later.subtract(const Duration(hours: 1)),
    );
    final records = await stream.first;
    expect(records.map((record) => record.id), [firstId, secondId]);
    expect(records.first.deviceId, 'ring-001');
    expect(records.first.createdAt, isA<DateTime>());

    final changed = stream.firstWhere((rows) => rows.first.bpm == 90);
    expect(await database.updateHeartRate(firstId, 90), 1);
    expect((await changed).first.bpm, 90);

    final deleted = stream.firstWhere((rows) => rows.length == 1);
    expect(await database.deleteHeartRateRecord(firstId), 1);
    expect((await deleted).single.id, secondId);
  });

  test('V1 文件数据库关闭后重新打开，原记录保留且不会重复插入', () async {
    final directory = await Directory.systemTemp.createTemp('drift_v1_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/drift_demo.sqlite');
    final original = AppDatabase(NativeDatabase(file));
    int id;
    try {
      id = await original.addHeartRateRecord(
        deviceId: 'ring-001',
        bpm: 75,
        measuredAt: DateTime(2026, 10, 10),
      );
      expect(
        await original.databaseFilePath(),
        await file.resolveSymbolicLinks(),
      );
    } finally {
      await original.close();
    }

    final reopened = AppDatabase(NativeDatabase(file));
    try {
      final records = await reopened.watchHeartRateRecords().first;
      expect(records, hasLength(1));
      expect(records.single.id, id);
      expect(records.single.bpm, 75);
      final version =
          await reopened.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 1);
    } finally {
      await reopened.close();
    }
  });
}

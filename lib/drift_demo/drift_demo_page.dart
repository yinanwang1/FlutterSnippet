import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'database/database_provider.dart';

class DriftDemoPage extends ConsumerStatefulWidget {
  const DriftDemoPage({super.key});

  @override
  ConsumerState<DriftDemoPage> createState() => _DriftDemoPageState();
}

class _DriftDemoPageState extends ConsumerState<DriftDemoPage> {
  late final AppDatabase _database;
  late final Stream<List<HeartRateRecord>> _records;
  late final Future<String> _filePath;
  final _random = Random();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _database = ref.read(appDatabaseProvider);
    _records = _database.watchHeartRateRecords();
    _filePath = _database.databaseFilePath();
  }

  Future<void> _runOperation(Future<void> Function() operation) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await operation();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('数据库操作失败：$error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _edit(HeartRateRecord record) async {
    var input = '${record.bpm}';
    String? validationError;
    final bpm = await showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('修改心率'),
          content: TextFormField(
            initialValue: input,
            onChanged: (value) => input = value,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '心率（bpm）',
              helperText: '示例允许范围：1–300',
              errorText: validationError,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final value = int.tryParse(input.trim());
                if (value == null || value < 1 || value > 300) {
                  setDialogState(() => validationError = '请输入 1–300 的整数');
                  return;
                }
                Navigator.pop(context, value);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
    if (bpm == null || !mounted) return;
    await _runOperation(() async {
      await _database.updateHeartRate(record.id, bpm);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drift 心率记录 · V1')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('数据库版本：${_database.schemaVersion}'),
                  FutureBuilder<String>(
                    future: _filePath,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('数据库打开失败：${snapshot.error}');
                      }
                      return SelectableText(
                        '文件路径：${snapshot.data ?? '正在打开…'}',
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _saving
                        ? null
                        : () => _runOperation(() async {
                              await _database.addHeartRateRecord(
                                deviceId: 'demo-ring-001',
                                bpm: 60 + _random.nextInt(41),
                                measuredAt: DateTime.now(),
                              );
                            }),
                    icon: const Icon(Icons.add),
                    label: Text(_saving ? '正在保存…' : '添加模拟心率记录'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<HeartRateRecord>>(
                stream: _records,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('读取失败：${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final records = snapshot.data!;
                  return Column(
                    children: [
                      Text('共 ${records.length} 条记录（按测量时间倒序）'),
                      Expanded(
                        child: records.isEmpty
                            ? const Center(child: Text('暂无记录，点击按钮添加'))
                            : ListView.builder(
                                itemCount: records.length,
                                itemBuilder: (context, index) {
                                  final record = records[index];
                                  return ListTile(
                                    key: ValueKey(record.id),
                                    title: Text(
                                        '${record.bpm} bpm · #${record.id}'),
                                    subtitle: Text(
                                      '设备：${record.deviceId}\n'
                                      '测量：${record.measuredAt.toLocal()}\n'
                                      '创建：${record.createdAt.toLocal()}',
                                    ),
                                    isThreeLine: true,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          tooltip: '修改心率',
                                          onPressed: _saving
                                              ? null
                                              : () => _edit(record),
                                          icon: const Icon(Icons.edit_outlined),
                                        ),
                                        IconButton(
                                          tooltip: '删除记录',
                                          onPressed: _saving
                                              ? null
                                              : () => _runOperation(() async {
                                                    await _database
                                                        .deleteHeartRateRecord(
                                                            record.id);
                                                  }),
                                          icon:
                                              const Icon(Icons.delete_outline),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

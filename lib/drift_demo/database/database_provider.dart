import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// 在现有 ProviderScope 内共享连接，首次读取时创建实例。
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

# Drift 学习示例：V1 心率记录

首页点击“跳转到学习数据库”，进入 V1 心率记录页面。

- `database/app_database.dart`：数据库版本为 1，使用固定名称 `drift_demo`，文件保存在 Application Support 目录，首次打开通过 `onCreate` 建表。
- `database/tables/heart_rate_records.dart`：包含自增 ID、设备 ID、心率、测量时间和创建时间；心率范围 1–300 是示例的数据约束。
- `database/database_provider.dart`：复用应用现有的 `ProviderScope`，通过 `ref.read(appDatabaseProvider)` 获取共享实例；作用域销毁时关闭连接。
- `drift_demo_page.dart`：点击添加模拟记录，修改心率、删除单条记录，通过 `watch()` 自动更新列表。页面显示版本、实际文件路径和数量。
- 数据库按需打开：进入学习页面才访问数据库；启动和重新打开不会自动插入模拟数据。
- `database/app_database.g.dart`：自动生成，不手动编辑。

修改数据库声明后，在项目根目录运行：

```bash
dart run build_runner build
```

验证命令：

```bash
flutter test test/drift_demo/app_database_test.dart
```

V1 表结构基线保存在根目录的 `drift_schemas/drift_schema_v1.json`。导出命令：

```bash
dart run drift_dev schema dump lib/drift_demo/database/app_database.dart drift_schemas/
```

设备验收：进入页面添加数条记录，修改一条、删除一条，彻底关闭 App 后重新打开，确认保留剩余记录。

请保留 V1 的安装和数据，下一步覆盖安装 V2 验证迁移。不要卸载或清除数据。

注意：第一步的空数据库也声明为 V1。如果曾通过自定义代码打开过空数据库，应使用干净的测试安装验证本次首次建表；本步骤不包含从空 V1 到有表 V1 的迁移。正常的第一步尚未访问数据库，不受影响。

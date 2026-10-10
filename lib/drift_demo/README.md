# Drift 学习示例：V2 心率记录与迁移

首页点击“跳转到学习数据库”，进入 V2 心率记录页面。

- `database/app_database.dart`：数据库版本为 2，仍使用固定名称 `drift_demo` 和 Application Support 目录。全新安装通过 `onCreate` 创建完整 V2 表；V1 通过 `onUpgrade` 添加 `is_synced` 列，不删除或重建旧数据。
- `database/tables/heart_rate_records.dart`：包含自增 ID、设备 ID、心率、测量时间、创建时间以及 V2 新增的 `isSynced`；心率范围 1–300 是示例的数据约束。同步状态非空，默认值为 `false`，适用于旧记录和新增记录。
- `database/database_provider.dart`：复用应用现有的 `ProviderScope`，通过 `ref.read(appDatabaseProvider)` 获取共享实例；作用域销毁时关闭连接。
- `drift_demo_page.dart`：点击添加模拟记录，通过每条记录右侧菜单修改、删除或标记已同步，`watch()` 自动更新列表。页面显示版本、文件路径、数量和同步状态。“标记已同步”仅为本地演示，尚未连接服务器。
- 数据库按需打开：进入学习页面才访问数据库；启动和重新打开不会自动插入模拟数据。
- `database/app_database.g.dart`：自动生成，不手动编辑。

修改数据库声明后，在项目根目录运行：

```bash
dart run build_runner build
```

验证命令：

```bash
flutter test test/drift_demo test/widget_test.dart
```

V1 表结构基线保持不变，V2 快照另存为 `drift_schemas/drift_schema_v2.json`。导出当前版本命令：

```bash
dart run drift_dev schema dump lib/drift_demo/database/app_database.dart drift_schemas/
```

`migration_test.dart` 根据 V1 快照创建旧版文件数据库并存入两条记录，关闭后用 V2 打开同一文件，验证旧字段、默认同步状态、版本号、自增主键以及重开后的状态持久化，并对比全新 V2 的列定义。

设备覆盖安装验收：

1. 保留已安装的 V1 和心率记录，停止旧 App。
2. 保持相同应用标识和签名，覆盖安装 V2；不要卸载或清除数据。
3. 进入学习页面，首次数据库访问自动迁移。确认版本为 2，旧记录数量和内容不变，状态为“未同步”。
4. 标记一条已同步，添加一条新记录，确认新记录仍为“未同步”。
5. 彻底关闭并重新打开，确认状态保留，数量不变。
6. 使用另一干净安装环境验证 V2 首次建库。

数据库 `schemaVersion` 与 App 的版本号相互独立。修改表声明后，必须重新生成代码并完整重启；热重载不能替代覆盖安装验收。当前自动化测试已执行本地文件迁移，设备安装验收需另行执行。

注意：本迁移以第二步已创建心率表的 V1 为基线，不适用于第一步通过自定义代码打开过的空 V1 数据库。

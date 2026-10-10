# Drift 学习示例：V4 心率与温度

首页点击“跳转到学习数据库”，进入 V4 页面，支持添加模拟心率、修改心率、删除记录以及实时展示温度。

- 数据库仍使用固定名称 `drift_demo`，保存在 Application Support 目录，按需打开。
- `schemaVersion` 为 4。保留 ID、设备 ID、心率、测量时间、创建时间和温度；删除 `isSynced`（SQL 列名 `is_synced`）。页面同步状态和“标记已同步”操作也已移除。
- 新增记录温度默认 36.8°C，仅为学习示例默认值，不代表实测温度。
- V3 → V4 使用 `alterTable(TableMigration(...))` 在事务内重建表并复制保留字段，实际删除同步列。同步标记的数据不再保留，其他字段及历史自增序列保留。
- V1/V2 → V4 先增加默认温度列，再迁移到最终 V4 表结构；不再添加已经废弃的同步列。
- 全新安装直接创建完整 V4 表；重新打开 V4 不重复迁移。
- Riverpod 管理共享连接；数据库生成代码不手动编辑。

代码生成和验证：

```bash
dart run build_runner build
flutter analyze lib/drift_demo test/drift_demo lib/Widgets/Database/learn_data_base.dart
flutter test test/drift_demo test/widget_test.dart
```

V1、V2、V3 历史快照保持不变，当前快照另存为 `drift_schemas/drift_schema_v4.json`：

```bash
dart run drift_dev schema dump lib/drift_demo/database/app_database.dart drift_schemas/
```

迁移测试从历史快照创建真实旧版文件，分别验证 V1/V2/V3 → V4：记录、时间、非默认温度保留；同步列实际移除；表结构与全新 V4 一致；已删除记录的 ID 不复用；关闭后重开不重复迁移。另测空表重建后的插入。

设备覆盖安装验收：

1. 保留设备上的 V3（或 V1/V2）数据，停止旧 App。
2. 保持相同应用标识和签名覆盖安装 V4，不卸载、不清除数据。
3. 进入学习页面触发迁移，确认版本为 4，原记录和温度保留，同步状态及操作已消失。
4. 添加、修改、删除记录，彻底关闭后重新打开，确认结果保留。
5. 在干净安装环境验证 V4 首次建库。

数据库版本与 App 版本号相互独立；修改表声明后需要代码生成和完整重启。文件迁移自动化测试不替代 Android、iOS 设备覆盖安装验收。迁移基线为第二步已建心率表的 V1，不包括第一步通过自定义代码打开过的空 V1 数据库。

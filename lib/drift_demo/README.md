# Drift 学习示例：第一步集成

当前仅接入数据库和代码生成，尚未添加业务表、迁移或演示页面。

- `database/app_database.dart`：数据库版本为 1，使用固定名称 `drift_demo`，文件保存在 Application Support 目录。
- `database/database_provider.dart`：复用应用现有的 `ProviderScope`，通过 `ref.read(appDatabaseProvider)` 获取共享实例；作用域销毁时关闭连接。
- 数据库按需打开：当前页面尚未读取 provider，因此启动 App 不会主动创建数据库文件。
- `database/app_database.g.dart`：自动生成，不手动编辑。

修改数据库声明后，在项目根目录运行：

```bash
dart run build_runner build
```

下一步添加第一张表，然后实现增删改查和页面监听。在 V1 实际安装并存入数据后，再进行 V2 迁移验证。

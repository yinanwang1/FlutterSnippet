import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
class SpUtils {
  static SpUtils? _singleton;
  static SharedPreferences? _preferences;
  static final Lock _lock = Lock();

  static Future<SpUtils> getInstance() async {
    if (null == _singleton) {
      _lock.lock();
      if (null == _singleton) {
        var singleton = SpUtils._();
        await singleton._init();
        _singleton = singleton;
      }
      _lock.unlock();
    }
    return _singleton!;
  }

  SpUtils._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void checkPreferences() {
    if (null == _preferences) {
      _init();
    }
  }

  static String? getString(String key) {
    getInstance().then((value) => value.checkPreferences());

    return _preferences?.getString(key);
  }

  static Future<bool>? putString(String key, String value) {
    getInstance().then((value) => value.checkPreferences());

    return _preferences?.setString(key, value);
  }

  static List<String>? getStringList(String key) {
    getInstance().then((value) => value.checkPreferences());

    return _preferences?.getStringList(key);
  }

  static Future<bool>? putStringList(String key, List<String> value) {
    getInstance().then((value) => value.checkPreferences());

    return _preferences?.setStringList(key, value);
  }

  static void delete(String key) {
    getInstance().then((value) => value.checkPreferences());

    _preferences?.remove(key);
  }
}

/// Add lock/unlock API for interceptors.
class Lock {
  Future? _lock;

  late Completer _completer;

  /// Whether this interceptor has been locked.
  bool get locked => _lock != null;

  /// Lock the interceptor.
  ///
  /// Once the request/response/error interceptor is locked, the incoming request/response/error
  /// will wait before entering the interceptor until the interceptor is unlocked.
  void lock() {
    if (!locked) {
      _completer = Completer();
      _lock = _completer.future;
    }
  }

  /// Unlock the interceptor. please refer to [lock()]
  void unlock() {
    if (locked) {
      _completer.complete();
      _lock = null;
    }
  }

  /// Clean the interceptor queue.
  void clear([String msg = 'cancelled']) {
    if (locked) {
      _completer.completeError(msg);
      _lock = null;
    }
  }
}

// UserDefault Keys

// 运营端的常见问题的搜索字符
const String userDefaultKeySearchingKeys = "userDefaultKeySearchingKeys";

// 运营端的车辆筛选 (单车状态;异常标记;停车类型;其他)
const String userDefaultKeyBicycleFilter = "userDefaultKeyBicycleFilter";

// 运营端的车辆信息配置 颜色码顺序 (保存字符串)
const String userDefaultKeyColorOrder = "userDefaultKeyColorOrder";

// 用户端 弹框信息的列表
const String userDefaultKeyActivityPopover = "userDefaultKeyActivityPopover";

// 运营端 电池排查的电池归属
const String userDefaultKeyBatteryOwners = "userDefaultKeyBatteryOwners";

// 运营端 电池排查的电池异常
const String userDefaultKeyBatteryAbnormalTypes = "userDefaultKeyBatteryAbnormalTypes";

// 运营端 电池维修的选中仓库. 采用字符串保存"id,name"的形式
const String userDefaultKeySelectedWarehouse = "userDefaultKeySelectedWarehouse";

// 运营端 单车换电，单车图标上展示指定数字 0 展示电池电量，1 展示单车型号
const String userDefaultKeySpecialNumberInMarkers = "userDefaultKeySpecialNumberInMarkers";

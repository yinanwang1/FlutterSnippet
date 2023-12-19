import 'dart:async';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter_snippet/Common/util/SpUtils.dart';
import 'package:flutter_snippet/Common/util/Utility.dart';

/// 定位。
/// 初始化时开始定位，并且实时

class FlutterLocation {
  static FlutterLocation? _singleton;
  static AMapFlutterLocation? _flutterLocation;
  static final Lock _lock = Lock();

  StreamController<StringLatLngTuple>? _receiveStream;

  // 已经定位的信息
  StringLatLngTuple? _location;

  StringLatLngTuple? get location {
    return _location;
  }

  static FlutterLocation getInstance() {
    if (null == _singleton) {
      _lock.lock();
      if (null == _singleton) {
        var singleton = FlutterLocation._();
        singleton._init();
        _singleton = singleton;
      }
      _lock.unlock();
    }

    return _singleton!;
  }

  FlutterLocation._();

  void _init() {
    _flutterLocation = AMapFlutterLocation();

    _flutterLocation?.onLocationChanged().listen((event) {
      var errorCode = event["errorCode"];
      if (null != errorCode) {
        return;
      }
      var latLng = LatLng(double.tryParse("${event["latitude"]}") ?? 0.0, double.tryParse("${event["longitude"]}") ?? 0.0);
      var address = "${event["district"]}${event["street"]}${event["streetNumber"]}${event["description"]}";

      var location = (address, latLng);
      _location = location;

      _receiveStream?.add(location);
    });

    startLocation();
  }

  // 开始定位
  void startLocation() {
    _flutterLocation?.setLocationOption(AMapLocationOption(needAddress: false));
    _flutterLocation?.startLocation();
  }

  // 结束定位
  void stopLocation() {
    _flutterLocation?.stopLocation();

    _receiveStream?.close();
    _receiveStream = null;
  }

  // 监听
  Stream<(String?, LatLng?)> onLocationChanged() {
    _receiveStream ??= StreamController.broadcast();

    return _receiveStream!.stream;
  }

  // 是否需要进行逆地理编码
  void needAddress(bool needAddress) {
    _flutterLocation?.setLocationOption(AMapLocationOption(needAddress: needAddress));
  }
}

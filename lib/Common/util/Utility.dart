import 'dart:math';
import 'dart:ui';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher_string.dart';

///
/// 功能性的函数其中在一起，方便管理也能有效的减少重复代码。
///

// 计算经纬度数组组成一个范围值，返回左下角和右上角点的经纬度数组
List<LatLng>? computeBounds(List<LatLng> latLngList) {
  if (latLngList.isEmpty) {
    return null;
  }

  // 地图展示范围
  var minLongitude = 180.0;
  var minLatitude = 90.0;
  var maxLongitude = 0.0;
  var maxLatitude = 0.0;

  for (var latLng in latLngList) {
    minLongitude = min(minLongitude, latLng.longitude);
    minLatitude = min(minLatitude, latLng.latitude);
    maxLongitude = max(maxLongitude, latLng.longitude);
    maxLatitude = max(maxLatitude, latLng.latitude);
  }

  return [LatLng(minLatitude, minLongitude), LatLng(maxLatitude, maxLongitude)];
}

// 拨打电话
void call(String? phone) async {
  if (null == phone || phone.isEmpty) {
    EasyLoading.showToast("呼叫失败, 电话号码为空");
    return;
  }

  var url = "tel:$phone";
  bool result = await canLaunchUrlString(url);
  if (result) {
    await launchUrlString(url);
  } else {
    EasyLoading.showToast("呼叫失败");
  }
}

/// 类型重命名

typedef StringIntTuple = (String, int);
typedef StringLatLngTuple = (String?, LatLng?);

typedef StringCallback = void Function(String? value);
typedef ColorListCallback = void Function(List<Color>? value);

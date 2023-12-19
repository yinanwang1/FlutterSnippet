import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/Common/util/macro.dart';

// 地图上展示的marker和polygon。
// 绘制还车点，那么会有marker和polygon。
// 绘制单车，那么只有marker
// 地图上绘制的内容（1）marker和polygon （2）polyline
class MapItem {
  PolygonItem? polygon;
  MarkerItem? marker;

  MapItem(this.polygon, this.marker);
}

class MarkerItem {
  // 单车编号，还车点的编号。 还车点时为还车点名称,或ID。
  String number;

  // 坐标位置
  LatLng position;

  // 名称 （如：还车点的名称）
  String? name;

  // 未选中的图片
  String bitmap;

  // 选中的图片
  String selectedBitmap;

  // 标记的标题,  当有title时，则不使用bitmap
  String? title;

  // 地图的Marker上编写内容
  MarkerTitleType markerTitleType;

  // 尽量能够做成通用的。
  // 单车换电使用 __START__
  //电量百分比
  int? power;

  // 员工骑行 __START__
  String? statusText;

  // 员工骑行 __END__

  // 轨迹 __START__
  String? infoWindow;

  // 轨迹 __END__

  MarkerItem(this.number, this.position,
      {required this.bitmap,
      required this.selectedBitmap,
      this.title,
      this.markerTitleType = MarkerTitleType.small,
      this.statusText,
      this.power,
      this.infoWindow,
      this.name});
}

class PolygonItem {
  // 多边形的坐标点
  List<LatLng> points;
  Color strokeColor;
  Color fillColor;

  PolygonItem(this.points, {this.strokeColor = Colors.red, this.fillColor = Colors.blue});
}

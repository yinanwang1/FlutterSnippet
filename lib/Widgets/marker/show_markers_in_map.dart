import 'dart:io';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/Common/util/Utility.dart';
import 'package:flutter_snippet/Widgets/marker/MapItem.dart';
import 'package:flutter_snippet/Widgets/marker/base_a_map.dart';
import 'package:flutter_snippet/generated/my_images.dart';
// 输入图标，坐标点，展示图标和轨迹。

class ShowMarkersInMap extends StatefulWidget {
  final List<MarkerItem>? markerItems;
  final List<LatLng>? latLngList;

  // 默认根据坐标点绘制轨迹
  final bool drawLocus;

  const ShowMarkersInMap({super.key, this.markerItems, this.latLngList, this.drawLocus = true});

  @override
  State createState() => _ShowMarkersInMapState();
}

class _ShowMarkersInMapState extends State<ShowMarkersInMap> {
  final GlobalKey<BaseAMapState> _baseAMapState = GlobalKey<BaseAMapState>();

  @override
  void didUpdateWidget(covariant ShowMarkersInMap oldWidget) {
    // 内容改变的时候，刷新数据
    if (oldWidget.markerItems != widget.markerItems) {
      _showMarkersPolyline();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaseAMap(
          key: _baseAMapState,
          didSelectBicycle: (MarkerItem? item) {
            // Do nothing
          },
          showInfoWindow: true,
          onMapCreated: _showMarkersPolyline,
          shouldMoveCenterToLocation: false,
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: _currentLocation(),
        )
      ],
    );
  }

  Widget _currentLocation() {
    return IconButton(
      onPressed: () {
        _returnUserLocation();
      },
      icon: Image.asset(MyImages.imagesIcLocation, width: 44, height: 44),
    );
  }

  void _returnUserLocation() {
    _baseAMapState.currentState?.returnUserLocation();
  }

  void _showMarkersPolyline() {
    if (null == _baseAMapState.currentState) {
      return;
    }
    var markerItems = widget.markerItems;
    var latLngList = widget.latLngList;

    if (null != markerItems) {
      _baseAMapState.currentState?.refreshMarkers(markerItems, clearPolyline: false);
    }

    if (null != latLngList) {
      if (widget.drawLocus) {
        var iconPath = MyImages.imagesIcBlueArrow;
        if (Platform.isIOS) {
          iconPath = MyImages.imagesIcBlueArrowIos;
        }
        _baseAMapState.currentState?.refreshPolyline(latLngList, customTexture: BitmapDescriptor.fromIconPath(iconPath));
      }

      var bounds = computeBounds(latLngList);
      if (null != bounds && bounds.length == 2) {
        _baseAMapState.currentState?.refreshLatLngBounds(bounds.first, bounds.last);
      }
    }
  }
}

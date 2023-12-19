import 'dart:math';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/Common/util/Utility.dart';
import 'package:flutter_snippet/Widgets/marker/MapConverting.dart';
import 'package:flutter_snippet/Widgets/marker/MapItem.dart';
import 'package:flutter_snippet/Widgets/marker/base_a_map.dart';

class DemoAMapMarkers extends StatefulWidget {
  const DemoAMapMarkers({super.key});

  @override
  State createState() => _DemoAMapMarkersState();
}

class _DemoAMapMarkersState extends State<DemoAMapMarkers> {
  final GlobalKey<BaseAMapState> _baseAMapState = GlobalKey<BaseAMapState>();

  @override
  Widget build(BuildContext context) {
    return BaseAMap(
      key: _baseAMapState,
      didSelectBicycle: (MarkerItem? item) {
        // DO nothing
      },
      onMapCreated: _showMarkers,
      shouldMoveCenterToLocation: false,
    );
  }

  void _showMarkers() async {
    if (null == _baseAMapState.currentState) {
      return;
    }
    var latLngList = _createTrackLatLng();

    Random random = Random();
    List<BatteryWeakListDataItems> items = latLngList
        .mapIndexed((index, element) => BatteryWeakListDataItems(
            bikeNo: "$index",
            power: random.nextInt(100),
            coordinate: CoordinateEntity(longitude: element.longitude, latitude: element.latitude)))
        .toList();

    if (latLngList.length < 2) {
      return;
    }

    var mapItems = MapConverting.asMapItemForExchange(items);
    var markerItems = await compute(MapConverting.asMarkerItem, mapItems);
    debugPrint("markerItems is $markerItems");
    _baseAMapState.currentState?.refreshMarkers(markerItems);

    var bounds = computeBounds(latLngList);
    if (null != bounds && bounds.length == 2) {
      _baseAMapState.currentState?.refreshLatLngBounds(bounds.first, bounds.last);
    }
  }

  List<LatLng> _createTrackLatLng() {
    return [
      const LatLng(39.885561, 116.37558),
      const LatLng(39.90176, 116.30022),
      const LatLng(39.91348, 116.422615),
      const LatLng(39.892015, 116.466217),
      const LatLng(39.863033, 116.444073),
      const LatLng(39.850909, 116.393089),
    ];
  }
}

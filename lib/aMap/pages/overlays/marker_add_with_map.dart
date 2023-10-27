import 'dart:math';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';

class MarkerAddWithMapPage extends BasePage {
  const MarkerAddWithMapPage(super.title, super.subTitle, {super.key});

  @override
  Widget build(BuildContext context) => _Body();
}

class _Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  static const LatLng mapCenter = LatLng(39.909187, 116.397451);
  final Map<String, Marker> _initMarkerMap = <String, Marker>{};

  @override
  Widget build(BuildContext context) {
    for(int i=0; i< 10; i++) {
      LatLng position = LatLng(
          mapCenter.latitude + sin(i * pi / 12.0) / 20.0,
          mapCenter.longitude + cos(i * pi / 12.0) / 20.0);
      Marker marker = Marker(position: position);
      _initMarkerMap[marker.id] = marker;
    }

    final AMapWidget amap = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      apiKey: ConstConfig.amapApiKeys,
      markers: Set<Marker>.of(_initMarkerMap.values),
    );
    return Container(
      child: amap,
    );
  }

}

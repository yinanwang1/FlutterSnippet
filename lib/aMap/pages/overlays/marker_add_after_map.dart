import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';

class MarkerAddAfterMapPage extends BasePage {
  const MarkerAddAfterMapPage(super.title, super.subTitle, {super.key});

  @override
  Widget build(BuildContext context) => _Body();
}

class _Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  static const LatLng defaultPosition = LatLng(39.909187, 116.397451);
  //需要先设置一个空的map赋值给AMapWidget的markers，否则后续无法添加marker
  final Map<String, Marker> _markers = <String, Marker>{};
  LatLng _currentLatLng = defaultPosition;
  //添加一个marker
  void _addMarker() {
    final markerPosition =
        LatLng(_currentLatLng.latitude, _currentLatLng.longitude + 2 / 1000);
    final Marker marker = Marker(
      position: markerPosition,
      //使用默认hue的方式设置Marker的图标
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    //调用setState触发AMapWidget的更新，从而完成marker的添加
    setState(() {
      _currentLatLng = markerPosition;
      //将新的marker添加到map里
      _markers[marker.id] = marker;
    });
  }

  TextButton _createMyFloatButton(String label, Function onPressed) {
    return TextButton(
      onPressed: (){
        onPressed();
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget amap = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      apiKey: ConstConfig.amapApiKeys,
      // //创建地图时，给marker属性赋值一个空的set，否则后续无法添加marker
      markers: Set<Marker>.of(_markers.values),
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 10,
            child: amap,
          ),
          Expanded(
            flex: 1,
            child: _createMyFloatButton('添加marker', _addMarker),
          ),
        ],
      ),
    );
  }
}

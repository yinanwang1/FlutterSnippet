import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLocationPage extends BasePage {
  const MyLocationPage(super.title, super.subTitle, {super.key});
  @override
  Widget build(BuildContext context) => const _Body();
}

class _Body extends StatefulWidget {
  const _Body();
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  void reassemble() {
    super.reassemble();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    debugPrint('permissionStatus=====> $status');
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget amap = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      apiKey: ConstConfig.amapApiKeys,
      myLocationStyleOptions: MyLocationStyleOptions(
        true,
        circleFillColor: Colors.lightBlue,
        circleStrokeColor: Colors.blue,
        circleStrokeWidth: 1,
      ),
    );
    return Container(
      child: amap,
    );
  }
}

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class LimitMapBoundsPage extends BasePage {
  const LimitMapBoundsPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => _Body();
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    final AMapWidget amap = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      apiKey: ConstConfig.amapApiKeys,
      limitBounds: LatLngBounds(southwest: const LatLng(39.83309, 116.290176), northeast: const LatLng(39.99951, 116.501663)),
    );
    return Container(
      child: amap,
    );
  }
}

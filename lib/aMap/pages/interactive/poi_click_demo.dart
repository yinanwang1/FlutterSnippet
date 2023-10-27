import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';

class PoiClickDemoPage extends BasePage {
  const PoiClickDemoPage(super.title, super.subTitle, {super.key});

  @override
  Widget build(BuildContext context) => const _Body();
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  Widget? _poiInfo;
  @override
  Widget build(BuildContext context) {
    final AMapWidget amap = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      touchPoiEnabled: true,
      onPoiTouched: _onPoiTouched,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: amap,
          ),
          Positioned(
            top: 40,
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Container(
              child: _poiInfo,
            ),
          )
        ],
      ),
    );
  }

  Widget showPoiInfo(AMapPoi poi) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0x8200CCFF),
      child: Text(
        '您点击了 ${poi.name}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _onPoiTouched(AMapPoi poi) {
    setState(() {
      _poiInfo = showPoiInfo(poi);
    });
  }
}

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';

class MinMaxZoomDemoPage extends BasePage {
  const MinMaxZoomDemoPage(String title, String subTitle, {super.key}) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => const _Body();
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final double _minZoom = 10;
  final double _maxZoom = 15;
  String? _currentZoom;
  AMapController? _mapController;
  @override
  Widget build(BuildContext context) {
    final AMapWidget amap = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      apiKey: ConstConfig.amapApiKeys,
      onMapCreated: _onMapCreated,
      onCameraMove: _onCameraMove,
      onCameraMoveEnd: _onCameraMoveEnd,
      minMaxZoomPreference: MinMaxZoomPreference(_minZoom, _maxZoom),
    );
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: amap,
          ),
          Positioned(
            top: 5,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '当前限制的最小最大缩放级别是：[$_minZoom, $_maxZoom]',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                _currentZoom != null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _currentZoom ?? "0",
                          style: const TextStyle(color: Colors.white),
                        ))
                    : const SizedBox(),
              ],
            ),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkResponse(
                  onTap: _zoomIn,
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.blue,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                InkResponse(
                  onTap: _zoomOut,
                  child: Container(
                    color: Colors.blue,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(AMapController controller) {
    _mapController = controller;
  }

  //移动视野
  void _onCameraMove(CameraPosition cameraPosition) {}

  //移动地图结束
  void _onCameraMoveEnd(CameraPosition cameraPosition) {
    setState(() {
      _currentZoom = '当前缩放级别：${cameraPosition.zoom}';
    });
  }

  //级别加1
  void _zoomIn() {
    _mapController?.moveCamera(
      CameraUpdate.zoomIn(),
      animated: true,
    );
  }

  //级别减1
  void _zoomOut() {
    _mapController?.moveCamera(
      CameraUpdate.zoomOut(),
      animated: true,
    );
  }
}
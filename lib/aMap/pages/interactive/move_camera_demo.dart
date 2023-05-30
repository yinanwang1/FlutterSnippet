import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:flutter_snippet/aMap/widgets/amap_gridview.dart';

class MoveCameraDemoPage extends BasePage {
  const MoveCameraDemoPage(String title, String subTitle, {super.key}) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => const _Body();
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  AMapController? _mapController;
  String? _currentZoom;
  @override
  Widget build(BuildContext context) {
    final AMapWidget amap = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      onMapCreated: _onMapCreated,
      onCameraMove: _onCameraMove,
      onCameraMoveEnd: _onCameraMoveEnd,
    );
    List<Widget> optionsWidget = [
      _createMyFloatButton('改变显示区域', _changeLatLngBounds),
      _createMyFloatButton('改变中心点', _changeCameraPosition),
      _createMyFloatButton('改变缩放级别到18', _changeCameraZoom),
      _createMyFloatButton('按照像素移动地图', _scrollBy),
    ];

    Widget cameraOptions() {
      return Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AMapGradView(
              childrenWidgets: optionsWidget,
            ),
          ],
        ),
      );
    }

    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height * 0.7),
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: amap,
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
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _currentZoom != null
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey,
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _currentZoom ?? "",
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : const SizedBox(),
                    Container(
                      child: cameraOptions(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void _onMapCreated(AMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  //移动视野
  void _onCameraMove(CameraPosition cameraPosition) {}

  //移动地图结束
  void _onCameraMoveEnd(CameraPosition cameraPosition) {
    setState(() {
      _currentZoom = '当前缩放级别：${cameraPosition.zoom}';
    });
  }

  void _changeCameraPosition() {
    _mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
            //中心点
            target: LatLng(31.230378, 121.473658),
            //缩放级别
            zoom: 13,
            //俯仰角0°~45°（垂直与地图时为0）
            tilt: 30,
            //偏航角 0~360° (正北方为0)
            bearing: 0),
      ),
      animated: true,
    );
  }

  //改变显示级别
  void _changeCameraZoom() {
    _mapController?.moveCamera(
      CameraUpdate.zoomTo(18),
      animated: true,
    );
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

  //改变显示区域
  void _changeLatLngBounds() {
    _mapController?.moveCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: const LatLng(33.789925, 104.838326),
              northeast: const LatLng(38.740688, 114.647472)),
          15.0),
      animated: true,
    );
  }

  //按照像素移动
  void _scrollBy() {
    _mapController?.moveCamera(
      CameraUpdate.scrollBy(50, 50),
      animated: true,
      duration: 1000,
    );
  }

  TextButton _createMyFloatButton(String label, Function onPressed) {
    return TextButton(
      onPressed: (){
        onPressed();
      },
      child: Text(label),
    );
  }
}

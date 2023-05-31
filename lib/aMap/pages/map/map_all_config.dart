import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:flutter_snippet/aMap/widgets/amap_switch_button.dart';

class AllMapConfigDemoPage extends BasePage {
  const AllMapConfigDemoPage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _MapUiBody();
  }
}

class _MapUiBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapUiBodyState();
}

class _MapUiBodyState extends State<_MapUiBody> {
  //默认显示在北京天安门
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(39.909187, 116.397451),
    zoom: 10.0,
  );

  ///地图类型
  MapType _mapType = MapType.normal;

  ///显示路况开关
  bool _trafficEnabled = false;

  /// 地图poi是否允许点击
  bool _touchPoiEnabled = false;

  ///是否显示3D建筑物
  bool _buildingsEnabled = true;

  ///是否显示底图文字标注
  bool _labelsEnabled = true;

  ///是否显示指南针
  bool _compassEnabled = false;

  ///是否显示比例尺
  bool _scaleEnabled = true;

  ///是否支持缩放手势
  bool _zoomGesturesEnabled = true;

  ///是否支持滑动手势
  bool _scrollGesturesEnabled = true;

  ///是否支持旋转手势
  bool _rotateGesturesEnabled = true;

  ///是否支持倾斜手势
  bool _tiltGesturesEnabled = true;

  AMapController? _controller;

  final CustomStyleOptions _customStyleOptions = CustomStyleOptions(false);

  ///自定义定位小蓝点
  final MyLocationStyleOptions _myLocationStyleOptions =
      MyLocationStyleOptions(false);
  @override
  void initState() {
    super.initState();
    _loadCustomData();
  }

  void _loadCustomData() async {
    ByteData styleByteData = await rootBundle.load('assets/style.data');
    _customStyleOptions.styleData = styleByteData.buffer.asUint8List();
    ByteData styleExtraByteData =
        await rootBundle.load('assets/style_extra.data');
    _customStyleOptions.styleExtraData =
        styleExtraByteData.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      apiKey: ConstConfig.amapApiKeys,
      initialCameraPosition: _kInitialPosition,
      mapType: _mapType,
      trafficEnabled: _trafficEnabled,
      buildingsEnabled: _buildingsEnabled,
      compassEnabled: _compassEnabled,
      labelsEnabled: _labelsEnabled,
      scaleEnabled: _scaleEnabled,
      touchPoiEnabled: _touchPoiEnabled,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      onMapCreated: onMapCreated,
      customStyleOptions: _customStyleOptions,
      myLocationStyleOptions: _myLocationStyleOptions,
      onLocationChanged: _onLocationChanged,
      onCameraMove: _onCameraMove,
      onCameraMoveEnd: _onCameraMoveEnd,
      onTap: _onMapTap,
      onLongPress: _onMapLongPress,
      onPoiTouched: _onMapPoiTouched,
    );

    Widget mapTypeRadio(String label, MapType radioValue) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          Radio(
            value: radioValue,
            groupValue: _mapType,
            onChanged: (value) {
              if (null != value) {
                setState(() {
                  _mapType = value;
                });
              }
            },
          ),
        ],
      );
    }

    final List<Widget> mapTypeList = [
      mapTypeRadio('普通地图', MapType.normal),
      mapTypeRadio('卫星地图', MapType.satellite),
      mapTypeRadio('导航地图', MapType.navi),
      mapTypeRadio('公交地图', MapType.bus),
      mapTypeRadio('黑夜模式', MapType.night),
    ];

    //ui控制
    final List<Widget> uiOptions = [
      AMapSwitchButton(
        label: const Text('显示路况'),
        defaultValue: _trafficEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _trafficEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: const Text('显示3D建筑物'),
        defaultValue: _buildingsEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _buildingsEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: const Text('显示指南针'),
        defaultValue: _compassEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _compassEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: const Text('显示地图文字'),
        defaultValue: _labelsEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _labelsEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: const Text('显示比例尺'),
        defaultValue: _scaleEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _scaleEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: const Text('点击Poi'),
        defaultValue: _touchPoiEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _touchPoiEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: const Text('自定义地图'),
        defaultValue: _customStyleOptions.enabled,
        onSwitchChanged: (value) => {
          setState(() {
            _customStyleOptions.enabled = value;
          })
        },
      ),
    ];

    //手势开关
    final List<Widget> gesturesOptions = [
      AMapSwitchButton(
        label: const Text('旋转'),
        defaultValue: _rotateGesturesEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _rotateGesturesEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: const Text('滑动'),
        defaultValue: _scrollGesturesEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _scrollGesturesEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: const Text('倾斜'),
        defaultValue: _tiltGesturesEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _tiltGesturesEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: const Text('缩放'),
        defaultValue: _zoomGesturesEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _zoomGesturesEnabled = value;
          })
        },
      ),
    ];

    Widget mapTypeOptions() {
      return Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('地图样式', style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: createGridView(mapTypeList),
            ),
          ],
        ),
      );
    }

    Widget myLocationStyleContainer() {
      return Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Text('定位小蓝点', style: TextStyle(fontWeight: FontWeight.w600)),
            AMapSwitchButton(
              label:
                  const Text('定位小蓝点', style: TextStyle(fontWeight: FontWeight.w600)),
              defaultValue: _myLocationStyleOptions.enabled,
              onSwitchChanged: (value) => {
                setState(() {
                  _myLocationStyleOptions.enabled = value;
                })
              },
            ),
          ],
        ),
      );
    }

    Widget uiOptionsWidget() {
      return Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('UI操作', style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: createGridView(uiOptions),
            ),
          ],
        ),
      );
    }

    Widget gesturesOptionsWidget() {
      return Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('手势控制', style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: createGridView(gesturesOptions),
            ),
          ],
        ),
      );
    }

    Widget optionsItem() {
      return Column(
        children: [
          mapTypeOptions(),
          myLocationStyleContainer(),
          uiOptionsWidget(),
          gesturesOptionsWidget(),
          TextButton(
            onPressed: _moveCameraToShoukai,
            child: const Text('moveCamera到首开'),
          ),
        ],
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: optionsItem(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onMapCreated(AMapController controller) {
    setState(() {
      _controller = controller;
      printApprovalNumber();
    });
  }

  void printApprovalNumber() async {
    var mapContentApprovalNumber =
        await _controller?.getMapContentApprovalNumber();
    var satelliteImageApprovalNumber =
        await _controller?.getSatelliteImageApprovalNumber();
    debugPrint('地图审图号（普通地图）: $mapContentApprovalNumber');
    debugPrint('地图审图号（卫星地图): $satelliteImageApprovalNumber');
  }

  Widget createGridView(List<Widget> widgets) {
    return GridView.count(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        //水平子Widget之间间距
        crossAxisSpacing: 1.0,
        //垂直子Widget之间间距
        mainAxisSpacing: 0.5,
        //一行的Widget数量
        crossAxisCount: 2,
        //宽高比
        childAspectRatio: 4,
        shrinkWrap: true,
        children: widgets);
  }

  //移动地图中心点到首开广场
  void _moveCameraToShoukai() {
    _controller?.moveCamera(CameraUpdate.newCameraPosition(const CameraPosition(
        target: LatLng(39.993306, 116.473004),
        zoom: 18,
        tilt: 30,
        bearing: 30)));
  }

  void _onLocationChanged(AMapLocation location) {
    debugPrint('_onLocationChanged ${location.toJson()}');
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    debugPrint('onCameraMove===> ${cameraPosition.toMap()}');
  }

  void _onCameraMoveEnd(CameraPosition cameraPosition) {
    debugPrint('_onCameraMoveEnd===> ${cameraPosition.toMap()}');
  }

  void _onMapTap(LatLng latLng) {
    debugPrint('_onMapTap===> ${latLng.toJson()}');
  }

  void _onMapLongPress(LatLng latLng) {
    debugPrint('_onMapLongPress===> ${latLng.toJson()}');
  }

  void _onMapPoiTouched(AMapPoi poi) {
    debugPrint('_onMapPoiTouched===> ${poi.toJson()}');
  }
}
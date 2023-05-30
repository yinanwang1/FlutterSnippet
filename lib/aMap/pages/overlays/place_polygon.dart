import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:flutter_snippet/aMap/widgets/amap_switch_button.dart';

class PolygonDemoPage extends BasePage {
  const PolygonDemoPage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return const _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Body> {
// Values when toggling Polygon color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  final Map<String, Polygon> _polygons = <String, Polygon>{};
  String? selectedPolygonId;

  void _onMapCreated(AMapController controller) {}

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    final int polygonCount = _polygons.length;
    final double offset = polygonCount * 0.01;
    points.add(_createLatLng(39.835334 + offset, 116.3710069));
    points.add(_createLatLng(39.843082 + offset, 116.3709830));
    points.add(_createLatLng(39.845932 + offset, 116.3642213));
    points.add(_createLatLng(39.845924 + offset, 116.3595219));
    points.add(_createLatLng(39.841562 + offset, 116.345568));
    points.add(_createLatLng(39.835347 + offset, 116.34575));
    return points;
  }

  void _add() {
    final Polygon polygon = Polygon(
      strokeColor: colors[++colorsIndex % colors.length],
      fillColor: colors[++colorsIndex % colors.length],
      strokeWidth: 15,
      points: _createPoints(),
    );
    setState(() {
      selectedPolygonId = polygon.id;
      _polygons[polygon.id] = polygon;
    });
  }

  void _remove() {
    final Polygon? selectedPolygon = _polygons[selectedPolygonId];
    //有选中的Marker
    if (selectedPolygon != null) {
      setState(() {
        _polygons.remove(selectedPolygonId);
      });
    } else {
      debugPrint('无选中的Polygon，无法删除');
    }
  }

  void _changeStrokeWidth() {
    final Polygon? selectedPolygon = _polygons[selectedPolygonId];
    double currentWidth = selectedPolygon?.strokeWidth ?? 0.0;
    if (currentWidth < 50) {
      currentWidth += 10;
    } else {
      currentWidth = 5;
    }
    //有选中的Marker
    var polygonId = selectedPolygonId;
    if (selectedPolygon != null && null != polygonId) {
      setState(() {
        _polygons[polygonId] =
            selectedPolygon.copyWith(strokeWidthParam: currentWidth);
      });
    } else {
      debugPrint('无选中的Polygon，无法修改宽度');
    }
  }

  void _changeColors() {
    final Polygon? polygon = _polygons[selectedPolygonId];
    var polygonId = selectedPolygonId;
    if (polygon != null && null != polygonId) {
      setState(() {
        _polygons[polygonId] = polygon.copyWith(
          strokeColorParam: colors[++colorsIndex % colors.length],
          fillColorParam: colors[(colorsIndex + 1) % colors.length],
        );
      });
    }
  }

  Future<void> _toggleVisible(value) async {
    final Polygon? polygon = _polygons[selectedPolygonId];
    var polygonId = selectedPolygonId;
    if (polygon != null && null != polygonId) {
      setState(() {
        _polygons[polygonId] = polygon.copyWith(
          visibleParam: value,
        );
      });
    }
  }

  void _changePoints() {
    final Polygon? polygon = _polygons[selectedPolygonId];
    if (null != polygon) {
      List<LatLng> currentPoints = polygon.points;
      List<LatLng> newPoints = <LatLng>[];
      newPoints.addAll(currentPoints);
      newPoints.add(const LatLng(39.828809, 116.360364));

      var polygonId = selectedPolygonId;
      if (null != polygonId) {
        setState(() {
          _polygons[polygonId] = polygon.copyWith(
            pointsParam: newPoints,
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      initialCameraPosition:
          const CameraPosition(target: LatLng(39.828809, 116.360364), zoom: 13),
      onMapCreated: _onMapCreated,
      polygons: Set<Polygon>.of(_polygons.values),
    );
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          TextButton(
                            onPressed: _add,
                            child: const Text('添加'),
                          ),
                          TextButton(
                            onPressed:
                                (selectedPolygonId == null) ? null : _remove,
                            child: const Text('删除'),
                          ),
                          TextButton(
                            onPressed: (selectedPolygonId == null)
                                ? null
                                : _changeStrokeWidth,
                            child: const Text('修改边框宽度'),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          TextButton(
                            onPressed: (selectedPolygonId == null)
                                ? null
                                : _changeColors,
                            child: const Text('修改边框和填充色'),
                          ),
                          AMapSwitchButton(
                            label: const Text('显示'),
                            onSwitchChanged: (selectedPolygonId == null)
                                ? null
                                : _toggleVisible,
                            defaultValue: true,
                          ),
                          TextButton(
                            onPressed: (selectedPolygonId == null)
                                ? null
                                : _changePoints,
                            child: const Text('修改坐标'),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:flutter_snippet/aMap/widgets/amap_switch_button.dart';

class PolylineDemoPage extends BasePage {
  PolylineDemoPage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Body> {
// Values when toggling polyline color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];
  Map<String, Polyline> _polylines = <String, Polyline>{};
  String? selectedPolylineId;

  void _onMapCreated(AMapController controller) {}

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    final int polylineCount = _polylines.length;
    final double offset = polylineCount * -(0.01);
    points.add(LatLng(39.938698 + offset, 116.275177));
    points.add(LatLng(39.966069 + offset, 116.289253));
    points.add(LatLng(39.944226 + offset, 116.306076));
    points.add(LatLng(39.966069 + offset, 116.322899));
    points.add(LatLng(39.938698 + offset, 116.336975));
    return points;
  }

  void _add() {
    final Polyline polyline = Polyline(
        color: colors[++colorsIndex % colors.length],
        width: 10,
        points: _createPoints(),
        onTap: _onPolylineTapped);
    setState(() {
      _polylines[polyline.id] = polyline;
    });
  }

  void _remove() {
    final Polyline? selectedPolyline = _polylines[selectedPolylineId];
    //有选中的Marker
    if (selectedPolyline != null) {
      setState(() {
        _polylines.remove(selectedPolylineId);
      });
    } else {
      print('无选中的Polyline，无法删除');
    }
  }

  void _changeWidth() {
    final Polyline? selectedPolyline = _polylines[selectedPolylineId];
    double currentWidth = selectedPolyline?.width ?? 0.0;
    if (currentWidth < 50) {
      currentWidth += 10;
    } else {
      currentWidth = 5;
    }
    //有选中的Marker
    var polylineId = selectedPolylineId;
    if (selectedPolyline != null && null != polylineId) {
      setState(() {
        _polylines[polylineId] =
            selectedPolyline.copyWith(widthParam: currentWidth);
      });
    } else {
      print('无选中的Polyline，无法修改宽度');
    }
  }

  void _onPolylineTapped(String polylineId) {
    print('Polyline: $polylineId 被点击了');
    setState(() {
      selectedPolylineId = polylineId;
    });
  }

  Future<void> _changeDashLineType() async {
    final Polyline? polyline = _polylines[selectedPolylineId];
    if (polyline == null) {
      return;
    }
    DashLineType currentType = polyline.dashLineType;
    if (currentType.index < DashLineType.circle.index) {
      currentType = DashLineType.values[currentType.index + 1];
    } else {
      currentType = DashLineType.none;
    }

    var polylineId = selectedPolylineId;
    if (null != polylineId) {
      setState(() {
        _polylines[polylineId] =
            polyline.copyWith(dashLineTypeParam: currentType);
      });
    }
  }

  void _changeCapType() {
    final Polyline? polyline = _polylines[selectedPolylineId];
    if (polyline == null) {
      return;
    }
    CapType capType = polyline.capType;
    if (capType.index < CapType.round.index) {
      capType = CapType.values[capType.index + 1];
    } else {
      capType = CapType.butt;
    }
    var polylineId = selectedPolylineId;
    if (null != polylineId) {
      setState(() {
        _polylines[polylineId] = polyline.copyWith(capTypeParam: capType);
      });
    }
  }

  void _changeJointType() {
    final Polyline? polyline = _polylines[selectedPolylineId];
    if (polyline == null) {
      return;
    }
    JoinType joinType = polyline.joinType;
    if (joinType.index < JoinType.round.index) {
      joinType = JoinType.values[joinType.index + 1];
    } else {
      joinType = JoinType.bevel;
    }
    var polylineId = selectedPolylineId;
    if (null != polylineId) {
      setState(() {
        _polylines[polylineId] =
            polyline.copyWith(joinTypeParam: joinType);
      });
    }
  }

  Future<void> _changeAlpha() async {
    final Polyline? polyline = _polylines[selectedPolylineId];
    if (null != polyline) {
      final double current = polyline.alpha;
      var polylineId = selectedPolylineId;
      if (null != polylineId) {
        setState(() {
          _polylines[polylineId] = polyline.copyWith(
            alphaParam: current < 0.1 ? 1.0 : current * 0.75,
          );
        });
      }
    }
  }

  Future<void> _toggleVisible(value) async {
    final Polyline? polyline = _polylines[selectedPolylineId];
    var polylineId = selectedPolylineId;
    if (null != polylineId && null != polyline) {
      setState(() {
        _polylines[polylineId] = polyline.copyWith(
          visibleParam: value,
        );
      });
    }
  }

  void _changeColor() {
    final Polyline? polyline = _polylines[selectedPolylineId];
    var polylineId = selectedPolylineId;
    if (null != polyline && null != polylineId) {
      setState(() {
        _polylines[polylineId] = polyline.copyWith(
          colorParam: colors[++colorsIndex % colors.length],
        );
      });
    }
  }

  void _changePoints() {
    final Polyline? polyline = _polylines[selectedPolylineId];
    if (null != polyline) {
      List<LatLng> currentPoints = polyline.points;
      List<LatLng> newPoints = <LatLng>[];
      newPoints.addAll(currentPoints);
      newPoints.add(LatLng(39.835347, 116.34575));

      var polylineId = selectedPolylineId;
      if (null != polylineId) {
        setState(() {
          _polylines[polylineId] = polyline.copyWith(
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
      onMapCreated: _onMapCreated,
      polylines: Set<Polyline>.of(_polylines.values),
    );
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
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
                            child: const Text('添加'),
                            onPressed: _add,
                          ),
                          TextButton(
                            child: const Text('删除'),
                            onPressed:
                                (selectedPolylineId == null) ? null : _remove,
                          ),
                          TextButton(
                            child: const Text('修改线宽'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeWidth,
                          ),
                          TextButton(
                            child: const Text('修改透明度'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeAlpha,
                          ),
                          AMapSwitchButton(
                            label: Text('显示'),
                            onSwitchChanged: (selectedPolylineId == null)
                                ? null
                                : _toggleVisible,
                            defaultValue: true,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          TextButton(
                            child: const Text('修改颜色'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeColor,
                          ),
                          TextButton(
                            child: const Text('修改线头样式'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeCapType,
                          ),
                          TextButton(
                            child: const Text('修改连接样式'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeJointType,
                          ),
                          TextButton(
                            child: const Text('修改虚线类型'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeDashLineType,
                          ),
                          TextButton(
                            child: const Text('修改坐标'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changePoints,
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

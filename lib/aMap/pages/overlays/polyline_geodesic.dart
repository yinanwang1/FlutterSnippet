import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';

class PolylineGeodesicDemoPage extends BasePage {
  const PolylineGeodesicDemoPage(super.title, super.subTitle, {super.key});

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
// Values when toggling polyline color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];
  final Map<String, Polyline> _polyLines = <String, Polyline>{};
  String? selectedPolylineId;
  AMapController? _controller;

  void _onMapCreated(AMapController controller) {
    _controller = controller;
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    final int polylineCount = _polyLines.length;
    final int offset = polylineCount * (-1);
    points.add(LatLng(39.905151 + offset, 116.401726));
    points.add(LatLng(38.905151 + offset, 70.401726));
    return points;
  }

  void _add() {
    final Polyline polyline =
        Polyline(color: colors[++colorsIndex % colors.length], width: 10, geodesic: true, points: _createPoints());

    setState(() {
      _polyLines[polyline.id] = polyline;
    });
    //移动到合适的范围
    LatLngBounds bound = LatLngBounds(southwest: const LatLng(25.0, 70.0), northeast: const LatLng(45, 117));
    CameraUpdate update = CameraUpdate.newLatLngBounds(bound, 10);
    _controller?.moveCamera(update);
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
      polylines: Set<Polyline>.of(_polyLines.values),
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
            child: map,
          ),
          Expanded(
              flex: 1,
              child: TextButton(
                onPressed: _add,
                child: const Text('添加大地曲线'),
              )),
        ],
      ),
    );
  }
}

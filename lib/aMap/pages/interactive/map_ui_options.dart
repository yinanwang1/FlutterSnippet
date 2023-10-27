import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:flutter_snippet/aMap/widgets/amap_gridview.dart';
import 'package:flutter_snippet/aMap/widgets/amap_switch_button.dart';

class MapUIDemoPage extends BasePage {
  const MapUIDemoPage(super.title, super.subTitle, {super.key});

  @override
  Widget build(BuildContext context) => const _Body();
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  ///显示路况开关
  bool _trafficEnabled = false;

  ///是否显示3D建筑物
  bool _buildingsEnabled = true;

  ///是否显示底图文字标注
  bool _labelsEnabled = true;

  ///是否显示指南针
  bool _compassEnabled = false;

  ///是否显示比例尺
  bool _scaleEnabled = true;

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      trafficEnabled: _trafficEnabled,
      buildingsEnabled: _buildingsEnabled,
      compassEnabled: _compassEnabled,
      labelsEnabled: _labelsEnabled,
      scaleEnabled: _scaleEnabled,
    );

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
    ];

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
              child: AMapGradView(childrenWidgets: uiOptions),
            ),
          ],
        ),
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
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: uiOptionsWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:flutter_snippet/aMap/widgets/amap_gridview.dart';
import 'package:flutter_snippet/aMap/widgets/amap_switch_button.dart';

class GesturesDemoPage extends BasePage {
  const GesturesDemoPage(super.title, super.subTitle, {super.key});
  @override
  Widget build(BuildContext context) => const _Body();
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  ///是否支持缩放手势
  bool _zoomGesturesEnabled = true;

  ///是否支持滑动手势
  bool _scrollGesturesEnabled = true;

  ///是否支持旋转手势
  bool _rotateGesturesEnabled = true;

  ///是否支持倾斜手势
  bool _tiltGesturesEnabled = true;

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
    );

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
              child: AMapGradView(childrenWidgets: gesturesOptions),
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
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: gesturesOptionsWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

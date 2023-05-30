import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:flutter_snippet/aMap/widgets/amap_radio_group.dart';

class ChangeMapTypePage extends BasePage {
  ChangeMapTypePage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => _PageBody();
}

class _PageBody extends StatefulWidget {
  _PageBody({Key? key}) : super(key: key);

  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<_PageBody> {
  //地图类型
  late MapType _mapType;
  final Map<String, MapType> _radioValueMap = {
    '普通地图': MapType.normal,
    '卫星地图': MapType.satellite,
    '导航地图': MapType.navi,
    '公交地图': MapType.bus,
    '黑夜模式': MapType.night,
  };
  @override
  void initState() {
    super.initState();
    _mapType = MapType.normal;
  }

  @override
  Widget build(BuildContext context) {
    //创建地图
    final AMapWidget map = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      apiKey: ConstConfig.amapApiKeys,
      //地图类型属性
      mapType: _mapType,
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
              child: Container(
                child: AMapRadioGroup(
                  groupLabel: '地图样式',
                  groupValue: _mapType,
                  radioValueMap: _radioValueMap,
                  onChanged: (value) => {
                    //改变当前地图样式为选中的样式
                    setState(() {
                      _mapType = value;
                    })
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

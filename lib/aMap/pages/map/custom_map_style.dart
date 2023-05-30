import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:flutter_snippet/aMap/widgets/amap_switch_button.dart';

class CustomMapStylePage extends BasePage {
  const CustomMapStylePage(String title, String subTitle, {super.key}) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => const _CustomMapStyleBody();
}

class _CustomMapStyleBody extends StatefulWidget {
  const _CustomMapStyleBody({Key? key}) : super(key: key);

  @override
  _CustomMapStyleState createState() => _CustomMapStyleState();
}

class _CustomMapStyleState extends State<_CustomMapStyleBody> {
  bool _mapCreated = false;

  CustomStyleOptions _customStyleOptions = CustomStyleOptions(false);

  //加载自定义地图样式
  void _loadCustomData() async {
    _customStyleOptions = CustomStyleOptions(false);
    ByteData styleByteData = await rootBundle.load('assets/style.data');
    _customStyleOptions.styleData = styleByteData.buffer.asUint8List();
    ByteData styleExtraByteData = await rootBundle.load('assets/style_extra.data');
    _customStyleOptions.styleExtraData = styleExtraByteData.buffer.asUint8List();
    //如果需要加载完成后直接展示自定义地图，可以通过setState修改CustomStyleOptions的enable为true
    // setState(() {
    //   _customStyleOptions.enabled = true;
    // });
  }

  @override
  void initState() {
    super.initState();
    _loadCustomData();
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      apiKey: ConstConfig.amapApiKeys,
      onMapCreated: onMapCreated,
      customStyleOptions: _customStyleOptions,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Positioned(
            top: 30,
            child: Container(
              color: const Color(0xFF00BFFF),
              child: AMapSwitchButton(
                label: const Text(
                  '自定义地图',
                  style: TextStyle(color: Colors.white),
                ),
                defaultValue: _customStyleOptions.enabled,
                onSwitchChanged: (value) => {
                  if (_mapCreated)
                    {
                      setState(() {
                        _customStyleOptions.enabled = value;
                      })
                    }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void onMapCreated(AMapController controller) {
    _mapCreated = true;
  }
}

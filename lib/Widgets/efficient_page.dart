import 'package:flutter/material.dart';

/// 高效的pageView
/// 通过局部更新的方式，来降低全局刷新
/// @author 阿南
/// @since 2021/11/23 20:15
///
///
class EfficientPage extends StatefulWidget {
  const EfficientPage({Key? key}) : super(key: key);

  @override
  _EfficientPageState createState() => _EfficientPageState();
}

class _EfficientPageState extends State<EfficientPage> {
  // 进度监听对象
  final ValueNotifier<double> factor = ValueNotifier<double>(1 / 5);

  // 页数监听对象
  final ValueNotifier<int> page = ValueNotifier<int>(1);

  // 页面滚动控制器
  late PageController _ctrl;
  final List<Widget> colorsWidget =
      [Colors.red, Colors.yellow, Colors.blue, Colors.green, Colors.orange]
          .map((e) => Container(
                decoration:
                    BoxDecoration(color: e, borderRadius: const BorderRadius.all(Radius.circular(20))),
              ))
          .toList();

  Color get startColor => Colors.red;

  Color get endColor => Colors.blue;

  // 圆角装饰
  BoxDecoration get boxDecoration => const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40), topRight: Radius.circular(40)));

  @override
  void initState() {
    super.initState();

    _ctrl = PageController(viewportFraction: 0.8)
      ..addListener(() {
        double value = (_ctrl.page! + 1) % 5 / 5;
        factor.value = value == 0 ? 1 : value;
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    page.dispose();
    factor.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: factor,
      builder: (_, double value, child) {
        return Container(
          color: Color.lerp(startColor, endColor, value),
          child: child,
        );
      },
      child: Column(
        children: <Widget>[
          _buildTitle(context),
          Expanded(
            child: Container(
              child: _buildContent(),
              margin: const EdgeInsets.only(left: 8, right: 8),
              decoration: boxDecoration,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() => Container(
        margin: const EdgeInsets.only(bottom: 12, left: 48, right: 48, top: 10),
        height: 2,
        child: ValueListenableBuilder(
          valueListenable: factor,
          builder: (context, value, child) {
            return LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                  Color.lerp(startColor, endColor, factor.value)),
              value: factor.value,
            );
          },
        ),
      );

  Widget _buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.api,
            color: Colors.white,
            size: 45,
          ),
          const SizedBox(
            width: 20,
          ),
          ValueListenableBuilder(
              valueListenable: page, builder: _buildWithPageChange)
        ],
      ),
    );
  }

  Widget _buildWithPageChange(BuildContext context, int value, Widget? child) {
    return Text(
      "绘制集录 $value/5",
      style: const TextStyle(fontSize: 30, color: Colors.white),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.only(bottom: 80, top: 40),
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              itemBuilder: (_, index) {
                return AnimatedBuilder(
                  animation: _ctrl,
                  builder: (context, child) =>
                      _buildAnimOfItem(context, child, index),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: colorsWidget[index],
                  ),
                );
              },
              onPageChanged: (index) => page.value = index + 1,
              controller: _ctrl,
              itemCount: colorsWidget.length,
            ),
          ),
          _buildProgress(),
        ],
      ),
    );
  }

  Widget _buildAnimOfItem(BuildContext context, Widget? child, int index) {
    double value;

    if (_ctrl.position.haveDimensions) {
      value = _ctrl.page! - index;
    } else {
      value = index.toDouble();
    }

    debugPrint("111 value is $value");

    value = (1 - ((value.abs()) * 0.5)).clamp(0, 1).toDouble();
    debugPrint("222 value is $value");
    value = Curves.easeOut.transform(value);
    debugPrint("333 value is $value");
    return Transform(
      transform: Matrix4.diagonal3Values(1.0, value, 1.0),
      alignment: Alignment.center,
      child: child,
    );
  }
}

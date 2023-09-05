import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';

void main() {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {})));
  // runApp(const ProviderScope(child: MyHomePage()));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的新世界"),
      ),
      body: Center(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.cyan, fontSize: 10),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "data",
                    style: TextStyle(),
                  )),
              _showAlertView(),
              const Test(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showAlertView() {
    return Container();
  }
}

// 使用CustomMultiChildLayout自定义页面
class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: CustomMultiChildLayout(delegate: MyDelegate(), children: [
        LayoutId(id: 1, child: const FlutterLogo(size: 100)),
        LayoutId(id: 2, child: const FlutterLogo(size: 100)),
      ]),
    );
  }
}

class MyDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    var size1 = layoutChild(1, const BoxConstraints(minHeight: 10, minWidth: 10, maxHeight: 100, maxWidth: 100));
    positionChild(1, const Offset(0, 0));
    var size2 = layoutChild(2, const BoxConstraints(minHeight: 10, minWidth: 10, maxHeight: 50, maxWidth: 50));
    positionChild(2, Offset(size1.width, size1.height));
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

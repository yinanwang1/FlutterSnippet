import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/DesignMode/adapter.dart';
import 'package:flutter_snippet/DesignMode/state.dart';

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: () {
              // Target target = Adapter();
              // target.request();


              Player b = Forwards("巴蒂尔");
              b.attack();

              Player m = Guards("麦克格雷迪");
              m.attack();

              Player ym = Translator("姚明");
              ym.attack();
              ym.defense();

              }, child: const Text("测试下"))
          ],
        ),
      ),
    );
  }
}

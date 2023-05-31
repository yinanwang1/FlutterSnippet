import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/DesignMode/state.dart';
import 'package:flutter_snippet/aMap/AMapDemo.dart';

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
              Work work = Work();

              work.hour = 1;
              work.writeProgram();

              work.hour = 10;
              work.writeProgram();

              work.hour = 19;
              work.writeProgram();

              work.hour = 21;
              work.writeProgram();

              work.hour = 3;
              work.writeProgram();


              }, child: const Text("测试下"))
          ],
        ),
      ),
    );
  }
}

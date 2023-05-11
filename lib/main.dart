import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/DesignMode/lei_feng.dart';
import 'package:flutter_snippet/DesignMode/person.dart';
import 'package:flutter_snippet/DesignMode/proxy.dart';

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
            const Text("试试看"),
            TextButton(
                onPressed: () {
                  IFactory factory = UndergraduateFactory();
                  LeiFeng studentA = factory.createLeiFeng();
                  studentA.buyRice();
                  LeiFeng studentB = factory.createLeiFeng();
                  studentB.sweep();
                  LeiFeng studentC = factory.createLeiFeng();
                  studentC.wash();
                },
                child: const Text("点我执行")),
          ],
        ),
      ),
    );
  }
}


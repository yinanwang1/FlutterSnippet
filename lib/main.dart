import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Common/paging_list.dart';

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
  final streamController = StreamController(
    onPause: () => debugPrint("Paused"),
    onResume: () => debugPrint("Resumed"),
    onCancel: () => debugPrint("Cancelled"),
    onListen: () => debugPrint("Listens"),
  );
  final stream = Stream<int>.periodic(const Duration(milliseconds: 200), (count) => count * count).take(4);

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
                  debugPrint("wyn streamController.stream is ${streamController.stream.hashCode}");

                  streamController.stream.listen((event) {
                    debugPrint("Event: $event");
                  }, onDone: () => debugPrint("Done"), onError: (error) => debugPrint("error is $error"));
                  //
                  // streamController.stream.listen((event) {
                  //   debugPrint("2Event: $event");
                  // }, onDone: () => debugPrint("2Done"), onError: (error) => debugPrint("2error is $error"));
                },
                child: const Text("监听起来")),
            const Padding(padding: EdgeInsets.only(top: 10)),
            TextButton(
                onPressed: () {
                  // _addStreamTest();
                  // streamController.add(9);
                  streamController.addStream(Stream.value(100));

                  debugPrint("wyn 222 streamController.stream is ${streamController.stream.hashCode}");

                  var (a, b) = _testRecords();
                  debugPrint("a is $a, b is $b");


                },
                child: const Text("点我执行")),
            const Padding(padding: EdgeInsets.only(top: 10)),
            TextButton(
                onPressed: () {
                  streamController.close();
                },
                child: const Text("取消监听")),
          ],
        ),
      ),
    );
  }

  void _addStreamTest() async {
    // streamController.addStream(stream);

    streamController.addStream(Stream.error(Exception("Issue 101")));
  }

  (int, int) _testRecords() {
    return (5, 6);
  }


}

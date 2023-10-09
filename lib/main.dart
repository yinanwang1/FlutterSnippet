import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';

void main() async {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {})));
  // runApp(const ProviderScope(child: MyHomePage()));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with SingleTickerProviderStateMixin {
  bool _test = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("_MyHomePageState build");

    return Scaffold(
      appBar: AppBar(
        title: const Text("美丽新世界"),
      ),
      body: Column(
        children: [
          TestWidget(_test ? "1" : "2"),
          ElevatedButton(
              onPressed: () {
                debugPrint("wyn aaaaaa");
              },
              child: const Text("点带你我试试"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _test = !_test;
          });
        },
      ),
    );
  }
}

class TestWidget extends StatefulWidget {
  final String index;

  const TestWidget(this.index, {Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint("_TestWidgetState build! ${widget.index}");

    return Center(
      child: Column(
        children: [
          Text("娃哈哈 ${widget.index}"),
          TextButton(
              onPressed: () {
                debugPrint("wyn 111");
                setState(() {});
              },
              child: const Text("点我开始通知")),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    debugPrint("didChangeDependencies");

    super.didChangeDependencies();
  }
}

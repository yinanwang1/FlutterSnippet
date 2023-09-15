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
  ValueNotifier valueNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    valueNotifier.addListener(() {
      debugPrint("wyn valueNotifier.value is ${valueNotifier.value}");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的新世界"),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (BuildContext context, value, Widget? child) {
            return Text("value is $value");
          },
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            // valueNotifier.value++;
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => TestWidget(valueNotifier)));
          },
          icon: const Icon(Icons.add)),
    );
  }
}


class TestWidget extends StatefulWidget {

  final ValueNotifier valueNotifier;

  const TestWidget(this.valueNotifier, {super.key});

  @override
  State<StatefulWidget> createState() => _TestWidgetState();

}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(onPressed: (){
              widget.valueNotifier.value++;
            }, child: const Text("好吧")),
          ],
        ),
      ),
    );
  }

}

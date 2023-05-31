import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/DesignMode/memento.dart';

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
              Originator o = Originator("On");
              o.show();

              Caretaker c = Caretaker(o.createMemento());

              o.state = "Off";
              o.show();

              o.setMemento(c.memento);
              o.show();

              }, child: const Text("测试下"))
          ],
        ),
      ),
    );
  }
}

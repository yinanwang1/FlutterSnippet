import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/DesignMode/person.dart';
import 'package:flutter_snippet/Widgets/flutter_text.dart';

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
                  Person xc = Person(name: "小菜");
                  Sneakers pqx = Sneakers();
                  BigTrouser kk = BigTrouser();
                  TShirts dtx = TShirts();

                  pqx.decorate(xc);
                  kk.decorate(pqx);
                  dtx.decorate(kk);
                  dtx.show();
                },
                child: const Text("点我执行")),
          ],
        ),
      ),
    );
  }
}


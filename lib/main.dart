import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';

void main() {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {})));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with SingleTickerProviderStateMixin {
  get builder => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("突飞猛进"),
      ),
      body: const SafeArea(
        maintainBottomViewPadding: false,
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    var foo = List.from(<int>[1, 2, 3]); // okay until runtime.
    // List<String> bar = List.of(<int>[1, 2, 3]); // analysis error
    debugPrint("wyn foo is $foo, ${foo[0].runtimeType}");

    return CustomScrollView(
      slivers: [
        SliverAnimatedOpacity(
          //动画执行完毕
          onEnd: () => print("动画完成"),
          curve: Curves.linear,
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(seconds: 2),
          sliver: SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return Image.network(
                    "https://p3-passport.byteimg.com/img/user-avatar/af5f7ee5f0c449f25fc0b32c050bf100~180x180.awebp");
              }, childCount: 1),
              itemExtent: 200.0),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 18),
          sliver: SliverToBoxAdapter(
              child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _visible = !_visible;
              });
            },
            tooltip: 'Toggle opacity',
            child: const Icon(Icons.flip),
          )),
        ),
      ],
    );
  }
}


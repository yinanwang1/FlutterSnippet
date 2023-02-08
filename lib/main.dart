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
    debugPrint("wyn MediaQuery.of(context).size.height is ${MediaQuery.of(context).size.height}");

    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text("突飞猛进"),
      // ),
      body: Center(
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final imageSrc =
      'https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/19524295f8a34d7d83dd3a4ea4643774~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/number.png",
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            Image.asset(
              "images/number.png",
              centerSlice: const Rect.fromLTRB(100, 100, 200, 200),
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    ));
  }
}

class Solution {
  int differenceOfSum(List<int> nums) {
    var x = nums.reduce((value, element) => value + element);
    var y = nums.fold<int>(0, (previousValue, element) {
      var sum = element.toString().split("").fold<int>(0, (previousValue, element) => previousValue + (int.tryParse(element) ?? 0));

      return previousValue + sum;
    });

    return (x - y).abs();
  }
}

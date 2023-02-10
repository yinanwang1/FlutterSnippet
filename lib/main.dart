import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/learnAnnotation.g.dart';

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
      body: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    var test = Wang();

    var random = Random();
    return CustomScrollView(
      // physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          actions: <Widget>[IconButton(onPressed: () => {}, icon: const Icon(Icons.add))],
          expandedHeight: 200,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              "First FlexibleSpace",
              style: TextStyle(color: Colors.blue),
            ),
            background: Image.network(
                "https://p3-passport.byteimg.com/img/user-avatar/af5f7ee5f0c449f25fc0b32c050bf100~180x180.awebp",
                fit: BoxFit.cover),
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle
            ],
          ),
        ),
        SliverGrid.extent(
          maxCrossAxisExtent: 150.0,
          children: List.generate(
              100,
              (index) => Container(
                    color: MyColors.randomColor(),
                    margin: EdgeInsets.all(random.nextInt(30).toDouble()),
                    child: const Text("测试下"),
                  )),
        ),
      ],
    );
  }
}

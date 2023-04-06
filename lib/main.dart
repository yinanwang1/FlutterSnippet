import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/Widgets/tearing_text.dart';
import 'package:polygon/polygon.dart';

void main() {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyApp()), {})));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
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

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      color: Colors.black,
      child: const TearingText("美丽蝴蝶"),
    ));
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Widgets/cashier_system.dart';

final themeProvider = StreamProvider<ThemeData>((ref) {
  var interval = const Duration(seconds: 2);
  return Stream<ThemeData>.periodic(interval, (count) => count % 2 == 0 ? ThemeData.light() : ThemeData.dark());
});

void main() {
  // runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {})));
  runApp(const ProviderScope(child: MyHomePage()));
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("收银系统")),
        body: const SafeArea(
          child: MyApp(),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.background,
      padding: const EdgeInsets.all(15),
      child: const CashierSystem(),
    );
  }
}

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';

import 'generated/l10n.dart';

void main() {
  // runApp(const ProviderScope(child: MyApp()));
  runApp(createMaterialApp(
      (settings) => MaterialPageRoute(builder: (context) {
            // return const Books();
            return MyHomePage(
              title: S.of(context).title,
            );
          }),
      {}));
}

class MyHomePage extends ConsumerStatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Hello world!",
                style: TextStyle(
                    fontSize: 34,
                    fontFamily: "myFont",
                    fontFeatures: [ui.FontFeature.alternativeFractions(), ui.FontFeature.denominator()]),
                strutStyle: StrutStyle(
                    // height: 6,
                    height: 3,
                    // leading: 1,
                    leadingDistribution: TextLeadingDistribution.even),
              ),
              Text(
                "data",
                style: TextStyle(
                    fontSize: 48,
                    fontFamily: 'RobotoSlab',
                    fontVariations: <ui.FontVariation>[ui.FontVariation('wght', 900.0), ui.FontVariation('wdth', 900.0)]),
              )
            ],
          ),
        ));
  }
}

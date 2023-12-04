import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/Widgets/water_mark.dart';

import 'generated/l10n.dart';

void main() {
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
  void initState() {
    Future.delayed(const Duration(milliseconds: 50), () {
      WaterMarkInstance().addWatermark(context, "稍微长一点把");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.flip(
                flipX: true,
                // flipY: true,
                child: const Text('Horizontal Flip'),
              ),
              Center(
                heightFactor: 2.0,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue.shade50,
                  child: const FractionalTranslation(
                    // translation: Offset(0.5, .5),
                    translation: Offset(.3, .1),
                    child: Text(
                      "FittedBox",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 250,
                color: Colors.blue.shade50,
                child: const LimitedBox(
                  child: Card(child: Text('Hello World! ')),
                ),
              )
            ],
          ),
        ));
  }
}

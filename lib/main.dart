import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/generated/assets.dart';

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
  Widget build(BuildContext context) {
    final String content = ' Hello World! ' * 1;

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
               Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  const FlutterLogo(),
                  const Expanded(
                    child: Text(
                        "Flutter's hot reload helps you quickly and easily experiment, build UIs, add features, and fix bug faster. Experience sub-second reload times, without losing state, on emulators, simulators, and hardware for iOS and Android."),
                  ),
                  Image.asset(Assets.imagesIcAppealDone),
                ],
              )
            ],
          ),
        ));
  }
}

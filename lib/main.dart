import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';

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
              SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 250,
                      color: Colors.white,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[Colors.black.withAlpha(0), Colors.black12, Colors.black45],
                        ),
                      ),
                      child: const Text(
                        'Foreground Text',
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

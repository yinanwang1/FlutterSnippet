import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyColors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      // 国际化配置 __START__
      localeListResolutionCallback:
          (List<Locale>? locals, Iterable<Locale>? supportedLocales) {
        return const Locale('zh');
      },
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale>? supportedLocales) {
        return const Locale("zh");
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('zh', 'CH'),
        Locale('en', 'US'),
      ],
      // 国际化配置 __END__
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamController streamController;

  @override
  void initState() {
    super.initState();

    streamController = StreamController<String>();
    streamController.add("0 init");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("我就是我"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text("试试看"),
            TextButton(
                onPressed: onPress,
                child: const Text(
                  "Push",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                )),
            StreamBuilder(
              builder: (context, snapshot) {
                return Text("Result: ${snapshot.data}");
              },
              stream: streamController.stream,
            ),
          ],
        ));
  }

  void onPress() async {
    debugPrint("wyn 111");

    streamController.add(DateTime.now().toIso8601String());

    _createStream().forEach((element) {
      debugPrint("event is $element");
      debugPrint("event is ${element.runtimeType}");
    });

    // await for (var event in _createStream()) {
    //   debugPrint("event is $event");
    //   debugPrint("event is ${event.runtimeType}");
    // }

    debugPrint("wyn 222");
  }

  Stream<String> _createStream() async* {
    for (int i = 0; i < 10; i++) {
      yield "$i";
    }
  }
}

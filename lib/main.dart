import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:images_picker/images_picker.dart';

import 'Widgets/loading.dart';

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

int maxValue = 100;
int minValue = 1;

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> languageList = <String>['Java', 'Dart', 'Kotlin'];
    Map<String, int> markMap = <String,int>{'Java':100, 'Dart':80, 'Kotlin':60};
    Set<String> languageSet = <String>{'Java', 'Dart','Kotlin'}; // 集合




    return Scaffold(
      appBar: AppBar(
        title: const Text("美丽新世界"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () async {
                  testSX();
                },
                child: const Text(
                  "点我试试",
                  style: TextStyle(color: Colors.black),
                )),
            ElevatedButton(
                onPressed: testSX,
                child: const Text(
                  "你要不试试",
                  style: TextStyle(color: Colors.black),
                )),
            OutlinedButton(
                onPressed: () {
                  testSX();
                },
                child: const Text(
                  "试试就试试",
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }

  void testSX() async {
    List<Media>? res =  await ImagesPicker.pick(
      count: 3,
      gif: false,
    );

    debugPrint("wyn res is $res");


  }
}


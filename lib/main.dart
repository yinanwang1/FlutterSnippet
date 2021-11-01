import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

import 'Widgets/math_runner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyColors.white,
        platform: TargetPlatform.iOS,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: '哇哈哈'),
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
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const CircleAvatar(
            backgroundImage: AssetImage("images/namei.png"),
          ),
          MathRunner(
            f: (t) => cos(t * pi),
            g: (t) => 0.6 * sin(t * pi),
            reverse: false,
            parts: 4,
            index: 0,
            child: const CircleAvatar(
              backgroundImage: AssetImage("images/namei.png"),
            ),
          ),
          MathRunner(
            f: (t) => cos(t * pi),
            g: (t) => 0.6 * sin(t * pi),
            reverse: false,
            parts: 4,
            index: 1,
            child: const CircleAvatar(
              backgroundImage: AssetImage("images/namei.png"),
            ),
          ),
          MathRunner(
            f: (t) => cos(t * pi),
            g: (t) => 0.6 * sin(t * pi),
            reverse: false,
            parts: 4,
            index: 2,
            child: const CircleAvatar(
              backgroundImage: AssetImage("images/namei.png"),
            ),
          ),
          MathRunner(
            f: (t) => cos(t * pi),
            g: (t) => 0.6 * sin(t * pi),
            reverse: false,
            parts: 4,
            index: 3,
            child: const CircleAvatar(
              backgroundImage: AssetImage("images/namei.png"),
            ),
          ),
        ],
      )
    );
  }
}

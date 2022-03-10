import 'dart:math';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Widgets/clock.dart';

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
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: "玩哈哈"),
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("花花世界"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
      ),
      body: const Center(child: Test()),
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() {
    return _TestState();
  }
}

class _TestState extends State<Test>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Animation<double> animation;
  late AnimationController controller;

  int badgeNumber = 0;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward(from: 0);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: animation.value,
            width: animation.value,
            child: const FlutterLogo(),
          ),
          const Clock(),
          Container(
            color: Colors.green,
            child: CustomPaint(
              painter: TestArc(),
              size: const Size(100, 100),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TestArc extends CustomPainter {
  Paint paintT = Paint()..color = Colors.red;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    RRect oval = RRect.fromLTRBR(10, 10, 90, 90, const Radius.circular(10));
    path.addRRect(oval);

    canvas.drawPath(path, paintT);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

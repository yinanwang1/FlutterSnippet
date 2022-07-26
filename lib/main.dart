import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

import 'Widgets/points_curve.dart';

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const int durationMilliseconds = 3000;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: durationMilliseconds));
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCirc))
      ..addListener(() {
        setState(() {
          debugPrint("wyn 222");
        });
      })..addStatusListener((status) {
        if (AnimationStatus.completed == status) {
          _controller.reset();
        }
      });

    create();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("pointsList is $pointsList");

    return Scaffold(
      appBar: AppBar(
        title: const Text("我就是我"),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "images/darkSky.jpeg",
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            color: backgroundColor(_animation.value),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SizedBox(
            height: 500,
            child: PointsCurve(
              pointsList,
              showStraight: false,
              showStraightCircle: false,
              curveColor: Colors.red,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _controller.forward();
                setState(() {
                  pointsList.clear();

                  create();
                });
              },
              child: const Text("点我")),
        ],
      ),
    );
  }

  Color backgroundColor(double value) {
    debugPrint("wyn 111");
    var whiteColors = [
      Colors.white10,
      Colors.white10,
      Colors.white12,
      Colors.white24,
      Colors.white54,
      Colors.white70,
      Colors.white70,
      Colors.white54,
      Colors.white24,
      Colors.white12,
      Colors.white10,
      Colors.white10,
    ];

    var index = (value * 10).floor();

    return whiteColors[index];
  }

  var curDetail = 100.0;
  var random = Random();
  var pointsList = <Offset>[];

  Future<List<Offset>> create() async {
    drawLightning(100, 50, 400, 500, 300);

    return pointsList;
  }

  void drawLightning(
      double x1, double y1, double x2, double y2, double displace) {
    if (displace < curDetail) {
      pointsList.add(Offset(x1, y1));
      pointsList.add(Offset(x2, y2));
    } else {
      var midX = (x2 + x1) / 2;
      var midY = (y2 + y1) / 2;
      midX += (random.nextDouble() - 0.8) * displace;
      midY += (random.nextDouble() - 0.8) * displace;

      drawLightning(x1, y1, midX, midY, displace / 2);
      drawLightning(midX, midY, x2, y2, displace / 2);
    }
  }
}

import 'dart:collection';
import 'dart:math';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("我就是我"),
      ),
      body: CustomPaint(
        painter: MyPainter(),
        child: const Text("哇哈哈"),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  var painter = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6
    ..isAntiAlias = true
  ..strokeCap = StrokeCap.round;
  var curDetail = 25.0;
  Path path = Path();
  var random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    drawLightning(100, 50, 400, 500, 500);

    canvas.drawPath(path, painter);
  }

  void drawLightning(double x1, double y1, double x2, double y2,
      double displace) {
    if (displace < curDetail) {
      path.moveTo(x1, y1);
      var midX = (x2 + x1) / 2;
      var midY = (y2 + y1) / 2;
      var temp = random.nextInt((curDetail / 2).floor());
      if (temp % 2 == 1) {
        temp = -temp;
      }
      path.quadraticBezierTo(midX + temp, midY - temp, x2, y2);
    } else {
      var midX = (x2 + x1) / 2;
      var midY = (y2 + y1) / 2;
      midX += (random.nextDouble() - 0.5) * displace;
      midY += (random.nextDouble() - 0.5) * displace;

      drawLightning(x1, y1, midX, midY, displace / 2);
      drawLightning(x2, y2, midX, midY, displace / 2);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyColors.white,
        platform: TargetPlatform.iOS,
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _time;
  late Animation<double> _offset;
  late Animation<Color?> _color;

  final wheelSize = 80.0;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4))
          ..addListener(() {
            setState(() {});
          });
    _time = Tween<double>(begin: 0, end: 8.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear)));
    _offset = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic)));
    _color = ColorTween(begin: Colors.black87, end: Colors.green).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.8, curve: Curves.easeIn)));

    super.initState();
  }

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
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  if (_controller.isCompleted) {
                    _controller.reverse();
                  } else if (!_controller.isAnimating) {
                    _controller.forward();
                  }
                },
                child: const Icon(Icons.play_arrow)),
            Expanded(child: animationW(),)
          ],
        ),
      ),
    );
  }

  Widget animationW() {
    final bottomHeight = MediaQuery.of(context).size.height / 2;

    return Stack(
      children: [
        Positioned(
          child: Container(
            width: double.infinity,
            height: bottomHeight,
            color: Colors.green[400],
          ),
          bottom: 0,
          left: 0,
          right: 0,
        ),
        Positioned(
          child: Wheel(
            size: wheelSize,
            color: _color.value!,
            time: _time.value,
          ),
          left: _offset.value * MediaQuery.of(context).size.width,
          bottom: bottomHeight,
        ),
        Positioned(
          child: Wheel(
            size: wheelSize,
            color: _color.value!,
            time: -_time.value,
          ),
          right: _offset.value * MediaQuery.of(context).size.width,
          bottom: bottomHeight,
        ),
      ],
    );
  }
}

class Wheel extends StatelessWidget {
  final double size;
  final Color color;
  final double time;

  const Wheel(
      {Key? key, required this.size, required this.color, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      transform: Matrix4.identity()..rotateZ(2 * pi * time),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: color, width: 10.0),
          borderRadius: BorderRadius.circular(size / 2),
          gradient: LinearGradient(colors: [
            Colors.white,
            Colors.orange[100]!,
            Colors.orange[400]!,
          ])),
    );
  }
}

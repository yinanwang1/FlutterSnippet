import 'package:flutter/material.dart';
import 'package:flutter_snippet/Widgets/ability_widget.dart';
import 'package:flutter_snippet/Widgets/circle_progress_widget.dart';

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
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: '哇哈哈'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;
  double value = 0.0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 5000));
    Tween<double> tween = Tween<double>(begin: 0.0, end: 1.0);
    animation = tween.animate(controller);
    animation.addListener(() {
      setState(() {
        value = animation.value;
      });
    });

    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CircleProgressWidget(Progress(value: value, backgroundColor: Colors.red)),
      ),
    );
  }
}

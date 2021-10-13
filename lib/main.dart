import 'package:flutter/material.dart';
import 'package:flutter_snippet/Widgets/ability_widget.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: AbilityWidget(
          ability: Ability(100, 1500, AssetImage("images/namei.png"), {
            "攻击力": 70.0,
            "生命": 90.0,
            "闪避": 50.0,
            "暴击": 70.0,
            "破格": 80.0,
            "格挡": 100.0,
          }, Colors.red),
        ),
      ),
    );
  }
}

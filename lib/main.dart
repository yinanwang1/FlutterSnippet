import 'package:flutter/material.dart';
import 'package:flutter_snippet/Common/my_buttons.dart';
import 'package:flutter_snippet/DesignModel/cashier_system.dart';
import 'package:flutter_snippet/DesignModel/person.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(
      title: "学习web",
    ),
  ));
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const CashierSystem());
  }
}

// flutter的样例

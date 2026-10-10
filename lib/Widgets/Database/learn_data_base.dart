import 'package:flutter/material.dart';


// 学习drift操作数据库

class LearnDataBase extends StatefulWidget {
  const LearnDataBase({super.key});

  @override
  State createState() => _LearnDataBaseState();
}

class _LearnDataBaseState extends State<LearnDataBase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Learn drift"),
      ),
      body: Center(
        child: Text(
          '我就是我',
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}

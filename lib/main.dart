import 'package:flutter/material.dart';

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
        body: ListView(
          children: [
            Container(
              height: 300,
              color: Colors.red,
              child: Center(child: Text("hello world", style: TextStyle(color: Colors.white, fontSize: 30),)),
            ),
            Container(
              color: Colors.blue,
              child: Text("hello world"),
            ),
            Row(
              children: [
                Flexible(fit: FlexFit.tight,child: Container(color: Colors.yellow, child: Text("hello world"),)),
                Flexible(fit: FlexFit.tight,child: Container(color: Colors.cyan, child: Text("hello world"),))
              ],
            )
          ],
        )
    );
  }
}

// flutter的样例

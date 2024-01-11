import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/generated/l10n.dart';
import 'package:flutter_snippet/generated/my_images.dart';

void main() {
  runApp(createMaterialApp(
      (settings) => MaterialPageRoute(builder: (context) {
            return MyHomePage(
              title: S.of(context).title,
            );
          }),
      {}));
}

class MyHomePage extends ConsumerStatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with SingleTickerProviderStateMixin {
  EdgeInsets _edgeInsets = EdgeInsets.zero;

  Random _random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.green,
              child: AnimatedPadding(
                duration: const Duration(seconds: 1),
                padding: _edgeInsets,
                child: Container(color: Colors.cyan, child: const Text("我是谁")),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _test();
                },
                child: const Text("改变")),
            Image.asset(MyImages.imagesIcNormalBikeHollowBigger),
          ],
        )));
  }

  void _test() {
    var listA = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4];
    var listB = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4];

    var result = [];
    for (var i = 0, j = 0; i < listA.length; i++, j++) {
      var answer = listB[j] + (listA[i] - 1) % 4 * 4;

      result.add(answer);
    }

    debugPrint("result is $result");
  }
}

// flutter的样例

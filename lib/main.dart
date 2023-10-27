import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Widgets/books/books.dart';

import 'generated/l10n.dart';

void main() {
  // runApp(const ProviderScope(child: MyApp()));
  runApp(createMaterialApp(
      (settings) => MaterialPageRoute(builder: (context) {
            // return const Books();
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
  String _name = "我是谁";

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
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Books()));
                  },
                  child: const Text("查看小学生课文")),
              RichText(text: const TextSpan(text: "textSpan")),
              const SelectionArea(
                child: Text("data"),
              ),
              GestureDetector(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: _name));
                  EasyLoading.showToast("$_name 已经拷贝");

                  setState(() {
                    _name = MyColors.randomColor().toString();
                  });
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  color: MyColors.mainColor,
                  alignment: Alignment.center,
                  child: Text(_name),
                ),
              )
            ],
          ),
        ));
  }
}

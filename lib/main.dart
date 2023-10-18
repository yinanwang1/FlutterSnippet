import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/Widgets/books/books.dart';
import 'package:flutter_snippet/generated/l10n.dart';

void main() {
  // runApp(const ProviderScope(child: MyApp()));
  runApp(createMaterialApp(
      (settings) => MaterialPageRoute(
          builder: (context) => MyHomePage(
                title: S.of(context).title,
              )),
      {}));
}

class MyHomePage extends ConsumerStatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with SingleTickerProviderStateMixin {
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
            ],
          ),
        ));
  }
}

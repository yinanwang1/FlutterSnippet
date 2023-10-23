import 'package:flutter/material.dart';
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
              DefaultTextStyle(
                style: Theme.of(context).textTheme.titleLarge ?? const TextStyle(color: MyColors.title),
                child: const Text("data"),
              ),
              MyInheritedWidget("我就是我",
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyPage1()));
                    },
                    child: const Column(
                      children: [
                        Text("跳转到第二页去"),
                        MyWidget(),
                        MyWidget2(),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text("MyWidget name is ${context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()?.name}"),
    );
  }
}

class MyWidget2 extends StatelessWidget {
  const MyWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: TextButton(
          onPressed: () {
            MyInheritedWidget? widget = context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
          },
          child: const Text("更变name"),
        ));
  }
}

class MyInheritedWidget extends InheritedWidget {
  final String name;

  const MyInheritedWidget(this.name, {super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class MyPage1 extends StatelessWidget {
  const MyPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("页面1"),
      ),
      body: Center(
        child: Text("name is ${context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()?.name}"),
      ),
    );
  }
}

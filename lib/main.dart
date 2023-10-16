import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
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

class MyHomePage extends ConsumerWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _headerWidget()
              Theme(data: Theme.of(context).copyWith(primaryColor: Colors.red), child: _headerWidget(context))
            ],
          ),
        ));
  }

  Widget _headerWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 3, left: 20, right: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 5, bottom: 1), child: Text("1.将车辆停在辅助线上方;")),
          RichText(
              text: TextSpan(
                  text: "2.将车辆踏板上的",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 30),
                  children: const [
                TextSpan(text: "颜色码", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "，放置在屏幕"),
                TextSpan(text: "绿色方框内", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                TextSpan(text: ";"),
              ])),
          Padding(
            padding: const EdgeInsets.only(top: 1, bottom: 1),
            child: RichText(
              text: TextSpan(text: "3.将地面", style: Theme.of(context).textTheme.bodyMedium, children: const [
                TextSpan(text: "辅助线", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "，放置在屏幕"),
                TextSpan(text: "红线内", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                TextSpan(text: ";"),
              ]),
            ),
          ),
          const Text("4.点击\"拍照还车\"."),
          TextButton(onPressed: () {}, child: const Text("TextButton")),
          TextField(),
        ],
      ),
    );
  }
}

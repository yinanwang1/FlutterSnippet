import 'dart:math';

import 'package:edge_to_edge/edge_to_edge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/l10n/app_localizations.dart';

final snippetLocaleProvider = NotifierProvider<SnippetLocaleNotifier, Locale>(SnippetLocaleNotifier.new);

class SnippetLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => Locale('zh', "CN");

  void setValue(Locale value) {
    state = value;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _configureEdgeToEdge();
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        locale: ref.watch(snippetLocaleProvider),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MyHomePage(
          title: '往事',
        ));
  }
}

void _configureEdgeToEdge() {
  // 每个页面使用SafeArea 在底部导航栏之上
  EdgeToEdge.configure(enableBottom: false);
}

class MyHomePage extends ConsumerStatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  int _count = 5;
  Random _random = Random();

  @override
  Widget build(BuildContext context) {
    print("CounterProvider build");

    return Scaffold(
      ///需要注意，这个的AppBar 会影响 overlap 数值，如果没有，会多这部分像素点返回
      appBar: AppBar(title: const Text("Overlap Debug")),
      backgroundColor: Colors.grey[50],
      body: Center(
          child: Column(
        children: [
          Text(AppLocalizations.of(context)?.title ?? ""),
          TextButton(
            onPressed: () {
              var locale = ref.read(snippetLocaleProvider);
              if (locale.countryCode?.toLowerCase() == "cn") {
                ref.read(snippetLocaleProvider.notifier).setValue(Locale('en', 'US'));
              } else {
                ref.read(snippetLocaleProvider.notifier).setValue(Locale('zh', 'CN'));
              }
            },
            child: Text(AppLocalizations.of(context)?.comeOn ?? ""),
          ),
          CounterProvider(
            _count,
            child: Column(
              children: [
                AWidget(),
                BWidget(),
                Padding(padding: EdgeInsets.only(top: 15), child: TextButton(onPressed: (){
                  setState(() {
                    _count = _random.nextInt(10);
                  });
                }, child: Text("CounterProvider 刷新")),)
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class AWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AWidgetState();
  }
}

class AWidgetState extends State<AWidget> {
  @override
  Widget build(BuildContext context) {
    print("AWidget build");

    return Column(
      children: [Text("data"), valueWidget()],
    );
  }

  Widget valueWidget() {
    var count = CounterProvider.of(context).count;

    return Text("value is $count");
  }
}

class CounterProvider extends InheritedWidget {
  final int count;

  const CounterProvider(this.count, {super.key, required super.child});

  static CounterProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>()!;
  }

  @override
  bool updateShouldNotify(CounterProvider oldWidget) {
    return count != oldWidget.count;
  }
}

class BWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BWidgetState();
  }
}

class BWidgetState extends State<BWidget> {
  @override
  Widget build(BuildContext context) {
    print("BWidget build");

    return Column(
      children: [Text("BWidget"), valueWidget()],
    );
  }

  Widget valueWidget() {
    var count = CounterProvider.of(context).count;

    return Text("BWidget value is $count");
  }
}

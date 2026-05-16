import 'package:edge_to_edge/edge_to_edge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Widgets/bloc/bloc_test.dart';
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
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return BlocTest();
              }));
            },
            child: Text("跳转到bloc"),
          ),
        ],
      )),
    );
  }
}

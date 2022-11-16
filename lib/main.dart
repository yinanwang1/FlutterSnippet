import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyColors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      // 国际化配置 __START__
      localeListResolutionCallback: (List<Locale>? locals, Iterable<Locale>? supportedLocales) {
        return const Locale('zh');
      },
      localeResolutionCallback: (Locale? locale, Iterable<Locale>? supportedLocales) {
        return const Locale("zh");
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('zh', 'CH'),
        Locale('en', 'US'),
      ],
      // 国际化配置 __END__
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with SingleTickerProviderStateMixin {
  get builder => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("wyn MediaQuery.of(context).size.height is ${MediaQuery.of(context).size.height}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.scrolledUnder) ? Colors.deepPurpleAccent : Colors.blue),
        title: const Text("美丽新世界"),
      ),
      extendBody: true,
      body: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            color: Colors.cyanAccent,
            child: Stack(
              children: [
                Container(
                  color: Colors.black12,
                ),
                Container(
                  height: 250,
                  color: Colors.black,
                ),
                Positioned.fill(
                  child: DraggableScrollableSheet(
                    minChildSize: 1 - 250 / constraints.maxHeight,
                    initialChildSize: 1 - 250 / constraints.maxHeight,
                    builder: (_, ScrollController scrollController) {
                      return ListView.builder(
                          itemCount: strings.length,
                          controller: scrollController,
                          itemBuilder: (_, index) {
                            return Container(
                              alignment: Alignment.center,
                              color: 0 == index % 2 ? Colors.red : Colors.blue,
                              height: 30,
                              child: Text(strings[index]),
                            );
                          });
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  List<String> strings = List.generate(100, (index) => "index $index");
}

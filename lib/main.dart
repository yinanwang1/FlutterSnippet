import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(const ProviderScope(child: MyTestApp()));
  // runApp(const ProviderScope(child: MyHomePage()));
  // runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {})));
}

class MyTestApp extends ConsumerWidget {
  const MyTestApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    String themeColor = ref.watch(themeColorProvider);
    Color color = themeColorMap[themeColor] ?? Colors.red;

    debugPrint("themeColor is $themeColor, color is $color");

    return MaterialApp(
      title: "我是谁",
      theme: ThemeData(
        primaryColor: color,
        primaryColorDark: color,
        // floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: color),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("美丽新世界"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ...themeColorMap.keys.map((e) => ListTile(
                    title: Text(e),
                    onTap: () {
                      ref.read(themeColorProvider.notifier).update((state) => e);

                      debugPrint("e is $e");
                    },
                  ))
            ],
          ),
        ),
        floatingActionButton: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      ),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    String themeColor = ref.watch(themeColorProvider);
    Color color = themeColorMap[themeColor] ?? Colors.red;

    debugPrint("themeColor is $themeColor, color is $color");

    return MaterialApp(
      title: "我是谁",
      // theme: ThemeData(primaryColor: color,
      //     primaryColorDark: color,
      //     // floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: color),
      // ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("美丽新世界"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ...themeColorMap.keys.map((e) => ListTile(
                    title: Text(e),
                    onTap: () {
                      ref.read(themeColorProvider.notifier).update((state) => e);

                      debugPrint("e is $e");
                    },
                  ))
            ],
          ),
        ),
        floatingActionButton: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      ),
    );
  }
}

/// 适配暗黑模式

final themeColorProvider = StateProvider<String>((ref) => '');

Map<String, Color> themeColorMap = {
  'gray': Colors.grey,
  'blue': Colors.blue,
  'blueAccent': Colors.blueAccent,
  'cyan': Colors.cyan,
  'deepPurple': Colors.purple,
  'deepPurpleAccent': Colors.deepPurpleAccent,
  'deepOrange': Colors.orange,
  'green': Colors.green,
  'indigo': Colors.indigo,
  'indigoAccent': Colors.indigoAccent,
  'orange': Colors.orange,
  'purple': Colors.purple,
  'pink': Colors.pink,
  'red': Colors.red,
  'teal': Colors.teal,
  'black': Colors.black,
};

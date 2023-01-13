import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';

void main() {
  runApp(createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {}));
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

    return LayoutBuilder(
      builder: (_, constraints) {
        return Container(
          color: Colors.cyanAccent,
          child: Stack(
            children: [
              SizedBox(
                width: constraints.maxWidth,
                height: 310,
                child: Image.asset(
                  "images/namei.png",
                  fit: BoxFit.fitHeight,
                ),
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
              ),
              Container(
                height: (AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight) + MediaQuery.of(context).padding.top,
                width: constraints.maxWidth,
                color: Colors.transparent,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  title: const Text("美丽新世嘉"),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black,),
                    onPressed: () {
                      debugPrint("wyn 111");
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> strings = List.generate(100, (index) => "index $index");
}

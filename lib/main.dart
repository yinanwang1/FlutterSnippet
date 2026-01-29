import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(
      title: "学习web",
    ),
  ));
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _handle = SliverOverlapAbsorberHandle();
  final ValueNotifier<String> _logNotifier = ValueNotifier("等待滚动...");

  final Map<String, String> _logState = {};

  @override
  void dispose() {
    _logNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///需要注意，这个的AppBar 会影响 overlap 数值，如果没有，会多这部分像素点返回
      appBar: AppBar(title: const Text("Overlap Debug")),
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  updateLogDisplay("Sliver 1", constraints.scrollOffset, constraints.overlap);

                  return SliverAppBar(
                    title: const Text('Sliver 1 (Pinned)'),
                    backgroundColor: Colors.red.withOpacity(0.7),
                    pinned: true,
                    stretch: true,
                    toolbarHeight: 60,
                    collapsedHeight: 60,
                    expandedHeight: 60,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(color: Colors.red.withOpacity(0.7)),
                      stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
                    ),
                  );
                },
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    height: 50,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: Text('中间填充 Item $index', style: const TextStyle(color: Colors.grey)),
                  ),
                  childCount: 5,
                ),
              ),
              SliverOverlapAbsorber(
                handle: _handle,
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    updateLogDisplay("Sliver 2", constraints.scrollOffset, constraints.overlap);
                    return SliverAppBar(
                      title: const Text('Sliver 2 (Pinned)'),
                      backgroundColor: Colors.blue.withOpacity(0.7),
                      pinned: true,
                      toolbarHeight: 60,
                      collapsedHeight: 60,
                      expandedHeight: 60,
                      primary: false,
                      elevation: 0,
                    );
                  },
                ),
              ),
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  final currentOverlap = constraints.overlap;
                  final offset = constraints.scrollOffset;
                  updateLogDisplay("Sliver 3", offset, currentOverlap);

                  return SliverMainAxisGroup(
                    slivers: [
                      SliverOverlapInjector(handle: _handle),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, index) {
                            return Container(
                              height: 50,
                              color: index == 0 ? Colors.green[900] : (index.isEven ? Colors.green[200] : Colors.green[100]),
                              alignment: Alignment.center,
                              child: Text(
                                index == 0 ? '我是头部 (Item 0)' : 'Sliver 3 - Item $index',
                                style: TextStyle(color: index == 0 ? Colors.white : Colors.black),
                              ),
                            );
                          },
                          childCount: 20,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: 100,
            right: 16,
            child: ValueListenableBuilder<String>(
              valueListenable: _logNotifier,
              builder: (context, value, child) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'Courier',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateLogDisplay(String name, double offset, double overlap) {
    String status = "";
    if (overlap > 0) {
      status = "-> 被遮挡: ${overlap.toStringAsFixed(1)}";
    } else if (overlap < 0) {
      status = "-> 顶部回弹/未接触";
    } else {
      status = "-> 无遮挡";
    }

    final singleLog = '[$name]\n'
        'Offset : ${offset.toStringAsFixed(1)}\n'
        'Overlap: ${overlap.toStringAsFixed(1)}\n'
        '$status';

    _logState[name] = singleLog;

    final sortedKeys = _logState.keys.toList()..sort();
    final combinedLog = sortedKeys.map((k) => _logState[k]).join('\n------------------\n');

    if (_logNotifier.value != combinedLog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _logNotifier.value = combinedLog;
        }
      });
    }

    print('$name -> Offset:$offset, Overlap:$overlap');
  }
}

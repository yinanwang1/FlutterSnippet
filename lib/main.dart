import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Common/paging_list.dart';
import 'package:flutter_snippet/DesignMode/lei_feng.dart';
import 'package:flutter_snippet/DesignMode/person.dart';
import 'package:flutter_snippet/DesignMode/proxy.dart';

void main() {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {})));
  // runApp(const ProviderScope(child: MyHomePage()));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的新世界"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("试试看"),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyList()));
                },
                child: const Text("点我执行")),
          ],
        ),
      ),
    );
  }
}

class MyList extends PagingListWidget {
  const MyList({super.key});

  @override
  PagingListWidgetState<PagingListWidget, dynamic> createState() => _MyListState();
}

class _MyListState extends PagingListWidgetState<MyList, String> {
  var random = Random();

  @override
  Future<void> fetchData() async {
    return Future.delayed(const Duration(seconds: 3), () {
      super.total = 100000;
      super.dataList.addAll(List.generate(super.pageSize, (index) => "测试下 ${random.nextInt(10000000)}"));

      setState(() {
        super.showLoadingMore = false;
        super.hasInitialed = true;
      });
    });
  }

  @override
  Widget listItem(int index) {
    return Container(
      color: MyColors.randomColor(),
      height: 44,
      padding: const EdgeInsets.only(top: 8, left: 8),
      child: Text(super.dataList[index], style: TextStyle(color: MyColors.randomColor(), fontSize: 16),),
    );
  }

  @override
  String? navigationTitle() {
    return "测试分页列表";
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Widgets/books/books.dart';
import 'package:flutter_snippet/model/book_entity.dart';
import 'package:path/path.dart';

// 朗读者详情
class DeclaimerDetail extends ConsumerWidget {
  const DeclaimerDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var bookList = ref.watch(selectedBookProvider);

    return Scaffold(
      appBar: AppBar(title: Text(bookList?.declaimer ?? "")),
      body: null == bookList
          ? const Center(
              child: Text("朗读者不存在"),
            )
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  _portraitWidget(bookList),
                  _bookDetailWidget(bookList, context),
                ],
              ),
            ),
    );
  }

  Widget _portraitWidget(BookList bookList) {
    String defaultImage =
        "https://ts1.cn.mm.bing.net/th/id/R-C.8ce37665e600c4d772934472f117f14e?rik=1qWQ%2bvGGajn8QQ&riu=http%3a%2f%2fwww.52gougouwang.com%2fuploads%2fdog%2f130104%2f1-130104125553R0.jpg&ehk=jYYbCuIfLOlagmm14hBuKvHVIe0EFBNhcmKk3ISfDqY%3d&risl=&pid=ImgRaw&r=0";
    return Hero(
        tag: bookList.declaimerPortrait ?? "${DateTime.now().millisecondsSinceEpoch}",
        child: Image.network(
          bookList.declaimerPortrait ?? defaultImage,
          fit: BoxFit.fitWidth,
        ));
  }

  Widget _bookDetailWidget(BookList bookList, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        child: Text(
          bookList.declaimerDesc ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

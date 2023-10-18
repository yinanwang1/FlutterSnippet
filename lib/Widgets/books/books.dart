import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Widgets/books/book_detail.dart';
import 'package:flutter_snippet/model/book_entity.dart';

/// 小学生课文朗读

// 课文列表
final booksProvider = StateProvider<List<BookList>>((ref) => []);

// 选中的课文
final selectedBookProvider = StateProvider<BookList?>((_) => null);

class Books extends ConsumerStatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _BooksState();
}

class _BooksState extends ConsumerState<Books> {
  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "小学生课文朗读",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: MyColors.randomColor().withOpacity(0.5),
      ),
      body: Consumer(builder: (_, ref, __) {
        var data = ref.watch(booksProvider);
        if (data.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              "images/gradient.png",
              fit: BoxFit.fill,
            )),
            Positioned.fill(child: _mainWidget(data))
          ],
        );
      }),
    );
  }

  Widget _mainWidget(List<BookList> books) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
          itemCount: books.length,
          itemExtent: 60,
          itemBuilder: (_, index) {
            if (index >= books.length) {
              return const SizedBox();
            }
            var book = books[index];
            return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                color: MyColors.randomColor(),
                child: _itemWidget(book));
          }),
    );
  }

  Widget _itemWidget(BookList bookList) {
    return ListTile(
      leading: Text(
        bookList.index ?? "",
        style: const TextStyle(color: Colors.white),
      ),
      title: Hero(
        tag: bookList.title ?? "${DateTime.now().millisecondsSinceEpoch}",
        child: Text(bookList.title ?? "", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
      ),
      onTap: () {
        ref.read(selectedBookProvider.notifier).update((state) => bookList);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const BookDetail();
        }));
      },
    );
  }

  Future<void> _initializeData() async {
    try {
      String books = await rootBundle.loadString("assets/books/grade2First.json");
      BookEntity entity = BookEntity.fromJson(jsonDecode(books));
      ref.read(booksProvider.notifier).update((state) => entity.list ?? []);
    } catch (e) {
      EasyLoading.showToast(e.toString());

      Future.delayed(const Duration(seconds: 5), () => _initializeData());
    }
  }
}

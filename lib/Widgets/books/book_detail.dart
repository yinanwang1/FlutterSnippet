import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Widgets/books/books.dart';
import 'package:flutter_snippet/Widgets/books/declaimer_detail.dart';
import 'package:flutter_snippet/model/book_entity.dart';

/// 课文详情页面，展示课文的内容和播放mps

class BookDetail extends ConsumerStatefulWidget {
  const BookDetail({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _BookDetailState();
}

class _BookDetailState extends ConsumerState<BookDetail> {
  double audioPlayingHeight = 80.0;

  // 播放的状态
  late ValueNotifier _valueNotifier;

  @override
  void initState() {
    _valueNotifier = ValueNotifier(false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bookList = ref.watch(selectedBookProvider);

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: bookList?.title ?? "${DateTime.now().millisecondsSinceEpoch}",
          child: Text(
            bookList?.title ?? "",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      body: null == bookList
          ? const Center(
              child: Text("此文章不存在"),
            )
          : Stack(
              children: [
                _mainWidget(bookList),
                _declaimerWidget(bookList),
              ],
            ),
    );
  }

  Widget _declaimerWidget(BookList bookList) {
    String defaultImage =
        "https://ts1.cn.mm.bing.net/th/id/R-C.8ce37665e600c4d772934472f117f14e?rik=1qWQ%2bvGGajn8QQ&riu=http%3a%2f%2fwww.52gougouwang.com%2fuploads%2fdog%2f130104%2f1-130104125553R0.jpg&ehk=jYYbCuIfLOlagmm14hBuKvHVIe0EFBNhcmKk3ISfDqY%3d&risl=&pid=ImgRaw&r=0";
    double width = 60;
    return Positioned(
      bottom: audioPlayingHeight + 8,
      right: 8,
      child: Hero(
        tag: bookList.declaimerPortrait ?? "${DateTime.now().millisecondsSinceEpoch}",
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return const DeclaimerDetail();
            }));
          },
          child: Container(
            width: width,
            height: width,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(width / 2)), border: Border.all()),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              bookList.declaimerPortrait ?? defaultImage,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainWidget(BookList bookList) {
    return Positioned.fill(
        child: Column(
      children: [
        Expanded(child: _bookDetailWidget(bookList)),
        _audioPlayingWidget(bookList),
      ],
    ));
  }

  Widget _bookDetailWidget(BookList bookList) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 50, left: 20, right: 20),
        child: Text(
          bookList.content ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _audioPlayingWidget(BookList bookList) {
    var mp3 = bookList.mp3;
    if (null == mp3 || mp3.isEmpty) {
      return Container(
        height: audioPlayingHeight,
        color: MyColors.randomColor().withOpacity(0.3),
        alignment: Alignment.center,
        child: const Text("没有音频文件"),
      );
    }

    debugPrint("mp3 is $mp3");

    return SafeArea(
      child: SizedBox(
        height: audioPlayingHeight,
        child: ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (BuildContext context, value, Widget? child) {
            return AudioWidget.assets(
              path: mp3,
              play: value,
              child: ElevatedButton(
                  child: Text(
                    value ? "pause" : "play ",
                  ),
                  onPressed: () {
                    _valueNotifier.value = !value;
                  }),
              onReadyToPlay: (duration) {
                //onReadyToPlay
              },
              onPositionChanged: (current, duration) {
                //onPositionChanged
              },
            );
          },
        ),
      ),
    );
  }
}

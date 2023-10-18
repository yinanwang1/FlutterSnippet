import 'package:flutter_snippet/generated/json/base/json_convert_content.dart';
import 'package:flutter_snippet/model/book_entity.dart';

BookEntity $BookEntityFromJson(Map<String, dynamic> json) {
  final BookEntity bookEntity = BookEntity();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    bookEntity.name = name;
  }
  final String? index = jsonConvert.convert<String>(json['index']);
  if (index != null) {
    bookEntity.index = index;
  }
  final List<BookList>? list = (json['list'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<BookList>(e) as BookList).toList();
  if (list != null) {
    bookEntity.list = list;
  }
  return bookEntity;
}

Map<String, dynamic> $BookEntityToJson(BookEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['index'] = entity.index;
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension BookEntityExtension on BookEntity {
  BookEntity copyWith({
    String? name,
    String? index,
    List<BookList>? list,
  }) {
    return BookEntity()
      ..name = name ?? this.name
      ..index = index ?? this.index
      ..list = list ?? this.list;
  }
}

BookList $BookListFromJson(Map<String, dynamic> json) {
  final BookList bookList = BookList();
  final String? index = jsonConvert.convert<String>(json['index']);
  if (index != null) {
    bookList.index = index;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    bookList.title = title;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    bookList.content = content;
  }
  final String? declaimer = jsonConvert.convert<String>(json['declaimer']);
  if (declaimer != null) {
    bookList.declaimer = declaimer;
  }
  final String? declaimerDesc = jsonConvert.convert<String>(json['declaimerDesc']);
  if (declaimerDesc != null) {
    bookList.declaimerDesc = declaimerDesc;
  }
  final String? declaimerPortrait = jsonConvert.convert<String>(json['declaimerPortrait']);
  if (declaimerPortrait != null) {
    bookList.declaimerPortrait = declaimerPortrait;
  }
  final String? mp3 = jsonConvert.convert<String>(json['mp3']);
  if (mp3 != null) {
    bookList.mp3 = mp3;
  }
  return bookList;
}

Map<String, dynamic> $BookListToJson(BookList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['index'] = entity.index;
  data['title'] = entity.title;
  data['content'] = entity.content;
  data['declaimer'] = entity.declaimer;
  data['declaimerDesc'] = entity.declaimerDesc;
  data['declaimerPortrait'] = entity.declaimerPortrait;
  data['mp3'] = entity.mp3;
  return data;
}

extension BookListExtension on BookList {
  BookList copyWith({
    String? index,
    String? title,
    String? content,
    String? declaimer,
    String? declaimerDesc,
    String? declaimerPortrait,
    String? mp3,
  }) {
    return BookList()
      ..index = index ?? this.index
      ..title = title ?? this.title
      ..content = content ?? this.content
      ..declaimer = declaimer ?? this.declaimer
      ..declaimerDesc = declaimerDesc ?? this.declaimerDesc
      ..declaimerPortrait = declaimerPortrait ?? this.declaimerPortrait
      ..mp3 = mp3 ?? this.mp3;
  }
}
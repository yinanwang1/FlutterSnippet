import 'dart:convert';

import 'package:flutter_snippet/generated/json/base/json_field.dart';
import 'package:flutter_snippet/generated/json/book_entity.g.dart';

export 'package:flutter_snippet/generated/json/book_entity.g.dart';

@JsonSerializable()
class BookEntity {
  String? name;
  String? index;
  List<BookList>? list;

  BookEntity();

  factory BookEntity.fromJson(Map<String, dynamic> json) => $BookEntityFromJson(json);

  Map<String, dynamic> toJson() => $BookEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class BookList {
// 第几课
  String? index;

  // 标题
  String? title;

  // 课文内容
  String? content;

  // 朗读者
  String? declaimer;

  // 朗读者介绍
  String? declaimerDesc;

  // 朗读者头像url
  String? declaimerPortrait;

  // 课文的mp3
  String? mp3;

  BookList();

  factory BookList.fromJson(Map<String, dynamic> json) => $BookListFromJson(json);

  Map<String, dynamic> toJson() => $BookListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

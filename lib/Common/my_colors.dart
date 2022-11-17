import 'dart:math';

import 'package:flutter/material.dart';

class MyColors {
  // 白色，导航栏使用
  static const MaterialColor white = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

  // 主蓝色
  static const Color mainColor = Color(0xFF368CF7);

  // 主蓝色2
  static const Color mainColor2 = Color(0xFF3BA9FE);

  // 标题颜色
  static const Color title = Color(0xFF333333);

  // 副标题颜色
  static const Color subtitle = Color(0xFF666666);

  // 灰色标题颜色
  static const Color greyTitle = Color(0xFF969696);

  // 提示语颜色
  static const Color promptTitle = Color(0xFFBEBCBC);

  // 背景色颜色
  static const Color background = Color(0xFFF0F0F0);

  // 背景色颜色2
  static const Color background2 = Color(0xFFF9FCFF);

  // 主视图的背景色颜色
  static const Color backgroundMainView = Color(0xfff6f6f6);

  // 按钮不可点击颜色
  static const Color buttonUnableBackground = Color(0xFFDADADA);

  // 主色半透明
  static const Color mainTranslucentColor = Color(0x4A005CAF);

  // 分割线
  static const Color divider = Color(0xFFF2F2F2);

  // 分割2
  static const Color divider2 = Color(0xFFF1EEEE);

  // 分割3
  static const Color divider3 = Color(0xFFECF0F6);

  // 提示语颜色
  static const Color placeholder = Color(0xFF999999);

  // 随机颜色
  static Color randomColor() {
    var random = Random();
    return Color.fromARGB(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
  }
}

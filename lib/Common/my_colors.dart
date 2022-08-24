
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

  // 标题颜色
  static const Color title = Color(0xFF333333);

  // 随机颜色
  static Color randomColor() {
    var random = Random();
    return Color.fromARGB(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
  }
}
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

// 创建app的统一的配置，方便管理。

MaterialApp createMaterialApp(RouteFactory? onGenerateRoute, Map<String, WidgetBuilder> routes) {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.light));
  }

  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      primarySwatch: MyColors.white,
      platform: TargetPlatform.iOS,
      appBarTheme: const AppBarTheme(shadowColor: Colors.white, elevation: 1),
      scaffoldBackgroundColor: Colors.white,
      primaryColor: MyColors.mainColor,
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: MyColors.mainColor,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: MyColors.title, fontSize: 16),
        ),
      ),
      dividerTheme: const DividerThemeData(space: 1, indent: 25, endIndent: 25, color: MyColors.divider),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14),
          ),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return MyColors.placeholder;
            }

            return MyColors.mainColor;
          }),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 16),
        ),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return MyColors.buttonUnableBackground;
          }

          return MyColors.mainColor;
        }),
      )),
    ),
    themeMode: ThemeMode.light,
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    builder: EasyLoading.init(),
    onGenerateRoute: onGenerateRoute,
    routes: routes,
    // 必须有这个主题，不然用户端不能审核通过
    title: "骑电单车",
  );
}

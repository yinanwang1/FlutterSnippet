import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/generated/l10n.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Widget createMaterialApp(RouteFactory? onGenerateRoute, Map<String, WidgetBuilder> routes) {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  }

  var materialApp = MaterialApp(
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    builder: EasyLoading.init(),
    onGenerateRoute: onGenerateRoute,
    routes: routes,
    // 必须有这个主题，不然用户端不能审核通过
    title: "美丽新世界",
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ],
    supportedLocales: const [
      Locale('zh', 'CH'),
      Locale('en', 'US'),
    ],
    navigatorObservers: [routeObserver],
    theme: ThemeData(
      useMaterial3: true,
      primaryColor: MyColors.mainColor,
      platform: TargetPlatform.iOS,
      appBarTheme: appBarTheme,
      scaffoldBackgroundColor: Colors.white,
      cupertinoOverrideTheme: cupertinoThemeData,
      dividerTheme: const DividerThemeData(space: 1, indent: 25, endIndent: 25, color: MyColors.divider),
      textButtonTheme: textButtonThemeData,
      elevatedButtonTheme: elevatedButtonThemeData,
      textTheme: textTheme,
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      primaryColor: MyColors.mainColor,
      platform: TargetPlatform.iOS,
      appBarTheme: appBarTheme2,
      scaffoldBackgroundColor: Colors.black,
      cupertinoOverrideTheme: cupertinoThemeData2,
      dividerTheme: const DividerThemeData(space: 1, indent: 25, endIndent: 25, color: MyColors.divider),
      textButtonTheme: textButtonThemeData2,
      elevatedButtonTheme: elevatedButtonThemeData,
      textTheme: textTheme2,
    ),
  );

  return ProviderScope(child: materialApp);
}

/// 自定义类型

const AppBarTheme appBarTheme = AppBarTheme(
    shadowColor: Colors.white,
    elevation: 1,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(color: MyColors.title, fontSize: 16, fontWeight: FontWeight.w500));

const AppBarTheme appBarTheme2 = AppBarTheme(
    shadowColor: Colors.white,
    elevation: 1,
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(color: MyColors.white, fontSize: 16, fontWeight: FontWeight.w500));

const CupertinoThemeData cupertinoThemeData = CupertinoThemeData(
  primaryColor: MyColors.mainColor,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(color: MyColors.title, fontSize: 16),
  ),
);

const CupertinoThemeData cupertinoThemeData2 = CupertinoThemeData(
  primaryColor: MyColors.mainColor,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(color: MyColors.white, fontSize: 16),
  ),
);

TextButtonThemeData textButtonThemeData = TextButtonThemeData(
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
);

TextButtonThemeData textButtonThemeData2 = TextButtonThemeData(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.black),
    textStyle: MaterialStateProperty.all(
      const TextStyle(fontSize: 14),
    ),
    foregroundColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return MyColors.white;
      }

      return MyColors.mainColor;
    }),
  ),
);

ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
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
));

// 统一字体，方便管理。如果有指定颜色或其他，则使用copyWith进行覆盖。
TextTheme textTheme = const TextTheme(
  headlineMedium: TextStyle(color: MyColors.title, fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall: TextStyle(color: MyColors.title, fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0.0),
  titleLarge: TextStyle(color: MyColors.title, fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: TextStyle(color: MyColors.title, fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleSmall: TextStyle(color: MyColors.title, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: TextStyle(color: MyColors.title, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  // 不设置默认为bodyMedium
  bodyMedium: TextStyle(color: MyColors.title, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  bodySmall: TextStyle(color: MyColors.title, fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelLarge: TextStyle(color: MyColors.subtitle, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  labelSmall: TextStyle(color: MyColors.subtitle, fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  // 这几个大的用不到，用来展示更小的内容
  displayLarge: TextStyle(color: MyColors.title, fontSize: 10, fontWeight: FontWeight.w300, letterSpacing: 1.5),
  displayMedium: TextStyle(color: MyColors.title, fontSize: 8, fontWeight: FontWeight.w300, letterSpacing: 1.5),
  displaySmall: TextStyle(color: MyColors.subtitle, fontSize: 8, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

TextTheme textTheme2 = const TextTheme(
  headlineMedium: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0.0),
  titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleSmall: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  // 不设置默认为bodyMedium
  bodyMedium: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  bodySmall: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelLarge: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  labelSmall: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  // 这几个大的用不到，用来展示更小的内容
  displayLarge: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w300, letterSpacing: 1.5),
  displayMedium: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w300, letterSpacing: 1.5),
  displaySmall: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

/// 自定义类型 __END__

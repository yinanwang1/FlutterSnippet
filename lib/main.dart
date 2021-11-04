import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_snippet/Common/my_buttons.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Widgets/normal_cell.dart';

import 'Widgets/math_runner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyColors.white,
        platform: TargetPlatform.iOS,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: '哇哈哈'),
      // 国际化配置 __START__
      localeListResolutionCallback:
          (List<Locale>? locals, Iterable<Locale>? supportedLocales) {
        return const Locale('zh');
      },
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale>? supportedLocales) {
        return const Locale("zh");
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('zh', 'CH'),
        Locale('en', 'US'),
      ],
      // 国际化配置 __END__
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("区域外骑行申请"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
      ),
      body: ListView(
        children: <Widget>[
          NormalCell(
            title: Text("申请地址："),
          ),
          Image.asset("images/apply.png"),
          NormalCell(
            title: Text("申请理由："),
          ),
          NormalCell(
            title: Text("去往地图所在的位置，取衣服。20分钟返回.",
                style: TextStyle(color: Colors.blue, fontSize: 18)),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          NormalCell(
            title: Text(
              "用户历史用车情况",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            ),
          ),
          NormalCell(
            title: Text(
              "车辆详情",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            ),
          ),
          NormalCell(
            title: Text(
              "允许时长：(分钟)",
            ),
          ),
          TextField(
            maxLength: 11,
            decoration: InputDecoration(
              labelText: "20",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 20)),
              Expanded(
                child: BlueButton(
                  onPressed: () {},
                  title: "通过",
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 20)),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "不通过",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red, minimumSize: Size(50, 50)),
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 20)),
            ],
          )
        ],
      ),
    );
  }
}

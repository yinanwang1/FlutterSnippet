import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

import 'Widgets/flutter_wave_loading.dart';
import 'Widgets/toggle_rotate.dart';

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
      home: const MyHomePage(title: "玩哈哈"),
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
      body: Container(
        color: Colors.grey.withAlpha(66),
        margin: const EdgeInsets.all(15),
        alignment: Alignment.center,
        child: CustomSingleChildLayoutDemo(),
      ),
    );
  }
}

class CustomSingleChildLayoutDemo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      color: Colors.grey.withAlpha(11),
      child: CustomSingleChildLayout(
        delegate: _TolySingleChildLayoutDelegate(),
        child: Container(
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}

class _TolySingleChildLayoutDelegate extends SingleChildLayoutDelegate {

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    debugPrint("---size:$size---childSize:$childSize");

    return Offset(size.width / 2, 0);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    debugPrint("getConstraintsForChild---constraints:$constraints");

    return BoxConstraints(
      maxHeight: constraints.maxHeight / 2,
      maxWidth: constraints.maxWidth / 2,
      minHeight: constraints.minHeight / 2,
      minWidth: constraints.minWidth / 2
    );
  }

  @override
  Size getSize(BoxConstraints constraints) {
    debugPrint("getSize---constraints:$constraints");

    return super.getSize(constraints);
  }
}







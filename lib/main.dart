import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: '哇哈哈'),
      // 国际化配置 __START__
      localeListResolutionCallback: (List<Locale>? locals, Iterable<Locale>? supportedLocales) {
        return const Locale('zh');
      },
      localeResolutionCallback: (Locale? locale, Iterable<Locale>? supportedLocales) {
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
  bool _showing = false;

  @override
  Widget build(BuildContext context) {
    var title = Container(
      alignment: AlignmentDirectional.center,
      child: const Text(
        "Dialog Unit",
        style: TextStyle(fontSize: 30),
      ),
    );

    void _showSimpleDialog(BuildContext context) {
      var strs = [
        '云深不知处内亥时息,卯时起',
        "云深不知处内不可挑食留剩",
        "云深不知处内不可私自斗殴",
        "云深不知处禁止魏无羡入内"
      ];

      var title = Row(
        children: <Widget>[
          Image.asset(
            "images/namei.png",
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text("啥是啥啊")
        ],
      );

      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: title,
              children: strs.map((str) {
                return SimpleDialogOption(
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.turned_in_not,
                        color: Colors.blue,
                      ),
                      Text(str),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(str);
                    debugPrint(str);
                  },
                );
              }).toList(),
            );
          }).then((value) => debugPrint("wyn return str is $value"));
    }

    void _showAlertDialog(BuildContext context) {
      var title = Row(
        children: <Widget>[
          Image.asset(
            "images/namei.png",
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text("表白"),
        ],
      );

      var content = Row(
        children: const <Widget>[
          Text("我💖你，你是我的"),
        ],
      );

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop("不要闹");
                    },
                    child: const Text("不要闹")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop("走开");
                    },
                    child: const Text("走开")),
              ],
            );
          }).then((value) => debugPrint("wyn value is $value"));
    }

    void _showCupertinoAlertDialog(BuildContext context) {
      var title = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/namei.png",
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text("表白"),
        ],
      );

      var content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text("我💖你，你是我的"),
        ],
      );

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CupertinoAlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop("不要闹");
                    },
                    child: const Text(
                      "不要闹",
                      style: TextStyle(color: Colors.red),
                    )),
                CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop("走开");
                    },
                    child: const Text("走开")),
              ],
            );
          }).then((value) => debugPrint("wyn value is $value"));
    }

    void _showWidgetDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return widget;
          });
    }

    void _showStatefulWidgetDialog(BuildContext context) {
      var progress = 0.0;
      StateSetter? stateSetter;

      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        progress += 0.01;
        if (null != stateSetter) {
          stateSetter!(() {});
        }

        if (progress >= 1) {
          timer.cancel();
          stateSetter = null;

          Navigator.of(context).pop();
        }
      });

      var statefulBuilder = StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        stateSetter = setState;

        return Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Card(
              elevation: 24.0,
              color: Colors.blue.withAlpha(240),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    value: progress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Loading....",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "done ${((progress - 0.1) * 100).toStringAsFixed(1)}%",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      });

      showDialog(
          context: context,
          builder: (context) {
            return statefulBuilder;
          });
    }

    void _showScaffold(BuildContext context) {
      var snakeBar = SnackBar(
        content: const Text("和同学好厉害啊"),
        backgroundColor: const Color(0xffFB6431),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "确定",
          onPressed: () {
            debugPrint("Flutter 显示以下啊");
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snakeBar);
    }

    void _showBottomSheet(BuildContext context) {
      var bottomSheet = BottomSheet(onClosing: () {
        debugPrint("on closing.");
      }, builder: (context) {
        return Container(
          color: const Color(0xdde3fbf6),
          height: 150,
          child: Center(
            child: Image.asset("images/namei.png"),
          ),
        );
      });

      if (_showing) {
        Navigator.of(context).pop();
      } else {
        Scaffold.of(context).showBottomSheet(bottomSheet.builder);
      }

      _showing = !_showing;
    }

    void _showDatePicker(BuildContext context) {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? child) {
          return Theme(data: ThemeData.dark(), child: child!);
        },
      ).then((value) => debugPrint("value is $value."));
    }

    void _showTimePicker(BuildContext context) {
      showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 11, minute: 45),
        builder: (BuildContext context, Widget? child) {
          return Theme(data: ThemeData.dark(), child: child!);
        },
      ).then((value) => debugPrint("value is $value"));
    }

    void _showCupertinoPicker(BuildContext context) {
      var names = [
        "位阻",
        "蓝二",
        "j谅解",
        "将就",
        "幺妹",
        "嘻嘻哈哈",
      ];
      final picker = CupertinoPicker(
        itemExtent: 40,
        onSelectedItemChanged: (position) {
          debugPrint("The position is ${names[position]}");
        },
        children: names.map((e) => Text(e)).toList(),
      );

      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              color: Colors.white,
              height: 250,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("完成"),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 200,
                    child: picker,
                  )
                ],
              ),
            );
          });
    }

    void _showCupertinoDatePicker(BuildContext context) {
      final picker = CupertinoDatePicker(
        onDateTimeChanged: (date) {
          debugPrint("当前日期、时间 ${date.toString()}");
        },
        initialDateTime: DateTime(1994),
      );

      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              color: Colors.white,
              height: 200,
              child: picker,
            );
          });
    }

    void _showCupertinoTimerPicker(BuildContext context) {
      final picker = CupertinoTimerPicker(onTimerDurationChanged: (duration) {
        debugPrint("当前时间为 $duration");
      });

      showCupertinoModalPopup(context: context, builder: (context) {
        return Material(
          child: SizedBox(
            height: 200,
            child: picker,
          ),
        );
      });
    }

    Map<String, Function> buttons = {
      "对话框SimpleDialog": _showSimpleDialog,
      "对话框AlertDialog": _showAlertDialog,
      "对话框CupertinoAlertDialog": _showCupertinoAlertDialog,
      "对话框显示自己": _showWidgetDialog,
      "对话框显示StatefulWidget": _showStatefulWidgetDialog,
      "Scaffold": _showScaffold,
      "BottomSheet": _showBottomSheet,
      "DatePicker": _showDatePicker,
      "TimePicker": _showTimePicker,
      "CupertinoPicker": _showCupertinoPicker,
      "CupertinoDatePicker": _showCupertinoDatePicker,
      "CupertinoTimerPicker": _showCupertinoTimerPicker,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            title,
            Builder(builder: (BuildContext context) {
              return Column(
                children: buttons.keys.toList().map((e) {
                  return ElevatedButton(
                      onPressed: () {
                        var f = buttons[e];
                        if (null != f) {
                          f(context);
                        }
                      },
                      child: Text(e));
                }).toList(),
              );
            })
          ],
        ),
      ),
    );
  }
}

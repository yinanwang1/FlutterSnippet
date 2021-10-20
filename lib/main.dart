
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
        title: Text(widget.title),
      ),
      body: OriginPage(),
    );
  }
}

class OriginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hero = Hero(
        tag: "user-head",
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: Image.asset(
            "images/namei.png",
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ));

    var container = Container(
      alignment: const Alignment(-0.8, -0.8),
      child: hero,
      width: 250,
      height: 250 * 0.618,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.red.withAlpha(99),
        Colors.yellow.withAlpha(189),
        Colors.green.withAlpha(88),
        Colors.blue.withAlpha(230),
      ])),
    );

    void _toNext(context) {
      Navigator.push(context, ScaleRouter(child: TargetPage()));
    }

    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Card(
            elevation: 5,
            child: container,
          ),
          onTap: () {
            _toNext(context);
          },
        ),
      ),
    );
  }
}

class TargetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hero = const Hero(
      tag: "user-head",
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 72.0,
          backgroundImage: AssetImage("images/namei.png"),
        ),
      ),
    );

    var touch = InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: hero,
    );

    return Scaffold(
      appBar: AppBar(
        leading: touch,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.red.withAlpha(99),
          Colors.yellow.withAlpha(189),
          Colors.green.withAlpha(88),
          Colors.blue.withAlpha(230),
        ])),
      ),
    );
  }
}

class ScaleRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int duration_ms;
  final Curve curve;

  ScaleRouter(
      {required this.child,
      this.duration_ms = 500,
      this.curve = Curves.fastOutSlowIn})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => child,
            transitionDuration: Duration(milliseconds: duration_ms),
            transitionsBuilder: (context, a1, a2, child) => ScaleTransition(
                  scale: Tween(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child,
                ));
}

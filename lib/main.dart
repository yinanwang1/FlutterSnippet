import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';

import 'generated/l10n.dart';

void main() {
  runApp(createMaterialApp(
      (settings) => MaterialPageRoute(builder: (context) {
            // return const Books();
            // return MyHomePage(
            //   title: S.of(context).title,
            // );
        return const FlowApp();
          }),
      {}));
}

class MyHomePage extends ConsumerStatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.flip(
                flipX: true,
                // flipY: true,
                child: const Text('Horizontal Flip'),
              ),
              Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Chip(
                    avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('AH')),
                    label: const Text('Ham'),
                  ),
                  Chip(
                    avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('ML')),
                    label: const Text('Lafayettezdgdg'),
                  ),
                  Chip(
                    avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('HM')),
                    label: const Text('Mull'),
                  ),
                  Chip(
                    avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('JL')),
                    label: const Text('Laurenssgasgasgg'),
                  ),Chip(
                    avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('AH')),
                    label: const Text('Ham'),
                  ),
                  Chip(
                    avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('ML')),
                    label: const Text('Lafayettezdgdg'),
                  ),
                  Chip(
                    avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('HM')),
                    label: const Text('Mull'),
                  ),
                  Chip(
                    avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('JL')),
                    label: const Text('Laurenssgasgasgg'),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class FlowApp extends StatelessWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flow Example'),
        ),
        body: const FlowMenu(),
      ),
    );
  }
}

class FlowMenu extends StatefulWidget {
  const FlowMenu({super.key});

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;
  IconData lastTapped = Icons.notifications;
  final List<IconData> menuItems = <IconData>[
    Icons.home,
    Icons.new_releases,
    Icons.notifications,
    Icons.settings,
    Icons.menu,
  ];

  void _updateMenu(IconData icon) {
    if (icon != Icons.menu) {
      setState(() => lastTapped = icon);
    }
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  Widget flowMenuItem(IconData icon) {
    final double buttonDiameter =
        MediaQuery.of(context).size.width / menuItems.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RawMaterialButton(
        fillColor: lastTapped == icon ? Colors.amber[700] : Colors.blue,
        splashColor: Colors.amber[100],
        shape: const CircleBorder(),
        constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
        onPressed: () {
          _updateMenu(icon);
          menuAnimation.status == AnimationStatus.completed
              ? menuAnimation.reverse()
              : menuAnimation.forward();
        },
        child: Icon(
          icon,
          color: Colors.white,
          size: 45.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
      children:
      menuItems.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          dx * menuAnimation.value,
          0,
          0,
        ),
      );
    }
  }
}


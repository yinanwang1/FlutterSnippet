import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/DesignMode/factory.dart';
import 'package:flutter_snippet/DesignMode/observer.dart';

import 'DesignMode/builder.dart';

void main() {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {})));
  // runApp(const ProviderScope(child: MyHomePage()));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的新世界"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: (){
              IFactory factory = AccessFactory();
              IUser user = factory.createUser();
              user.insert(User("test", 2));
              user.getUser(2);

              IProject project = factory.createProject();
              project.insertProject(Project("Woo", "1"));
              project.getProject("123");

            }, child: const Text("测试下"))
          ],
        ),
      ),
    );
  }
}

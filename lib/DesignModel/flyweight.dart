import 'package:flutter/material.dart';

/// 享元模式

// 网页抽象类
abstract class WebSite {
  void use();
}

// 具体网站类
class ConcreteWebSite extends WebSite {
  final String name;

  ConcreteWebSite(this.name);

  @override
  void use() {
    debugPrint("网站分类: $name");
  }
}

// 网站工厂
class WebSiteFactory {
  final Map<String, ConcreteWebSite> _flyweights = {};

  WebSite getWebSiteCategory(String key) {
    if (!_flyweights.containsKey(key)) {
      _flyweights[key] = ConcreteWebSite(key);
    }

    return _flyweights[key] ?? ConcreteWebSite(key);
  }

  int getWebSiteCount() {
    return _flyweights.length;
  }
}

// 例子
class FlyweightWidget extends StatelessWidget {
  const FlyweightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(onPressed: _onClickTestBtn, child: const Text("不点我下吗？")),
    );
  }

  void _onClickTestBtn() {
    WebSiteFactory factory = WebSiteFactory();

    WebSite fx = factory.getWebSiteCategory("产品展示");
    fx.use();

    WebSite fy = factory.getWebSiteCategory("产品展示");
    fy.use();

    WebSite fz = factory.getWebSiteCategory("产品展示");
    fz.use();

    WebSite fl = factory.getWebSiteCategory("博客");
    fl.use();

    WebSite fm = factory.getWebSiteCategory("博客");
    fm.use();

    WebSite fn = factory.getWebSiteCategory("博客");
    fn.use();

    debugPrint("网站分类总数为${factory.getWebSiteCount()}");
  }
}

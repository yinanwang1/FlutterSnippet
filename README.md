# FlutterSnippet
## 声明： 如果有任何代码侵权，请联系我wyn18968158629@gmail.com。 

在项目使用到或者网上看到好的组件，整理一份方便以后开发的时候使用。
## 1. FlutterText 字体抖动
一个字体抖动的组件，继承自Text。用法和Text一样，可以设置Text的所有属性。
可以传入一个动画的配置项，实现动画。支持重复播放。
使用示例：
```
FlutterText(
              "我们都是孩子",
              style: const TextStyle(fontSize: 30, color: Colors.cyan),
              config: AnimationConfig(curveTween: CurveTween(curve: Curves.ease), repeat: true),
            ),
```

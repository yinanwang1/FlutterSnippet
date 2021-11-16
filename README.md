# FlutterSnippet
## 声明： 如果有任何代码侵权，请联系我wyn18968158629@gmail.com。 

**在项目使用到或者网上看到好的组件，整理一份方便以后开发的时候使用。**

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
![flutter](./images/flutter.gif)

## 2. NormalCell 一行显示左边的图标，标题，和右边的尾部组件
提供了（1）标题图片（2）标题（3）内容（4）尾部内容（或箭头）（5）是否需要底部分割线（6）点击事件
使用示例：
```
const NormalCell(leading: Text("leading"), title: Text("title"), middle: Text("middle"), trailing: Text("trailing")),
```
![cell](./images/cell.jpg)

## 3. NStarView 多边形
绘制多边形，传入多边形的个数n，外半径R，内半径r，填充的颜色color
使用示例：
```
NStarView(15, 30, 20, color: Colors.red,)
```
![多边形](./images/nStar.jpg)

## 4. AbilityWidget 蛛网显示能力图
蛛网的样式显示不同能力值，并伴有动画。
使用示例：
```
AbilityWidget(
          ability: Ability(100, 1500, AssetImage("images/namei.png"), {
            "攻击力": 70.0,
            "生命": 90.0,
            "闪避": 50.0,
            "暴击": 70.0,
            "破格": 80.0,
            "格挡": 100.0,
          }, Colors.black),
        ),
```
![蛛网显示能力图](./images/network.gif)

## 5. CircleProgressWidget  圆形进度条 
通过Progress来设置属性. 使用时设置动画，可实现动态显示
使用示例：
```
CircleProgressWidget(Progress(value: value, backgroundColor: Colors.red))
```
![圆形进度条](./images/circle.gif)

## 6. FlutterWebView 浏览器
传入url和title，打开新页面在浏览器展示内容。
iOS使用时，需要在ViewDidLoad中添加`GeneratedPluginRegistrant.register(with: self)`。
使用示例：
```
Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return const FlutterWebView(
                    "http://www.baidu.com",
                    title: "我就是我");
              }));
```
*需要在pubspec.yaml中依赖webview_flutter: ^2.1.1*

## 7. MathRunner 按函数移动
封装了一个动画，传入x和y的函数，使组件按函数动起来。
使用示例：
```
Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const CircleAvatar(
            backgroundImage: AssetImage("images/namei.png"),
          ),
          MathRunner(
            f: (t) => cos(t * pi),
            g: (t) => 0.6 * sin(t * pi),
            reverse: false,
            parts: 4,
            index: 0,
            child: const CircleAvatar(
              backgroundImage: AssetImage("images/namei.png"),
            ),
          ),
          MathRunner(
            f: (t) => cos(t * pi),
            g: (t) => 0.6 * sin(t * pi),
            reverse: false,
            parts: 4,
            index: 1,
            child: const CircleAvatar(
              backgroundImage: AssetImage("images/namei.png"),
            ),
          ),
          MathRunner(
            f: (t) => cos(t * pi),
            g: (t) => 0.6 * sin(t * pi),
            reverse: false,
            parts: 4,
            index: 2,
            child: const CircleAvatar(
              backgroundImage: AssetImage("images/namei.png"),
            ),
          ),
          MathRunner(
            f: (t) => cos(t * pi),
            g: (t) => 0.6 * sin(t * pi),
            reverse: false,
            parts: 4,
            index: 3,
            child: const CircleAvatar(
              backgroundImage: AssetImage("images/namei.png"),
            ),
          ),
        ],
      )
```
![按函数移动](./images/math_runner.gif)

## 8. 评分
StarScore显示评分结果
CustomRating打分
使用示例：
```
Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CustomRating(
      onRating: (double d) {
        debugPrint("score is $d");
      },
    ),
    StarScore(
      score: 3.0,
      tail: Column(
        children: const <Widget>[Text("综合评分"), Text("3.0")],
      ),
    ),
  ],
),
```
![评分](./images/star.jpg)

## 9. ToggleRotate 点击旋转组件
点击一个组件的时候，可以将组件旋转到指定的角度，并可指定动画效果。
使用示例：
```
ToggleRotate(
  onTap: () {},
  child: const Icon(
    Icons.arrow_upward,
    size: 60,
    color: Colors.orangeAccent,
  ),
  durationMs: 500,
  curve: Curves.bounceInOut,
),
```
![旋转](./images/rotate.gif)










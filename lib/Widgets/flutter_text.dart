import 'dart:math';

import 'package:flutter/cupertino.dart';

/// 抖动的文字。
/// 每一个字都可以抖动。

class FlutterText extends Text {
  final String content;
  final AnimationConfig? config;

  /// 重载Text的属性
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? textOverflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;

  const FlutterText(
    this.content, {
    this.config,
    Key? key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.textOverflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
  }) : super(content, key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _formChild(),
    );
  }

  List<Widget> _formChild() {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < content.length; i++) {
      list.add(
        FlutterLayout(
          Text(
            content[i],
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
          ),
          config ?? AnimationConfig(),
        ),
      );
    }

    return list;
  }
}

class FlutterLayout extends StatefulWidget {
  final Widget child;
  final AnimationConfig config;

  const FlutterLayout(this.child, this.config, {Key? key}) : super(key: key);

  @override
  _FlutterLayoutState createState() {
    return _FlutterLayoutState();
  }
}

class _FlutterLayoutState extends State<FlutterLayout>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.config.duration),
    );
    var dx = widget.config.offset;
    var sequence = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween(begin: 0, end: dx), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: dx, end: -dx), weight: 2),
      TweenSequenceItem<double>(tween: Tween(begin: -dx, end: dx), weight: 3),
      TweenSequenceItem<double>(tween: Tween(begin: dx, end: 0), weight: 4),
    ]);
    var curveTween = widget.config.curveTween;
    _animation = sequence.animate(
        null == curveTween ? _controller : curveTween.animate(_controller))
      ..addStatusListener((status) {
        print("status is $status");

        if (status == AnimationStatus.completed) {
          print("wyn 111");
          _controller.forward();
        }
      });
    if (widget.config.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }

  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterAnimation(widget.child, _animation, widget.config);
  }
}

enum RockMode {
  /// 随机
  random,

  /// 上下
  upDown,

  /// 左右
  leftRight,

  /// 倾斜
  lean
}

class AnimationConfig {
  /// 时长
  int duration;

  /// 偏移大小
  double offset;

  /// 摇晃模式
  RockMode mode;

  /// 运动曲线
  CurveTween? curveTween;

  /// 循环播放动画，默认为false
  bool repeat;

  AnimationConfig(
      {this.duration = 2000,
      this.offset = 1,
      this.mode = RockMode.leftRight,
      this.curveTween,
      this.repeat = false});
}

class FlutterAnimation extends StatelessWidget {
  final Widget _child;
  final Animation<double> _animation;
  final AnimationConfig _config;

  const FlutterAnimation(this._child, this._animation, this._config, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var result = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          transform: _formTransform(_config),
          alignment: Alignment.center,
          child: _child,
        );
      },
    );

    return Center(
      child: result,
    );
  }

  Matrix4 _formTransform(AnimationConfig config) {
    Random _random = Random();
    Matrix4 result;
    switch (config.mode) {
      case RockMode.random:
        result = Matrix4.rotationZ(_animation.value * pi / 180);
        break;
      case RockMode.upDown:
        result = Matrix4.translationValues(
            0, _animation.value * pow(-1, _random.nextInt(20)), 0);
        break;
      case RockMode.leftRight:
        result = Matrix4.translationValues(
            _animation.value * pow(-1, _random.nextInt(20)), 0, 0);
        break;
      case RockMode.lean:
        result = Matrix4.rotationZ(_animation.value * pi / 180);
        break;
    }

    return result;
  }
}

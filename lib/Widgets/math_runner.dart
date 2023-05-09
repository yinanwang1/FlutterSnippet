import 'dart:math';

import 'package:flutter/material.dart';

/// 通过align + animation 实现指定函数的路径移动
///
/// @author 阿南
/// @since 2021/11/1 20:05

typedef FunNum1 = Function(double t);

class MathRunner extends StatefulWidget {
  // 子组件
  final Widget child;

  // x函数
  final FunNum1 f;

  // y函数
  final FunNum1 g;

  // 是否倒转
  final bool reverse;

  // 分几部分
  final int parts;

  // 第几部分
  final int index;

  const MathRunner(
      {Key? key, required this.child, required this.f, required this.g, this.parts = 1, this.index = 0, this.reverse = true})
      : super(key: key);

  @override
  State createState() {
    return _MathRunnerState();
  }
}

class _MathRunnerState extends State<MathRunner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation animationX;
  double _x = -1.0;
  double _y = 0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animationX = Tween(begin: -1.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          var value = animationX.value + ((2 / widget.parts) * widget.index - 1);
          _x = widget.f(value);
          _y = widget.g(value);
        });
      });

    super.initState();

    _controller.repeat(reverse: widget.reverse);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(_x, _y),
      child: widget.child,
    );
  }

  double f(double x) {
    double y = cos(pi * x);
    return y;
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

/// 水印样式
/// rowCount: 当前屏幕宽度中 展示多少列水印
/// columnCount: 当前屏幕高度中，展示多少行水印
/// watermark: 水印展示的文字
/// textStyle: 文字的样式
class DisableScreenshotsWaterMark extends StatelessWidget {
  final int rowCount;
  final int columnCount;
  final String text;
  final TextStyle textStyle;

  const DisableScreenshotsWaterMark({
    super.key,
    required this.rowCount,
    required this.columnCount,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        children: createColumnWidgets(),
      ),
    );
  }

  List<Widget> createRowWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < rowCount; i++) {
      final widget = Expanded(child: Center(child: Transform.rotate(angle: pi / 10, child: Text(text, style: textStyle))));
      list.add(widget);
    }
    return list;
  }

  List<Widget> createColumnWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < columnCount; i++) {
      final widget = Expanded(
          child: Row(
        children: createRowWidgets(),
      ));
      list.add(widget);
    }
    return list;
  }
}

/// 水印工具类 单例 instance
/// 使用方式：
///
/// 获取实例: WaterMarkInstance instance = WaterMarkInstance();
/// 添加水印: instance.addWatermark(context, "320321199708134818");
/// 删除水印: instance.removeWatermark();
///
class WaterMarkInstance {
  static WaterMarkInstance? _instance;

  factory WaterMarkInstance() {
    _instance ??= WaterMarkInstance.private();
    return _instance!;
  }

  WaterMarkInstance.private();

  OverlayEntry? _overlayEntry;

  void addWatermark(BuildContext context, String watermark, {int rowCount = 2, int columnCount = 8, TextStyle? textStyle}) async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
    }
    OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        builder: (context) => DisableScreenshotsWaterMark(
              rowCount: rowCount,
              columnCount: columnCount,
              text: watermark,
              textStyle: textStyle ?? const TextStyle(color: Color(0xff000000), fontSize: 14, decoration: TextDecoration.none),
            ));
    overlayState.insert(_overlayEntry!);

    debugPrint("overlayState is $overlayState");
  }

  void removeWatermark() async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}

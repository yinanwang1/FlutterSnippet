import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageUtils {
  // 将ImageProvider转为ui.Image
  static Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调
    ImageStreamListener? listener;
    ImageStream stream = provider.resolve(config); //获取图片流
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      //监听
      final ui.Image image = frame.image;
      completer.complete(image); //完成
      if (null != listener) {
        stream.removeListener(listener); //移除监听
      }
    });
    stream.addListener(listener); //添加监听

    return completer.future; //返回
  }

  //通过 文件读取Image
  static Future<ui.Image> loadImageByFile(String path) async {
    var list = await File(path).readAsBytes();
    return loadImageByUint8List(list);
  }

  //通过[Uint8List]获取图片
  static Future<ui.Image> loadImageByUint8List(Uint8List list) async {
    ui.Codec codec = await ui.instantiateImageCodec(list);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }
}

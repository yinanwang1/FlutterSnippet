import 'dart:ui' as ui;

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_snippet/Common/util/macro.dart';
import 'package:flutter_snippet/generated/my_images.dart';

/// 创建一个BitmapDescriptor的map用来保存已经生成的，从而效率。
///
/// 为了解决“单车换电”中自定义图标，导致了加载慢的问题。

class BitmapDescriptorFactory {
  // key为 图片的名称 + title 构成。 value为创建marker需要的BitmapDescriptor
  static final Map<String, BitmapDescriptor> _createdBitmapDescriptor = {};
  static ImageConfiguration imageConfiguration = ImageConfiguration(devicePixelRatio: AMapUtil.devicePixelRatio);

  static Future<BitmapDescriptor> createBitmapDescriptor(BuildContext context, String imageName,
      {String? title, bool selected = false, MarkerTitleType markerTitleType = MarkerTitleType.small}) async {
    // 先从本地查找
    String key = "$imageName${title ?? ""}$selected";
    BitmapDescriptor? bitmapDescriptor = _createdBitmapDescriptor[key];
    if (null != bitmapDescriptor) {
      return bitmapDescriptor;
    }

    // 不存在重新创建
    if (null == title) {
      return _createDefaultBitmapDescriptor(imageName, key);
    }

    var view = await _createMarkerView(
      context,
      title,
      imageName,
      selected: selected,
      markerTitleType: markerTitleType,
    );
    if (!context.mounted) {
      return _createDefaultBitmapDescriptor(imageName, key);
    }
    double width = markerTitleType.width;
    if (markerTitleType == MarkerTitleType.big) {
      width += title.length * 15;
    }
    double height = markerTitleType.height;
    var data = await _widgetToByteData(view, imageName,
        context: context,
        devicePixelRatio: AMapUtil.devicePixelRatio,
        pixelRatio: AMapUtil.devicePixelRatio,
        size: Size(selected ? width * 1.5 : width, selected ? height * 1.2 : height));
    var uInt8List = data?.buffer.asUint8List();
    if (null != uInt8List) {
      bitmapDescriptor = BitmapDescriptor.fromBytes(uInt8List);

      _createdBitmapDescriptor[key] = bitmapDescriptor;
    } else {
      bitmapDescriptor = await BitmapDescriptor.fromAssetImage(imageConfiguration, MyImages.imagesIcNormalBikeHollow);
    }

    return bitmapDescriptor;
  }

  static Future<BitmapDescriptor> _createDefaultBitmapDescriptor(String imageName, String key) async {
    var bitmapDescriptor = await BitmapDescriptor.fromAssetImage(imageConfiguration, imageName);
    _createdBitmapDescriptor[key] = bitmapDescriptor;

    return bitmapDescriptor;
  }

  static Future<Widget> _createMarkerView(BuildContext context, String name, String imageName,
      {bool selected = false, MarkerTitleType markerTitleType = MarkerTitleType.small}) async {
    var height = markerTitleType.height;
    if (selected) {
      height *= 2;
    }
    var width = markerTitleType.width;

    return Container(
      height: height,
      constraints: BoxConstraints(minWidth: width),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imageName)),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          name,
          style: TextStyle(fontSize: selected ? 22 : 14, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static Future<ByteData?> _widgetToByteData(Widget widget, String imageName,
      {Alignment alignment = Alignment.center,
      Size size = const Size(double.maxFinite, double.maxFinite),
      double devicePixelRatio = 1.0,
      double pixelRatio = 1.0,
      required BuildContext context}) async {
    RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    RenderView renderView = RenderView(
      child: RenderPositionedBox(alignment: alignment, child: repaintBoundary),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints(maxWidth: size.width, maxHeight: size.height),
        devicePixelRatio: devicePixelRatio,
      ),
      view: View.of(context),
    );

    PipelineOwner pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    RenderObjectToWidgetElement rootElement = RenderObjectToWidgetAdapter(
      container: repaintBoundary,
      child: widget,
    ).attachToRenderTree(buildOwner);
    await precacheImage(AssetImage(imageName), rootElement);
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData;
  }
}

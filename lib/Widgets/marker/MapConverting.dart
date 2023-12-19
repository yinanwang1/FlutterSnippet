import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_snippet/Widgets/marker/MapItem.dart';
import 'package:flutter_snippet/generated/my_images.dart';

/// 提供将不同的model转为MapItem。
/// model转为MapItem，统一在此类完成，方便复用和后期的性能优化
/// 当需要转化的数据量大的时候，采用异步在其他线程来执行，减少对主线程的阻塞时间
///
/// 采用compute来处理处理，减少阻塞主线程的时间
///
/// MarkerItem 的title 出现时，说明要进行自定义marker
///

class MapConverting {
  static List<MapItem> asMapItemForExchange(List<BatteryWeakListDataItems> items) {
    List<MapItem> mapItems = [];

    for (var element in items) {
      if (null == element.bikeNo || null == element.coordinate) {
        continue;
      }

      var number = element.bikeNo ?? "";

      String bitmap = MyImages.imagesIcNormalBikeHollow;
      String bitmapBigger = MyImages.imagesIcNormalBikeHollowBigger;

      var latLng = LatLng(double.tryParse("${element.coordinate?.latitude}") ?? 30.276096,
          double.tryParse("${element.coordinate?.longitude}") ?? 119.996503);

      var markerItem = MarkerItem(number, latLng, bitmap: bitmap, selectedBitmap: bitmapBigger);
      markerItem.power = element.power;
      markerItem.title = "${element.power ?? 0}";

      mapItems.add(MapItem(null, markerItem));
    }

    return mapItems;
  }

  static List<MarkerItem> asMarkerItem(List<MapItem> mapItems) {
    List<MarkerItem> markerItems = [];
    for (var element in mapItems) {
      MarkerItem? item = element.marker;
      if (null != item) {
        markerItems.add(item);
      }
    }

    return markerItems;
  }
}

class BatteryWeakListDataItems {
  BatteryWeakListDataItems({this.bikeNo, this.power, this.coordinate});

  final String? bikeNo;

  //电量百分比
  final int? power;
  final CoordinateEntity? coordinate;
}

class CoordinateEntity {
  final double? longitude;
  final double? latitude;

  CoordinateEntity({this.longitude, this.latitude});
}

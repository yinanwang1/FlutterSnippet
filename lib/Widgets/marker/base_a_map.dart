import 'dart:async';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Common/util/Utility.dart';
import 'package:flutter_snippet/Widgets/marker/BitmapDescriptorFactory.dart';
import 'package:flutter_snippet/Widgets/marker/FlutterLocation.dart';
import 'package:flutter_snippet/Widgets/marker/MapItem.dart';
import 'package:flutter_snippet/generated/my_images.dart';

///
/// 地图页面，仅仅用来展示地图相关的内容，不包含业务逻辑
/// Created by arthur on 2021/8/3
///
/// 数据源通过MapConverting转为marker和polygon来处理需要展示的图标和多边形。
/// 通过3个方法分别来处理图标，多边形和路径
///

class BaseAMap extends ConsumerStatefulWidget {
  // 是否可以拖动地图
  final bool scrollGesturesEnabled;

  // 设置中心点
  final LatLng centerLatLng;

  // 是否需要将地图中心移动到定位
  final bool shouldMoveCenterToLocation;

  // 缩放比例
  final double zoom;

  // 展示 info window。则不需要出现将图标变大或刷新页面
  final bool showInfoWindow;

  // 选中图标的操作。 如果为空，则表示不进行选中操作
  final Function(MarkerItem?) didSelectBicycle;

  // 点击地图事件
  final Function? didTapMap;

  // 地图移动结束的回调
  final Function(LatLng?)? updateCenterMapLatLng;

  // 地图移动的回调
  final Function(LatLng?)? updateMapLatLng;

  // 定位成功
  final Function()? locatedSuccess;

  // 地图创建成功
  final Function()? onMapCreated;

  const BaseAMap({
    super.key,
    this.scrollGesturesEnabled = true,
    this.locatedSuccess,
    this.centerLatLng = const LatLng(30.276096, 119.996503),
    this.shouldMoveCenterToLocation = true,
    this.zoom = 15,
    this.showInfoWindow = false,
    required this.didSelectBicycle,
    this.updateCenterMapLatLng,
    this.updateMapLatLng,
    this.onMapCreated,
    this.didTapMap,
  });

  @override
  ConsumerState createState() => BaseAMapState();
}

class BaseAMapState extends ConsumerState<BaseAMap> {
  AMapController? _mapController;
  final Map<String, Marker> _markers = {};
  final Map<String, Polyline> _polylineMap = {};
  final Map<String, Polygon> _polygons = {};
  final Map<String, MarkerItem> _bikeItems = {};

  // 点击选中的marker id
  String? _selectedMarkerId;

  // 当前位置 外部需要调用
  LatLng? currentLatLng;
  LatLng? _lastCenterLatLng;

  // 当前相机位置,（当前的位置，旋转的角度）
  CameraPosition? currentCameraPosition;
  bool _hasLocated = false;

  // 地图的静态属性
  final _locationImage = Image.asset(MyImages.imagesIcHomepageSearchLocationBg);
  final _locationStyleOptions = MyLocationStyleOptions(true,
      icon: BitmapDescriptor.fromIconPath(MyImages.imagesMyLocationIconBlue), circleFillColor: MyColors.mainTranslucentColor);
  final _privacyStatement = const AMapPrivacyStatement(hasContains: true, hasAgree: true, hasShow: true);

  // 定位的监听
  StreamSubscription? _streamSubscription;

  // Public Methods __START__

  void returnUserLocation() {
    var latLng = currentLatLng;
    if (null != latLng) {
      _mapController?.moveCamera(CameraUpdate.newLatLng(latLng));
    }

    if (null == _selectedMarkerId) {
      // 移动到当前位置，取消选中marker
      _revertMarker();
    }
  }

  // 将地图中心点移动到指定经纬度
  void moveCenterTo(LatLng latLng, {double? bearing}) {
    if (null == bearing) {
      _mapController?.moveCamera(CameraUpdate.newLatLng(latLng));
    } else {
      _mapController
          ?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, bearing: bearing, zoom: widget.zoom)));
    }
  }

  // 绘制图标组
  void refreshMarkers(List<MarkerItem>? items, {bool clearPolyline = true}) async {
    _selectedMarkerId = null;

    _markers.clear();
    _bikeItems.clear();

    if (clearPolyline) {
      _polylineMap.clear();
    }

    if (null != items) {
      for (MarkerItem item in items) {
        await _createMarker(item);
      }
    }

    _trySetState(() {});
  }

  // 绘制一个选中的图标
  void addSelectedMarker(MarkerItem? item) async {
    // 如果之前有图标被选中了，那么需要先恢复
    _revertMarker();

    widget.didSelectBicycle(item);

    if (null != item) {
      await _createMarker(item, selected: true);
      _trySetState(() {});
    }
  }

  // 绘制还车点区域
  void refreshPolygons(List<PolygonItem>? items) async {
    _polygons.clear();

    items?.forEach((element) {
      _addPolygon(element);
    });

    _trySetState(() {});
  }

  void refreshPolyline(List<LatLng> points, {Color pathColor = MyColors.mainColor, BitmapDescriptor? customTexture}) {
    // 路径仅仅只会有一条，所以先清空
    if (_polylineMap.isNotEmpty) {
      _trySetState(() {
        _polylineMap.clear();
      });
    }

    if (points.isEmpty) {
      return;
    }
    final Polyline polyline =
        Polyline(points: points, color: pathColor, width: 5, joinType: JoinType.round, customTexture: customTexture);

    _trySetState(() {
      _polylineMap[polyline.id] = polyline;
    });
  }

  void refreshLatLngBounds(LatLng southwest, LatLng northeast) {
    var limitBounds = LatLngBounds(southwest: southwest, northeast: northeast);

    _mapController?.moveCamera(CameraUpdate.newLatLngBounds(limitBounds, 50));
  }

  // Public Methods __END__

  @override
  void initState() {
    currentLatLng = widget.centerLatLng;

    Future.delayed(const Duration(milliseconds: 2000), _addLocationListen);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BaseAMap build");

    AMapWidget map = AMapWidget(
      initialCameraPosition: CameraPosition(target: widget.centerLatLng, zoom: widget.zoom),
      onMapCreated: _onMapCreated,
      scrollGesturesEnabled: widget.scrollGesturesEnabled,
      markers: Set<Marker>.of(_markers.values),
      polylines: Set<Polyline>.of(_polylineMap.values),
      onCameraMove: _onCameraMove,
      onCameraMoveEnd: _onCameraMoveEnd,
      onTap: _onMapTap,
      polygons: Set<Polygon>.of(_polygons.values),
      privacyStatement: _privacyStatement,
      myLocationStyleOptions: _locationStyleOptions,
      tiltGesturesEnabled: false,
      buildingsEnabled: false,
      touchPoiEnabled: false,
    );

    return Stack(
      children: [
        map,
        Center(
          child: _locationImage,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();

    super.dispose();
  }

  void _addLocationListen() {
    _streamSubscription = FlutterLocation.getInstance().onLocationChanged().listen((StringLatLngTuple event) {
      if (!mounted) {
        return;
      }

      _handleLocation(event);
    });
  }

  void _handleLocation(StringLatLngTuple event) {
    try {
      var latLng = event.$2;

      if (!_hasLocated && null != latLng) {
        if (widget.shouldMoveCenterToLocation && null != _mapController) {
          _mapController?.moveCamera(CameraUpdate.newLatLng(latLng));
          _hasLocated = true;
        }

        if (null != widget.locatedSuccess) {
          widget.locatedSuccess!();
        }
      }

      currentLatLng = latLng;
    } catch (e) {
      debugPrint("$e");
    }
  }

  void _onMapCreated(AMapController aMapController) {
    _mapController = aMapController;

    var onMapCreated = widget.onMapCreated;
    if (null != onMapCreated) {
      onMapCreated();
    }

    // 地图创建完成，如果之前已经定位成功，则直接移动页面
    var location = FlutterLocation.getInstance().location;
    if (null != location && !_hasLocated) {
      _handleLocation(location);
    }
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    // debugPrint("_onCameraMove ===> ${cameraPosition.toMap()}");

    currentCameraPosition = cameraPosition;

    if (null != widget.updateMapLatLng) {
      widget.updateMapLatLng!(cameraPosition.target);
    }
  }

  void _onCameraMoveEnd(CameraPosition cameraPosition) {
    // debugPrint("_onCameraMoveEnd ===> ${cameraPosition.toMap()}");

    currentCameraPosition = cameraPosition;

    var last = _lastCenterLatLng;
    bool shouldUpdate = true;
    if (null != last) {
      shouldUpdate = AMapTools.distanceBetween(last, cameraPosition.target) > 50;
    }

    if (null != widget.updateCenterMapLatLng && shouldUpdate) {
      widget.updateCenterMapLatLng!(cameraPosition.target);
      _lastCenterLatLng = cameraPosition.target;
    }

    if (null == _selectedMarkerId) {
      // 当点击地图的时候，取消选中
      // 恢复之前的图标
      _revertMarker();
    }
  }

  void _onMapTap(LatLng latLng) {
    // debugPrint("_onMapTap ===> ${latLng.toJson()}");

    if (null != widget.didTapMap) {
      widget.didTapMap!();
    }

    // 当点击地图的时候，取消选中
    widget.didSelectBicycle(null);

    // 当点击地图的时候，取消选中
    // 恢复之前的图标
    _revertMarker();

    // 取消路径
    if (_polylineMap.isNotEmpty) {
      _trySetState(() {
        _polylineMap.clear();
      });
    }
  }

  void _onMarkerTap(String markerId) async {
    // 如果之前有图标被选中了，那么需要先恢复
    _revertMarker();

    MarkerItem? item = _bikeItems[markerId];

    widget.didSelectBicycle(item);

    if (widget.showInfoWindow) {
      // 如果需要渲染info window，那么不进行图标变大
      return;
    }

    if (null != item) {
      await _createMarker(item, selected: true);
    }
    _markers.remove(markerId);
    _bikeItems.remove(markerId);
    _trySetState(() {});
  }

  // 处理图标
  Future<void> _createMarker(MarkerItem item, {bool selected = false}) async {
    var title = item.title;
    var imageName = selected ? item.selectedBitmap : item.bitmap;
    var descriptor = await BitmapDescriptorFactory.createBitmapDescriptor(context, imageName,
        title: title, selected: selected, markerTitleType: item.markerTitleType);
    Marker marker = Marker(
        position: item.position,
        zIndex: 10,
        icon: descriptor,
        onTap: _onMarkerTap,
        infoWindowEnable: item.infoWindow != null,
        infoWindow: InfoWindow(title: item.infoWindow));

    _markers[marker.id] = marker;
    _bikeItems[marker.id] = item;

    if (selected) {
      _selectedMarkerId = marker.id;
    }
  }

  void _revertMarker() async {
    var markerId = _selectedMarkerId;
    if (null == markerId) {
      return;
    }

    MarkerItem? item = _bikeItems[markerId];
    if (null != item) {
      await _createMarker(item);
    }
    _markers.remove(markerId);
    _bikeItems.remove(markerId);
    _selectedMarkerId = null;
    _trySetState(() {});
  }

  void _addPolygon(PolygonItem item) {
    final Polygon polygon =
        Polygon(points: item.points, strokeColor: item.strokeColor, fillColor: item.fillColor, strokeWidth: 1);

    _polygons[polygon.id] = polygon;
  }

  void _trySetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}

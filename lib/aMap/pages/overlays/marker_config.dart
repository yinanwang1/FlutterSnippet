import 'dart:async';
import 'dart:math';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snippet/aMap/base_page.dart';
import 'package:flutter_snippet/aMap/const_config.dart';
import 'package:flutter_snippet/aMap/widgets/amap_switch_button.dart';

class MarkerConfigDemoPage extends BasePage {
  const MarkerConfigDemoPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) {
    return const _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Body> {
  static const LatLng mapCenter = LatLng(39.909187, 116.397451);

  final Map<String, Marker> _markers = <String, Marker>{};
  BitmapDescriptor? _markerIcon;
  String? selectedMarkerId;

  void _onMapCreated(AMapController controller) {}

  ///通过BitmapDescriptor.fromAssetImage的方式获取图片
  // Future<void> _createMarkerImageFromAsset(BuildContext context) async {
  //   if (_markerIcon == null) {
  //     final ImageConfiguration imageConfiguration = createLocalImageConfiguration(context);
  //     BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/start.png').then(_updateBitmap);
  //   }
  // }

  ///通过BitmapDescriptor.fromBytes的方式获取图片
  // Future<void> _createMarkerImageFromBytes(BuildContext context) async {
  //   final Completer<BitmapDescriptor> bitmapIcon = Completer<BitmapDescriptor>();
  //   final ImageConfiguration config = createLocalImageConfiguration(context);
  //
  //   const AssetImage('assets/end.png').resolve(config).addListener(ImageStreamListener((ImageInfo image, bool sync) async {
  //     final ByteData? bytes = await image.image.toByteData(format: ImageByteFormat.png);
  //     if (null != bytes) {
  //       final BitmapDescriptor bitmap = BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  //       bitmapIcon.complete(bitmap);
  //     }
  //   }));
  //
  //   bitmapIcon.future.then((value) => _updateBitmap(value));
  // }

  // void _updateBitmap(BitmapDescriptor bitmap) {
  //   setState(() {
  //     _markerIcon = bitmap;
  //   });
  // }

  void _add() {
    final int markerCount = _markers.length;
    LatLng markPosition = LatLng(
        mapCenter.latitude + sin(markerCount * pi / 12.0) / 20.0, mapCenter.longitude + cos(markerCount * pi / 12.0) / 20.0);
    final Marker marker = Marker(
      position: markPosition,
      icon: _markerIcon!,
      infoWindow: InfoWindow(title: '第 $markerCount 个Marker'),
      onTap: (markerId) => _onMarkerTapped(markerId),
      onDragEnd: (markerId, endPosition) => _onMarkerDragEnd(markerId, endPosition),
    );

    setState(() {
      _markers[marker.id] = marker;
    });
  }

  void _onMarkerTapped(String markerId) {
    final Marker? tappedMarker = _markers[markerId];
    final String? title = tappedMarker?.infoWindow.title;
    debugPrint('$title 被点击了,markerId: $markerId');
    setState(() {
      selectedMarkerId = markerId;
    });
  }

  void _onMarkerDragEnd(String markerId, LatLng position) {
    final Marker? tappedMarker = _markers[markerId];
    final String? title = tappedMarker?.infoWindow.title;
    debugPrint('$title markerId: $markerId 被拖拽到了: $position');
  }

  void _remove() {
    final Marker? selectedMarker = _markers[selectedMarkerId];
    //有选中的Marker
    if (selectedMarker != null) {
      setState(() {
        _markers.remove(selectedMarkerId);
      });
    } else {
      debugPrint('无选中的Marker，无法删除');
    }
  }

  void _removeAll() {
    if (_markers.isNotEmpty) {
      setState(() {
        _markers.clear();
        selectedMarkerId = null;
      });
    }
  }

  void _changeInfo() async {
    final Marker? marker = _markers[selectedMarkerId];
    final String newTitle = '${marker?.infoWindow.title ?? ""}*';
    var markerId = selectedMarkerId;
    if (null != marker && null != markerId) {
      setState(() {
        _markers[markerId] = marker.copyWith(
          infoWindowParam: marker.infoWindow.copyWith(
            titleParam: newTitle,
          ),
        );
      });
    }
  }

  void _changeAnchor() {
    final Marker? marker = _markers[selectedMarkerId];
    if (marker == null) {
      return;
    }
    final Offset currentAnchor = marker.anchor;
    double dx = 0;
    double dy = 0;
    if (currentAnchor.dx < 1) {
      dx = currentAnchor.dx + 0.1;
    } else {
      dx = 0;
    }
    if (currentAnchor.dy < 1) {
      dy = currentAnchor.dy + 0.1;
    } else {
      dy = 0;
    }
    final Offset newAnchor = Offset(dx, dy);
    setState(() {
      _markers[selectedMarkerId!] = marker.copyWith(
        anchorParam: newAnchor,
      );
    });
  }

  void _changePosition() {
    final Marker? marker = _markers[selectedMarkerId];
    final LatLng current = marker?.position ?? const LatLng(0, 0);
    final Offset offset = Offset(
      mapCenter.latitude - current.latitude,
      mapCenter.longitude - current.longitude,
    );
    var markerId = selectedMarkerId;
    if (null != marker && null != markerId) {
      setState(() {
        _markers[markerId] = marker.copyWith(
          positionParam: LatLng(
            mapCenter.latitude + offset.dy,
            mapCenter.longitude + offset.dx,
          ),
        );
      });
    }
  }

  Future<void> _changeAlpha() async {
    final Marker? marker = _markers[selectedMarkerId];
    final double current = marker?.alpha ?? 0.0;
    var markerId = selectedMarkerId;
    if (null != marker && null != markerId) {
      setState(() {
        _markers[markerId] = marker.copyWith(
          alphaParam: current < 0.1 ? 1.0 : current * 0.75,
        );
      });
    }
  }

  Future<void> _changeRotation() async {
    final Marker? marker = _markers[selectedMarkerId];
    final double current = marker?.rotation ?? 0.0;
    var markerId = selectedMarkerId;
    if (null != marker && null != markerId) {
      setState(() {
        _markers[markerId] = marker.copyWith(
          rotationParam: current == 330.0 ? 0.0 : current + 30.0,
        );
      });
    }
  }

  Future<void> _toggleVisible(value) async {
    final Marker? marker = _markers[selectedMarkerId];
    var markerId = selectedMarkerId;
    if (null != marker && null != markerId) {
      setState(() {
        _markers[markerId] = marker.copyWith(
          visibleParam: value,
        );
      });
    }
  }

  Future<void> _toggleDraggable(value) async {
    final Marker? marker = _markers[selectedMarkerId];
    var markerId = selectedMarkerId;
    if (null != marker && null != markerId) {
      setState(() {
        _markers[markerId] = marker.copyWith(
          draggableParam: value,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///以下几种获取自定图片的方式使用其中一种即可。
    //最简单的方式
    _markerIcon ??= BitmapDescriptor.fromIconPath('assets/location_marker.png');

    //通过BitmapDescriptor.fromAssetImage的方式获取图片
    // _createMarkerImageFromAsset(context);
    //通过BitmapDescriptor.fromBytes的方式获取图片
    // _createMarkerImageFromBytes(context);

    final AMapWidget map = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      apiKey: ConstConfig.amapApiKeys,
      onMapCreated: _onMapCreated,
      markers: Set<Marker>.of(_markers.values),
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          TextButton(
                            onPressed: _add,
                            child: const Text('添加'),
                          ),
                          TextButton(
                            onPressed: (selectedMarkerId == null) ? null : _remove,
                            child: const Text('移除'),
                          ),
                          TextButton(
                            onPressed: (selectedMarkerId == null) ? null : _changeInfo,
                            child: const Text('更新InfoWidow'),
                          ),
                          TextButton(
                            onPressed: (selectedMarkerId == null) ? null : _changeAnchor,
                            child: const Text('修改锚点'),
                          ),
                          TextButton(
                            onPressed: (selectedMarkerId == null) ? null : _changeAlpha,
                            child: const Text('修改透明度'),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          TextButton(
                            onPressed: _markers.isNotEmpty ? _removeAll : null,
                            child: const Text('全部移除'),
                          ),
                          AMapSwitchButton(
                            label: const Text('允许拖动'),
                            onSwitchChanged: (selectedMarkerId == null) ? null : _toggleDraggable,
                            defaultValue: false,
                          ),
                          AMapSwitchButton(
                            label: const Text('显示'),
                            onSwitchChanged: (selectedMarkerId == null) ? null : _toggleVisible,
                            defaultValue: true,
                          ),
                          TextButton(
                            onPressed: (selectedMarkerId == null) ? null : _changePosition,
                            child: const Text('修改坐标'),
                          ),
                          TextButton(
                            onPressed: (selectedMarkerId == null) ? null : _changeRotation,
                            child: const Text('修改旋转角度'),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

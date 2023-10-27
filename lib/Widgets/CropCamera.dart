import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_snippet/Common/ImageUtils.dart';
import 'package:flutter_snippet/Common/my_alert_view.dart';
import 'package:flutter_snippet/Common/my_buttons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 自定义拍照页面，拍了一张照片后，根据指定范围大小进行裁剪，然后保存到临时文件

const normalTextStyle = TextStyle(color: Color(0xff333333), fontSize: 14);

class CropCamera extends StatefulWidget {
  const CropCamera({super.key});

  @override
  State createState() => _CropCameraState();
}

class _CropCameraState extends State<CropCamera> {
  CameraDescription? firstCamera;

  late ValueNotifier _valueNotifier;

  // 手电筒状态， 默认关闭
  late ValueNotifier _touchNotifier;

  // 拍照按钮状态，默认开启
  late ValueNotifier _takePhotoNotifier;

  // 自定义拍照
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  String? _croppedImagePath;

  @override
  void initState() {
    super.initState();

    _valueNotifier = ValueNotifier(false);
    _touchNotifier = ValueNotifier(false);
    _takePhotoNotifier = ValueNotifier(true);

    _initializeCamera();
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    _touchNotifier.dispose();
    _takePhotoNotifier.dispose();

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ColorOrder build");

    return Scaffold(
      appBar: AppBar(
        title: const Text("拍照获取指定大小的图片"),
      ),
      body: ValueListenableBuilder(
        valueListenable: _valueNotifier,
        builder: (BuildContext context, value, Widget? child) {
          var camera = firstCamera;
          if (null == camera || !value) {
            return const CircularProgressIndicator();
          }

          return _mainWidget();
        },
      ),
    );
  }

  // Widget __START__

  Widget _mainWidget() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: _defineCamera(),
          );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _defineCamera() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CameraPreview(_controller),
        _linesWidget(),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: _headerWidget(),
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: _footerWidget())
      ],
    );
  }

  Widget _headerWidget() {
    return DefaultTextStyle(
      style: normalTextStyle,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 8, bottom: 3, left: 20, right: 20),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (null != _croppedImagePath) ...[
              BlueButton(
                onPressed: () {
                  setState(() {
                    _croppedImagePath = null;
                  });
                },
                title: "删除照片",
              ),
              const Padding(padding: EdgeInsets.only(top: 8)),
              Image.file(File(_croppedImagePath!)),
              Text("裁剪后的地址为：$_croppedImagePath"),
            ],
          ],
        ),
      ),
    );
  }

  Widget _linesWidget() {
    double height = 79;
    double width = 110;
    double centerHeight = 91;
    const borderWidth = 3.0;
    const BorderSide borderSide = BorderSide(width: borderWidth, color: Colors.red);
    const Color background = Colors.black54;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          SizedBox(
            height: double.infinity,
            width: width,
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      color: background,
                    )),
                Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(border: Border(top: borderSide, bottom: borderSide), color: Colors.transparent),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      color: background,
                    )),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: background,
                      )),
                  Container(
                    height: centerHeight,
                    decoration: BoxDecoration(border: Border.all(color: Colors.green, width: borderWidth)),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: background,
                      )),
                ],
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      color: background,
                    )),
                Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(border: Border(top: borderSide, bottom: borderSide)),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      color: background,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(right: 15, top: 8, bottom: 20),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
                onTap: () {
                  debugPrint("_controller.value.flashMode is ${_controller.value.flashMode}");
                  if (FlashMode.torch != _controller.value.flashMode) {
                    _controller.setFlashMode(FlashMode.torch);
                    _touchNotifier.value = true;
                  } else {
                    _controller.setFlashMode(FlashMode.off);
                    _touchNotifier.value = false;
                  }
                },
                child: ValueListenableBuilder(
                    valueListenable: _touchNotifier,
                    builder: (_, value, __) {
                      return Center(
                        child: Image.asset(
                            value ? "images/ic_scanning_flashlight_checked.png" : "images/ic_scanning_flashlight_unchecked.png",
                            width: 44,
                            height: 44),
                      );
                    })),
          ),
          Expanded(
              flex: 3,
              child: ValueListenableBuilder(
                valueListenable: _takePhotoNotifier,
                builder: (BuildContext context, value, Widget? child) {
                  return BlueButton(
                    onPressed: value ? _takePhoto : null,
                    title: "拍照",
                  );
                },
              ))
        ],
      ),
    );
  }

  // Widget __END__

  // Action __START__

  void _initializeCamera() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        cameras.first,
        // Define the resolution to use.
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

    _valueNotifier.value = true;
  }

  // 拍照，并进行上传
  void _takePhoto() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.clear);
    _takePhotoNotifier.value = false;

    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // 设置对焦，提高拍照效率
      await _controller.setFocusMode(FocusMode.locked);
      await _controller.setExposureMode(ExposureMode.locked);

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();

      if (!mounted) {
        EasyLoading.dismiss();
        return;
      }

      debugPrint("image.path is ${image.path}");
      _cropImage(image.path);
    } catch (e) {
      // If an error occurs, log the error to the console.
      debugPrint("e is $e");
      _judgeCameraPermission();
    } finally {
      _takePhotoNotifier.value = true;

      EasyLoading.dismiss();
    }
  }

  void _cropImage(String path) async {
    debugPrint("upload image's path is $path");
    var background = await ImageUtils.loadImageByFile(path);

    double width = background.width.toDouble();
    double height = background.height.toDouble();
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    Rect rect = Rect.fromLTWH(0, height / 3, width, height / 3);
    Rect dstRect = Rect.fromLTWH(0, 0, width, height / 3);
    canvas.drawImageRect(background, rect, dstRect, Paint());
    Picture picture = recorder.endRecording();
    ui.Image image = await picture.toImage(width.toInt(), height ~/ 3);

    // 写入到文件夹中
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    if (null != byteData) {
      try {
        final Directory appCache = await getApplicationCacheDirectory();
        var filePath = "${appCache.path}/test${DateTime.now().millisecondsSinceEpoch}.png";
        File file = File(filePath);
        file = await file.writeAsBytes(byteData.buffer.asUint8List());

        setState(() {
          _croppedImagePath = file.path;
        });
      } on MissingPlatformDirectoryException catch (e) {
        debugPrint("保存图片失败，${e.message}");
      }
    }
  }

  void _judgeCameraPermission() async {
    bool isGranted = await Permission.camera.request().isGranted;
    if (!isGranted) {
      _showPermissionDialog();
    } else {
      EasyLoading.showToast("拍照失败，请检查是否授权拍照权限");
    }
  }

  void _showPermissionDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return MyAlertView(
              title: "拍照授权",
              content: "请授权拍照来拍照还车",
              leftTitle: "取消",
              onClickLeft: () {
                Navigator.of(context).pop();
              },
              rightTitle: "去授权",
              onClickRight: () {
                Navigator.of(context).pop();

                openAppSettings();
              });
        },
        transitionDuration: const Duration(milliseconds: 125),
        transitionBuilder: (_, anim1, ___, child) {
          return Transform.scale(
            scale: anim1.value,
            child: Opacity(
              opacity: anim1.value,
              child: child,
            ),
          );
        });
  }

// Action __END__

// Network START

// Network END
}

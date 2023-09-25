import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

void main() async {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyHomePage()), {})));
  // runApp(const ProviderScope(child: MyHomePage()));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的新世界"),
        scrolledUnderElevation: 0,
      ),
      body: const Center(
        child: Text("测试下"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const OpenNewPage();
          }));
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}

class OpenNewPage extends StatefulWidget {
  const OpenNewPage({super.key});

  @override
  State createState() => _OpenNewPageState();
}

class _OpenNewPageState extends State<OpenNewPage> {
  CameraDescription? firstCamera;

  late ValueNotifier _valueNotifier;

  @override
  void initState() {
    super.initState();

    _valueNotifier = ValueNotifier(false);

    _initializeCamera();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeCamera() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;

    _valueNotifier.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("打开新页面"),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (BuildContext context, value, Widget? child) {
            var camera = firstCamera;
            if (null == camera || !value) {
              return const CircularProgressIndicator();
            }

            return ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: camera)));
              },
              child: const Text("打开新页面"),
            );
          },
        ),
      ),
    );
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("拍个照片吧"),),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
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
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            debugPrint("image.path is ${image.path}");

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            debugPrint("e is $e");
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _defineCamera() {
    const BorderSide borderSide = BorderSide(width: 3, color: MyColors.mainColor);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        const Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Text(
            "data",
            style: TextStyle(fontSize: 30, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ),
        CameraPreview(_controller),
        Row(
          children: [
            Expanded(flex: 1, child: Container(
              height: 80,
              decoration: const BoxDecoration(
                border: Border(top: borderSide, bottom: borderSide)
              ),
            )),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3)
              ),
            ),
            Expanded(flex: 1, child: Container(
              height: 80,
              decoration: const BoxDecoration(
                  border: Border(top: borderSide, bottom: borderSide)
              ),
            )),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IconButton(
              onPressed: () {
                debugPrint("_controller.value.flashMode is ${_controller.value.flashMode}");
                if (FlashMode.off == _controller.value.flashMode) {
                  _controller.setFlashMode(FlashMode.torch);
                } else {
                  _controller.setFlashMode(FlashMode.off);
                }
              },
              icon: const Icon(
                Icons.flashlight_on_sharp,
                size: 60,
              )),
        )
      ],
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

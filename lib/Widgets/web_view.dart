import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 展示网页
/// 依赖webview_flutter: ^2.1.1
/// @author 阿南
/// @since 2021/10/21 20:19

class FlutterWebView extends StatefulWidget {
  final String url;
  final String title;

  const FlutterWebView(this.url, {this.title = "", super.key});

  @override
  State createState() => _FlutterWebViewState();
}

class _FlutterWebViewState extends State<FlutterWebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
